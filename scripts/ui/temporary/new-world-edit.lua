function initNewWorldEdit()
    worldEdit = {
        open = false,
        drawable = true,
        isDrawing = false,
        toolbarAmount = 1,
        boxHeight = 1,
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
    if love.mouse.isDown(1) or love.mouse.isDown(2) then worldEdit.isDrawing = true else worldEdit.isDrawing = false end
    local isMouse = isMouseOver(0, love.graphics.getHeight() - (32 * (worldEdit.boxHeight + 1)), love.graphics.getWidth(), (32 * (worldEdit.boxHeight + 1)))
    if worldEdit.open then
        if not worldEdit.isDrawing and isMouse then
            worldEdit.drawable = false 
            worldEdit.toolbarAmount = worldEdit.toolbarAmount + 5 * dt
            if worldEdit.toolbarAmount > 1 then worldEdit.toolbarAmount = 1 end
        elseif worldEdit.isDrawing and not isMouse then
            worldEdit.drawable = true
            worldEdit.toolbarAmount = worldEdit.toolbarAmount - 5 * dt
            if worldEdit.toolbarAmount < 0 then worldEdit.toolbarAmount = 0 end
        end
    end
end

function drawNewWorldEditHud()
    if worldEdit.open then
        local thisX, thisY = 0, cerp(love.graphics.getHeight() + (32 * (worldEdit.boxHeight + 1)), love.graphics.getHeight(), worldEdit.toolbarAmount)
        love.graphics.setColor(0,0,0,0.6)
        love.graphics.rectangle("fill", thisX, thisY, love.graphics.getWidth(), (-32 * (worldEdit.boxHeight + 1)))
        love.graphics.setColor(1,1,1,1)

        local x, y = 10, love.graphics.getHeight() - 42 + cerp((32 * (worldEdit.boxHeight + 1)), 0, worldEdit.toolbarAmount)
        worldEdit.boxHeight = 1
        for i,v in ipairs(worldFiles) do
            if string.sub(v,1,25) ~= "assets/world/objects/Wall" and string.sub(v,1,18) ~= "assets/world/water" then
                love.graphics.draw(worldImg[v], x, y)
                x = x + 32 + 5
                if x > love.graphics.getWidth() * 0.98 then
                    y = y - (32 + 5)
                    x = 10
                    worldEdit.boxHeight = worldEdit.boxHeight + 1
                end
            end
        end 
        
    end
end

function drawNewWorldEditTiles()
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
                    worldEdit.selectedTile = {x, y}
                end
                if worldEdit.draw[x][y] == 2 then
                    love.graphics.setColor(0,1,0,0.4)
                    love.graphics.rectangle("fill", thisX, thisY, 32, 32)
                    love.graphics.setColor(1,1,1,0.6)
                end

                if worldEdit.drawable and isMouseOver(
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
            end
        end
    end
    love.graphics.setColor(1,1,1,1)
end

function getWorldEditMouseDown(button)

end