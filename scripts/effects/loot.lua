--[[
    This effect shoots loot out then gradually draws it back to the player
]]

loot = {}

local xpOwed = 0 -- this is used to correctly set the pitch as XP flies in (previously it all hit the same tone)

function burstLoot(x, y, amount, type)
    if type == "xp" then
        xpOwed = amount
    end
    for i=1,amount do
        loot[#loot+1] = {
            x = x,
            y = y,
            phase = "initial",
            type = type,
            timeToFly = 1,
            speedToPlayer = 8
        }

        if type ~= "xp" then
            loot[#loot].xv = love.math.random(48,90)
            loot[#loot].yv = love.math.random(48,90)
        else
            loot[#loot].xv = love.math.random(48,90)
            loot[#loot].yv = love.math.random(48,90)
         
        end

        if love.math.random(1,2) == 1 then
            loot[#loot].xv = -loot[#loot].xv
        end
        if love.math.random(1,2) == 1 then
            loot[#loot].yv = -loot[#loot].yv
        end
    end
end

function drawLoot()
    love.graphics.setColor(1,1,1,1)
    for i,v in ipairs(loot) do
        if v.type == "xp" then
            love.graphics.draw(xpImg, v.x, v.y)
        else
            drawItemIfExists(v.type, v.x, v.y)
        end
    end
end

function updateLoot(dt)
    for i,v in ipairs(loot) do
        local targetX = player.dx+16
        local targetY = player.dy+16

        v.timeToFly = v.timeToFly - 1*dt
        v.x = v.x + v.xv*dt
        v.y = v.y + v.yv*dt
           if v.x > player.dx+16 then
                v.x = v.x - 8*dt
            elseif v.x < player.dx+16 then
                v.x = v.x + 8*dt
            end

        if v.phase == "initial" then
          
            if math.abs(v.xv) > 1 then
                if v.xv > 0 then
                    v.xv = v.xv - 64*dt
                else 
                    v.xv = v.xv + 64*dt
                end
            else
                v.xv = 0
            end
    
            if math.abs(v.yv) > 1 then
                if v.yv > 0 then
                    v.yv = v.yv - 64*dt
                else
                    v.yv = v.yv + 64*dt
                end
            else
                v.yv = 0
            end

            if v.timeToFly < 0 and v.xv == 0 and v.yv == 0 then
                v.phase = "player"
                
            end
        else
            v.speedToPlayer = v.speedToPlayer + 8*dt
            if v.y > player.dy+16 then
                v.y = v.y - v.speedToPlayer*dt
            elseif v.y < player.dy+16 then
                v.y = v.y + v.speedToPlayer*dt
            end

            if v.x > player.dx+16 then
                v.x = v.x - v.speedToPlayer*dt
            elseif v.x < player.dx+16 then
                v.x = v.x + v.speedToPlayer*dt
            end

            if  difference(player.dx+16, v.x) > 32 then
                if player.dx+16 > v.x then
                    v.xv = v.xv + 128*dt
                else
                    v.xv = v.xv - 128*dt
                end
            end

            if difference(player.dy+16, v.y) > 32 then
                if player.dy+16 > v.y then
                    v.yv = v.yv + 128*dt
                else
                    v.yv = v.yv - 128*dt
                end
            end
        end

        if distanceToPoint(player.dx+16, player.dy+16, v.x, v.y) < 32 and v.phase ~= "initial" then
            if v.type == "xp" then
                local nsfx = xpSfx:clone()
                nsfx:setPitch(1 + ((player.xp-xpOwed)/100))
                xpOwed = xpOwed - 1
                nsfx:setRelative(true)
                nsfx:setVolume(1*sfxVolume)
                setEnvironmentEffects(nsfx)
                love.audio.play(nsfx)
            else
                local nsfx = lootSfx[love.math.random(1,#lootSfx)]:clone()
                nsfx:setVolume(0.5*sfxVolume)
             
                love.audio.play(nsfx)
            end
            player.xp = player.xp + 1
            table.remove(loot, i)
        end
    end
end