--[[
    This effect shoots loot out then gradually draws it back to the player
]]

loot = {}

function burstLoot(x, y, amount)
    for i=1,amount do
    loot[#loot+1] = {
        x = x,
        y = y,
        xv = love.math.random(-128,128),
        yv = love.math.random(-128,128),
        phase = "initial"
    }
end
end

function drawLoot()
    love.graphics.setColor(0.4,0.4,1)
    for i,v in ipairs(loot) do
        love.graphics.setColor(0,0,1)
        love.graphics.rectangle("line", v.x, v.y, 3, 3)
       -- love.graphics.draw(xpImg, v.x, v.y)
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

            if v.xv == 0 and v.yv == 0 then
                v.phase = "player"
                
            end
        else
          
            if math.abs(v.yv) < 64 and difference(player.dx+16, v.x) > 32 then
                if player.dx+16 > v.x then
                    v.xv = v.xv + 64*dt
                else
                    v.xv = v.xv - 64*dt
                end
            end

            if math.abs(v.yv) < 64 and difference(player.dy+16, v.y) > 32 then
                if player.dy+16 > v.y then
                    v.yv = v.yv + 64*dt
                else
                    v.yv = v.yv - 64*dt
                end
            end

            if distanceToPoint(player.dx+16, player.dy+16, v.x, v.y) < 32 then
              --  xpSound:stop()
               -- xpSound:play()
                table.remove(loot, i)
            end
        end
    end
end