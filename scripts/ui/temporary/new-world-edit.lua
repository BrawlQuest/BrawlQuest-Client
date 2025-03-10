function initNewWorldEdit()
    worldEdit = {
        open = false,
        changed = false,
        drawable = true,
        isDrawing = false,
        showHud = true,
        tileSelect = false,
        tileSelection = {x = 0, y = 0},
        mousePosition = {x = 0, y = 0},
        mousePositionStart = {x = 0, y = 0},
        toolbarAmount = 0,
        boxHeight = 1,
        draw = {
            -- 1. ground tile
            -- 2. foreground tile
            -- 3. enemy name
            -- 4. collisions
            -- 5. tile name
            -- 6. tile music
            -- 7. enemy index
            -- 8. tile name color
            -- 9. tile name color
        },
        selectableTile = "",
        drawableTile = {
            "assets/world/grounds/grass/grass08.png",   -- 1. ground tile
            "assets/world/grounds/grass/grass08.png",   -- 2. foreground tile
            "", -- enemy name                           -- 3. enemy name
            true, -- collisions                         -- 4. collisions
            "", --  Tile Name                           -- 5. tile name
            "*", -- Music                               -- 6. tile music
            0, -- enemy index                           -- 7. enemy index
        },
        drawmode = "pencil",
        drawableRect = {ax = 0, ay = 0, bx = 0, by = 0},
        isDrawingRect = false,
        areaDrawButtonsTotal = 0,
        selectedTile = {},
        enemyImages = {},
        selectedFloor = "",
        selectedObject = "",
        enemyInputType = 0,
        eraser = true,
        hoveringOverButton = false,
        mouseOverEnemyButtons = 0,
        mouseOverControlButtons = 0,
        mouseOverAreaDrawButtons = 0,
        worldSize = 500,
        drawnWorldSize = 50, -- +- value
        font = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 8),
        previousScrollPosition = 0,
        isTyping = false,
        enteredWorldText = "",
        readyToWriteText = false,
    }

    availablePlaceNames = {}
    avaliableMusic = {}

    
    areaDraw = {
        tabMode = false,
        showPlaceNames = false,
        showMusic = false, 
        state = {
            false, -- 1. ground tile
            false, -- 2. foreground tile
            false, -- 3. enemy name
            false, -- 4. collisions
            false, -- 5. tile name
            false, -- 6. tile music
        },
        previousState = {true, true, true, true, false, false},
        nextPlaceColor = {0,0,0,0},
        nextMusicColor = {0,0,0,0},
        selectedColor = null,
        mouseOverPlaceNames = -1,
        mouseOverMusicNames = -1,
    }

    editorCtl = {
        title = {"(CMD + S) Save Changes", "(Q) Collisions: ", "(E) Hud: ", "(R or Space) Rubber: ", "Clear Changes", },
        state = {false, true, true, false, false},
        stateTitle = {{"", "",}, {"OFF", "ON"}, {"Closed", "Open",}, {"OFF", "ON"}, {"", "",},},
    }

    initDrawableNewWorldEditTiles()
end

function initDrawableNewWorldEditTiles()
    local i = 0
    for x = worldEdit.worldSize * -1, worldEdit.worldSize do
        worldEdit.draw[x] = {}
        for y = worldEdit.worldSize * -1, worldEdit.worldSize do
            worldEdit.draw[x][y] = {"", "", "", false, "", "*", 0, null, null}            
        end
    end
    worldEdit.changed = false
    editorCtl.state[1] = false
    editorCtl.state[5] = false
    worldEdit.enemyInputType = 0
    worldEdit.drawableTile[3] = "" 
    worldEdit.drawableTile[7] = 0
end

