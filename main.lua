
require 'scripts.dummy.lanterns'
require "scripts.libraries.api"
require "scripts.player.character"
require "scripts.effects.bones"
require "scripts.effects.lighting"
require "scripts.effects.music"
require "scripts.effects.sfx"
require "scripts.effects.loot"
require "scripts.ui.hud_controller"
require "scripts.ui.components.chat"
require "scripts.ui.components.toolbar"
require "scripts.ui.components.battlebar"
require "scripts.ui.components.profile"
require "scripts.ui.components.inventory"
require "scripts.ui.components.questpannel"
require "scripts.ui.components.questpopup"
require "scripts.ui.components.perks"
require "scripts.libraries.api"
require "scripts.libraries.utils"
require 'scripts.libraries.simple-slider'
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
        drawEnemies()

        for i, v in ipairs(playersDrawable) do
            drawPlayer(v, i)
        end

        drawPlayer(me, -1)
        drawLoot()
        drawFloats()
        Luven.drawEnd()
    
        if not isWorldEditWindowOpen then
            drawHUD()
        end
        if isWorldEditWindowOpen then
            drawEditWorldWindow()
        end
        Luven.camera:draw()
        -- print(brightnessSlider:getValue())
    end


    mx, my = love.mouse.getPosition()
    love.graphics.setColor(1,1,1)
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

        date_table = os.date("*t")
        ms = string.match(tostring(os.clock()), "%d%.(%d+)")
        hour, minute, second = date_table.hour, date_table.min, date_table.sec
        timeOfDay = cerp(0.1, 1, ((math.abs(hour) * 60) + math.abs(minute)) / 720)
        Luven.setAmbientLightColor({timeOfDay, timeOfDay, timeOfDay+0.1})

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
            messages = {}
            for i=1, #response['Chat']['Global'] do
                local v = response['Chat']['Global'][#response['Chat']['Global'] + 1 - i]
             
                messages[#messages+1] = {
                    username = v["Sender"]["Name"],
                    text = v["Message"],
                    player = v["Sender"]
                }
             end
             
       

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
        if not isTypingInChat then
            if isWorldEditWindowOpen then
                checkEditWorldKeyPressed(key)
            elseif isSettingsWindowOpen then
                if key == "escape" then
                    isSettingsWindowOpen = false
                end
                if key == "return" then
                    love.event.quit()
                end
            else
                if key == "m" then
                    beginMounting()
                end
                checkTargeting()
                if key == "." then
                    scale = scale * 1.25
                    uiX = love.graphics.getWidth()/scale -- scaling options
                    uiY = love.graphics.getHeight()/scale
                end
                if key == "," then
                    scale = scale / 1.25
                    uiX = love.graphics.getWidth()/scale -- scaling options
                    uiY = love.graphics.getHeight()/scale
                end
                if key == keybinds.SHIELD then
                    shieldUpSfx:play()
                end
                if key == "escape" then                 
                    isSettingsWindowOpen = true
                    loadSliders()
                end
            end
            if key == "'" then
                if isWorldEditWindowOpen then isWorldEditWindowOpen = false else isWorldEditWindowOpen = true end
            elseif key == "space" and love.keyboard.isDown("lshift") then
                c, h = http.request{url = api.url.."/world", method="POST", source=ltn12.source.string(json:encode(pendingWorldChanges)), headers={["Content-Type"] = "application/json",["Content-Length"]=string.len(json:encode(pendingWorldChanges)),["token"]=token}}
                pendingWorldChanges = {}
                local b = {}
                c, h = http.request{url = api.url.."/world", method="GET", source=ltn12.source.string(body), headers={["token"]=token}, sink=ltn12.sink.table(b)}
                world = json:decode(b[1])
                createWorld()
            elseif key == "lctrl" then
                --
                pendingWorldChanges[#pendingWorldChanges+1] = {
                    GroundTile = textfields[5],
                    ForegroundTile = textfields[6],
                    Name =  textfields[7],
                    Music = "*",
                    Collision = thisTile.Collision,
                    Enemy = textfields[8],
                    X = player.x + 0,
                    Y = player.y + 0,
                }
                
            elseif key == "o" then
            end
        end
        if key == "q" then
            print("Time of Day = " .. timeOfDay)
            love.event.quit()
        end
        checkKeyPressedChat(key)
    end
end

function love.keyreleased(key)
    if key == keybinds.SHIELD and not isTypingInChat then
        shieldDownSfx:play()
    end
end

function love.textinput(key)
    if phase == "login" then
        checkLoginTextinput(key)
    elseif isWorldEditWindowOpen and key ~= "'" then
        checkEditWorldTextinput(key)
    elseif isTypingInChat then
        checkChatTextinput(key)
    end
end

function love.mousepressed(x, y, button)
    if phase == "login" then
        checkClickLogin(x, y)
    elseif isWorldEditWindowOpen then
        checkEditWorldClick(x, y)
    elseif phase == "game" then
       checkInventoryMousePressed()
    --    checkChatMousePressed()
       checkPerksMousePressed(button)
       checkSettingsMousePressed(button)
    end
end

function love.resize(width, height)
    if phase == "login" then
        initLogin()
    else
        createWorld()
        loadSliders()
    end
    uiX = love.graphics.getWidth()/scale -- scaling options
    uiY = love.graphics.getHeight()/scale
end
