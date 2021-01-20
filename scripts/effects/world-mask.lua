
function drawWorldMask()
    local thisWorldScale = worldScale - ((worldScale * settPan.opacityCERP) * 0.2)
    local gridSize = 32
    local gridScale = 32 / gridSize
    local cloudScale = 1 / thisWorldScale
    local width  = math.floor(((love.graphics.getWidth()  * cloudScale)/2) / gridSize) + 2 + (thisWorldScale)
    local height = math.floor(((love.graphics.getHeight() * cloudScale)/2) / gridSize) + 2 + (thisWorldScale)
    love.graphics.setBlendMode("alpha", "premultiplied")
    local range = 14 * gridSize

    for x = (player.x * gridScale) - width, (player.x * gridScale) + width do      
        for y = (player.y * gridScale) - height, (player.y * gridScale) + height do
            local distance = distanceToPoint(player.dx, player.dy, x * gridSize, y * gridSize)
            if distance <= range then 
                love.graphics.setColor(0,0,0, 1 - ((range * 0.7) / distance))
            else
                love.graphics.setColor(0,0,0, 0.35)                
            end
            love.graphics.rectangle("fill", x * gridSize, y * gridSize, gridSize, gridSize)
        end
    end 

    love.graphics.setBlendMode("alpha")
end