function drawEditorButtons()
    for i,v in ipairs(editorCtl.title) do -- Top Left Control Buttons
        local x, y, width, height, padding = cerp(10, 320, worldEdit.toolbarAmount) + (110 * (i - 1)), love.graphics.getHeight() - 45, 100, 35, 10
        drawNewWorldEditButton(x, y, width, height, editorCtl.state[i])
        if isMouseOver(x, y, width, height) then
            worldEdit.mouseOverControlButtons = i
        end
        if editorCtl.state[i] then love.graphics.setColor(0,0,0,1) else love.graphics.setColor(1,1,1,1) end
        love.graphics.printf(editorCtl.title[i] .. editorCtl.stateTitle[i][boolToInt(editorCtl.state[i]) + 1], x + padding, y + padding, width - (padding * 2))
    end
end

function updateNewWorldEdit(dt)
    if worldEdit.open then
        
        if isMouseDown() then worldEdit.isDrawing = true else worldEdit.isDrawing = false end
        local isMouse = isMouseOver(0, love.graphics.getHeight() - (32 * (worldEdit.boxHeight + 3)), 310, (32 * (worldEdit.boxHeight + 3)))
        
        if editorCtl.state[3] then
            worldEdit.drawable = not isMouse
            worldEdit.toolbarAmount = worldEdit.toolbarAmount + 5 * dt
            if worldEdit.toolbarAmount > 1 then worldEdit.toolbarAmount = 1 end
        else
            worldEdit.drawable = true
            worldEdit.toolbarAmount = worldEdit.toolbarAmount - 5 * dt
            if worldEdit.toolbarAmount < 0 then worldEdit.toolbarAmount = 0 end
        end

        if love.keyboard.isDown("lctrl") then
            worldEdit.tileSelect = true
        else
            worldEdit.tileSelect = false
        end
    end  
end

function drawNewWorldEditHud() 
    if worldEdit.open then
        worldEdit.mouseOverEnemyButtons = 0
        worldEdit.mouseOverControlButtons = 0
        worldEdit.mouseOverAreaDrawButtons = 0
        areaDraw.mouseOverMusicNames = -1
        areaDraw.mouseOverPlaceNames = -1
        worldEdit.hoveringOverButton = false
        worldEdit.readyToWriteText = false
        worldEdit.selectableTile = ""
        local thisX, thisY = 0, cerp(love.graphics.getHeight() + (32 * (worldEdit.boxHeight + 3)), love.graphics.getHeight(), worldEdit.toolbarAmount)
        love.graphics.setColor(0,0,0,0.6)
        love.graphics.rectangle("fill", thisX, thisY, 310, (-32 * (worldEdit.boxHeight + 3)))
        love.graphics.setColor(1,1,1,1)

        thisX, thisY = love.graphics.getWidth(), love.graphics.getHeight()
        local x, y = thisX, thisY
        for i, v in ipairs(availableEnemies) do
            drawEnemyButton(x, y, 42, 42, 10, v.Name, worldEdit.enemyInputType == i, i, v.Image)
            y = y - 52
            if y <= 52 then
                y = thisY
                x = x - 52
            end
        end
        drawTilePicker()
        drawEditorButtons()
        drawAreaDrawButtons()
        love.graphics.setColor(1,1,1)
    end
end

function drawTilePicker()
    local x, y = 10, love.graphics.getHeight() - 42 + cerp((32 * (worldEdit.boxHeight + 3)), 0, worldEdit.toolbarAmount)
    worldEdit.boxHeight = 1

    for i,v in ipairs(worldFiles) do -- draws the tiles to choose from
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

            if v == "assets/world/grounds/grass/grass08.png" then
                love.graphics.setColor(1,0,1,1)
                roundRectangle("fill", x - 4, y - 4 , 10, 10, 5) -- Origin
                love.graphics.setColor(1,1,1,1)
            end
            
            x = x + 32 + 5
            if x > 300 then
                y = y - (32 + 5)
                x = 10
                worldEdit.boxHeight = worldEdit.boxHeight + 1
            end
        end
    end 
end

