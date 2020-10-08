require "scripts.player.character"
require "scripts.dummy.enemies"
require "scripts.effects.bones"
require "scripts.effects.lighting"
require "scripts.effects.music"
Luven = require "scripts.libraries.luven.luven"

trees = {} -- temp
lanterns = {} -- temp
blockMap = {}
treeMap = {}

nextTick = 1

timeOfDay = 0

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    Luven.init()
    Luven.setAmbientLightColor({ 0.1, 0.1, 0.1 })
    Luven.camera:init(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    Luven.camera:setScale(1.3)

    lightId = Luven.addFlickeringLight(600, 400, { min = { 0.8, 0.0, 0.8, 0.8 }, max = { 1.0, 0.0, 1.0, 1.0 } }, { min = 0.25, max = 0.27 }, { min = 0.12, max = 0.2 })
    lightId2 = Luven.addFlickeringLight(700, 400, { min = { 0.8, 0.0, 0.8, 0.8 }, max = { 1.0, 0.0, 1.0, 1.0 } }, { min = 0.25, max = 0.7 }, { min = 0.12, max = 0.2 }, Luven.lightShapes.cone)
    Luven.addNormalLight(700, 500, { 0.9, 1, 0 }, 1, Luven.lightShapes.cone, 0)

    loadMusic()

    birds = love.audio.newSource("assets/sfx/ambient/forest/birds.mp3", "stream")
    birds:setLooping(true)
    birds:setVolume(0.1)
    love.audio.play(birds)

    stepSound = love.audio.newSource("assets/sfx/step/grass.mp3", "static")

    playerImg = love.graphics.newImage("assets/player/base.png")
    groundImg = love.graphics.newImage("assets/world/grounds/grass.png")
    treeImg = love.graphics.newImage("assets/world/objects/tree.png")
    lanternImg = love.graphics.newImage("assets/world/objects/lantern.png")
    targetImg = love.graphics.newImage("assets/ui/target.png")
    playerHitSfx = love.audio.newSource("assets/sfx/hit.wav", "static")
    enemyHitSfx = love.audio.newSource("assets/sfx/impact_b.wav", "static")
    critHitSfx = love.audio.newSource("assets/sfx/pit_trap_damage.wav", "static")
    enemyDieSfx = love.audio.newSource("assets/sfx/skeleton.wav", "static")
    arrowImg = {}
    arrowImg[-1]  = {
            [0]=love.graphics.newImage("assets/ui/target/W_Arrow_1.png"),
            [-1] = love.graphics.newImage("assets/ui/target/NW_Arrow_1.png"),
            [1]=love.graphics.newImage("assets/ui/target/SW_Arrow_1.png")
        }
        arrowImg[0] = 
        {
            [-1] = love.graphics.newImage("assets/ui/target/N_Arrow_1.png"),
            [1] = love.graphics.newImage("assets/ui/target/S_arrow_1.png")
        }
        arrowImg[1] = {
            [0] = love.graphics.newImage("assets/ui/target/E_Arrow_1.png"),
            [-1] = love.graphics.newImage("assets/ui/target/NE_Arrow_1.png"),
            [1] = love.graphics.newImage("assets/ui/target/SE_Arrow_1.png")
        }
   
    loadDummyEnemies()

    love.graphics.setBackgroundColor(0,0.3,0)

    for i = 1, 70 do
        trees[i] = {
            x = love.math.random(0,love.graphics.getWidth()/32),
            y = love.math.random(0,love.graphics.getHeight()/32)
        }
        blockMap[trees[i].x..","..trees[i].y] = true
        treeMap[trees[i].x..","..trees[i].y] = true
    end

    for i = 1, 4 do
        lanterns[i] = {
            x = love.math.random(0,love.graphics.getWidth()/32),
            y = love.math.random(0,love.graphics.getHeight()/32)
        }
        Luven.addNormalLight(lanterns[i].x*32,lanterns[i].y*32,{0.96,0.66,0.25}, 3)
    end
end

function love.draw()
    Luven.drawBegin()
    for x=0,30 do
        for y = 0,30 do
            if isTileLit(x,y) then
                if not wasTileLit(x,y) then
                    love.graphics.setColor(1-oldLightAlpha,1-oldLightAlpha,1-oldLightAlpha) -- light up a tile
                else
                    love.graphics.setColor(1,1,1)
                end
            elseif wasTileLit(x,y) and oldLightAlpha > 0.2 then
                love.graphics.setColor(oldLightAlpha, oldLightAlpha, oldLightAlpha)
            else
                love.graphics.setColor(0.2,0.2,0.2)
            end
            love.graphics.draw(groundImg, x*32, y*32)
        end
    end
    
    for i,v in ipairs(trees) do
        if isTileLit(v.x,v.y) then
            love.graphics.setColor(1,1,1)
        else
            love.graphics.setColor(0.2,0.2,0.2)
        end
        love.graphics.draw(treeImg, v.x*32, v.y*32)
    end
    
    for i,v in ipairs(lanterns) do
        love.graphics.setColor(1,1,1)
        love.graphics.draw(lanternImg,v.x*32,v.y*32)
    end

    drawBones()

    love.graphics.setColor(1,1,1,1)

    drawDummyEnemies()

    love.graphics.draw(playerImg, player.dx, player.dy)
    love.graphics.setColor(0,0,0)
  
    love.graphics.rectangle("line", player.dx, player.dy-8, 32,6)
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("fill", player.dx, player.dy-8, (player.dhp/player.mhp)*32,6)
    love.graphics.setColor(1,1,1)

    
    if player.target.active then
        diffX = player.target.x - player.x
        diffY = player.target.y - player.y
        if arrowImg[diffX] ~= nil and arrowImg[diffX][diffY] ~= nil then
            love.graphics.draw(arrowImg[diffX][diffY], player.dx-32, player.dy-32)
        end
    end

    Luven.drawEnd()

    love.graphics.print("BrawlQuest\nEnemies in aggro: "..enemiesInAggro)

    Luven.camera:draw()
end

function love.update(dt)
    nextTick = nextTick - 1*dt
    if nextTick < 0 then
        tick()
        nextTick = 1
    end

    oldLightAlpha = oldLightAlpha - 2*dt -- update light, essentially

    updateDummyEnemies(dt)
    updateCharacter(dt)
    updateBones(dt)
    updateMusic(dt)
    Luven.update(dt)

    Luven.camera:setPosition(player.dx, player.dy)

    timeOfDay = timeOfDay + 0.05*dt
    if timeOfDay < 1 then
        Luven.setAmbientLightColor({ 1-timeOfDay, 1-timeOfDay, 1-timeOfDay })
    else 
        Luven.setAmbientLightColor({ timeOfDay-1, timeOfDay-1, timeOfDay-1 })
        if timeOfDay > 2 then
            timeOfDay = 0 
        end
    end
end

function tick()
   tickDummyEnemies()

   if player.target.active then
        if player.dx > player.target.x*32 then
            player.dx = player.dx - 16
        elseif player.dx < player.target.x*32 then
            player.dx = player.dx + 16
        end
        if player.dy > player.target.y*32 then
            player.dy = player.dy - 16
        elseif player.dy < player.target.y*32 then
            player.dy = player.dy + 16
        end
   end
end

function distanceToPoint(x,y,x2,y2)
    return math.sqrt(math.abs(x-x2)*math.abs(x-x2) + math.abs(y-y2)*math.abs(y-y2))
end

function difference(a,b)
    return math.abs(a-b)
end

function love.keypressed(key)
   checkTargeting()
end

function copy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
    return res
  end

  function arrayContains (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end