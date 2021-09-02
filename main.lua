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
require "scripts.libraries.api"
require "scripts.libraries.utils"
require "scripts.libraries.colorize"
require "scripts.libraries.simple-slider"
require "scripts.phases.login.login"
require "scripts.player.animation"
require "scripts.player.armour"
require "scripts.player.other_players"
require "scripts.player.ranged-weapons"
require "scripts.player.targeting"
require "scripts.enemies"
require "scripts.npcs"
require "scripts.server"
require "scripts.world.world"
require "scripts.world.tiles"
require "scripts.world.biomes"
require "scripts.ui.temporary.worldedit"
require "scripts.ui.temporary.new-world-edit"
require "scripts.ui.temporary.world-edit-rect"
require "data.data_controller"
require "scripts.player.settings"
require "scripts.player.structures"

require "scripts.ui.panels.npc-chat"
require "scripts.ui.panels.tutorial"

require "scripts.achievements"
Luven = require "scripts.libraries.luven.luven"

version = "Early Access" 
versionType = "dev" -- "dev" for quick login, "release" for not
useSteam = true -- turn off for certain naughty computers
if versionType == "dev" then require 'dev' end
versionNumber = "1.4.0" -- very important for settings
drawAnimations = false -- player animations

if love.system.getOS() ~= "Linux" and useSteam then steam = require 'luasteam' end -- we can disable other platforms here. Can't get Steam working on Linux and we aren't targetting it so this'll do for dev purposes
json = require("scripts.libraries.json")
http = require("socket.http")
ltn12 = require("ltn12")
utf8 = require("utf8")
newOutliner = require 'scripts.libraries.outliner'


version = "Early Access"
versionType = "dev" -- "dev" for quick login, "release" for not
if versionType == "dev" then
    require 'dev'
end

versionNumber = "1.4.0" -- very important for settings

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
username = "Pebsie"
readyForUpdate = true
playersOnline = ""
firstLaunch = true
playerCount = 0

oldInfo = {}

sendUpdate = false

function love.load()
    showMouse, mouseAmount, mx, my = true, 1, 0, 0
    limits = love.graphics.getSystemLimits()
    print(limits.multicanvas)
    outlinerOnly = newOutliner(true)
    outlinerOnly:outline(0.8, 0, 0) -- this is used to draw enemy outlines
    grayOutlinerOnly = newOutliner(true)
    grayOutlinerOnly:outline(1,1,1)
    if love.system.getOS() ~= "Linux" and useSteam then  steam.init() end
    love.graphics.setDefaultFilter("nearest", "nearest")
    initHardData()
    initLogin()
    initScrolling()
    initHUD()
    initLeaves()
    initSettings()
    initSFX()
    loadMusic()
    initEditWorld()
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
    initNews()
    initAnimation()
    love.graphics.setFont(textFont)
    recursivelyDelete( "img" )
    love.filesystem.createDirectory( "img" )
end

