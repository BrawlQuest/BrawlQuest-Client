function love.mousepressed(x, y, button)
    if phase == "login" then
        checkClickLogin(x, y)
    elseif isWorldEditWindowOpen then
        checkEditWorldClick(x, y)
    elseif phase == "game" then
        checkQuestPanelMousePressed(button)
        checkInventoryMousePressed()
        checkSettingsMousePressed(button)
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
    if isMouseOver(0, 0, 313 * scale, (uiY - 97) * scale) then
        velyInventory = velyInventory + dy * 512
    elseif isMouseOver(((uiX) - 313) * scale, ((uiY) - ((uiY/1.25) - 15)) * scale, (313) * scale, ((uiY/1.25) - 106 - 14) * scale) then
        velYQuest = velYQuest + dy * 512
    elseif showNPCChatBackground then
        npcChatArg.posY = npcChatArg.posY + (dy * (npcChatArg.font:getHeight() * 0.5))
    elseif worldEdit.open then
        if dy > 0 then
            worldScale = worldScale * 1.5
        else
            worldScale = worldScale * 0.5
        end
        worldEdit.previousScrollPosition = dy
    else 
        if isTypingInChat then velyChat = velyChat + dy * 512 end
    end
end
