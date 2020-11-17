
require 'scripts.dummy.lanterns'
require "scripts.libraries.api"
require "scripts.player.character"
require "scripts.effects.bones"
require "scripts.effects.lighting"
require "scripts.effects.music"
require "scripts.effects.loot"
require "scripts.ui.hud_controller"
require "scripts.ui.componants.chat"
require "scripts.ui.componants.toolbar"
require "scripts.ui.componants.battlebar"
require "scripts.ui.componants.profile"
require "scripts.ui.componants.inventory"
require "scripts.libraries.api"
require "scripts.libraries.utils"
require "scripts.phases.login.login"
require "scripts.player.other_players"
require "scripts.enemies"
require "scripts.world"
require "scripts.ui.temporary.worldedit"
require "data.data_controller"
require "scripts.player.settings"
Luven = require "scripts.libraries.luven.luven"

json = require("scripts.libraries.json")
http = require("socket.http")
ltn12 = require("ltn12")

version = "Pre-Release"
phase = "login"

blockMap = {}
treeMap = {}
players = {} -- other players
playersDrawable = {}
sblockMap = {}
lootTest = {}
inventoryAlpha = {}
itemImg = {}
nextUpdate = 1
timeOutTick = 3
previousTick = 0
nextTick = 1
totalCoverAlpha = 0 -- this covers the entire screen in white, for hiding purposes
timeOfDay = 0
enemiesInAggro = 0
username = "Pebsie"
readyForUpdate = true

world = {}
worldImg = {}
lightGivers = {
    ["assets/world/objects/lantern.png"] = 1,
    ["assets/world/objects/Mushroom.png"] = 0.5,
    ["assets/world/objects/Pumpkin0.png"] = 0.8,
    ["assets/world/objects/Pumpkin1.png"] = 0.8,
    ["assets/world/objects/Pumpkin2.png"] = 0.8
}

oldInfo = {}

sendUpdate = false

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    initHardData()
    initSettings()

    loadMusic()
    initLogin()
    initHUD()
    initEditWorld()
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

    textFont = love.graphics.newFont("assets/ui/fonts/rainyhearts.ttf", 24)

    smallTextFont = love.graphics.newFont("assets/ui/fonts/rainyhearts.ttf", 12)
    headerFont = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 18) -- TODO: get a license for this font
    headerBigFont = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 32) -- TODO: get a license for this font
    font = headerFont
    love.graphics.setFont(textFont)

end

function love.draw()
    if phase == "login" then
        drawLogin()
    else
        Luven.drawBegin()

        drawWorld()

        love.graphics.setColor(1, 1, 1)
        drawEnemies()

        for i, v in ipairs(playersDrawable) do
            drawOtherPlayer(v, i)
        end

        drawPlayer()
        drawLoot()
        drawFloats()
        Luven.drawEnd()
    
        drawHUD()
        if isWorldEditWindowOpen then
            drawEditWorldWindow()
        end
        Luven.camera:draw()
    end


    mx, my = love.mouse.getPosition()
    love.graphics.draw(mouseImg, mx, my)

    love.graphics.setColor(1, 1, 1, totalCoverAlpha)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

function love.update(dt)
    totalCoverAlpha = totalCoverAlpha - 1 * dt
    if phase == "login" then
        updateLogin(dt)
    else
        nextUpdate = nextUpdate - 1 * dt
        nextTick = nextTick - 1 * dt
        if nextUpdate < 0 then

            getPlayerData('/players/' .. username, json:encode(
                {
                    ["X"] = player.x,
                    ["Y"] = player.y,
                    ["AX"] = player.target.x,
                    ["AY"] = player.target.y,
                    ["IsShield"] = love.keyboard.isDown(keybinds.SHIELD)
                }))

            nextUpdate = 0.5
        end
        oldLightAlpha = oldLightAlpha - 2 * dt -- update light, essentially
        
        updateHUD(dt)

     
        updateEnemies(dt)

        updateCharacter(dt)
        updateBones(dt)
        updateMusic(dt)
        updateLoot(dt)
        Luven.update(dt)

        if not player.target.active then
            Luven.camera:setPosition(player.dx + 16, player.dy + 16)
        end

        local date_table = os.date("*t")
        local ms = string.match(tostring(os.clock()), "%d%.(%d+)")
        local hour, minute, second = date_table.hour, date_table.min, date_table.sec
        timeOfDay = 0 -- date_table.min/1440
        if timeOfDay < 0.8 then
            Luven.setAmbientLightColor({0.8 - timeOfDay, 0.8 - timeOfDay, 1 - timeOfDay})
        else
            Luven.setAmbientLightColor({timeOfDay - 0.8, timeOfDay - 0.8, timeOfDay - 1})
            if timeOfDay > 2 then
                timeOfDay = 0
            end
        end

        updateOtherPlayers(dt)

        local info = love.thread.getChannel('players'):pop()
        if info then
            local response = json:decode(info)

            players = response['Players']

            if json:encode(inventoryAlpha) ~= json:encode(response['Inventory']) then
                updateInventory(response)
                inventoryAlpha = response['Inventory']
            end
            me = response['Me']

            if distanceToPoint(me.X, me.Y, player.x, player.y) > 6 then
                player.x = 0
                player.dx = 0
                player.dy = 0
                player.y = 0
                totalCoverAlpha = 2
                love.audio.play(awakeSfx)
            end
            -- update player
            player.hp = me.HP
            player.name = me.Name
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
    tickEnemies()
    nextTick = 1