function love.draw()
    inventory.notNPC = true -- I've moved this here so that it defaults to on and is then turned off rather than turned on. This means that we don't have to worry about its position when checking for "Press E" text or similar
    if phase == "login" then
        drawLogin()
    else
        Luven.drawBegin()
        drawWorld()
        if worldEdit.open and player then drawNewWorldEditTiles() end
        drawStructures()
        drawAuras()
        drawBones()
        love.graphics.setColor(1, 1, 1)
        drawNPCs()
        drawEnemies()
        drawRangedWeaponEffects()
        drawExplosions()
        drawParticles()
        for i, v in ipairs(playersDrawable) do drawPlayer(v, i) end
        drawFloats()
        drawPlayer(me, -1)
        if showWorldAnimations then
            drawLeaves()
            drawCritters()
        end
        drawLoot()
        local drawingText = false
        if isNearbyTile("assets/world/objects/Anvil.png") and not drawingText then
            drawTextBelowPlayer("Press " .. keybinds.INTERACT .. " to craft")
            inventory.notNPC = false
            drawingText = true
        elseif isNearbyTile("assets/world/objects/Furnace.png") and not drawingText then
            drawTextBelowPlayer("Press " .. keybinds.INTERACT .. " to forge")
            inventory.notNPC = false
            drawingText = true
        elseif isNearbyTile("assets/world/objects/Portal.png") and not drawingText then
            if me.LVL ~= 30 then
                drawTextBelowPlayer("You must be Level 30 to Enchant")
            else
                drawTextBelowPlayer("Press " .. keybinds.INTERACT .. " to Enchant")
            end
            inventory.notNPC = false
            drawingText = true
        elseif isNearbyTile("assets/world/objects/Well.png") and not drawingText then
            drawTextBelowPlayer("Press " .. keybinds.INTERACT .. " to Cleanse")
        elseif isNearbyTile("assets/world/objects/Class Machine.png") and not drawingText then
            drawTextBelowPlayer("Press " .. keybinds.INTERACT .. " to change class")
            inventory.notNPC = false
            drawingText = true
        end

        for i, v in ipairs(npcs) do
            if distanceToPoint(player.x, player.y, v.X, v.Y) <= 1 and not showNPCChatBackground and v.Conversation ~= "" then
                local isQuestCompleter = false
                for k, q in ipairs(quests[1]) do
                    if q.rawData.Quest.ReturnNPCID == v.ID and q.currentAmount == q.requiredAmount then
                        drawTextBelowPlayer("Press " .. keybinds.INTERACT .. " to complete quest")
                        isQuestCompleter = true
                    end
                end

                if not isQuestCompleter and not drawingText then
                    drawTextBelowPlayer("Press " .. keybinds.INTERACT .. " to talk")
                    drawingText = true
                end

                inventory.notNPC = false
                openTutorial(4)
            end
        end
        drawWeather()
        if andCalc(true, {showWorldMask, not worldEdit.open, enchanting.amount < 0.01}) then drawWorldMask() end -- not worldEdit.open or
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
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(settPan.itemFont)
        local text
        if true then text = "BrawlQuest "..version.." "..versionNumber.. "\nPress \"r\" to enable animations preview" .. "\nX,Y: " .. player.x..","..player.y .. " FPS: " .. tostring(love.timer.getFPS()) .. "\nPlayers: " .. playerCount .."\n"..playersOnline
        else text = "X,Y: " .. player.x..","..player.y .. " FPS: " .. tostring(love.timer.getFPS()) .. "\nPlayers: " .. playerCount end
        love.graphics.print(text, offset, 10)
    end
    mx, my = love.mouse.getPosition()
    love.graphics.setColor(1, 1, 1, mouseAmount)
    love.graphics.draw(mouseImg, mx, my)
end

function love.update(dt)
    if love.system.getOS() ~= "Linux" and useSteam then steam.runCallbacks() end

    enchantmentPos = enchantmentPos + 15 * dt
    if enchantmentPos > 64 then enchantmentPos = 0 end

    love.graphics.print(json:encode(love.audio.getActiveEffects()))

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
        updateWorld(dt)
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
        updateScrolling(dt)
        if news.open then updateNews(dt) end
        if itemDrag.dragging then updateItemDrag(dt) end
        if death.open then updateDeath(dt) end
        if forging.open then updateForging(dt) end
        updateRangedWeapons(dt)
        if showNPCChatBackground then updateNPCChat(dt) end
        if showWorldAnimations then
            updateLeaves(dt)
            updateCritters(dt)
        end
        Luven.update(dt)
        if showClouds and enchanting.amount < 0.01 then updateClouds(dt) end
        if enchanting.amount >= 0.01 then updateEnchanting(dt) end
        updateCamera(dt)
        updateOtherPlayers(dt)
        serverResponse()
    end
end

local tickCount = 0

function tick()
    tickCount = tickCount + 1
    tickOtherPlayers()
    tickEnemies()
    tickAuras()
    checkTargeting()
    lastTick = nextTick
    nextTick = 1
    getInventory()
    tickRangedWeapons()
    tickWorld()
    if me then tickCharacterHub() end
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
        recalculateLighting()
        createWorld()
        loadSliders()
    end
    if scale then
        uiX = love.graphics.getWidth() / scale -- scaling options
        
        uiY = love.graphics.getHeight() / scale
    end
    if enchanting.open then
        if enchanting.phase == 3 then
            transitionToEnchantingPhase3()
        elseif enchanting.phase == 5 then
            transitionToEnchantingPhase5()
        end
    end
    getDisplay()
    writeSettings()
end

function love.quit()
    if love.system.getOS() ~= "Linux" and useSteam then steam.shutdown() end
end
