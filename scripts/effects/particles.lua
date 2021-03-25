function initParticles()
    particles = {
        sparkles = {

        }
    }
end

function updateParticles(dt)
    updateSparkles(dt)
end

function drawParticles()
    love.graphics.setBlendMode("add")
    drawSparkles()
    love.graphics.setBlendMode("alpha")
end

function updateSparkles(dt)
    for i,v in ipairs(particles.sparkles) do
        v.x = v.x + v.vx * dt
        v.y = v.y + v.vy * dt
        v.vx = math.damp(dt, v.vx, 20)
        v.vy = math.damp(dt, v.vy, 20)
        v.alpha = v.alpha - v.alphaRate * dt
        if v.alpha <= 0 then table.remove(particles.sparkles, i) end
    end
end

function drawSparkles()
    for i,v in ipairs(particles.sparkles) do
        love.graphics.setColor(1,1,1,v.alpha)
        love.graphics.draw(smokeImg, smokeImages[1], v.x, v.y, 0, 2)
    end
end

function addSparkles(x,y,amount,speed)
    for i = 1, amount or 10 do
        local r = math.rad(love.math.random(0, 360))
        speed = speed or 32
        particles.sparkles[#particles.sparkles+1] = {
            vx = math.cos(r) * speed,
            vy = math.sin(r) * speed,
            x = x or 0,
            y = y or 0,
            alpha = 1,
            alphaRate = love.math.random() * 0.4 + 0.2,
        }
    end
end

--[[
updateSparkles(dt)
drawSparkles()
addSparkles()
]]