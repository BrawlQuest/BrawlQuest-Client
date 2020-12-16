
require "scripts.dummy.lanterns"
require "scripts.libraries.api"
require "scripts.player.character"
require "scripts.player.keyboard_input"
require "scripts.player.mouse_input"
require "scripts.effects.bones"
require "scripts.effects.lighting"
require "scripts.effects.music"
require "scripts.effects.sfx"
require "scripts.effects.loot"
require "scripts.effects.buddies"
require "scripts.ui.hud_controller"
require "scripts.ui.components.character-hub"
require "scripts.ui.components.toolbar-inventory"
require "scripts.ui.components.chat"
require "scripts.ui.components.toolbar"
require "scripts.ui.components.battlebar"
require "scripts.ui.components.profile"
require "scripts.ui.components.inventory"
require "scripts.ui.components.questpanel"
require "scripts.ui.components.questpopup"
require "scripts.ui.components.perks"
require "scripts.libraries.api"
require "scripts.libraries.utils"
require "scripts.libraries.simple-slider"
require "scripts.phases.login.login"
require "scripts.player.other_players"
require "scripts.enemies"
require "scripts.npcs"
require "scripts.world"
require "scripts.ui.temporary.worldedit"
require "data.data_controller"
require "scripts.player.settings"
require "scripts.ui.components.npc-chat"
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
nextTick = 0
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
    ["assets/world/objects/Pumpkin2.png"] = 0.8,
    ["assets/world/objects/Lamp.png"] = 1,
    ["assets/world/objects/Furnace.png"] = 1,
    ["assets/world/objects/Campfire.png"] = 1,
}

oldInfo = {}

sendUpdate = false

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    initHardData()
    initLogin()
    initHUD()
    
    initSettings()
    loadMusic()
    initEditWorld()
    initSFX()
    love.graphics.setFont(textFont)
end

function love.draw()
    if phase == "login" then
        drawLogin()
    else
        Luven.drawBegin()

        drawWorld()

        love.graphics.setColor(1, 1, 1)
        drawNPCs()
        drawEnemies()

        for i, v in ipairs(playersDrawable) do
            drawPlayer(v, i)
        end

        drawPlayer(me, -1)
        drawLoot()
        drawFloats()
        Luven.drawEnd()
       --wd drawNPCChatIndicator()
        if not isWorldEditWindowOpen then
            drawHUD()
        end
        if isWorldEditWindowOpen then
            drawEditWorldWindow()
        end


        for i,v in ipairs(npcs) do
            if distanceToPoint(player.x,player.y,v.X,v.Y) <= 1 and not showNPCChatBackground  and v.Conversation ~= "" then
                love.graphics.setFont(smallTextFont)
                love.graphics.setColor(0,0,0)
                love.graphics.rectangle("fill",love.graphics.getWidth()/2-smallTextFont:getWidth("Press E to talk")/2,love.graphics.getHeight()/2+38,smallTextFont:getWidth("Press E to talk"),smallTextFont:getHeight())
                love.graphics.setColor(1,1,1)
                love.graphics.print("Press E to talk",love.graphics.getWidth()/2-smallTextFont:getWidth("Press E to talk")/2,love.graphics.getHeight()/2+38)
            end
        end
       
             Luven.camera:draw()
          
        -- print(brightnessSlider:getValue())
    end


    mx, my = love.mouse.getPosition()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(mouseImg, mx, my)
    love.graphics.print(player.x..", "..player.y,200,200)

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
        
        updateHUD(dt)

        updateEnemies(dt)
        updateNPCs(dt)
        updateCharacter(dt)
        updateBones(dt)
        updateMusic(dt)
        updateLoot(dt)
        updateNPCChat(dt)
        Luven.update(dt)

        if not player.target.active then
            Luven.camera:setPosition(player.dx + 16, player.dy + 16)
        end
        
        updateOtherPlayers(dt)

        local info = love.thread.getChannel('players'):pop()
        if info then
            local response = json:decode(info)

            players = response['Players']
            npcs = response['NPC']

            if json:encode(inventoryAlpha) ~= json:encode(response['Inventory']) then
                updateInventory(response)
                inventoryAlpha = response['Inventory']
            end
         
            player.cp = response['CharPoints']
            messages = {}
            for i=1, #response['Chat']['Global'] do
                local v = response['Chat']['Global'][#response['Chat']['Global'] + 1 - i]
             
                messages[#messages+1] = {
                    username = v["Sender"]["Name"],
                    text = v["Message"],
                    player = v["Sender"]
                }
             end
            
           timeOfDay = cerp(0.1, 1, ((math.abs(response['CurrentHour']) * 60) + 0) / 720)
        
           Luven.setAmbientLightColor({timeOfDay, timeOfDay, timeOfDay+0.1})

           me = response['Me']

            if distanceToPoint(me.X, me.Y, player.x, player.y) > 4 then
                player.x = me.X
                player.dx = me.X*32
                player.dy = me.Y*32
                player.y = me.Y
          
                totalCoverAlpha = 2
                love.audio.play(awakeSfx)
            end
            -- update player
            player.name = me.Name
  
            player.buddy = me.Buddy
            player.hp = me.HP
            player.xp = me.XP
            if player.lvl ~= me.LVL then
                love.audio.play(lvlSfx)
                player.lvl = me.LVL
            end
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

function love.resize(width, height)
    if phase == "login" then
        initLogin()
    else
        createWorld()
        loadSliders()
    end
    if scale then
        uiX = love.graphics.getWidth()/scale -- scaling options
        uiY = love.graphics.getHeight()/scale
    end
end
