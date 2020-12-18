function love.mousepressed(x, y, button)
    if phase == "login" then
        checkClickLogin(x, y)
    elseif isWorldEditWindowOpen then
        checkEditWorldClick(x, y)
    elseif phase == "game" then
        checkQuestPanelMousePressed(button)
        checkInventoryMousePressed()
        checkPerksMousePressed(button)
        checkSettingsMousePressed(button)
        checkStatsMousePressed(button)
        if showNPCChatBackground then
            checkNPCChatMousePressed()
        end
    end
end

function love.wheelmoved( dx, dy )
    if isMouseOver(0, 0, 313 * scale, (uiY - 97) * scale) then
        velyInventory = velyInventory + dy * 512
    elseif isMouseOver(((uiX) - 313) * scale, ((uiY) - ((uiY/1.25) - 15)) * scale, (313) * scale, ((uiY/1.25) - 106 - 14) * scale) then
        velYQuest = velYQuest + dy * 512
    else 
        velyChat = velyChat + dy * 512
    end
end
