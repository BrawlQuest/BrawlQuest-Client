
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
require "scripts.effects.auras"
require "scripts.effects.leaves"
require "scripts.effects.camera"
require "scripts.ui.hud_controller"
require "scripts.ui.components.character-hub"
require "scripts.ui.components.crafting"
require "scripts.ui.components.toolbar-inventory"
require "scripts.ui.components.quest-hub"
require "scripts.ui.components.quests-panel"
require "scripts.ui.components.chat"
require "scripts.ui.components.toolbar"
require "scripts.ui.components.battlebar"
require "scripts.ui.components.zone-titles"
require "scripts.ui.components.profile"
require "scripts.libraries.api"
require "scripts.libraries.utils"
require "scripts.libraries.simple-slider"
require "scripts.phases.login.login"
require "scripts.player.other_players"
require "scripts.enemies"
require "scripts.npcs"
require "scripts.world"
require "scripts.ui.temporary.worldedit"
require "scripts.ui.temporary.new-world-edit"
require "scripts.ui.temporary.world-edit-rect"
require "data.data_controller"
require "scripts.player.settings"
require "scripts.ui.components.npc-chat"
Luven = require "scripts.libraries.luven.luven"

json = require("scripts.libraries.json")
http = require("socket.http")
ltn12 = require("ltn12")

version = "Pre-Release" 
versionNumber = "2.0" -- very important for settings

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
    ["assets/world/grounds/Lava.png"] = 0.2,
}

oldInfo = {}

sendUpdate = false

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    initHardData()
    initLogin()
    initHUD()
    initLeaves()
    initSettings()
    loadMusic()
    initEditWorld()
    initSFX()
    initCamera()
    love.graphics.setFont(textFont)
end

function love.draw()
    if phase == "login" then
        drawLogin()
    else
        Luven.drawBegin()

            drawWorld()

            if worldEdit.open and player then
                drawNewWorldEditTiles()
            end

            drawAuras()
            love.graphics.setColor(1, 1, 1)
            drawNPCs()
            drawEnemies()

            for i, v in ipairs(playersDrawable) do
                drawPlayer(v, i)
            end

            drawPlayer(me, -1)
            drawLeaves()
            drawLoot()
            drawFloats()
            
            Luven.drawEnd()
            
            if not worldEdit.open then
                drawHUD()
            end
            
            drawNewWorldEditHud()

            inventory.notNPC = true
            for i,v in ipairs(npcs) do
                if distanceToPoint(player.x,player.y,v.X,v.Y) <= 1 and not showNPCChatBackground  and v.Conversation ~= "" then
                    drawTextBelowPlayer("Press "..keybinds.INTERACT.." to talk")
                    inventory.notNPC = false
                end
            end

            if isNearbyTile("assets/world/objects/Anvil.png") then  drawTextBelowPlayer("Press "..keybinds.INTERACT.." to craft")
            end
        
        Luven.camera:draw()

        love.graphics.setFont(font)
        love.graphics.print(player.x..", "..player.y .. ", " .. tostring(love.timer.getFPS()), 10, 6)
        if worldLookup[player.x] and worldLookup[player.x][player.y] then    
            love.graphics.print("\n"..tostring(worldLookup[player.x][player.y].Name), 10, 6)
        end
    end


    mx, my = love.mouse.getPosition()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(mouseImg, mx, my)
    

    love.graphics.setColor(1, 1, 1, totalCoverAlpha)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
end

function love.update(dt)

    Luven.camera:setScale(worldScale)
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
        updateAuras(dt)
        updateMusic(dt)
        updateLoot(dt)
        updateNPCChat(dt)
        updateLeaves(dt)
        Luven.update(dt)
        updateCamera(dt)
        updateOtherPlayers(dt)

        local info = love.thread.getChannel('players'):pop()
        if info then
            local response = json:decode(info)

            players = response['Players']
            npcs = response['NPC']
            auras = response['Auras']
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
    tickAuras()
    nextTick = 1
end

function love.resize(width, height)
    local x, y, thisdisplay = love.window.getPosition( )
    display = thisdisplay
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
    writeSettings()
end
