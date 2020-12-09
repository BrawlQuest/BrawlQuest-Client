function love.mousepressed(x, y, button)
    if phase == "login" then
        checkClickLogin(x, y)
    elseif isWorldEditWindowOpen then
        checkEditWorldClick(x, y)
    elseif phase == "game" then
       checkInventoryMousePressed()
    --    checkChatMousePressed()
       checkPerksMousePressed(button)
       checkSettingsMousePressed(button)
       if showNPCChatBackground then
        checkNPCChatMousePressed()
       end
    end
end

function love.wheelmoved( dx, dy )
    if isMouseOver(0, toolbarY*scale, inventory:getWidth()*scale, inventory:getHeight()*scale) then
        velyInventory = velyInventory + dy * 512
    else 
        velyChat = velyChat + dy * 512
    end
end