function drawNewWorldEditButton(thisX, thisY, width, height, thisMode)
    love.graphics.setFont(worldEdit.font)
    if isMouseOver(thisX, thisY, width, height) then
        if thisMode then 
            love.graphics.setColor(1,1,1,1)
            
        else
            love.graphics.setColor(0,0.8,0,1)
        end
        worldEdit.hoveringOverButton = true
    elseif thisMode then
        love.graphics.setColor(1,1,1,0.8)
    else
        love.graphics.setColor(0,0,0,0.6)
    end
    roundRectangle("fill", thisX, thisY, width, height, 5)
    love.graphics.setColor(1,1,1,1)
end

function drawEnemyButton(thisX, thisY, width, height, padding, text, thisMode, count, image)
    local thisX, thisY = thisX - width - padding, thisY - height - padding
    drawNewWorldEditButton(thisX, thisY, width, height, thisMode)

    if isMouseOver(thisX, thisY, width, height) then
        worldEdit.mouseOverEnemyButtons = count
    end

    love.graphics.draw(worldEdit.enemyImages[count], thisX + 5, thisY + 5)
end

function drawNewWorldEditTiles()
    love.graphics.setColor(1,1,1,1)
    local worldSize = {w = worldEdit.drawnWorldSize, h = worldEdit.drawnWorldSize}
    for x = (worldSize.w * -1) + player.x, worldSize.w + player.x do
        for y = (worldSize.h * -1) + player.y, worldSize.h + player.y do
            -- x, y = x + 10, y + 10
            thisX, thisY = x * 32 , y * 32 -- x,y  = x, y + player position?
            love.graphics.setColor(1,1,1)

            if worldEdit.draw[x] and worldEdit.draw[x][y] and worldEdit.draw[x][y][1] and worldEdit.draw[x][y][2] and worldEdit.draw[x][y][1] ~= (nil or "") then
                local img1 = getImgIfNotExist(worldEdit.draw[x][y][1])
                local img2 = getImgIfNotExist(worldEdit.draw[x][y][2])
                love.graphics.draw(img1, thisX, thisY) -- draws new tiles

                if worldEdit.draw[x][y][1] ~= worldEdit.draw[x][y][2] then
                    love.graphics.draw(img2, thisX, thisY) -- draws new tiles
                end

                if worldEdit.draw[x][y][7] > 0 then
                    love.graphics.draw(worldEdit.enemyImages[worldEdit.draw[x][y][7]], thisX, thisY) -- draw enemy
                end

                if worldEdit.draw[x][y][4] then 
                    love.graphics.setColor(1,0,1,1) 
                    roundRectangle("fill", thisX - 5, thisY - 5 , 10, 10, 5) -- collisions indicator
                    love.graphics.setColor(1,1,1,1) 
                end
            end

            drawAreaDrawAreas(x, y)

            if areaDraw.state[5] then
                if worldEdit.draw[x][y][8] ~= null then
                    love.graphics.setColor(unpack(worldEdit.draw[x][y][8]))
                    love.graphics.rectangle("fill", thisX, thisY, 32, 32)
                elseif worldEdit.draw[x][y][1] ~= (nil or "") and worldEdit.draw[x][y][5] ~= "" then
                    love.graphics.setColor(unpack(areaDraw.nextPlaceColor))
                    love.graphics.rectangle("fill", thisX, thisY, 32, 32)
                end
            end

            if areaDraw.state[6] then
                if worldEdit.draw[x][y][9] ~= null then
                    love.graphics.setColor(unpack(worldEdit.draw[x][y][9]))
                    love.graphics.rectangle("fill", thisX, thisY, 32, 32)
                elseif worldEdit.draw[x][y][1] ~= (nil or "") and worldEdit.draw[x][y][6] ~= "" then
                    love.graphics.setColor(unpack(areaDraw.nextMusicColor))
                    love.graphics.rectangle("fill", thisX, thisY, 32, 32)
                end
            end
    
            love.graphics.setColor(1,1,1,1)    
            if worldEdit.drawable and not worldEdit.hoveringOverButton and isMouseOverTile(thisX, thisY) then

                worldEdit.mousePosition = {x = x, y = y}
                
                if worldEdit.tileSelect then
                    love.graphics.setColor(1, 0, 1, 0.5)
                    worldEdit.tileSelection = {x = x, y = y}
                else
                    love.graphics.setColor(1,1,1,0.5)
                end

                if worldEdit.drawmode == "pencil" then
                    love.graphics.rectangle("fill", thisX, thisY, 32, 32)
                elseif worldEdit.drawmode == "rectangle" and not worldEdit.tileSelect then -- if mouse down true fade if not.
                    local startx = worldEdit.mousePositionStart.x
                    local starty = worldEdit.mousePositionStart.y
                    local endx = worldEdit.mousePosition.x
                    local endy = worldEdit.mousePosition.y
                    local width = 0
                    local height = 0
                    local topLeft = {}
                    if isMouseDown() then
                        worldEdit.isDrawingRect = true

                        if endx < startx then
                            startx = startx + 1
                        else
                            endx = endx + 1
                        end

                        if endy < starty then
                            starty = starty + 1
                        else
                            endy = endy + 1
                        end

                        width = endx - startx
                        height = endy - starty

                        love.graphics.rectangle("fill", startx * 32, starty * 32, width * 32, height * 32)
                        worldEdit.drawableRect = {ax = startx, ay = starty, bx = endx, by = endy, w = width, h = height}
                    else
                        worldEdit.isDrawingRect = false
                        love.graphics.rectangle("fill", thisX, thisY, 32, 32)
                    end
                end


                if worldEdit.drawmode == "pencil" and not worldEdit.tileSelect and isMouseDown() then
                    worldEdit.changed = true
                    editorCtl.state[1] = true
                    editorCtl.state[5] = true
                
                    if love.mouse.isDown(1) then
                        if editorCtl.state[4] then -- rubber
                            if worldLookup[x..","..y] then
                                worldEdit.draw[x][y][1] = worldLookup[x..","..y].GroundTile
                                worldEdit.draw[x][y][2] = worldLookup[x..","..y].ForegroundTile
                                worldEdit.draw[x][y][3] = ""
                            else
                                for i = 1, 3 do
                                    worldEdit.draw[x][y][i] = ""
                                end
                            end
                            worldEdit.draw[x][y][4] = false -- collisions
                            worldEdit.draw[x][y][7] = 0 -- enemy index
                        else
                            for i = 1, 3 do
                                worldEdit.draw[x][y][i] = worldEdit.drawableTile[i]
                            end
                            worldEdit.draw[x][y][4] = editorCtl.state[2] -- collisions

                            worldEdit.draw[x][y][7] = worldEdit.drawableTile[7] -- enemy index
                        end
                        standardIfStatement(x, y)
                    end

                    if love.mouse.isDown(2) then
                        if editorCtl.state[4] then -- rubber
                            if worldEdit.draw[x][y][1] ~= "" then
                                worldEdit.draw[x][y][1] = worldEdit.draw[x][y][1]
                            end
                            worldEdit.draw[x][y][2] = ""

                        elseif love.keyboard.isDown("lshift") then
                            if worldLookup[x..","..y] then
                                worldEdit.draw[x][y][1] = worldLookup[x..","..y].GroundTile
                                worldEdit.draw[x][y][2] = worldLookup[x..","..y].ForegroundTile
                            else
                                for i = 1, 3 do
                                    worldEdit.draw[x][y][i] = ""
                                end
                            end

                        else
                            worldEdit.draw[x][y][1] = worldEdit.drawableTile[1]
                            worldEdit.draw[x][y][2] = worldEdit.drawableTile[1]
                        end                      
                        worldEdit.draw[x][y][3] = "" -- enemy
                        worldEdit.draw[x][y][4] = false -- collisions
                        worldEdit.draw[x][y][7] = 0 -- enemy index
                        standardIfStatement(x, y)
                    end
                end
            end
        end
    end
    love.graphics.setColor(1,1,1,1)
