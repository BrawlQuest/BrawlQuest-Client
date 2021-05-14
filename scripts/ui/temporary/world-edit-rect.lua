function checkWorldEditRectMouseUp(button)
    if (button == 1 or button == 2) and worldEdit.isDrawingRect then
        local ax, ay, bx, by = worldEdit.drawableRect.ax, worldEdit.drawableRect.ay, worldEdit.drawableRect.bx, worldEdit.drawableRect.by
        if ax < bx then
            while ax < bx-1 do
                getYValue(ax, ay, bx, by, button)
                ax = ax + 1 
            end
        elseif ax > bx then
            while ax-1 > bx do
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
        while ay < by-1 do
            drawWorldEditTileFromRect(ax, ay, button)
            ay = ay + 1 
        end
    elseif ay > by then
        while ay-1 > by do
            ay = ay - 1 
            drawWorldEditTileFromRect(ax, ay, button)
        end
    end
    ay = worldEdit.drawableRect.ay
end

function drawWorldEditTileFromRect(x, y, button)

    if worldLookup[x..","..y] and worldEdit.draw[x] and worldEdit.draw[x][y] then
        -- if not worldLookup[x..","..y] then
        --     worldLookup[x..","..y] = worldEdit.draw[x][y]
        -- end
        worldEdit.draw[x][y][1] = worldLookup[x..","..y].GroundTile
        worldEdit.draw[x][y][2] = worldLookup[x..","..y].ForegroundTile
        worldEdit.draw[x][y][3] = worldLookup[x..","..y].Enemy
        worldEdit.draw[x][y][4] = worldLookup[x..","..y].Collision
        worldEdit.draw[x][y][5] = worldLookup[x..","..y].Name
    end

    if button == 1 then
        for i, v in ipairs(areaDraw.state) do
            if v == true then
                if i == 1 then
                    if worldEdit.draw[x][y][1] ~= "" then
                        if worldEdit.draw[x][y][1] == worldEdit.draw[x][y][2] then -- if ground and foreground match
                            worldEdit.draw[x][y][2] = worldEdit.drawableTile[1]
                        end
                    elseif worldLookup[x..","..y] then
                        if  worldLookup[x..","..y].GroundTile == worldLookup[x..","..y].ForegroundTile then -- if ground and foreground match
                            worldEdit.draw[x][y][2] = worldEdit.drawableTile[1]
                        end
                    end
                    worldEdit.draw[x][y][1] = worldEdit.drawableTile[1]
                elseif i == 3 then -- enemies
                    worldEdit.draw[x][y][3] = worldEdit.drawableTile[3] 
                    worldEdit.draw[x][y][5] = worldEdit.drawableTile[5]
                elseif i == 5 then
                    worldEdit.draw[x][y][i] = worldEdit.drawableTile[i] 
                    worldEdit.draw[x][y][8] = areaDraw.selectedColor -- color
                elseif i == 6 then
                    worldEdit.draw[x][y][i] = worldEdit.drawableTile[i] 
                    worldEdit.draw[x][y][9] = areaDraw.selectedColor -- color         
                else
                    worldEdit.draw[x][y][i] = worldEdit.drawableTile[i]
                end
            end
        end

    elseif button == 2 and worldEdit.draw[x][y][1] ~= "" then
        for i, v in ipairs(areaDraw.state) do
            if v == true and worldLookup[x..","..y] then
                if i == 1 then
                    if areaDraw.state[2] then -- if drawing object as well
                        worldEdit.draw[x][y][1] = worldEdit.drawableTile[1]
                    else
                        worldEdit.draw[x][y][1] = worldLookup[x..","..y].GroundTile
                    end
                elseif i == 2 then
                    worldEdit.draw[x][y][2] = worldLookup[x..","..y].ForegroundTile
                elseif i == 3 then
                    worldEdit.draw[x][y][3] = worldLookup[x..","..y].Enemy
                elseif i == 4 then
                    worldEdit.draw[x][y][4] = worldLookup[x..","..y].Collision
                end
            end
        end
    end
    print ("Second: " .. json:encode(worldEdit.draw[x][y]))
end

