function initClouds()
    local Now = os.date('*t')
    cloud = {
        movement = {x = (Now.hour * 60) + Now.min,  y = 0, z = 0, speed = {x = 0.3, y = 0.2},},
        opacity = 1,
        fade = 0,
        offset = 0,
    }
end

function updateClouds(dt)
    local gridScale = 32 / worldScale
    cloud.movement.x = ((cloud.movement.x) - (cloud.movement.speed.x * worldScale) * dt)
    cloud.movement.y = ((cloud.movement.y) - (cloud.movement.speed.y * worldScale) * dt)
    cloud.fade = cloud.fade + 0.05 * dt
    if cloud.fade > 2 then cloud.fade = 0 end
    cloud.movement.z = cerp(0.2, 0.9, cloud.fade)

    cloud.opacity = (1 / worldScale) + settPan.opacityCERP
    if cloud.opacity > 1 then cloud.opacity = 1 end
end

function drawClouds()
    local noiseFactor = 0.5 * (cloud.opacity + 0.1)
    local gridSize = 32 / worldScale
    local gridScale = 32 / gridSize
    local cloudScale = 1 / cameraScale
    local width  = math.floor(((love.graphics.getWidth()  * cloudScale)/2) / gridSize) + 2 + (worldScale)
    local height = math.floor(((love.graphics.getHeight() * cloudScale)/2) / gridSize) + 2 + (worldScale)
    local movement = {x = cloud.movement.x * gridScale, y = cloud.movement.y * gridScale}

    for x = (player.x * gridScale) - width, (player.x * gridScale) + width do
        for y = (player.y * gridScale) - height, (player.y * gridScale) + height do
            local noise = ((
                love.math.noise((((x + movement.x) * gridSize) * 0.003), (((y + movement.y) * gridSize) * 0.003)) - 
                (love.math.noise((((x + (movement.x * 2)) * gridSize) * 0.001), (((y + (movement.y * 2)) * gridSize) * 0.001)) * cloud.movement.z) - 
                (love.math.noise((((x + movement.x) * gridSize) * 0.0001), (((y + movement.y) * gridSize) * 0.0001)))
            ) * noiseFactor)
            if noise > 0.015 then 
                love.graphics.setColor(1,1,1, noise)
                love.graphics.rectangle("fill", x * gridSize, y * gridSize, gridSize, gridSize)
            end
        end
    end
end