end

function checkWorldEditMouseDown(button)
    if worldEdit.open then

        if button == 1 and worldEdit.tileSelect then -- Selecting a tile to copy - enemies
            if worldLookup[worldEdit.tileSelection.x..","..worldEdit.tileSelection.y] then
                if worldLookup[worldEdit.tileSelection.x..","..worldEdit.tileSelection.y].GroundTile ~= worldLookup[worldEdit.tileSelection.x..","..worldEdit.tileSelection.y].ForegroundTile then
                    worldEdit.drawableTile[2] = worldLookup[worldEdit.tileSelection.x..","..worldEdit.tileSelection.y].ForegroundTile
                end
                worldEdit.drawableTile[1] = worldLookup[worldEdit.tileSelection.x..","..worldEdit.tileSelection.y].GroundTile
                worldEdit.drawableTile[4] = worldLookup[worldEdit.tileSelection.x..","..worldEdit.tileSelection.y].Collision
                editorCtl.state[2] = worldLookup[worldEdit.tileSelection.x..","..worldEdit.tileSelection.y].Collision
            else
                worldEdit.drawableTile[1] = "assets/world/grounds/grass/grass08.png"
                worldEdit.drawableTile[2] = "assets/world/grounds/grass/grass08.png"
                worldEdit.drawableTile[4] = false
                editorCtl.state[2] = false
            end
        end

        if (button == 1 or button == 2) and worldEdit.drawable then
            worldEdit.mousePositionStart = worldEdit.mousePosition
        end

        if worldEdit.readyToWriteText then
            worldEdit.isTyping = not worldEdit.isTyping
        end

        if worldEdit.mouseOverEnemyButtons > 0 then

            if button == 1 then
                if worldEdit.enemyInputType == worldEdit.mouseOverEnemyButtons then
                    worldEdit.enemyInputType = 0
                    worldEdit.drawableTile[3] = "" 
                    worldEdit.drawableTile[8] = 0
                else
                    worldEdit.enemyInputType = worldEdit.mouseOverEnemyButtons
                    worldEdit.drawableTile[3] = availableEnemies[worldEdit.enemyInputType].Name 
                    worldEdit.drawableTile[8] = worldEdit.enemyInputType
                end
            end

        elseif worldEdit.mouseOverControlButtons > 0 then
            if button == 1 then
                if worldEdit.mouseOverControlButtons == 1 then -- save
                    if worldEdit.changed then saveWorldChanges() end 
                end
                if worldEdit.mouseOverControlButtons == 2 then -- collisions
                    editorCtl.state[2] = not editorCtl.state[2]
                    worldEdit.drawableTile[4] = not worldEdit.drawableTile[4]
                end
                if worldEdit.mouseOverControlButtons == 3 then -- show hud
                    editorCtl.state[3] = not editorCtl.state[3]
                end
                
                if worldEdit.mouseOverControlButtons == 4 then -- rubber
                    editorCtl.state[4] = not editorCtl.state[4]
                end
                if worldEdit.mouseOverControlButtons == 5 then -- clear
                    initDrawableNewWorldEditTiles()
                end
            end

        elseif worldEdit.mouseOverAreaDrawButtons > 0 then
            checkAreaDrawButtonsPressed(button)

        elseif areaDraw.mouseOverPlaceNames > -1 then
            if button == 1 then
                local count = 1
                for i,v in ipairs(availablePlaceNames) do
                    if areaDraw.mouseOverPlaceNames == count then
                        worldEdit.enteredWorldText = v.name
                        worldEdit.drawableTile[5] = v.name
                    elseif areaDraw.mouseOverPlaceNames == 0 then
                        worldEdit.enteredWorldText = ""
                        worldEdit.drawableTile[5] = ""
                    end
                    if v.name ~= "" then 
                        count = count + 1
                    end
                end
            end
        elseif areaDraw.mouseOverMusicNames > -1 then
            if button == 1 then
                local count = 1
                for i,v in ipairs(avaliableMusic) do
                    if areaDraw.mouseOverMusicNames == count then
                        worldEdit.drawableTile[6] = v.name
                    elseif areaDraw.mouseOverMusicNames == 0 then
                        worldEdit.drawableTile[6] = "*"
                    end
                    if v.name ~= "" then 
                        count = count + 1
                    end
                end
            end
        elseif worldEdit.selectableTile ~= "" then
            if button == 1 then
                worldEdit.drawableTile[2] = worldEdit.selectableTile
            elseif button == 2 then
                worldEdit.drawableTile[1] = worldEdit.selectableTile
            end
        end
    end
