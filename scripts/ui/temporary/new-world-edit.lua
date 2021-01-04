function initNewWorldEdit()
    worldEdit = {
        open = false,
        drawable = true,
        isDrawing = false,
        toolbarAmount = 1,
        boxHeight = 1,
        draw = {},
        selectableTile = "",
        drawableTile = {"assets/world/grounds/grass/grass01.png", "assets/world/grounds/grass/grass01.png", ""},
        selectedTile = {},
        enemyImages = {},
        selectedFloor = "",
        selectedObject = "",
        tileInputType = 1,
        mouseOverSelectionButtons = 0,
        font = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 8),
    }

    local getWidth, getHeight = 400, 400
    for x = getWidth * -1, getWidth do
        worldEdit.draw[x] = {}
        for y = getHeight * -1, getHeight do
            worldEdit.draw[x][y] = {"", "", ""}
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
        worldEdit.mouseOverSelectionButtons = 0
        worldEdit.selectableTile = ""
        local thisX, thisY = 0, cerp(love.graphics.getHeight() + (32 * (worldEdit.boxHeight + 1)), love.graphics.getHeight(), worldEdit.toolbarAmount)
        love.graphics.setColor(0,0,0,0.6)
        love.graphics.rectangle("fill", thisX, thisY, love.graphics.getWidth(), (-32 * (worldEdit.boxHeight + 1)))
        love.graphics.setColor(1,1,1,1)

        thisX, thisY = love.graphics.getWidth(), love.graphics.getHeight()
        for i, v in ipairs(availableEnemies) do
            drawNewWorldEditButton(thisX, thisY - (52 * (i - 1)), 42, 42, 10, v.Name, worldEdit.tileInputType == i, i, v.Image)
        end
        -- drawNewWorldEditButton(thisX, thisY - 180, 50, 80, 10, "Floor (1)", worldEdit.tileInputType == 1, 1)
        -- drawNewWorldEditButton(thisX, thisY - 90, 50, 80, 10, "Object (2)", worldEdit.tileInputType == 2, 2)
        -- drawNewWorldEditButton(thisX, thisY, 50, 80, 10, "Enemy (3)", worldEdit.tileInputType == 3, 3)

        local x, y = 10, love.graphics.getHeight() - 42 + cerp((32 * (worldEdit.boxHeight + 1)), 0, worldEdit.toolbarAmount)
        worldEdit.boxHeight = 1
        for i,v in ipairs(worldFiles) do
            if string.sub(v,1,25) ~= "assets/world/objects/Wall" and string.sub(v,1,18) ~= "assets/world/water" then
                
                if isMouseOver(x, y, 32, 32) then worldEdit.selectableTile = v end
                
                if v == worldEdit.drawableTile[1] then
                    love.graphics.setColor(0,1,0,1)
                    love.graphics.rectangle("fill", x - 2, y - 2, 36, 36)
                end

                love.graphics.setColor(1,1,1,1)
                love.graphics.draw(worldImg[v], x, y) 

                if v == worldEdit.drawableTile[2] then
                    love.graphics.setColor(0.5,0.5,1,0.6)
                    love.graphics.rectangle("fill", x - 2, y - 2, 36, 36)
                end

                x = x + 32 + 5
                if x > love.graphics.getWidth() - 32 - 70 then
                    y = y - (32 + 5)
                    x = 10
                    worldEdit.boxHeight = worldEdit.boxHeight + 1
                end
                
            end
        end 
    end
end

function drawNewWorldEditButton(thisX, thisY, width, height, padding, text, thisMode, count, image)
    love.graphics.setFont(worldEdit.font)
    local thisX, thisY = thisX - width - padding, thisY - height - padding
    if isMouseOver(thisX, thisY, width, height) then
        love.graphics.setColor(0,0.7,0,1)
        worldEdit.mouseOverSelectionButtons = count
    elseif thisMode then
        love.graphics.setColor(1,0,0,0.6)
    else
        love.graphics.setColor(0,0,0,0.6)
    end
    roundRectangle("fill", thisX, thisY, width, height, 5)
    love.graphics.setColor(1,1,1,1)
    
    love.graphics.draw(worldEdit.enemyImages[count], thisX + 5, thisY + 5)

    love.graphics.printf(text, thisX + (padding * 0.5), thisY, width - ((padding * 0.5) * 2), "center")
end

function drawNewWorldEditTiles()
    if worldEdit.open then 
        local getWidth, getHeight = 100, 100
        love.graphics.setColor(1,1,1,0.6)
        for x = getWidth * -1, getWidth do
            for y = getHeight * -1, getHeight do
                thisX, thisY = x * 32 , y * 32 
                for z = 1, 3 do
                    if worldEdit.draw[x][y][z] ~= (nil or "") then
                        love.graphics.setColor(1,1,1,1) 
                        love.graphics.draw(worldImg[worldEdit.draw[x][y][z]], thisX, thisY)
                    end
                end

                love.graphics.setColor(1,1,1,0.6)
                if worldEdit.drawable and isMouseOver(
                    (((thisX - player.dx - 16) * worldScale) + (love.graphics.getWidth()/2)), 
                    (((thisY - player.dy - 16) * worldScale) + (love.graphics.getHeight()/2)), 
                    32 * worldScale, 
                    32 * worldScale) then
                    love.graphics.rectangle("fill", thisX, thisY, 32, 32)
                    if love.mouse.isDown(1) then
                        for i = 1, 3, 1 do
                            worldEdit.draw[x][y][i] = worldEdit.drawableTile[i]
                        end
                    end
                    if love.mouse.isDown(2) and  worldEdit.draw[x][y][1] ~= "" then
                        worldEdit.draw[x][y][2] = worldEdit.draw[x][y][1]
                    end
                end
            end
        end
    end
    love.graphics.setColor(1,1,1,1)
end

function checkWorldEditMouseDown(button)
    if worldEdit.open then
        if worldEdit.mouseOverSelectionButtons > 0 then
            if button == 1 then worldEdit.tileInputType = worldEdit.mouseOverSelectionButtons end
        end

        if worldEdit.selectableTile ~= "" then
            if button == 1 then
                worldEdit.drawableTile[2] = worldEdit.selectableTile
            elseif button == 2 then
                worldEdit.drawableTile[1] = worldEdit.selectableTile
            end
        end
    end
end