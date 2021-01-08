function checkWorldEditRectMouseUp(button)
    if (button == 1 or button == 2) and worldEdit.isDrawingRect then
        -- print(worldEdit.drawableRect.ax .. ", " .. worldEdit.drawableRect.ay .. " : " .. worldEdit.drawableRect.bx .. ", " .. worldEdit.drawableRect.by)
        print("------------- drawing -------------")
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
        -- print(json:encode(worldEdit.draw[worldEdit.drawableRect.ax][worldEdit.drawableRect.ay]))
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
        -- print(json:encode(worldLookup[x][y]))
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
                elseif i == 3 then -- enemies
                    worldEdit.draw[x][y][3] = worldEdit.drawableTile[3]
                    worldEdit.draw[x][y][5] = worldEdit.drawableTile[8]
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
    standardIfStatement(x, y)
    print(json:encode(worldEdit.draw[x][y]))
end

function drawAreaDrawButtons()

    local thisX, thisY = cerp(10, 320, worldEdit.toolbarAmount), love.graphics.getHeight() - 45 - 52
    
    for i, v in ipairs(areaDraw.state) do
        local x, y = thisX + (52 * (i - 1)), thisY
        drawNewWorldEditButton(x, y, 42, 42, areaDraw.state[i])
        if i < 3 then love.graphics.draw(worldImg[worldEdit.drawableTile[i]], x + 5, y + 5)
        elseif i == 3 then 
            if worldEdit.drawableTile[8] ~= 0 then
                love.graphics.draw(worldEdit.enemyImages[worldEdit.drawableTile[8]], x + 5, y + 5)
            else
                love.graphics.printf("Enemy", x + 5, y + 10, 32)
            end
        elseif i == 4 then 
            if areaDraw.state[4] then love.graphics.setColor(0,0,0,1) else love.graphics.setColor(1,1,1,1) end
            love.graphics.printf("Collisions: " .. boolToString(worldEdit.drawableTile[4]), x + 5, y + 10, 32)
        end
        if isMouseOver(x,y,42,42) then worldEdit.mouseOverAreaDrawButtons = i end
    end

    thisX, thisY = thisX, thisY - 42
    local width, height = 202, 32
    drawNewWorldEditButton(thisX, thisY, width, height, false)
    -- love.graphics.printf("Collisions: " .. boolToString(worldEdit.drawableTile[4]), x + 5, y + 10, 32)
    love.graphics.print("Enemy: ''" .. worldEdit.drawableTile[3] .. "''", thisX + 10, thisY + 10, 0, 1.5)

    thisX, thisY = thisX + width + 10, thisY
    drawNewWorldEditButton(thisX, thisY, width, height, worldEdit.isTyping)
    if isMouseOver(thisX, thisY, width, height) then worldEdit.readyToWriteText = true end
    if worldEdit.isTyping then love.graphics.setColor(0,0,0) else love.graphics.setColor(1,1,1) end
    love.graphics.print("Area Name: ''" .. worldEdit.enteredWorldText .. "''", thisX + 10, thisY + 10, 0, 1.5)
end

function checkAreaDrawButtonsPressed(button)
    if button == 1 then
        
        for i, v in ipairs(areaDraw.state) do
            if worldEdit.mouseOverAreaDrawButtons == i then -- Ground
                areaDraw.state[i] = not areaDraw.state[i]
            end
        end

        areaDraw.previousState = copy(areaDraw.state)

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

function standardIfStatement(x, y)
    if worldLookup[x][y] then
        worldEdit.draw[x][y][8] = worldLookup[x][y].Name
    else
        worldEdit.draw[x][y][8] = ""
    end
    worldEdit.draw[x][y][7] = "*"
end

function boolToInt(value)
    return value and 1 or 0
end

function boolToString(bool)
    if bool then return "On" else return "Off" end
end