end

function checkWorldEditKeyPressed(key)
    if worldEdit.isTyping then
        if key == "backspace" then
            worldEdit.enteredWorldText = string.sub( worldEdit.enteredWorldText, 1, string.len( worldEdit.enteredWorldText) - 1)
        elseif key == "return" and worldEdit.enteredWorldText ~= "" then
            worldEdit.isTyping = false
            worldEdit.drawableTile[5] = worldEdit.enteredWorldText
            -- print(worldEdit.drawableTile[5])
        elseif key == "escape" then 
            worldEdit.isTyping = false
        end
    else
        if key == "r" or key == "space" then
            editorCtl.state[4] = not editorCtl.state[4]
        elseif key == "q" then
            editorCtl.state[2] = not editorCtl.state[2]
            worldEdit.drawableTile[4] = not worldEdit.drawableTile[4]
        elseif key == "e" then
            editorCtl.state[3] = not editorCtl.state[3]
        elseif key == "x" then
            editorCtl.state[3] = not editorCtl.state[3]
        elseif key == "return" then 
            worldEdit.isTyping = true
        end

        for i, v in ipairs(areaDraw.state) do -- check areaDraw buttons pressed
            if key == tostring(i) then
                checkAreaDrawSingleButtonPressed(i)
                checkAreaDrawButtonsPressedTotal()
            end
        end
        

        if key == "tab" then
            areaDraw.tabMode = not areaDraw.tabMode
            if areaDraw.tabMode then
                areaDraw.state = copy(areaDraw.previousState)
            else
                areaDraw.previousState = copy(areaDraw.state)
                areaDraw.state = {false, false, false, false, areaDraw.previousState[5], areaDraw.previousState[6]}
            end
        end

        if key == "escape" or key == "'" then  
            worldEdit.open = false 
        end

        if key == "s" and (love.keyboard.isDown("lgui") or love.keyboard.isDown("lalt")) then
            saveWorldChanges()
        end
    end
