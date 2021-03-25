require "scripts.dummy.lanterns"
require "scripts.libraries.api"
require "scripts.player.character"
require "scripts.player.keyboard"
require "scripts.player.mouse"
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
require "scripts.effects.death"
require "scripts.effects.critters"
require "scripts.effects.weather"
require "scripts.effects.world-sfx-emitters"
require "scripts.effects.particles"
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
require "scripts.ui.components.enchanting"
require "scripts.ui.components.challenges"
require "scripts.ui.components.item-drag"
require "scripts.ui.components.forging"
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
require "scripts.player.structures"
require "scripts.ui.components.npc-chat"
require "scripts.ui.components.tutorial"
require "scripts.achievements"
Luven = require "scripts.libraries.luven.luven"

if love.system.getOS() ~= "Linux" then steam = require 'luasteam' end -- we can disable other platforms here. Can't get Steam working on Linux and we aren't targetting it so this'll do for dev purposes
json = require("scripts.libraries.json")
http = require("socket.http")
ltn12 = require("ltn12")
utf8 = require("utf8")
newOutliner = require 'scripts.libraries.outliner'

version = "Early Access" 
versionType = "dev" -- "dev" for quick login, "release" for not
if versionType == "dev" then require 'dev' end
versionNumber = "1.3.0" -- very important for settings

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
lastTick = 0
totalCoverAlpha = 0 -- this covers the entire screen in white, for hiding purposes
timeOfDay = 0
enemiesInAggro = 0
username = "Pebsie"
readyForUpdate = true
playersOnline = ""
firstLaunch = true
playerCount = 0

oldInfo = {}

sendUpdate = false

function love.load()
    showMouse, mouseAmount, mx, my = true, 1, 0, 0
    limits = love.graphics.getSystemLimits( )
    print(limits.multicanvas)
    outlinerOnly = newOutliner(true)
    outlinerOnly:outline(0.8,0,0) -- this is used to draw enemy outlines
    grayOutlinerOnly = newOutliner(true)
    grayOutlinerOnly:outline(1,1,1)
    if love.system.getOS() ~= "Linux" then  steam.init() end
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
    initDeath()
    initPlayers()
    initEnchanting()
    initChallenges()
    initItemDrag()
    initForging()
    initCritters()
    initWeather()
    initParticles()
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
            drawStructures()
            drawAuras()
            drawBones()
            love.graphics.setColor(1, 1, 1)
            drawNPCs()
            drawEnemies()
            drawRangedWeaponEffects()
            drawExplosions()
            drawParticles()

            for i, v in ipairs(playersDrawable) do
                drawPlayer(v, i)
            end
            drawFloats()
            
            drawPlayer(me, -1)
            if showWorldAnimations then drawLeaves() drawCritters() end
            drawLoot()

            local drawingText = false
            if isNearbyTile("assets/world/objects/Anvil.png") and not drawingText then
                drawTextBelowPlayer("Press "..keybinds.INTERACT.." to craft")
                inventory.notNPC = false
                drawingText = true
            elseif isNearbyTile("assets/world/objects/Furnace.png") and not drawingText then
                drawTextBelowPlayer("Press "..keybinds.INTERACT.." to forge")
                inventory.notNPC = false
                drawingText = true
            elseif isNearbyTile("assets/world/objects/Portal.png") and not drawingText then
                if me.LVL ~= 25 then
                    drawTextBelowPlayer("You must be Level 25 to Enchant")
                else
                    drawTextBelowPlayer("Press "..keybinds.INTERACT.." to Enchant")
                end
                inventory.notNPC = false
                drawingText = true
            end

            for i,v in ipairs(npcs) do
                if distanceToPoint(player.x,player.y,v.X,v.Y) <= 1 and not showNPCChatBackground  and v.Conversation ~= "" then
                    local isQuestCompleter = false
                    for k,q in ipairs(quests[1]) do
                        if q.rawData.Quest.ReturnNPCID == v.ID and q.currentAmount == q.requiredAmount then
                            drawTextBelowPlayer("Press "..keybinds.INTERACT.." to complete quest")
                            isQuestCompleter = true
                        end
                    end

                    if not isQuestCompleter and not drawingText then
                        drawTextBelowPlayer("Press "..keybinds.INTERACT.." to talk")
                        drawingText = true
                    end
                        
                    inventory.notNPC = false
                    openTutorial(4)
                end
            end
            drawWeather()
            if showWorldMask and not worldEdit.open and enchanting.amount < 0.01 then drawWorldMask() end --not worldEdit.open or
            if showClouds and not worldEdit.open and enchanting.amount < 0.01 then drawClouds() end

            -- if player.target.active then
            --     love.graphics.setColor(1,0,0,0.5 * nextTick)
            --     love.graphics.rectangle("fill", player.target.x * 32, player.target.y * 32, 32, 32)
            --     love.graphics.setColor(1,1,1)
            -- end
            
        Luven.drawEnd()
      
        if death.open then drawDeath() end
        if not worldEdit.open then drawHUD() end
        drawNewWorldEditHud()
        Luven.camera:draw()

        local offset = cerp(10, 324 * scale, inventory.amount)
        love.graphics.setColor(1,1,1)
        love.graphics.setFont(settPan.itemFont)
        local text
        if true then text = "BrawlQuest "..version.." "..versionNumber.."\nX,Y: " .. player.x..","..player.y .. " FPS: " .. tostring(love.timer.getFPS()) .. "\nPlayers: " .. playerCount .."\n"..playersOnline
        else text = "X,Y: " .. player.x..","..player.y .. " FPS: " .. tostring(love.timer.getFPS()) .. "\nPlayers: " .. playerCount end
        love.graphics.print(text, offset, 10)
    end
    mx, my = love.mouse.getPosition()
    love.graphics.setColor(1,1,1,mouseAmount)
    love.graphics.draw(mouseImg, mx, my)
