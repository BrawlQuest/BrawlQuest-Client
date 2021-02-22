
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
require "scripts.effects.clouds"
require "scripts.effects.world-mask"
require "scripts.ui.hud_controller"
require "scripts.ui.components.character-hub"
require "scripts.ui.components.crafting"
require "scripts.ui.components.toolbar-inventory"
require "scripts.ui.components.draw-inventory"
require "scripts.ui.components.quest-hub"
require "scripts.ui.components.quests-panel"
require "scripts.ui.components.settings-panel"
require "scripts.ui.components.chat"
require "scripts.ui.components.toolbar"
require "scripts.ui.components.zone-titles"
require "scripts.ui.components.profile"
require "scripts.ui.components.hotbar"
require "scripts.ui.components.events"
require "scripts.libraries.api"
require "scripts.libraries.utils"
require "scripts.libraries.colorize"
require "scripts.libraries.simple-slider"
require "scripts.phases.login.login"
require "scripts.player.other_players"
require "scripts.player.ranged-weapons"
require "scripts.player.targeting"
require "scripts.enemies"
require "scripts.npcs"
require "scripts.world"
require "scripts.ui.temporary.worldedit"
require "scripts.ui.temporary.new-world-edit"
require "scripts.ui.temporary.world-edit-rect"
require "data.data_controller"
require "scripts.player.settings"
require "scripts.ui.components.npc-chat"
require "scripts.ui.components.tutorial"
Luven = require "scripts.libraries.luven.luven"

steam = require 'luasteam'
json = require("scripts.libraries.json")
http = require("socket.http")
ltn12 = require("ltn12")
newOutliner = require 'scripts.libraries.outliner'

version = "Pre-Release" 
versionType = "dev" -- "dev" for quick login, "release" for not
versionNumber = "Beta 1.1.2" -- very important for settings

phase = "login"

blockMap = {}
treeMap = {}
players = {} -- other players
playersDrawable = {}
blockMap = {}
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
playersOnline = ""

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
    outlinerOnly = newOutliner(true)
    outlinerOnly:outline(0.8,0,0) -- this is used to draw enemy outlines
    steam.init()
    love.graphics.setDefaultFilter("nearest", "nearest")
    initHardData()
    initLogin()
    initHUD()
    initLeaves()
    initSettings()
    loadMusic()
    initEditWorld()
    initSFX()
    initTargeting()
    initEvents()
    initCamera()
    initRangedWeapons()
    initClouds()
    initWorldMask()
    love.graphics.setFont(textFont)
end

function love.draw()
    inventory.notNPC = true -- I've moved this here so that it defaults to on and is then turned off rather than turned on. This means that we don't have to worry about its position when checking for "Press E" text or similar
    if phase == "login" then
        drawLogin()
    else
        Luven.drawBegin()

            drawWorld()

            if worldEdit.open and player then
                drawNewWorldEditTiles()
            end
            
            drawAuras()
            drawBones()
            love.graphics.setColor(1, 1, 1)
            drawNPCs()
            drawEnemies()
            -- drawRangedWeaponEffects()

            for i, v in ipairs(playersDrawable) do
                drawPlayer(v, i)
            end
            drawFloats()
            drawPlayer(me, -1)
            if showWorldAnimations then drawLeaves() end
            drawLoot()
            

            if not worldEdit.open then drawWorldMask() end
            if showClouds then drawClouds() end     
            for i,v in ipairs(npcs) do
                if distanceToPoint(player.x,player.y,v.X,v.Y) <= 1 and not showNPCChatBackground  and v.Conversation ~= "" then
                    local isQuestCompleter = false
                    for k,q in ipairs(quests[1]) do
                    
                            if q.rawData.Quest.ReturnNPCID == v.ID and q.currentAmount == q.requiredAmount then
                                drawTextBelowPlayer("Press "..keybinds.INTERACT.." to complete quest")
                                isQuestCompleter = true
                            end
                       
                    end

                    if not isQuestCompleter then
                        drawTextBelowPlayer("Press "..keybinds.INTERACT.." to talk")
                    end
                        
                    inventory.notNPC = false
                    openTutorial(4)
                end
            end
        
            if isNearbyTile("assets/world/objects/Anvil.png") then  drawTextBelowPlayer("Press "..keybinds.INTERACT.." to craft")
                inventory.notNPC = false
            end

            if showWorldMask and not worldEdit.open then drawWorldMask() end --not worldEdit.open or
            if showClouds and not worldEdit.open then drawClouds() end

            -- if player.target.active then
            --     love.graphics.setColor(1,0,0,0.5 * nextTick)
            --     love.graphics.rectangle("fill", player.target.x * 32, player.target.y * 32, 32, 32)
            --     love.graphics.setColor(1,1,1)
            -- end
            Luven.drawEnd()
     
            if not worldEdit.open then drawHUD() end
            drawNewWorldEditHud()

        Luven.camera:draw()

        local offset = cerp(10, 205, inventory.amount)
        love.graphics.setColor(1,1,1)
        love.graphics.setFont(settPan.itemFont)
        love.graphics.print("X,Y: " .. player.x..","..player.y .. " FPS: " .. tostring(love.timer.getFPS()).."\nPlayers: "..playersOnline, offset, 10)
        -- if worldLookup[player.x] and worldLookup[player.x][player.y] then
        --     love.graphics.print(string.upper("\n"..tostring(worldLookup[player.x][player.y].Name)), offset, 13)
        -- end

    end


    mx, my = love.mouse.getPosition()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(mouseImg, mx, my)

    -- love.graphics.setColor(1, 1, 1, totalCoverAlpha)
    -- if totalCoverAlpha > 0 then love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight()) end