end

function saveWorldChanges()
    -- recursivelyDelete( "img" )
    -- love.filesystem.createDirectory( "img" )
    -- for key, v in next, worldImages do v:release( ) table.removekey(worldImages, key) end
    -- local count = 0
    local count = 0
    for x = worldEdit.worldSize * -1, worldEdit.worldSize do
        for y = worldEdit.worldSize * -1, worldEdit.worldSize do
            if worldEdit.draw[x] and worldEdit.draw[y] and worldEdit.draw[x][y][1] ~= "" then
                count = count + 1
                pendingWorldChanges[#pendingWorldChanges+1] = {
                    GroundTile = worldEdit.draw[x][y][1],
                    ForegroundTile = worldEdit.draw[x][y][2],
                    Name =  worldEdit.draw[x][y][5],
                    Music = worldEdit.draw[x][y][6],  
                    Enemy = worldEdit.draw[x][y][3],
                    Collision = worldEdit.draw[x][y][4],
                    X = x,
                    Y = y,
                }
            end
        end
    end
    local b = {}
    print (json:encode(pendingWorldChanges))
    print("World change amount: " .. count)
    c, h = http.request{url = api.url.."/world", method="POST", source=ltn12.source.string(json:encode(pendingWorldChanges)), headers={["Content-Type"] = "application/json",["Content-Length"]=string.len(json:encode(pendingWorldChanges)),["token"]=token}}
    pendingWorldChanges = {}
    local b = {}
    c, h = http.request{url = api.url.."/world", method="GET", source=ltn12.source.string(body), headers={["token"]=token}, sink=ltn12.sink.table(b)}
    initWorldTable(json:decode(table.concat(b)))
    --createWorld()
    initWorldMap()
    initDrawableNewWorldEditTiles()
    getWorldInfo() 
    worldEdit.changed = false
    editorCtl.state[1] = false
    editorCtl.state[5] = false
    player.cx, player.cy = player.dx, player.dy
