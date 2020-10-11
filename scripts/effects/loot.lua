--[[
    This effect shoots loot out then gradually draws it back to the player
]]

loot = {}

function burstLoot(x, y, amount, type)
    for i=1,amount do
    loot[#loot+1] = {
        x = x,
        y = y,
        xv = love.math.random(-64,64),
        yv = love.math.random(-64,64),
        phase = "initial",
        type = type
    }
end
end

function drawLoot()
    for i,v in ipairs(loot) do
        if v.type == "xp" then
            love.graphics.draw(xpImg, v.x, v.y)
        else
            love.graphics.draw(swordImg, v.x, v.y)
        end
    end
end

function updateLoot(dt)
    for i,v in ipairs(loot) do
        v.x = v.x + v.xv*dt
        v.y = v.y + v.yv*dt
    
        if v.phase == "initial" then
          
            if math.abs(v.xv) > 16 then
                if v.xv > 0 then
                    v.xv = v.xv - 64*dt
                else 
                    v.xv = v.xv + 64*dt
                end
            else
                v.xv = 0
            end
    
            if math.abs(v.yv) > 16 then
                if v.yv > 0 then
                    v.yv = v.yv - 64*dt
                else
                    v.yv = v.yv + 64*dt
                end
            else
                v.yv = 0
            end

            if v.xv == 0 or v.yv == 0 then
                v.phase = "player"
                
            end
        else
          
            if math.abs(v.yv) < 64 and difference(player.dx+16, v.x) > 32 then
                if player.dx+16 > v.x then
                    v.xv = v.xv + 128*dt
                else
                    v.xv = v.xv - 128*dt
                end
            end

            if math.abs(v.yv) < 64 and difference(player.dy+16, v.y) > 32 then
                if player.dy+16 > v.y then
                    v.yv = v.yv + 128*dt
                else
                    v.yv = v.yv - 128*dt
                end
            end

            --Accepts XP
            if distanceToPoint(player.dx+16, player.dy+16, v.x, v.y) < 32 then
                if v.type == "xp" then
                    xpSound:stop()
                    xpSound:setPitch(1 + (player.xp/100))
                    xpSound:play()
                else
                    lootSound:stop()
                    lootSound:play()
                end
                player.xp = player.xp + 1
                table.remove(loot, i)
            end
        end
    end
end