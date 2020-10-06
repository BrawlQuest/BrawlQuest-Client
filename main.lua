require "scripts.player.character"
require "scripts.dummy.enemies"
require "scripts.effects.bones"


trees = {} -- temp
blockMap = {}

nextTick = 1

function love.load()
    playerImg = love.graphics.newImage("assets/player/base.png")
    groundImg = love.graphics.newImage("assets/world/grounds/grass.png")
    treeImg = love.graphics.newImage("assets/world/objects/tree.png")
    targetImg = love.graphics.newImage("assets/ui/target.png")
    playerHitSfx = love.audio.newSource("assets/sfx/hit.wav", "static")
    enemyHitSfx = love.audio.newSource("assets/sfx/impact_b.wav", "static")
    critHitSfx = love.audio.newSource("assets/sfx/pit_trap_damage.wav", "static")
    enemyDieSfx = love.audio.newSource("assets/sfx/skeleton.wav", "static")
    loadDummyEnemies()

    love.graphics.setBackgroundColor(0,0.3,0)

    for i = 1, 30 do
        trees[i] = {
            x = love.math.random(0,love.graphics.getWidth()/32),
            y = love.math.random(0,love.graphics.getHeight()/32)
        }
        blockMap[trees[i].x..","..trees[i].y] = true
    end
end

function love.draw()
    for x=0,love.graphics.getWidth()/32 do
        for y = 0,love.graphics.getHeight()/32 do
            love.graphics.draw(groundImg, x*32, y*32)
        end
    end
    
    for i,v in ipairs(trees) do
        love.graphics.draw(treeImg, v.x*32, v.y*32)
    end

    drawBones()

    love.graphics.setColor(1,1,1,1)

    if player.target.active then
        love.graphics.draw(targetImg, player.target.x*32, player.target.y*32)
    end

    drawDummyEnemies()

    love.graphics.draw(playerImg, player.dx, player.dy)
    love.graphics.setColor(0,0,0)
  
    love.graphics.rectangle("line", player.dx, player.dy-8, 32,6)
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("fill", player.dx, player.dy-8, (player.dhp/player.mhp)*32,6)
    love.graphics.setColor(1,1,1)

    love.graphics.print("BrawlQuest")
end

function love.update(dt)
    nextTick = nextTick - 1*dt
    if nextTick < 0 then
        tick()
        nextTick = 1
    end

    updateDummyEnemies(dt)

    updateCharacter(dt)
    updateBones(dt)
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