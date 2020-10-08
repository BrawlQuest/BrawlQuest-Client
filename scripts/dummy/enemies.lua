--[[
    Load dummy data on enemies
]]
enemies = {}
enemiesInAggro = 0 -- for music

function loadDummyEnemies()
    enemyImg = love.graphics.newImage("assets/monsters/skeletons/sword.png")
    rangedEnemyImg = love.graphics.newImage("assets/monsters/skeletons/mage.png")
    alertImg = love.graphics.newImage("assets/ui/alert.png")
    attackSounds = {
        love.audio.newSource("assets/sfx/monsters/skeletons/attack/1.ogg", "static"),
        love.audio.newSource("assets/sfx/monsters/skeletons/attack/2.ogg", "static"),
        love.audio.newSource("assets/sfx/monsters/skeletons/attack/3.ogg", "static"),
        love.audio.newSource("assets/sfx/monsters/skeletons/attack/4.ogg", "static")
    }

    aggroSounds = {
        love.audio.newSource("assets/sfx/monsters/skeletons/aggro/1.ogg", "static"),
        love.audio.newSource("assets/sfx/monsters/skeletons/aggro/2.ogg", "static"),
        love.audio.newSource("assets/sfx/monsters/skeletons/aggro/3.ogg", "static")
    }

    deathSounds = {
        love.audio.newSource("assets/sfx/monsters/skeletons/death/1.ogg", "static"),
        love.audio.newSource("assets/sfx/monsters/skeletons/death/2.ogg", "static"),
        love.audio.newSource("assets/sfx/monsters/skeletons/death/3.ogg", "static")
    }


    for i = 1,10 do
        enemies[#enemies+1] = {
            x = love.math.random(0,15),
            dx = 0, -- drawX / drawY, for smoothing purposes
            dy = 0,
            y = love.math.random(0,15),
            hp = 12,
            mhp = 12,
            dhp = 12, -- drawn HP, for smoothing purposes
            atk = 1,
            aggro = true,
            range = 1,
            red = 0,
            atkAlpha = 0, -- the alpha for the line that is drawn when an attack hits
            aggroAlpha = 0
        }
        enemies[i].dx = enemies[i].x*32
        enemies[i].dy = enemies[i].y*32
        blockMap[enemies[#enemies].x..","..enemies[#enemies].y] = true
    end

    for i = 1,2 do
        enemies[#enemies+1] = {
            x = love.math.random(10,15),
            dx = 0, -- drawX / drawY, for smoothing purposes
            dy = 0,
            y = love.math.random(10,15),
            hp = 24,
            mhp = 24,
            dhp = 24, -- drawn HP, for smoothing purposes
            atk = 1,
            aggro = true,
            range = 2,
            red = 0, -- when this is set the enemy lights up red to indicate being hit
            atkAlpha = 0, -- the alpha for the line that is drawn when an attack hits
            aggroAlpha = 0
        }
        enemies[#enemies].dx = enemies[#enemies].x*32
        enemies[#enemies].dy = enemies[#enemies].y*32
        blockMap[enemies[#enemies].x..","..enemies[#enemies].y] = true
    end
end

function drawDummyEnemies()
    for i, v in ipairs(enemies) do
       if isTileLit(v.x,v.y) then
            love.graphics.setColor(1,1-v.red,1-v.red)
            if v.range == 1 then
                love.graphics.draw(enemyImg, v.dx, v.dy)
            else
                love.graphics.draw(rangedEnemyImg, v.dx, v.dy)
            end
            
            love.graphics.setColor(1,0,0)
            love.graphics.rectangle("fill", v.dx, v.dy-6, (v.dhp/v.mhp)*32,6)
            love.graphics.setColor(1,1,1,v.aggroAlpha)
            love.graphics.draw(alertImg,v.dx+8,v.dy-16)
            love.graphics.setColor(1,1,1)
        else
            if v.aggroAlpha > 0 then
                love.graphics.setColor(1,1,1,v.aggroAlpha)
                if v.range == 1 then
                    love.graphics.draw(enemyImg, v.dx, v.dy)
                else
                    love.graphics.draw(rangedEnemyImg, v.dx, v.dy)
                end
                love.graphics.draw(alertImg,v.dx+8,v.dy-16)
                love.graphics.setColor(1,1,1)
            elseif v.atkAlpha > 0 then
                love.graphics.setColor(1,1,1,v.atkAlpha)
                if v.range == 1 then
                    love.graphics.draw(enemyImg, v.dx, v.dy)
                else
                    love.graphics.draw(rangedEnemyImg, v.dx, v.dy)
                end
            end
        end

        if distanceToPoint(v.x,v.y,player.x,player.y) < v.range+1 then
            love.graphics.setColor(1,0,0,v.atkAlpha)
            love.graphics.line(v.dx+16,v.dy+16,player.dx+16,player.dy+16)
            love.graphics.setColor(1,1,1,1)
        end
    end
end

function updateDummyEnemies(dt)
    for i, v in ipairs(enemies) do
        smoothMovement(v,dt)
        if v.dhp > v.hp then
            v.dhp = v.dhp - 32*dt
        end
        if v.red > 0 then
            v.red = v.red - 2*dt
            if v.red < 0 then
                v.red = 0
            end
        end
        v.atkAlpha = v.atkAlpha - 2*dt
        v.aggroAlpha = v.aggroAlpha - 1*dt
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

    local iterationsLeft = 8
    local px = v.x
    local py = v.y
    while (difference(player.x,v.x) > v.range or difference(player.y,v.y) > v.range) and blockMap[x..","..y] ~= nil and iterationsLeft > 0 do
        x = px
        y = py
        x = x + love.math.random(-1,1)
        y = y + love.math.random(-1,1)
        iterationsLeft = iterationsLeft - 1
    end

    moveEnemy(x,y,v)
end

function moveEnemy(x,y,v) 
    if blockMap[x..","..y] == nil then
        blockMap[v.x..","..v.y] = nil
        v.x = x
        v.y = y
        blockMap[v.x..","..v.y] = true
    end
end

function tickDummyEnemies()
    enemiesInAggro = #enemies
    for i, v in ipairs(enemies) do
        -- enemy logic
       -- if v.hp > 0 then enemiesInAggro = enemiesInAggro + 1 end
        if not v.aggro and distanceToPoint(v.x,v.y,player.x,player.y) < 4 + v.range*2 then
            v.aggro = true
            local aggroSound = aggroSounds[love.math.random(1,#aggroSounds)]
            aggroSound:setPitch(love.math.random(80,150)/100)
            aggroSound:setPosition(v.x-player.x,v.y-player.y)
            love.audio.play(aggroSound)
            v.aggroAlpha = 2
        elseif distanceToPoint(v.x,v.y,player.x,player.y) > 4 + v.range*2 then
            v.aggro = false
            enemiesInAggro = enemiesInAggro - 1
        end
      
        if v.aggro then
            moveToPlayer(v.x, v.y, v)
            
            if distanceToPoint(v.x,v.y,player.x,player.y) < v.range+1 then
                boneSpurt(player.dx+16,player.dy+16,v.atk,48,1,0,0)
                local attackSound = attackSounds[love.math.random(1,#attackSounds)]
                attackSound:setPitch(love.math.random(50,100)/100)
                love.audio.play(attackSound)
                player.hp = player.hp - v.atk
                v.atkAlpha = 1
                if (player.target.x ~= v.x or player.target.y ~= v.y) and v.range == 10000 then
                    if v.x > player.x then
                        v.dx = v.dx - 6
                    elseif v.x < player.x then
                        v.dx = v.dx + 6
                    end
                    if v.y > player.y then
                        v.dy = v.dy - 6
                    elseif v.y < player.y then
                        v.dy = v.dy + 6
                    end
                end
            end
        end

        if player.target.x == v.x and player.target.y == v.y and player.target.active then
            v.hp = v.hp - player.atk
            v.red = 1
            local pushBack = 8
            if love.math.random(1,4) == 1 then -- CRIT
                local modifier = love.math.random(2,12)
                v.hp = v.hp - player.atk*modifier
                v.red = modifier
                pushBack = 12*modifier
                critHitSfx:setPitch(1 * (modifier/14))
                love.audio.play(critHitSfx)
                boneSpurt(v.dx+16,v.dy+16,4*modifier,12*modifier,1,1,1)
                if v.dx > player.x*32 then
                    moveEnemy(v.x+1,v.y,v)
                elseif v.dx < player.x*32 then
                    moveEnemy(v.x-1,v.y,v)
                end
                if v.dy > player.y*32 then
                    moveEnemy(v.x,v.y+1,v)
                elseif v.dy < player.y*32 then
                    moveEnemy(v.x,v.y-1,v)
                end
            else
                enemyHitSfx:setPitch(love.math.random(50,100)/100)
                love.audio.setEffect('myEffect', {type = 'reverb'})
                enemyHitSfx:setEffect('myEffect')
                love.audio.play(enemyHitSfx)
                if v.dx > player.x*32 then
                    v.dx = v.dx + pushBack
                elseif v.dx < player.x*32 then
                    v.dx = v.dx - pushBack
                end
                if v.dy > player.y*32 then
                    v.dy = v.dy + pushBack
                elseif v.dy < player.y*32 then
                    v.dy = v.dy - pushBack
                end
            end

           
            boneSpurt(v.dx+16,v.dy+16,4,48,1,1,1)
            if v.hp < 1 then
                v.dx = v.x*32 -- there may be displacement from a crit, so we set the draw pos to the regular pos
                v.dy = v.y*32
                love.audio.play(deathSounds[love.math.random(1,#deathSounds)])
                blockMap[v.x..","..v.y] = nil
                boneSpurt(v.dx+16,v.dy+16,48,72,0.8,0.8,1)
                v.x = -9999
                v.dx = -9999
                v.dy = -9999
                v.y = -9999
            end
        end
    end 
end