end

function love.update(dt)
    if love.system.getOS() ~= "Linux" then steam.runCallbacks() end

    enchantmentPos = enchantmentPos + 15 * dt
    if enchantmentPos > 64 then enchantmentPos = 0 end

    totalCoverAlpha = totalCoverAlpha - 1 * dt
    if phase == "login" then
        updateLogin(dt)
    else
        love.audio.setPosition(player.dx / 32, player.dy / 32)
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
        updateMouse(dt)
        updateHUD(dt)
        updateEnemies(dt)
        updateNPCs(dt)
        updateCharacter(dt)
        updateBones(dt)
        updateAuras(dt)
        updateMusic(dt)
        updateLoot(dt)
        updateEvents(dt)
        updateChallenges(dt)
        updateWeather(dt)
        updateWorldEmitters(dt)
        updateParticles(dt)
        if itemDrag.dragging then updateItemDrag(dt) end
        if death.open then updateDeath(dt) end
        if forging.open then updateForging(dt) end
        updateRangedWeapons(dt)
        if showNPCChatBackground then updateNPCChat(dt) end
        if showWorldAnimations then updateLeaves(dt) updateCritters(dt) end
        Luven.update(dt)
        if showClouds and enchanting.amount < 0.01 then updateClouds(dt) end
        if showWorldMask then updateWorldMask(dt) end
        if enchanting.amount >= 0.01 then updateEnchanting(dt) end
        updateCamera(dt)
        updateOtherPlayers(dt)
        local info = love.thread.getChannel('players'):pop()
        if info then
            local response = json:decode(info)

            if response then
                local previousMe = copy(me) -- Temp
                me = response['Me']
                if not isMouseDown() then-- if perks.stats[1] == 0 then
                    perks.stats = {me.STR, me.INT, me.STA, player.cp}
                end

                if response then
                    local previousPlayers = copy(players) -- Temp

                
                    players = response['Players']
                    npcs = response['NPC']
                    auras = response['Auras']
                    playersOnline = ""
                    playerCount = 0
                    if response['OnlinePlayers'] then
                        for i,v in ipairs(response['OnlinePlayers']) do
                            playersOnline = playersOnline .. v .. "\n"
                            playerCount = playerCount + 1
                        end
                    end
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
                    usedItemThisTick = false
                    setLighting(response)
                    local previousMe = copy(me) -- Temp
                    me = response['Me']
                    
                    if response["PlayerStructures"] then
                        structures = response["PlayerStructures"]
                        updateWorldLookup()
                    end
                    if perks.stats[1] == 0 then
                        perks.stats = {me.STR, me.INT, me.STA, player.cp}
                    end
                    if me.IsDead == true then
                        c, h = http.request {
                            url = api.url .. "/revive/" .. username,
                            method = "GET",
                            headers = {
                                ["token"] = token
                            },
                
                        }
                    end
                    if me.IsDead then
                        player.x = me.X
                        player.y = me.Y
                        c, h = http.request {
                            url = api.url .. "/revive/" .. username,
                            method = "GET",
                            headers = {
                                ["token"] = token
                            },
                
                        }
                        if death.previousPosition.hp < getMaxHealth() * 0.9 then
                            death.open = true
                            totalCoverAlpha = 2
                            awakeSfx:play()
                        else
                            player.dx = me.X * 32
                            player.dy = me.Y * 32
                            player.cx = me.X * 32
                            player.cy = me.Y * 32
                        end
                    end
                    if not death.open then death.previousPosition = {x = player.x, y = player.y, hp = player.hp} end
                    player.name = me.Name
                    player.buddy = me.Buddy
                    if player.hp > me.HP and me.HP < getMaxHealth() then
                        player.damageHUDAlphaUp = true
                        boneSpurt(player.dx + 16, player.dy + 16, player.hp - me.HP, 40, 1, 1, 1, "me")
                    end
                    player.hp = me.HP
                    player.owedxp = me.XP - player.xp
                    player.xp = me.XP
                    if me and me.LVL and player.lvl ~= me.LVL then
                        if not firstLaunch then
                            if player.lvl ~= 0 then
                                openTutorial(6)
                            end
                            lvlSfx:play()
                            perks.stats[4] = player.cp
                            addFloat("level", player.dx + 16, player.dy + 16, null, {1,0,0}, 10)
                        end
                        player.lvl = me.LVL
                        firstLaunch = false
                    end
                    player.name = me.Name
                    newEnemyData(response['Enemies'])
                    quests = {
                        {},
                        {},
                        {},
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
                        elseif v.Quest.Type == "go" then
                            quests[v.Tracked][#quests[v.Tracked]].task = "Go to "..(worldLookup[v.Quest.X][v.Quest.Y].Name or v.Quest.X..", "..v.Quest.Y)
                        end
                    end

                    activeConversations = response['ActiveConversations']
                    if response['Tick'] ~= previousTick then
                        tick()
                        previousTick = response['Tick']
                    end

                    weather.type = response['Weather']

                    checkAchievementUnlocks()
                end
            end
        end
    end
end

function tick()
    tickOtherPlayers()
    tickEnemies()
    tickAuras()
    checkTargeting()
    lastTick = nextTick
    nextTick = 1
    getInventory()
    tickRangedWeapons()
    if hotbarChanged then
        hotbarChangeCount = hotbarChangeCount + 1
        if hotbarChangeCount > 0 then
            checkHotbarChange()
            hotbarChangeCount = 0
            hotbarChanged = false
        end
    end
    if crafting.changed then
        crafting.changeCount = crafting.changeCount + 1
        if crafting.changeCount > 0 then
            enterCraftingItems(crafting.recipes[crafting.fields[crafting.selectedField.i]][crafting.selectedField.j])
            checkHotbarChange()
            crafting.changeCount = 0
            crafting.changed = false
        end
    end
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
    if enchanting.open then
        if enchanting.phase == 3 then transitionToEnchantingPhase3()
        elseif enchanting.phase == 5 then transitionToEnchantingPhase5() end
    end
    getDisplay()
    writeSettings()
end

function love.quit()
    if love.system.getOS() ~= "Linux" then steam.shutdown() end
end