function drawAreaDrawButtons()
    local thisX, thisY = cerp(10, 320, worldEdit.toolbarAmount), love.graphics.getHeight() - 45 - 42 
    areaDraw.selectedColor = null

    local width, height = 202, 32
    drawNewWorldEditButton(thisX, thisY, width, height, false) -- Draws the name of an enemy, no input
    love.graphics.print("Enemy: ''" .. worldEdit.drawableTile[3] .. "''", thisX + 10, thisY + 10, 0, 1.5)

    thisX, thisY = thisX + width + 10, thisY
    drawNewWorldEditButton(thisX, thisY, width * 2, height, worldEdit.isTyping)
    if isMouseOver(thisX, thisY, width * 2, height) then worldEdit.readyToWriteText = true end
    if worldEdit.isTyping then love.graphics.setColor(0,0,0) else love.graphics.setColor(1,1,1) end
    love.graphics.print("Area Name: ''" .. worldEdit.enteredWorldText .. "''", thisX + 10, thisY + 10, 0, 1.5)

    thisX, thisY = thisX - (width + 10), thisY - 52

    for i, v in ipairs(areaDraw.state) do -- draw area buttons
        local x, y = thisX + (52 * (i - 1)), thisY
        drawNewWorldEditButton(x, y, 42, 42, areaDraw.state[i])
        if i < 3 then 
            love.graphics.draw(worldImg[worldEdit.drawableTile[i]], x + 5, y + 5)

        elseif i == 3 then 
            if worldEdit.drawableTile[7] ~= 0 then
                love.graphics.draw(worldEdit.enemyImages[worldEdit.drawableTile[7]], x + 5, y + 5)
            else
                love.graphics.printf("Enemy", x + 5, y + 10, 32, "center")
            end

        elseif i == 4 then 
            if areaDraw.state[4] then love.graphics.setColor(0,0,0,1) else love.graphics.setColor(1,1,1,1) end
            love.graphics.printf("Collisions: " .. boolToString(worldEdit.drawableTile[4]), x + 5, y + 10, 32, "center")

        elseif i == 5 then
            if areaDraw.state[i] then love.graphics.setColor(0,0,0,1) else love.graphics.setColor(1,1,1,1) end
            love.graphics.printf("Tile Name: ''" .. worldEdit.drawableTile[5] .. "''", x + 5, y + 10, 32, "center")

        elseif i == 6 then
            if areaDraw.state[i] then love.graphics.setColor(0,0,0,1) else love.graphics.setColor(1,1,1,1) end
            love.graphics.printf("Music: ''" .. worldEdit.drawableTile[6] .. "''", x + 5, y + 10, 32, "center")
        end

        if isMouseOver(x,y,42,42) then worldEdit.mouseOverAreaDrawButtons = i end
    end

    if areaDraw.state[5] then -- draw avaliable world names
        local thisX, thisY = love.graphics.getWidth() - 62 - 150, love.graphics.getHeight() - 104
        local count = 0
        for i,v in ipairs(availablePlaceNames) do
            if v.name ~= "" then 
                local bool = v.name == worldEdit.drawableTile[5]
                
                drawNewWorldEditButton(thisX, thisY, 150, 42, bool)

                count = count + 1
                if bool then
                    areaDraw.selectedColor = v.color
                end

                if isMouseOver(thisX, thisY, 150, 42) then
                    areaDraw.mouseOverPlaceNames = count
                end

                love.graphics.setColor(1,1,1)
                love.graphics.printf("''" .. v.name .. "''", thisX + 5, thisY + 10, 100, "left")
            
                love.graphics.setColor(unpack(v.color))
                roundRectangle("fill", thisX + 150 - 37, thisY + 5, 32, 32, 5)
                thisY = thisY - 52
            else
                local x, y = love.graphics.getWidth() - 62 - 150, love.graphics.getHeight() - 52
                drawNewWorldEditButton(x, y, 150, 42, bool)

                if isMouseOver(x, y, 150, 42) then
                    areaDraw.mouseOverPlaceNames = 0
                end

                love.graphics.printf("''" .. v.name .. "''", x + 5, y + 10, 100, "left")
            end
        end
    end

    if areaDraw.state[6] then -- draw avaliable world names
        local thisX, thisY = love.graphics.getWidth() - 62 - 150, love.graphics.getHeight() - 104
        local count = 0
        for i,v in ipairs(avaliableMusic) do
            if v.name ~= "*" then 
                local bool = v.name == worldEdit.drawableTile[6]
                
                drawNewWorldEditButton(thisX, thisY, 150, 42, bool)

                count = count + 1
                if bool then
                    areaDraw.selectedColor = v.color
                end

                if isMouseOver(thisX, thisY, 150, 42) then
                    areaDraw.mouseOverMusicNames = count
                end

                love.graphics.setColor(1,1,1)
                love.graphics.printf("''" .. v.name .. "''", thisX + 5, thisY + 10, 100, "left")
            
                love.graphics.setColor(unpack(v.color))
                roundRectangle("fill", thisX + 150 - 37, thisY + 5, 32, 32, 5)
                thisY = thisY - 52
            else
                local x, y = love.graphics.getWidth() - 62 - 150, love.graphics.getHeight() - 52
                drawNewWorldEditButton(x, y, 150, 42, bool)

                if isMouseOver(x, y, 150, 42) then
                    areaDraw.mouseOverMusicNames = 0
                end

                love.graphics.printf("''" .. v.name .. "''", x + 5, y + 10, 100, "left")
            end
        end
    end
