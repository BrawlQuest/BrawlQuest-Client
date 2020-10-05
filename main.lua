require "scripts.player.character"
require "scripts.dummy.enemies"

enemies = {}

blockMap = {}

bones = {}

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

    for i,v in ipairs(bones) do
        love.graphics.setColor(v.r,v.g,v.b,v.alpha)
        love.graphics.rectangle("fill",v.x,v.y,2,2)
    end
    love.graphics.setColor(1,1,1,1)

    drawDummyEnemies()

    if player.target.active then
        love.graphics.draw(targetImg, player.target.x*32, player.target.y*32)
    end
    love.graphics.draw(playerImg, player.dx, player.dy)

    love.graphics.print("BrawlTest Combat v1")

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
    for i, v in ipairs(enemies) do
        -- enemy logic
        if distanceToPoint(v.x,v.y,player.x,player.y) < 10 then
            v.aggro = true
        else
            v.aggro = false
        end

        if v.aggro then
            targetV = moveToPlayer(v.x, v.y, v)
            if blockMap[targetV.x..","..targetV.y] == nil then
                blockMap[v.x..","..v.y] = nil
                v.x = targetV.x
                v.y = targetV.y
                blockMap[v.x..","..v.y] = true
            end
            if distanceToPoint(v.x,v.y,player.x,player.y) < v.range+1 then
                boneSpurt(player.dx+16,player.dy+16,v.atk,48,1,0,0)
            end
        end

        if player.target.x == v.x and player.target.y == v.y then
            v.hp = v.hp - player.atk
            boneSpurt(v.dx+16,v.dy+16,4,48,1,1,1)
            if v.hp < 1 then
                boneSpurt(v.dx+16,v.dy+16,48,74,1,1,1)
                v.x = -9999
                v.dx = -9999
                v.dy = -9999
                v.y = -9999
               
            end
        end
    end 
end

function distanceToPoint(x,y,x2,y2)
    return math.sqrt(math.abs(x-x2)*math.abs(x-x2) + math.abs(y-y2)*math.abs(y-y2))
end

function difference(a,b)
    return math.abs(a-b)
end

function boneSpurt(x,y,amount,velocity,r,g,b) 
    for i=1,amount do
        bones[#bones+1] = {
            x = x,
            y = y,
            xv = love.math.random(-velocity,velocity),
            yv = love.math.random(-velocity,velocity),
            alpha = 3,
            r = r,
            g = g, 
            b = b
        }
    end
end

function updateBones(dt)
    local drag = 32
    for i,v in ipairs(bones) do
        v.x = v.x + v.xv*dt
        v.y = v.y + v.yv*dt

        if math.abs(v.xv) > 4 then
            if v.xv > 0 then
                v.xv = v.xv - drag*dt
            else 
                v.xv = v.xv + drag*dt
            end
        else
            v.xv = 0
        end

        if math.abs(v.yv) > 4 then
            if v.yv > 0 then
                v.yv = v.yv - drag*dt
            else
                v.yv = v.yv + drag*dt
            end
        else
            v.yv = 0
        end

        v.alpha = v.alpha - 1*dt

    end
end

function love.keypressed(key)

   checkTargeting()
end