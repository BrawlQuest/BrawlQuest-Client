bones = {}

function boneSpurt(x,y,amount,velocity,r,g,b) 
    for i=1,amount do
        bones[#bones+1] = {
            x = x,
            y = y,
            xv = love.math.random(-velocity,velocity),
            yv = love.math.random(-velocity,velocity),
            alpha = 10,
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

        if blockMap[math.abs(v.x/32)..","..math.abs(v.y/32)] then
            v.yv = -v.yv
            v.xv = -v.xv
        end

        v.alpha = v.alpha - 1*dt
    end
end

function drawBones()
    for i,v in ipairs(bones) do
        love.graphics.setColor(v.r,v.g,v.b,v.alpha)
        love.graphics.rectangle("fill",v.x,v.y,1,1)
    end
end