end

function checkIfReadyToQuit()
    if worldEdit.changed then
        local buttons = {"Save And Quit", "Quit Without Saving", "Cancel", enterbutton = 1, escapebutton = 3}
        local savePopup = love.window.showMessageBox("Warning", "Do you want to quit without saving world changes?", buttons )
        if savePopup == 1 then 
            saveWorldChanges()
            love.event.quit()
        end
        if savePopup == 2 then love.event.quit() end
        if savePopup == 3 then end
    else
        love.event.quit()
    end
end

function getWorldInfo() 
    availablePlaceNames = {}
    avaliableMusic = {}

    for i, v in ipairs(worldMusic) do -- Gets all current music
        avaliableMusic[i] = v
    end
    for i, v in ipairs(battleMusic) do -- Gets all current music
        avaliableMusic[i + #worldMusic] = v
    end

    local count = 0
    for key,tiles in next, worldChunks do
        if orCalc(key, {player.wx - 1 ..","..player.wy - 1, player.wx..","..player.wy - 1, player.wx - 1 ..","..player.wy, player.wx..","..player.wy,}) then
            for i,v in ipairs(tiles) do
                if  worldLookup[v.X..","..v.Y] then
                    local location = worldLookup[v.X..","..v.Y].Name or ""
                    if not arrayContains(availablePlaceNames, location) and not string.find(location, "Dominion") then
                        availablePlaceNames[#availablePlaceNames + 1] = location
                    end
                    if not arrayContains(avaliableMusic, worldLookup[v.X..","..v.Y].Music) then
                        avaliableMusic[#avaliableMusic + 1] = worldLookup[v.X..","..v.Y].Music
                    end
                end
            end
        end
    end

    for i, v in ipairs(availablePlaceNames) do
        love.math.setRandomSeed(i)
        availablePlaceNames[i] = {name = v, color = {getAreaColor(), getAreaColor(), getAreaColor(), 0.7}}
    end

    for i, v in ipairs(avaliableMusic) do
        love.math.setRandomSeed(i)
        avaliableMusic[i] = {name = v, color = {getAreaColor(), getAreaColor(), getAreaColor(), 0.7}}
    end
    
    love.math.setRandomSeed(#availablePlaceNames + 1)
    areaDraw.nextPlaceColor = {getAreaColor(), getAreaColor(), getAreaColor(), 0.7}

    love.math.setRandomSeed(#avaliableMusic + 1)
    areaDraw.nextMusicColor = {getAreaColor(), getAreaColor(), getAreaColor(), 0.7}

    print("Places: " .. json:encode(availablePlaceNames))
    print("Music: " .. json:encode(avaliableMusic))
end

function checkWorldEditTextInput(key)
    worldEdit.enteredWorldText = worldEdit.enteredWorldText .. key
end

function getAreaColor()
    return 1 - (love.math.random() * 1)
end