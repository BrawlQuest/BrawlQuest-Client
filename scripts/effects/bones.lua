bones = {}

function boneSpurt(x,y,amount,velocity,r,g,b) 
    local distX = (player.x - player.target.x) * -velocity
    local distY = (player.y - player.target.y) * -velocity
    
    for i=1,amount do
        local xv, yv
        local range = 25
        local rand = 1 - love.math.random() * 0.3

        if (distX == 0 or distY == 0) then
            -- if (distX) == 0 then
                xv = love.math.random(distX - range, distX + range)
                yv = love.math.random(distY - range, distY + range)
            -- elseif distY == 0 then
                -- xv = love.math.random(distY - range, distY + range)
                -- yv = love.math.random(distX - range, distX + range)
            -- end
        else
            xv = love.math.random(distX - (range * (player.y - player.target.y)), distX + (range * (player.y - player.target.y))) * 0.7
            yv = love.math.random(distY - (range * (player.x - player.target.x)), distY + (range * (player.x - player.target.x))) * 0.7
        end

        bones[#bones+1] = {
            x = x,
            y = y,
            xv = xv,
            yv = yv,
            alpha = 10 * love.math.random(),
            r = r * rand,
            g = g * rand, 
            b = b * rand,
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

        if blockMap[math.abs(v.x/32)..","..math.abs(v.y/32)] then
            v.yv = -v.yv
            v.xv = -v.xv
        end

        v.alpha = v.alpha - 1*dt
        if v.alpha < 0 then
            table.remove(bones, i)
        end
    end
end

function drawBones()
    for i,v in ipairs(bones) do
        love.graphics.setColor(v.r,v.g,v.b,v.alpha)
        love.graphics.rectangle("fill",v.x,v.y,2, 2)
    end
end