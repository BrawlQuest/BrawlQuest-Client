local boneMultiple = 4

function initBones()
    bones = {}

    bone = {
        image = {
            love.graphics.newImage("assets/world/objects/Blood.png"),
            love.graphics.newImage("assets/world/objects/Blood2.png"),
            love.graphics.newImage("assets/world/objects/Bone.png"),
        },    
    }
    
    levelImg = love.graphics.newImage("assets/player/effects/+1.png")
end

function boneSpurt(x, y, amount, velocity, r, g, b, type, mobType) 
    local distX = (player.x - player.target.x) * -velocity
    local distY = (player.y - player.target.y) * -velocity
    type = type or "mob"
    mobType = mobType or "image"
    
    for i = 1, amount do
        local xv, yv
        local range = 15
        local rand = 1 - love.math.random() * 0.3
        local deviance = 30

        if type == "mob" then 
            if (distX == 0 or distY == 0) then
                if (distX) == 0 then
                    xv = love.math.random(distX - range, distX + range) + love.math.random(-deviance, deviance)
                    yv = love.math.random(distY - range, distY + range) + love.math.random(-deviance, deviance)
                elseif distY == 0 then
                    xv = love.math.random(distX - range, distX + range) + love.math.random(-deviance, deviance)
                    yv = love.math.random(distY - range, distY + range) + love.math.random(-deviance, deviance)
                end
            else
                xv = love.math.random(distX - (range * (player.y - player.target.y)), distX + (range * (player.y - player.target.y))) + love.math.random(-deviance, deviance)
                yv = love.math.random(distY - (range * (player.x - player.target.x)), distY + (range * (player.x - player.target.x))) + love.math.random(-deviance, deviance)
            end

        elseif type == "level" then
            xv = love.math.random(-velocity, velocity)
            yv = love.math.random(-velocity * 2, velocity)
        else
            mobType = "image" -- this is "me" or another player, so it should be set to the default
            xv = love.math.random(-velocity, velocity)
            yv = love.math.random(-velocity, velocity)
        end

        bones[#bones+1] = {
            x = x,
            y = y,
            xv = xv * boneMultiple,
            yv = yv * boneMultiple,
            alpha = 10 * love.math.random(),
            r = r * rand,
            g = g * rand, 
            b = b * rand,
            type = type,
            image = love.math.random(1, 2),
            scale =  1 - love.math.random() * 0.5,
            rota = math.rad(love.math.random(0, 360)),
            mobType = mobType
        }
    end
end

function updateBones(dt)
    local drag = 128 * boneMultiple
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
        local r = 0
        if v.image == 3 then r = v.rota end
        if v.type == "level" then
            love.graphics.draw(levelImg, v.x - (16 * v.scale), v.y - (16 * v.scale), r, v.scale)
        elseif bone[v.mobType] and bone[v.mobType][v.image] then
            love.graphics.draw(bone[v.mobType][v.image], v.x - (16 * v.scale), v.y - (16 * v.scale), r, v.scale)
        end
    end
end