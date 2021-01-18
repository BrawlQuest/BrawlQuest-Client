function initClouds()
    cloud = {
        movement = {x = 0,  y = 0, z = 0, speed = {x = 2, y = 1},},
        fade = 0,
    }
end

function updateClouds(dt)
    cloud.movement.x = (cloud.movement.x) - cloud.movement.speed.x * dt
    cloud.movement.y = (cloud.movement.y)- cloud.movement.speed.y * dt
    cloud.fade = cloud.fade + 0.05 * dt
    if cloud.fade > 2 then cloud.fade = 0 end
    cloud.movement.z = cerp(0, 1, cloud.fade)
end

function drawClouds()
    local noiseFactor = 0.2 -- 0.18
    local gridSize = 32
    local gridScale = 32 / gridSize
    local cloudScale = 1 / worldScale
    local width = math.floor(((love.graphics.getWidth() * cloudScale)/2) / gridSize)
    local height = math.floor(((love.graphics.getHeight() * cloudScale)/2) / gridSize)

    for x = (player.x * gridScale) - width, (player.x * gridScale) + width do
        for y = (player.y * gridScale) - height, (player.y * gridScale) + height do
            local noise = ((
                love.math.noise((((x + cloud.movement.x) * gridSize) * 0.003), (((y + cloud.movement.y) * gridSize) * 0.003)) - 
                (love.math.noise((((x + (cloud.movement.x * 2)) * gridSize) * 0.001), (((y + (cloud.movement.y * 2)) * gridSize) * 0.001)) * cloud.movement.z)
            ) * noiseFactor)
            love.graphics.setColor(1,1,1, noise)
            love.graphics.rectangle("fill", x * gridSize, y * gridSize, gridSize, gridSize)
        end
    end
end

