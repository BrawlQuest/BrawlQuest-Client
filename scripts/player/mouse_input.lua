function love.mousepressed(x, y, button)
    if phase == "login" then
        checkClickLogin(x, y)
    elseif isWorldEditWindowOpen then
        checkEditWorldClick(x, y)
    elseif phase == "game" then
        checkQuestPanelMousePressed(button)
        checkInventoryMousePressed()
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
        elseif isMouseOver(0, 0, 313 * scale, (uiY - 97) * scale) then
            velyInventory = velyInventory + dy * 512
        elseif isMouseOver(((uiX) - 313) * scale, ((uiY) - ((uiY/1.25) - 15)) * scale, (313) * scale, ((uiY/1.25) - 106 - 14) * scale) then
            velYQuest = velYQuest + dy * 512
        elseif showNPCChatBackground then
            npcChatArg.posY = npcChatArg.posY + (dy * (npcChatArg.font:getHeight() * 0.5))
        -- elseif worldEdit.open then
        --     if dy > 0 then
        --         worldScale = worldScale * 1.5
        --     else
        --         worldScale = worldScale * 0.5
        --     end
            velyWorldScale = velyWorldScale + dy * 1
            worldEdit.previousScrollPosition = dy
        else 
            if isTypingInChat then velyChat = velyChat + dy * 512 end
            velyWorldScale = velyWorldScale + dy * 1  -- We need to use integer values, then smooth between the integers.
            -- if dy > 0 then
            --     worldScale = worldScale * 1.5
            -- else
            --     worldScale = worldScale * 0.5
            -- end
        end
    end
end
