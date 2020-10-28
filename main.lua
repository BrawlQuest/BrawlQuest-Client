require "scripts.dummy_controller"
require 'scripts.dummy.lanterns'
require "scripts.libraries.api"
require "scripts.player.character"
require "scripts.dummy.enemies"
require "scripts.effects.bones"
require "scripts.effects.lighting"
require "scripts.effects.music"
require "scripts.effects.loot"
require "scripts.ui.chat"
require "scripts.libraries.api"
require "scripts.libraries.utils"
require "scripts.phases.login.login"
require "scripts.player.other_players"
require "scripts.enemies"
require "data.data_controller"
require "settings"
Luven = require "scripts.libraries.luven.luven"

json = require("scripts.libraries.json")
http = require("socket.http")
ltn12 = require("ltn12")


version = "Pre-Release"
phase = "login"

trees = {} -- temp
blockMap = {}
treeMap = {}
players = {} -- other players
playersDrawable = {}
sblockMap = {}
lootTest = {}
nextUpdate = 1
timeOutTick = 3
totalCoverAlpha = 0 -- this covers the entire screen in white, for hiding purposes
timeOfDay = 0
username = "Pebsie"
readyForUpdate = true
scale, uiX, uiY = 1

oldInfo = {}

sendUpdate = false

function love.load()
    print("start")
    initHardData()
    initChat()
    love.graphics.setDefaultFilter("nearest", "nearest")
    loadMusic()
    initLogin()
    birds = love.audio.newSource("assets/sfx/ambient/forest/jungle.ogg", "stream")
    birds:setLooping(true)
    love.audio.play(birds)

    stepSfx = love.audio.newSource("assets/sfx/step/grass.mp3", "static")
    xpSfx = love.audio.newSource("assets/sfx/xp.wav", "static")
    xpSfx:setVolume(0.4)

    awakeSfx = love.audio.newSource("assets/sfx/player/awake.wav", "static")
   
    playerHitSfx = love.audio.newSource("assets/sfx/hit.wav", "static")
    enemyHitSfx = love.audio.newSource("assets/sfx/impact_b.wav", "static")
    critHitSfx = love.audio.newSource("assets/sfx/pit_trap_damage.wav", "static")

    textFont = love.graphics.newFont("assets/ui/fonts/rainyhearts.ttf",24)
  
    smallTextFont = love.graphics.newFont("assets/ui/fonts/rainyhearts.ttf",12)
    headerFont = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 18) -- TODO: get a license for this font
    headerBigFont = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 32) -- TODO: get a license for this font
    font = headerFont
    love.graphics.setFont(textFont)

    initDummyData()
    scale, uiX, uiY = 1
    print("loaded")
end

function love.draw()
    if phase == "login" then
        drawLogin()
    else
        Luven.drawBegin()

        drawDummy()

        drawEnemies()

        
        for i,v in ipairs(playersDrawable) do
            drawOtherPlayer(v,i)
        end
        
        drawPlayer()
        drawLoot()
        Luven.drawEnd()

        love.graphics.push() -- chat and quests scaling TODO: Quests
            local i = 0.5
            love.graphics.scale(scale*i)
            drawChatPanel(uiX/i, uiY/i)
            love.graphics.setDefaultFilter("nearest", "nearest")
        love.graphics.pop()

        love.graphics.print("BrawlQuest\nEnemies in aggro: "..enemiesInAggro)
        Luven.camera:draw()
    end

    

    love.graphics.setColor(1,1,1,totalCoverAlpha)
    love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
    love.graphics.print(love.timer.getFPS().." FPS",0,love.graphics.getHeight()-12)
end

function love.update(dt)
    if phase == "login" then
        updateLogin(dt)
    else
        nextUpdate = nextUpdate - 1*dt
        if nextUpdate < 0 then
             
            getPlayerData('/players/'..username, json:encode({
                ["X"] = player.x,
                ["Y"] = player.y ,
                ["AX"] = player.target.x,
                ["AY"] = player.target.y,
            }))

            nextUpdate = 0.5
        end

        oldLightAlpha = oldLightAlpha - 2*dt -- update light, essentially
        totalCoverAlpha = totalCoverAlpha - 1*dt
        
        uiX = love.graphics.getWidth()/scale -- scaling options
        uiY = love.graphics.getHeight()/scale

        updateEnemies(dt)
        updateCharacter(dt)
        updateBones(dt)
        updateMusic(dt)
        updateLoot(dt)
        Luven.update(dt)

        if not player.target.active then
            Luven.camera:setPosition(player.dx+16, player.dy+16)
        end

        timeOfDay = timeOfDay + 0.00001*dt
        if timeOfDay < 0.8 then
            Luven.setAmbientLightColor({ 0.8-timeOfDay, 0.8-timeOfDay, 1-timeOfDay })
        else 
            Luven.setAmbientLightColor({ timeOfDay-0.8, timeOfDay-0.8, timeOfDay-1 })
            if timeOfDay > 2 then
                timeOfDay = 0 
            end
        end

        updateOtherPlayers(dt)

        local info = love.thread.getChannel( 'players' ):pop()
        if info then
            local response = json:decode(info)

            players = response['Players']
            sblockMap = response['BlockMap']
            me = response['Me']
            print(#sblockMap)
            newEnemyData(response['Enemies'])
            if response['Tick'] ~= previousTick then
                tick()
                previousTick = response['Tick']
            end
        end
    end
end

function tick()
  -- tickDummyEnemies()
    tickOtherPlayers()
    if player.target.active then
    
    else
        player.target.x = player.x
        player.target.y = player.y
    end

end



function love.keypressed(key)
    -- checkLoginKeyPressedPhaseCharchters(key)

    if (key == "l") then
        print("Tom is a lower")
    end

    if phase == "login" then
        checkLoginKeyPressed(key)
   
    else
        if key == "m" then
        beginMounting()
        end
        checkTargeting()
    end
    if key == "." then
        scale = scale * 1.25
    end
    if key == "," then
        scale = scale / 1.25
    end
    if key == "escape" then
        print("end")
        love.event.quit()
    end
end

function love.textinput(key)
    if phase == "login" then
        checkLoginTextinput(key)
    end
end

function love.mousepressed(x,y,button)
    if phase == "login" then
        checkClickLogin(x,y)
    end
end

function love.resize(width, height)
    if phase == "login" then
        initLogin()
    else
        reinitLighting(width, height)
    end
end