end

function love.update(dt)
    steam.runCallbacks()

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
        updateEvents(dt)
        -- updateRangedWeapons(dt)
        if showNPCChatBackground then updateNPCChat(dt) end
        -- if showClouds then updateClouds(dt) end
        if showWorldAnimations then updateLeaves(dt) end
        Luven.update(dt)
        if showClouds then updateClouds(dt) end
        if showWorldMask then updateWorldMask(dt) end
        updateCamera(dt)
        updateOtherPlayers(dt)

        local info = love.thread.getChannel('players'):pop()
        if info then
            local response = json:decode(info)


            local previousPlayers = copy(players) -- Temp
            players = response['Players']
            npcs = response['NPC']
            auras = response['Auras']
            playersOnline = ""
            if response['OnlinePlayers'] then
                for i,v in ipairs(response['OnlinePlayers']) do
                    playersOnline = playersOnline..v.." "
                end
            end
            if json:encode(players) ~= json:encode(previousPlayers) then -- Temp [
                for i,v in ipairs(players) do
                    if v.Color == null then -- New thing for the people
                        if previousPlayers[i] and previousPlayers[i].Color then
                            players[i].Color = previousPlayers[i].Color
                        else
                            players[i].Color = {love.math.random(), love.math.random(), love.math.random(),  1}
                        end
                    end
                end
            end -- Temp ]

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
            timeOfDay = timeOfDay + 0.2
            usedItemThisTick = false

            if not worldEdit.open then
                Luven.setAmbientLightColor({timeOfDay, timeOfDay, timeOfDay+  0.1})
            else
                Luven.setAmbientLightColor({1,1,1})
            end

            local previousMe = copy(me) -- Temp
            me = response['Me']

            if perks.stats[1] == 0 then
                perks.stats = {me.STR, me.INT, me.STA, player.cp}
            end

            if json:encode(me) ~= json:encode(previousMe) then -- Temp [
                if me.Color == null then -- New thing for the people
                    if previousMe and previousMe.Color then
                        me.Color = previousMe.Color
                    else
                        me.Color = {love.math.random(), love.math.random(), love.math.random(),  1}
                    end
                end
            end -- Temp ]

            if distanceToPoint(me.X, me.Y, player.x, player.y) > 4 then
                player.x = me.X
                player.y = me.Y
                player.dx = me.X*32
                player.dy = me.Y*32
                player.cx = me.X*32
                player.cy = me.Y*32
                totalCoverAlpha = 2
                love.audio.play(awakeSfx)
            end
            -- update player
            player.name = me.Name
            player.buddy = me.Buddy
            if player.hp > me.HP then
                player.damageHUDAlphaUp = true
                boneSpurt(player.dx + 16, player.dy + 16, player.hp - me.HP, 40, 1, 1, 1, "me")
            end
            player.hp = me.HP
            player.owedxp = me.XP - player.xp
            player.xp = me.XP
            if player.lvl ~= me.LVL then
                if player.lvl ~= 0 then
                    openTutorial(6)
                end
                love.audio.play(lvlSfx)
                player.lvl = me.LVL
            end
            player.name = me.Name
            newEnemyData(response['Enemies'])
            quests = {
                {},
                {},
                {}
            }
            for i,v in ipairs(response['MyQuests']) do
                local trackedVar = 2
                if v.Tracked == 1 then
                    trackedVar = 1
                end
                quests[v.Tracked][#quests[v.Tracked]+1] = {
                    title = v.Quest.Title,
                    comment = v.Quest.Desc,
                    profilePic = v.Quest.ImgPath,
                    giver = "",
                    requiredAmount = v.Quest.ValueRequired,
                    currentAmount = v.Progress,
                    rawData = v
                }
                if v.Quest.Type == "kill" then
                    quests[v.Tracked][#quests[v.Tracked]].task = "Kill "..v.Quest.ValueRequired.."x "..v.Quest.Value
                elseif v.Quest.Type == "gather" then
                 
                        quests[v.Tracked][#quests[v.Tracked]].task = "Gather "..v.Quest.ValueRequired.."x "..v.Quest.Value
                end
            end

            activeConversations = response['ActiveConversations']
            if response['Tick'] ~= previousTick then
                tick()
                previousTick = response['Tick']
            end
        end
    end

    
end

function tick()
    tickOtherPlayers()
    tickEnemies()
    tickAuras()
    checkTargeting()
    nextTick = 1
    getInventory()
    -- tickRangedWeapons() 
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
    getDisplay()
    writeSettings()
end

function love.quit()
    steam.shutdown()
end