function checkWorldEditRectMouseUp(button)
    if button == 1 and worldEdit.isDrawingRect then
        -- print(worldEdit.drawableRect.ax .. ", " .. worldEdit.drawableRect.ay .. " : " .. worldEdit.drawableRect.bx .. ", " .. worldEdit.drawableRect.by)
        local ax, ay, bx, by = worldEdit.drawableRect.ax, worldEdit.drawableRect.ay, worldEdit.drawableRect.bx, worldEdit.drawableRect.by
        if ax < bx then
            while ax < bx do
                getYValue(ax, ay, bx, by)
                ax = ax + 1 
            end
        elseif ax > bx then
            while ax > bx do
                ax = ax - 1 
                getYValue(ax, ay, bx, by)
            end
        end

        worldEdit.changed = true
        editorCtl.state[1] = true
        editorCtl.state[5] = true

    end
end

function getYValue(ax, ay, bx, by)
    if ay < by then
        while ay < by do
            -- print(ax .. ", " .. ay)
            drawWorldEditTileFromRect(ax, ay)
            ay = ay + 1 
        end
    elseif ay > by then
        while ay > by do
            ay = ay - 1 
            -- print(ax .. ", " .. ay)
            drawWorldEditTileFromRect(ax, ay)
        end
    end
    ay = worldEdit.drawableRect.ay
end

function drawWorldEditTileFromRect(x, y)
    
    if worldLookup[x][y] then
        worldEdit.draw[x][y][1] = worldLookup[x][y].GroundTile
        worldEdit.draw[x][y][2] = worldLookup[x][y].ForegroundTile
        worldEdit.draw[x][y][3] = worldLookup[x][y].Enemy
        worldEdit.draw[x][y][4] = worldLookup[x][y].Collision
    end

    for i, v in ipairs(areaDraw.state) do
        if v == true then
            if i == 1 and worldLookup[x][y] then
                if  worldLookup[x][y].GroundTile == worldLookup[x][y].ForegroundTile then
                    worldEdit.draw[x][y][2] = worldEdit.drawableTile[1]
                end
                worldEdit.draw[x][y][1] = worldEdit.drawableTile[1]
            else
                worldEdit.draw[x][y][i] = worldEdit.drawableTile[i]
            end
        end
    end
end

function drawAreaDrawButtons()
    for i = 1, 4 do
        local x, y = cerp(10, 320, worldEdit.toolbarAmount) + (52 * (i - 1)), love.graphics.getHeight() - 45 - 52
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
end