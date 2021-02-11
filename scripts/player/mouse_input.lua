function love.mousepressed(x, y, button)
    if phase == "login" then
        checkClickLogin(x, y)
        checkCharacterSelectorMousePressed()
    elseif isWorldEditWindowOpen then
        checkEditWorldClick(x, y)
    elseif phase == "game" then
        checkQuestPanelMousePressed(button)
        checkInventoryMousePressed(button)
        if isSettingsWindowOpen then checkSettingsMousePressed(button) end
        checkStatsMousePressed(button)
        if crafting.open then checkCraftingMousePressed(button) end
        if showNPCChatBackground then
        checkNPCChatMousePressed(button)
        end
        checkWorldEditMouseDown(button)
    end
end

function love.mousereleased(x, y, button)

    if worldEdit.open and worldEdit.drawmode == "rectangle" then
       checkWorldEditRectMouseUp(button)
    end
    
end

function love.wheelmoved( dx, dy )
    if phase == "game" then
        if isSettingsWindowOpen then
            scrollSettings(dx, dy)
        elseif crafting.open then
            crafting.velY = crafting.velY + dy * 512            
        elseif isMouseOver(0, 0, 313 * scale, (uiY - 97) * scale) then
            velyInventory = velyInventory + dy * 512
        elseif isMouseOver(((uiX) - 313) * scale, ((uiY) - ((uiY/1.25) - 15)) * scale, (313) * scale, ((uiY/1.25) - 106 - 14) * scale) then
            velYQuest = velYQuest + dy * 512
        elseif showNPCChatBackground then
            npcChatArg.posY = npcChatArg.posY + (dy * (npcChatArg.font:getHeight() * 0.5))
        elseif worldEdit.open then
            zoomCamera(dy, worldEditScales)
        else 
            if isTypingInChat then velyChat = velyChat + dy * 512 end
            zoomCamera(dy, worldScales)
        end
    end
end

function zoomCamera(dy, table)
    if not worldScaleSmoothing then worldScaleSmoothing = true end
    previousWorldScale = worldScale
    worldScaleAmount = 0
    if dy > 0 then
        selectedWorldScale = selectedWorldScale - 1
    else
        selectedWorldScale = selectedWorldScale + 1
    end
    if selectedWorldScale < 1 then selectedWorldScale = 1
    elseif selectedWorldScale > #table then selectedWorldScale = #table end
end

function checkMouseTargeting()
    -- perhaps just target whatever tile mouse is over.
    local mx, my = love.mouse.getPosition()
    mx = player.cx - (player.cx - (mx - love.graphics.getWidth() * 0.5))
    my = player.cy - (player.cy - (my - love.graphics.getHeight() * 0.5))
    
    local range = {x = 4 * 32, y = 4 * 32}

    if my < -range.y then 
        player.target.active = true
        player.target.y = player.y - 1
    elseif my > range.y then
        player.target.active = true
        player.target.y = player.y + 1
    end

    if mx < -range.x then
        player.target.active = true
        player.target.x = player.x - 1
    elseif mx > range.x then
        player.target.active = true
        player.target.x = player.x + 1
    end
end

function checkForceTargeting()
    
end