--[[
    Load dummy data on enemies
]]
enemies = {}

function loadDummyEnemies()
    enemyImg = love.graphics.newImage("assets/monsters/skeletons/sword.png")
    rangedEnemyImg = love.graphics.newImage("assets/monsters/skeletons/mage.png")

    for i = 1,12 do
        enemies[#enemies+1] = {
            x = love.math.random(1,30),
            dx = 0, -- drawX / drawY, for smoothing purposes
            dy = 0,
            y = love.math.random(1,30),
            hp = 48,
            dhp = 48, -- drawn HP, for smoothing purposes
            atk = 1,
            aggro = true,
            range = 1
        }
        enemies[i].dx = enemies[i].x*32
        enemies[i].dy = enemies[i].y*32
        blockMap[enemies[#enemies].x..","..enemies[#enemies].y] = true
    end

    for i = 1,4 do
        enemies[#enemies+1] = {
            x = love.math.random(1,30),
            dx = 0, -- drawX / drawY, for smoothing purposes
            dy = 0,
            y = love.math.random(1,30),
            hp = 48,
            dhp = 48, -- drawn HP, for smoothing purposes
            atk = 1,
            aggro = true,
            range = 2
        }
        enemies[#enemies].dx = enemies[#enemies].x*32
        enemies[#enemies].dy = enemies[#enemies].y*32
        blockMap[enemies[#enemies].x..","..enemies[#enemies].y] = true
    end
end

function drawDummyEnemies()
    for i, v in ipairs(enemies) do
        if distanceToPoint(v.x,v.y,player.x,player.y) < v.range+1 then
            love.graphics.setColor(0,0,0.4)
            love.graphics.line(v.dx+16,v.dy+16,player.dx+16,player.dy+16)
            love.graphics.setColor(1,1,1)
        end

        if v.range == 1 then
            love.graphics.draw(enemyImg, v.dx, v.dy)
        else
            love.graphics.draw(rangedEnemyImg, v.dx, v.dy)
        end
        love.graphics.setColor(1,0,0)
        love.graphics.rectangle("fill", v.dx, v.dy-6, (v.dhp/48)*32,6)
        love.graphics.setColor(1,1,1)
    end
end

function updateDummyEnemies(dt)
    for i, v in ipairs(enemies) do
        smoothMovement(v,dt)
        if v.dhp > v.hp then
            v.dhp = v.dhp - 32*dt
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

function moveToPlayer(x,y,v) -- this needs work
    if x > player.x + v.range then
        x = x - 1
    elseif x < player.x - v.range then
        x = x + 1
    end

    if y > player.y + v.range then
        y = y - 1
    elseif y < player.y - v.range then
        y = y + 1
    end

    return {x=x,y=y}
end

function tickDummyEnemies()
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