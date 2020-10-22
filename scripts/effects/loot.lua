--[[
    This effect shoots loot out then gradually draws it back to the player
]]

loot = {}

function burstLoot(x, y, amount, type)
    for i=1,amount do
        loot[#loot+1] = {
            x = x,
            y = y,
            phase = "initial",
            type = type,
            timeToFly = 1,
            speedToPlayer = 8
        }

        if type == "sword" then
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
    for i,v in ipairs(loot) do
        if v.type == "xp" then
            love.graphics.draw(xpImg, v.x, v.y)
        else
            love.graphics.draw(lootImg, v.x, v.y)
        end
    end
end

function updateLoot(dt)
    for i,v in ipairs(loot) do
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

         --Accepts XP
         if distanceToPoint(player.dx+16, player.dy+16, v.x, v.y) < 32 and v.phase ~= "initial" then
            if v.type == "xp" then
                xpSfx:stop()
                xpSfx:setPitch(1 + (player.xp/100))
                xpSfx:play()
            else
                lootSfx:stop()
                lootSfx:play()
            end
            player.xp = player.xp + 1
            table.remove(loot, i)
        end
    end
end