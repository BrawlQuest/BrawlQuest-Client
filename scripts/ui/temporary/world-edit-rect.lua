function checkWorldEditRectMouseUp(button)
    if (button == 1 or button == 2) and worldEdit.isDrawingRect then
        -- print(worldEdit.drawableRect.ax .. ", " .. worldEdit.drawableRect.ay .. " : " .. worldEdit.drawableRect.bx .. ", " .. worldEdit.drawableRect.by)
        local ax, ay, bx, by = worldEdit.drawableRect.ax, worldEdit.drawableRect.ay, worldEdit.drawableRect.bx, worldEdit.drawableRect.by
        if ax < bx then
            while ax < bx do
                getYValue(ax, ay, bx, by, button)
                ax = ax + 1 
            end
        elseif ax > bx then
            while ax > bx do
                ax = ax - 1 
                getYValue(ax, ay, bx, by, button)
            end
        end
        worldEdit.changed = true
        editorCtl.state[1] = true
        editorCtl.state[5] = true
    end
end

function getYValue(ax, ay, bx, by, button)
    if ay < by then
        while ay < by do
            drawWorldEditTileFromRect(ax, ay, button)
            ay = ay + 1 
        end
    elseif ay > by then
        while ay > by do
            ay = ay - 1 
            drawWorldEditTileFromRect(ax, ay, button)
        end
    end
    ay = worldEdit.drawableRect.ay
end

function drawWorldEditTileFromRect(x, y, button)
    
    if worldEdit.draw[x][y][1] ~= "" then -- You're already drawing a tile
    elseif worldLookup[x][y] then -- Draw a tile from the current world
        worldEdit.draw[x][y][1] = worldLookup[x][y].GroundTile
        worldEdit.draw[x][y][2] = worldLookup[x][y].ForegroundTile
        worldEdit.draw[x][y][3] = worldLookup[x][y].Enemy
        worldEdit.draw[x][y][4] = worldLookup[x][y].Collision
    end

    if button == 1 then
        for i, v in ipairs(areaDraw.state) do
            if v == true then
                if i == 1 and worldLookup[x][y] then
                    if worldEdit.draw[x][y][1] ~= "" then
                        if worldEdit.draw[x][y][1] == worldEdit.draw[x][y][2] then
                            worldEdit.draw[x][y][2] = worldEdit.drawableTile[1]
                        end
                    else
                        if  worldLookup[x][y].GroundTile == worldLookup[x][y].ForegroundTile then
                            worldEdit.draw[x][y][2] = worldEdit.drawableTile[1]
                        end
                    end
                    worldEdit.draw[x][y][1] = worldEdit.drawableTile[1]
                elseif i == 3 then
                    worldEdit.draw[x][y][3] = worldEdit.drawableTile[3]
                    worldEdit.draw[x][y][5] = worldEdit.drawableTile[6]
                else
                    worldEdit.draw[x][y][i] = worldEdit.drawableTile[i]
                end
            end
        end

    elseif button == 2 and worldEdit.draw[x][y][1] ~= "" then
        for i, v in ipairs(areaDraw.state) do
            if v == true and worldLookup[x][y] then
                if i == 1 then
                    worldEdit.draw[x][y][1] = worldLookup[x][y].GroundTile
                elseif i == 2 then
                    worldEdit.draw[x][y][2] = worldLookup[x][y].ForegroundTile
                elseif i == 3 then
                    worldEdit.draw[x][y][3] = worldLookup[x][y].Enemy
                elseif i == 4 then
                    worldEdit.draw[x][y][4] = worldLookup[x][y].Collision
                end
            end
        end
    end
end

function drawAreaDrawButtons()

    thisX, thisY = cerp(10, 320, worldEdit.toolbarAmount), love.graphics.getHeight() - 45 - 52
    
    for i = 1, 4 do
        local x, y = thisX + (52 * (i - 1)), thisY
        drawNewWorldEditButton(x, y, 42, 42, areaDraw.state[i])
        if i < 3 then love.graphics.draw(worldImg[worldEdit.drawableTile[i]], x + 5, y + 5)
        elseif i == 3 then 
            if worldEdit.drawableTile[6] ~= 0 then
                love.graphics.draw(worldEdit.enemyImages[worldEdit.drawableTile[6]], x + 5, y + 5)
            else
                love.graphics.printf("Enemy", x + 5, y + 10, 32)
            end
        elseif i == 4 then 
            if areaDraw.state[4] then love.graphics.setColor(0,0,0,1) else love.graphics.setColor(1,1,1,1) end
            love.graphics.printf("Collisions: " .. boolToString(worldEdit.drawableTile[4]), x + 5, y + 10, 32)
        end
        if isMouseOver(x,y,42,42) then worldEdit.mouseOverAreaDrawButtons = i end
    end

    drawNewWorldEditButton(thisX, thisY - 42, 202, 32, false)
    -- love.graphics.printf("Collisions: " .. boolToString(worldEdit.drawableTile[4]), x + 5, y + 10, 32)
    love.graphics.print("Enemy: ''" .. worldEdit.drawableTile[3] .. "''", thisX + 10, thisY - 52 + 20, 0, 2)
end

function checkAreaDrawButtonsPressed(button)
    if button == 1 then
                
        if worldEdit.mouseOverAreaDrawButtons == 1 then -- Ground
            areaDraw.state[1] = not areaDraw.state[1]
        end
        if worldEdit.mouseOverAreaDrawButtons == 2 then -- Foreground
            areaDraw.state[2] = not areaDraw.state[2]
        end
        if worldEdit.mouseOverAreaDrawButtons == 3 then -- enemies
            areaDraw.state[3] = not areaDraw.state[3]
        end
        if worldEdit.mouseOverAreaDrawButtons == 4 then -- Collisions
            areaDraw.state[4] = not areaDraw.state[4]
        end
        if worldEdit.mouseOverAreaDrawButtons == 5 then -- Area Name
            areaDraw.state[5] = not areaDraw.state[5]
        end
        local total = 0
        for i, v in ipairs(areaDraw.state) do
            if v == true then
                total = total + 1
            end
        end
        if total <= 0 then
            worldEdit.drawmode = "pencil"
        else
            worldEdit.drawmode = "rectangle"
        end
    end
    
end