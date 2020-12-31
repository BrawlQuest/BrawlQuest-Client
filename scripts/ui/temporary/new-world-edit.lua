function initNewWorldEdit()
    worldEdit = {
        open = false,
        draw = {},
        selectedTile = {}
    }

    local getWidth, getHeight = 400, 400
    for x = getWidth * -1, getWidth do
        worldEdit.draw[x] = {}
        for y = getHeight * -1, getHeight do
            worldEdit.draw[x][y] = 0
        end
    end

end

function updateNewWorldEdit(dt)

end

function drawNewWorldEdit()
    if worldEdit.open then
        local getWidth, getHeight = 100, 100
        love.graphics.setColor(1,1,1,0.6)
        for x = getWidth * -1, getWidth do
            for y = getHeight * -1, getHeight do
                thisX, thisY = x * 32 , y * 32 
                if worldEdit.draw[x][y] == 1 then
                    love.graphics.setColor(1,0,0,0.4)
                    love.graphics.rectangle("fill", thisX, thisY, 32, 32)
                    love.graphics.setColor(1,1,1,0.6)
                end
                
                if worldEdit.draw[x][y] == 2 then
                    love.graphics.setColor(0,1,0,0.4)
                    love.graphics.rectangle("fill", thisX, thisY, 32, 32)
                    love.graphics.setColor(1,1,1,0.6)
                end

                if isMouseOver(
                    (((thisX - player.dx - 16) * worldScale) + (love.graphics.getWidth()/2)), 
                    (((thisY - player.dy - 16) * worldScale) + (love.graphics.getHeight()/2)), 
                    32 * worldScale, 
                    32 * worldScale) then
                    love.graphics.rectangle("fill", thisX, thisY, 32, 32)
                    if love.mouse.isDown(1) then
                        worldEdit.draw[x][y] = 1
                    end
                    if love.mouse.isDown(2) then
                        worldEdit.draw[x][y] = 0
                    end
                end
                -- worldEdit.selectedTile = {x, y}
            end
        end
    end
    love.graphics.setColor(1,1,1,1)
end

function getWorldEditMouseDown(button)

end