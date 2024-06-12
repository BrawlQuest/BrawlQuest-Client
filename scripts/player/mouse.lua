function love.mousepressed(x, y, button)
    if phase == "login" then
        checkClickLogin(x, y)
        checkCharacterSelectorMousePressed()
    elseif isWorldEditWindowOpen then
        checkEditWorldClick(x, y)
    elseif phase == "game" then
        checkQuestPanelMousePressed(button)
        -- checkHotbarMousePressed(button)
        if challenges.open then checkChallengesMousePressed(button) end
        if isSettingsWindowOpen then checkSettingsMousePressed(button) end
        checkStatsMousePressed(button)
        if crafting.open then checkCraftingMousePressed(button) end
        if inventory.mouseOverButtonsAmount == 0 and inventory.isMouseOverInventoryItem then checkItemDragMousePressed(button) 
        elseif inventory.mouseOverButtonsAmount > 0 then checkItemDragMousePressed(button, inventory.mouseOverButtonsAmount) end
        if showNPCChatBackground then checkNPCChatMousePressed(button) end
        checkWorldEditMouseDown(button)
        if mouseOverChat then isTypingInChat = not isTypingInChat end
        if enchanting.open then checkEnchantingMousePressed(button) end
        if forging.open then checkForgingMousePressed(button) end
        if news.open then checkNewsMousePressed(button) end
        if orders.open then checkOrdersMousePressed(button) end
        if shop.open then shop:mousepressed(button) end
    end
end

function love.mousereleased(x, y, button)
    if phase == "game" then
        if worldEdit.open and worldEdit.drawmode == "rectangle" then
        checkWorldEditRectMouseUp(button)
        elseif characterHub.amount > 0 then
            if characterHub.selectedPerk > -1 then
                if perks.changeAmount > 0 then
                    apiGET("/stat/"..player.name.."/"..perkTitles[characterHub.selectedPerk+1].."/"..perks.changeAmount)
                else
                    c, h = http.request{url = api.url.."/stat/"..player.name.."/"..perkTitles[characterHub.selectedPerk+1].."/"..math.abs(perks.changeAmount), method="DELETE", headers={["token"]=token}}
                end
            end
        end
        --- If the ID of the current dragged item matches the ID of the released item then we know the user is trying to use the item rather than move it to the hotbar
        if itemDrag.item and inventory.mouseOverButtonsAmount == 0 and itemDrag.item.name == selectedItem.name then checkInventoryMousePressed(button) 
        elseif inventory.mouseOverButtonsAmount > 0 and lunajson.encode(itemDrag.item) == lunajson.encode(hotbar[inventory.mouseOverButtonsAmount].item) then checkHotbarMousePressed(button) end
        checkItemDragMouseReleased(button)
        onPremiumMouseDown()
        onHardcoreMouseDown()
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    if not itemDrag.dragging then showMouse = true end
end

local speed = 8
function updateMouse(dt)
    if showMouse and mouseAmount < 1 then
        mouseAmount = mouseAmount + speed * dt
        if mouseAmount >= 1 then mouseAmount = 1 end
    elseif mouseAmount > 0 then 
        mouseAmount = mouseAmount - speed * dt
        if mouseAmount <= 0 then mouseAmount = 0 end
    end
end

function love.wheelmoved( dx, dy )
    checkScrollingWheelMoved(dx, dy)
    if phase == "game" then
        if isSettingsWindowOpen then scrollSettings(dx, dy)
        elseif isTypingInChat then velyChat = velyChat + dy * 512
        elseif crafting.open then crafting.velY = crafting.velY + dy * 512            
        elseif isMouseOver(0, 0, 313 * scale, (uiY - 97) * scale) then velyInventory = velyInventory + dy * 512
        elseif isMouseOver(((uiX) - 313) * scale, ((uiY) - ((uiY/1.25) - 15)) * scale, (313) * scale, ((uiY/1.25) - 106 - 14) * scale) then velYQuest = velYQuest + dy * 512
        elseif showNPCChatBackground then npcChatArg.posY = npcChatArg.posY + (dy * (npcChatArg.font:getHeight() * 0.5))
        elseif questHub.commentOpen and #quests[1] > 0 then questHub.velY = questHub.velY + dy * 512
        elseif orders.open then
        elseif reputation.open then
        elseif shop.open then
        elseif worldEdit.open then zoomCamera(dy, worldEditScales)
        else zoomCamera(dy, worldScales) end
    end
end

function zoomCamera(dy, table)
    if not worldScaleSmoothing then worldScaleSmoothing = true end
    previousWorldScale = worldScale
    worldScaleAmount = 0
    if dy > 0 then selectedWorldScale = selectedWorldScale - 1
    else selectedWorldScale = selectedWorldScale + 1 end
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
        player.attacking = true
    elseif my > range.y then
        player.target.active = true
        player.target.y = player.y + 1
        player.attacking = true
    end

    if mx < -range.x then
        player.target.active = true
        player.target.x = player.x - 1
        player.attacking = true
        player.previousDirection = "left"
    elseif mx > range.x then
        player.target.active = true
        player.target.x = player.x + 1
        player.attacking = true
        player.previousDirection = "right"
    end
end