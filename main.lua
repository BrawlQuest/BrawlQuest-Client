player = {
    x = 0,
    y = 0,
    hp = 100,
    atk = 12,
    target = {
        x = 0,
        y = 0,
        active = false
    }
}

enemies = {}

blockMap = {}

bones = {}

nextTick = 1

function love.load()
    playerImg = love.graphics.newImage("assets/player/base.png")
    groundImg = love.graphics.newImage("assets/world/grounds/grass.png")
    treeImg = love.graphics.newImage("assets/world/objects/tree.png")
    enemyImg = love.graphics.newImage("assets/monsters/skeletons/sword.png")
    targetImg = love.graphics.newImage("assets/ui/target.png")

    for i = 1,12 do
        enemies[#enemies+1] = {
            x = love.math.random(1,30),
            dx = 0, -- drawX / drawY, for smoothing purposes
            dy = 0,
            y = love.math.random(1,30),
            hp = 48,
            dhp = 48, -- drawn HP, for smoothing purposes
            atk = 1,
            aggro = true
        }
        enemies[i].dx = enemies[i].x*32
        enemies[i].dy = enemies[i].y*32
        blockMap[enemies[#enemies].x..","..enemies[#enemies].y] = true
    end

    love.graphics.setBackgroundColor(0,0.3,0)
end

function love.draw()

    for i,v in ipairs(bones) do
        love.graphics.setColor(1,1,1,v.alpha)
        love.graphics.rectangle("fill",v.x,v.y,2,2)
    end
    love.graphics.setColor(1,1,1,1)

    love.graphics.draw(playerImg, player.x*32, player.y*32)

    for i, v in ipairs(enemies) do
        love.graphics.draw(enemyImg, v.dx, v.dy)
        love.graphics.setColor(1,0,0)
        love.graphics.rectangle("fill", v.dx, v.dy-6, (v.dhp/48)*32,6)
        love.graphics.setColor(1,1,1)
    end

    if player.target.active then
        love.graphics.draw(targetImg, player.target.x*32, player.target.y*32)
    end

    love.graphics.print("BrawlTest Combat v1")

end

function love.update(dt)
    nextTick = nextTick - 1*dt
    if nextTick < 0 then
        tick()
        nextTick = 1
    end

    for i, v in ipairs(enemies) do
        smoothMovement(v,dt)
        if v.dhp > v.hp then
            v.dhp = v.dhp - 32*dt
        end
    end

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
            targetV = moveToPlayer(v.x, v.y)
            if blockMap[targetV.x..","..targetV.y] == nil then
                blockMap[v.x..","..v.y] = nil
                v.x = targetV.x
                v.y = targetV.y
                blockMap[v.x..","..v.y] = true
            end
        end

        if player.target.x == v.x and player.target.y == v.y then
            v.hp = v.hp - player.atk
            boneSpurt(v.dx+16,v.dy+16,4,48)
            if v.hp < 1 then
                boneSpurt(v.dx+16,v.dy+16,48,74)
                v.x = -9999
                v.dx = -9999
                v.dy = -9999
                v.y = -9999
               
            end
        end
    end 
end

function smoothMovement(v,dt)
    if distanceToPoint(v.dx,v.dy,v.x*32,v.y*32) > 3 then
        if v.dx > v.x*32 then
            v.dx = v.dx - 32*dt
        elseif v.dx < v.x*32 then
            v.dx = v.dx + 32*dt
        end

        if v.dy > v.y*32 then
            v.dy = v.dy - 32*dt
        elseif v.dy < v.y*32 then
            v.dy = v.dy + 32*dt
        end
    else
        v.dx = v.x*32 -- preventing blurring from fractional pixels
        v.dy = v.y*32 
    end
end

function moveToPlayer(x,y) -- this needs work
    if x > player.x + 1 then
        x = x - 1
    elseif x < player.x - 1 then
        x = x + 1
    end

    if y > player.y + 1 then
        y = y - 1
    elseif y < player.y - 1 then
        y = y + 1
    end

    return {x=x,y=y}
end

function distanceToPoint(x,y,x2,y2)
    return math.sqrt(math.abs(x-x2)*math.abs(x-x2) + math.abs(y-y2)*math.abs(y-y2))
end

function boneSpurt(x,y,amount,velocity) 
    for i=1,amount do
        bones[#bones+1] = {
            x = x,
            y = y,
            xv = love.math.random(-velocity,velocity),
            yv = love.math.random(-velocity,velocity),
            alpha = 3
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
    if key == "w" then
        player.y = player.y - 1
        player.target.active = false
    elseif key == "s" then
        player.y = player.y + 1
        player.target.active = false
    elseif key == "d" then
        player.x = player.x + 1
        player.target.active = false
    elseif key == "a" then
        player.x = player. x - 1
        player.target.active = false
    elseif key == "left" then
        player.target.active = true
        player.target.x = player.x - 1
        player.target.y = player.y
    elseif key == "right" then
        player.target.active = true
        player.target.x = player.x + 1
        player.target.y = player.y
    elseif key == "up" then
        player.target.active = true
        player.target.y = player.y - 1
        player.target.x = player.x
    elseif key == "down" then
        player.target.active = true
        player.target.y = player.y + 1
        player.target.x = player.x
    end
end