end

function checkAreaDrawButtonsPressed(button)
    if button == 1 then
        
        for i, v in ipairs(areaDraw.state) do
            if worldEdit.mouseOverAreaDrawButtons == i then -- Ground
                checkAreaDrawSingleButtonPressed(i)
            end
        end

        areaDraw.previousState = copy(areaDraw.state)
        checkAreaDrawButtonsPressedTotal()
    end
end

function checkAreaDrawButtonsPressedTotal()
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

function standardIfStatement(x, y)
    if worldLookup[x..","..y] then
        worldEdit.draw[x][y][5] = worldLookup[x..","..y].Name
    else
        worldEdit.draw[x][y][5] = ""
    end
    worldEdit.draw[x][y][6] = "*"
end

function boolToInt(value) return value and 1 or 0 end

function boolToString(bool)
    if bool == true then return "true" elseif bool == false then return "false" else return bool end
end

function checkAreaDrawSingleButtonPressed(i)
    if i == 5 then
        if areaDraw.state[6] then 
            areaDraw.showMusic = false
            areaDraw.state[6] = false 
        end
        areaDraw.showPlaceNames = not areaDraw.showPlaceNames
        if not areaDraw.state[5] then
            getWorldInfo()
        end
        areaDraw.state[i] = not areaDraw.state[i]
    elseif i == 6 then
        if areaDraw.state[5] then 
            areaDraw.showPlaceNames = false
            areaDraw.state[5] = false 
        end
        areaDraw.showMusic = not areaDraw.showMusic
        if not areaDraw.state[6] then
            getWorldInfo()
        end
        areaDraw.state[i] = not areaDraw.state[i]
    else
        areaDraw.state[i] = not areaDraw.state[i]
    end
end

function drawAreaDrawAreas(x, y)
    if areaDraw.showPlaceNames then
        love.graphics.setColor(1, 0, 1, 0.5)
        if worldLookup[x..","..y] then
            if worldLookup[x..","..y].Name ~= "" then
                for j,v in ipairs(availablePlaceNames) do
                    if v.name == worldLookup[x..","..y].Name then
                        love.graphics.setColor(unpack(v.color))
                    end
                end
                love.graphics.rectangle("fill", x * 32, y * 32, 32, 32)
            end
        end
    elseif areaDraw.showMusic then
        love.graphics.setColor(1, 0, 1, 0.5)
        if worldLookup[x..","..y] then
            if worldLookup[x..","..y].Music ~= "*" then
                for j,v in ipairs(avaliableMusic) do
                    if v.name == worldLookup[x..","..y].Music then
                        love.graphics.setColor(unpack(v.color))
                    end
                end
                love.graphics.rectangle("fill", x * 32, y * 32, 32, 32)
            end
        end
    end
end