end

function love.keypressed(key)

    if phase == "login" then
        checkLoginKeyPressed(key)
    else
        if isWorldEditWindowOpen then
            checkEditWorldKeyPressed(key)
        else
            if key == "m" then
                beginMounting()
            end
            checkTargeting()
            if key == "." then
                scale = scale * 1.25
            end
            if key == "," then
                scale = scale / 1.25
            end
            if key == keybinds.SHIELD then
                shieldUpSfx:play()
            end
        end
        if key == "'" then
            if isWorldEditWindowOpen then
                isWorldEditWindowOpen = false
            else
                isWorldEditWindowOpen = true
            end
        elseif key == "lctrl" then
            -- createWorld()
            -- print("Sending...")
            -- pendingWorldChanges[#pendingWorldChanges+1] = {
            --     GroundTile = textfields[5],
            --     ForegroundTile = textfields[6],
            --     Name =  textfields[7],
            --     Music = "*",
            --     Collision = thisTile.Collision,
            --     Enemy = textfields[8],
            --     X = player.x,
            --     Y = player.y,
            -- }
            -- print(json:encode(pendingWorldChanges))
            -- c, h = http.request{url = api.url.."/world", method="POST", source=ltn12.source.string(json:encode(pendingWorldChanges)), headers={["Content-Type"] = "application/json",["Content-Length"]=string.len(json:encode(pendingWorldChanges)),["token"]=token}}
            -- pendingWorldChanges = {}
        elseif key == "o" then
        end
    end

    if key == "escape" then
        love.event.quit()
    end
end

function love.keyreleased(key)
    if key == keybinds.SHIELD then
        shieldDownSfx:play()
    end
end

function love.textinput(key)
    if phase == "login" then
        checkLoginTextinput(key)
    elseif isWorldEditWindowOpen and key ~= "'" then
        checkEditWorldTextinput(key)
    end
end

function love.mousepressed(x, y, button)
    if phase == "login" then
        checkClickLogin(x, y)
    elseif isWorldEditWindowOpen then
        checkEditWorldClick(x, y)
    elseif love.keyboard.isDown("lctrl") then
        pendingWorldChanges[#pendingWorldChanges + 1] = {
            GroundTile = textfields[5],
            ForegroundTile = textfields[6],
            Name = textfields[7],
            Music = "*",
            Collision = thisTile.Collision,
            Enemy = textfields[8],
            X = player.x,
            Y = player.y
        }
        print(json:encode(pendingWorldChanges))
        c, h = http.request {
            url = api.url .. "/world",
            method = "POST",
            body = ltn12.source.string(json:encode(pendingWorldChanges)),
            headers = {
                ["token"] = token
            }
        }
        pendingWorldChanges = {}
    elseif phase == "game" then
       checkInventoryMousePressed()
    end
end

function love.mousereleased(x, y, button)
    if #pendingWorldChanges ~= 0 then
        c, h = http.request {
            url = api.url .. "/world",
            method = "POST",
            body = ltn12.source.string(json:encode(pendingWorldChanges)),
            headers = {
                ["token"] = token
            }
        }
        pendingWorldChanges = {}
    end
end

function love.resize(width, height)
    if phase == "login" then
        initLogin()
    else
        createWorld()
    end

end
