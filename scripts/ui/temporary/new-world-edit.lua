function initNewWorldEdit()
    worldEdit = {
        open = false,
        changed = false,
        drawable = true,
        isDrawing = false,
        toolbarAmount = 1,
        boxHeight = 1,
        draw = {},
        selectableTile = "",
        drawableTile = {"assets/world/grounds/grass/grass08.png", "assets/world/grounds/grass/grass08.png", ""},
        selectedTile = {},
        enemyImages = {},
        selectedFloor = "",
        selectedObject = "",
        enemyInputType = 1,
        eraser = true,
        hoveringOverButton = false,
        mouseOverEnemyButtons = 0,
        mouseOverControlButtons = 0,
        worldSize = 100,
        font = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 8),
    }

    editorCtl = {
        title = {"Save Changes", "Draw Mode: ", "Collisions: ",},
        state = {false, false, false},
        stateTitle = {{"", "",}, {"Ground + Foreground", "Grounds",}, {"OFF", "ON"}},
    }

    initDrawableNewWorldEditTiles()
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
        worldEdit.mouseOverEnemyButtons = 0
        worldEdit.mouseOverControlButtons = 0
        worldEdit.hoveringOverButton = false
        worldEdit.selectableTile = ""
        local thisX, thisY = 0, cerp(love.graphics.getHeight() + (32 * (worldEdit.boxHeight + 1)), love.graphics.getHeight(), worldEdit.toolbarAmount)
        love.graphics.setColor(0,0,0,0.6)
        love.graphics.rectangle("fill", thisX, thisY, love.graphics.getWidth(), (-32 * (worldEdit.boxHeight + 1)))
        love.graphics.setColor(1,1,1,1)

        thisX, thisY = love.graphics.getWidth(), love.graphics.getHeight()
        for i, v in ipairs(availableEnemies) do
            drawEnemyButton(thisX, thisY - (52 * (i - 1)), 42, 42, 10, v.Name, worldEdit.enemyInputType == i, i, v.Image)
        end

        local x, y = 10, love.graphics.getHeight() - 42 + cerp((32 * (worldEdit.boxHeight + 1)), 0, worldEdit.toolbarAmount)
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
                x = x + 32 + 5
                if x > love.graphics.getWidth() - 32 - 70 then
                    y = y - (32 + 5)
                    x = 10
                    worldEdit.boxHeight = worldEdit.boxHeight + 1
                end
            end
        end 

        for i = 1, 3 do -- Top Left Control Buttons
            local x, y, width, height, padding = 100 + (110 * (i - 1)), 10, 100, 35, 10
            drawNewWorldEditButton(x, y, width, height, editorCtl.state[i])
            if isMouseOver(x, y, width, height) then
                worldEdit.mouseOverControlButtons = i
            end
            love.graphics.printf(editorCtl.title[i] .. editorCtl.stateTitle[i][1], x + padding, y + padding, width - (padding * 2))
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
        love.graphics.setColor(1,1,1,1)
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
    love.graphics.printf(text, thisX - width, thisY, width - ((padding * 0.5) * 2), "right")
end

