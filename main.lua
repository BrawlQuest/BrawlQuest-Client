require "scripts.player.character"
require "scripts.dummy.enemies"
require "scripts.effects.bones"



blockMap = {}

nextTick = 1

function love.load()
    playerImg = love.graphics.newImage("assets/player/base.png")
    groundImg = love.graphics.newImage("assets/world/grounds/grass.png")
    treeImg = love.graphics.newImage("assets/world/objects/tree.png")
   
    targetImg = love.graphics.newImage("assets/ui/target.png")

    loadDummyEnemies()

    love.graphics.setBackgroundColor(0,0.3,0)
end

function love.draw()
    drawBones()

    love.graphics.setColor(1,1,1,1)

    drawDummyEnemies()

    if player.target.active then
        love.graphics.draw(targetImg, player.target.x*32, player.target.y*32)
    end
    love.graphics.draw(playerImg, player.dx, player.dy)

    love.graphics.print("BrawlQuest")
end

function love.update(dt)
    nextTick = nextTick - 1*dt
    if nextTick < 0 then
        tick()
        nextTick = 1
    end

    updateDummyEnemies(dt)

    movePlayer(dt)
    updateBones(dt)
end

function tick()
   tickDummyEnemies()
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