function initClouds()
    cloud = {
        movement = {x = 0,  y = 0, z = 0, speed = {x = 1, y = 1},},
        fade = 0,
    }
end

function updateClouds(dt)
    local gridScale = 32 / worldScale
    cloud.movement.x = ((cloud.movement.x) - (cloud.movement.speed.x * worldScale) * dt)
    cloud.movement.y = ((cloud.movement.y) - (cloud.movement.speed.y * worldScale) * dt)
    -- print(cloud.movement.x .. ", " .. cloud.movement.y  .. ", " .. worldScale)
    cloud.fade = cloud.fade + 0.05 * dt
    if cloud.fade > 2 then cloud.fade = 0 end
    cloud.movement.z = cerp(0.2, 0.9, cloud.fade)
end

function drawClouds()
    local thisWorldScale = worldScale - ((worldScale * settPan.opacityCERP) * 0.2)
    local noiseFactor = 0.3
    local gridSize = 32 / worldScale
    local gridScale = 32 / gridSize
    local cloudScale = 1 / thisWorldScale
    local width  = math.floor(((love.graphics.getWidth()  * cloudScale)/2) / gridSize) + 2 + (worldScale)
    local height = math.floor(((love.graphics.getHeight() * cloudScale)/2) / gridSize) + 2 + (worldScale)
    -- width, height = math.clamp(0, width, worldEdit.worldSize / 3), math.clamp(0, height, worldEdit.worldSize / 3)
    local movement = {x = cloud.movement.x * gridScale, y = cloud.movement.y * gridScale}

    for x = (player.x * gridScale) - width, (player.x * gridScale) + width do
        for y = (player.y * gridScale) - height, (player.y * gridScale) + height do
            local noise = ((
                love.math.noise((((x + movement.x) * gridSize) * 0.003), (((y + movement.y) * gridSize) * 0.003)) - 
                (love.math.noise((((x + (movement.x * 2)) * gridSize) * 0.001), (((y + (movement.y * 2)) * gridSize) * 0.001)) * cloud.movement.z) - 
                (love.math.noise((((x + movement.x) * gridSize) * 0.0001), (((y + movement.y) * gridSize) * 0.0001)))
            ) * noiseFactor)
            love.graphics.setColor(1,1,1, noise)
            love.graphics.rectangle("fill", x * gridSize, y * gridSize, gridSize, gridSize)
        end
    end
end