function drawNewWorldEditTiles()
    if worldEdit.open then 
        local getWidth, getHeight = 100, 100
        love.graphics.setColor(1,1,1,1)
        for x = getWidth * -1, getWidth do
            for y = getHeight * -1, getHeight do
                thisX, thisY = x * 32 , y * 32 
                love.graphics.setColor(1,1,1,1) 
                for z = 1, 3 do
                    if worldEdit.draw[x][y][z] ~= (nil or "") then
                        love.graphics.draw(worldImg[worldEdit.draw[x][y][z]], thisX, thisY)
                    end
                end

                love.graphics.setColor(1,1,1,0.6)
                if worldEdit.drawable and not worldEdit.hoveringOverButton and isMouseOver(
                    (((thisX - player.dx - 16) * worldScale) + (love.graphics.getWidth()/2)), 
                    (((thisY - player.dy - 16) * worldScale) + (love.graphics.getHeight()/2)), 
                    32 * worldScale, 
                    32 * worldScale) then
                    love.graphics.rectangle("fill", thisX, thisY, 32, 32)
                    if love.mouse.isDown(1) then
                        for i = 1, 3, 1 do
                            worldEdit.draw[x][y][i] = worldEdit.drawableTile[i]
                        end
                        worldEdit.draw[x][y][4] = editorCtl.state[3]
                    end
                    if love.mouse.isDown(2) then
                        if worldEdit.eraser then
                            for i = 1, 3, 1 do
                                worldEdit.draw[x][y][i] = ""
                            end
                        else
                            worldEdit.draw[x][y][1] = worldEdit.drawableTile[1]
                            worldEdit.draw[x][y][2] = worldEdit.drawableTile[1]
                            worldEdit.draw[x][y][4] = editorCtl.state[3]
                        end
                    end
                end
            end
        end
    end
    love.graphics.setColor(1,1,1,1)
end

function checkWorldEditMouseDown(button)
    if worldEdit.open then
        if worldEdit.mouseOverEnemyButtons > 0 then
            if button == 1 then
                if worldEdit.enemyInputType == worldEdit.mouseOverEnemyButtons then
                    worldEdit.enemyInputType = 0
                else
                    worldEdit.enemyInputType = worldEdit.mouseOverEnemyButtons
                end
            end
        elseif worldEdit.mouseOverControlButtons > 0 then
            if button == 1 then
                if worldEdit.mouseOverControlButtons == 1 then saveWorldChanges() end
                if worldEdit.mouseOverControlButtons == 2 then
                    editorCtl.state[2] = not editorCtl.state[2]
                end
                if worldEdit.mouseOverControlButtons == 3 then
                    editorCtl.state[3] = not editorCtl.state[3]
                end
                -- put stuff here!
            end
        elseif worldEdit.selectableTile ~= "" then
            worldEdit.changed = true
            if button == 1 then
                worldEdit.drawableTile[2] = worldEdit.selectableTile
            elseif button == 2 then
                worldEdit.drawableTile[1] = worldEdit.selectableTile
            end
        end
    end
end

function saveWorldChanges()
    local getWidth, getHeight = 100, 100
    local count = 0
    for x = getWidth * -1, getWidth do
        for y = getHeight * -1, getHeight do
            if worldEdit.draw[x][y][1] ~= "" then
                count = count + 1
                pendingWorldChanges[#pendingWorldChanges+1] = {
                    GroundTile = worldEdit.draw[x][y][1],
                    ForegroundTile = worldEdit.draw[x][y][2],
                    Name =  "",
                    Music = "*",
                    Enemy = worldEdit.draw[x][y][3],
                    Collision = worldEdit.draw[x][y][4],
                    X = x,
                    Y = y,
                }
            end
        end
    end
    local b = {}
    print("World change amount = " .. count)
    c, h = http.request{url = api.url.."/world", method="POST", source=ltn12.source.string(json:encode(pendingWorldChanges)), headers={["Content-Type"] = "application/json",["Content-Length"]=string.len(json:encode(pendingWorldChanges)),["token"]=token}}
    pendingWorldChanges = {}
    local b = {}
    c, h = http.request{url = api.url.."/world", method="GET", source=ltn12.source.string(body), headers={["token"]=token}, sink=ltn12.sink.table(b)}
    world = json:decode(b[1])
    createWorld()
    initDrawableNewWorldEditTiles()
    worldEdit.changed = false
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

function initDrawableNewWorldEditTiles()
    for x = worldEdit.worldSize * -1, worldEdit.worldSize do
        worldEdit.draw[x] = {}
        for y = worldEdit.worldSize * -1, worldEdit.worldSize do
            worldEdit.draw[x][y] = {"", "", "", false}
        end
    end
end