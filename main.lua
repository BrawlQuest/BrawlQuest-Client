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
    Luven.camera:setScale(2)

    loadMusic()

    birds = love.audio.newSource("assets/sfx/ambient/forest/birds.mp3", "stream")
    birds:setLooping(true)
    birds:setVolume(0.1)
  --  love.audio.play(birds)

    stepSound = love.audio.newSource("assets/sfx/step/grass.mp3", "static")

    playerImg = love.graphics.newImage("assets/player/base.png")
    swordImg = love.graphics.newImage("assets/player/gear/weapons/tridant01.png")
    armour = {
        love.graphics.newImage("assets/player/gear/armour/misc/tinfoil crown.png"),
        love.graphics.newImage("assets/player/gear/armour/casual/green shirt.png"),
        love.graphics.newImage("assets/player/gear/armour/casual/red robe.png")
    }
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
        blockMap[trees[#trees].x..","..trees[#trees].y] = true
        treeMap[trees[#trees].x..","..trees[#trees].y] = true
    end

    for i = 1, 8 do
        lanterns[i] = {
            x = love.math.random(0,love.graphics.getWidth()/32),
            y = love.math.random(0,love.graphics.getHeight()/32)
        }
        Luven.addNormalLight(16+lanterns[i].x*32,16+lanterns[i].y*32,{1,0.5,0}, 1)
    end
end

function love.draw()
    Luven.drawBegin()

    for x=-30,love.graphics.getWidth()/32 do
        for y = -30,love.graphics.getHeight()/32 do
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
    
    love.graphics.setColor(1,1,1,1)

    love.graphics.draw(swordImg, player.dx-(swordImg:getWidth()-32), player.dy-(swordImg:getHeight()-32))
    love.graphics.draw(playerImg, player.dx, player.dy)
    for i, v in ipairs(armour) do
        love.graphics.draw(v, player.dx, player.dy)
    end

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
    
    for i in pairs(blockMap) do
    --O    love.graphics.rectangle("line", explode(i, ",")[1]*32, explode(i, ",")[2]*32, 32, 32)
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

    if not player.target.active then
        Luven.camera:setPosition(player.dx, player.dy)
    end

    timeOfDay = timeOfDay + 0.005*dt
    if timeOfDay < 0.8 then
        Luven.setAmbientLightColor({ 0.8-timeOfDay, 0.8-timeOfDay, 1-timeOfDay })
    else 
        Luven.setAmbientLightColor({ timeOfDay-0.8, timeOfDay-0.8, timeOfDay-1 })
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

function explode (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end