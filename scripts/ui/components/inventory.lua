selectedItem = {}



function drawInventoryFields(thisX, y)
    love.graphics.setFont(inventorySubHeaderFont)
    local thisY = y
    
    for i = 1, #inventoryFields do -- Draws each inventory field
        if inventoryFieldLength[i] ~= 0 then
            inventoryItemField(thisX + 8, thisY + 0, i)
            thisY = thisY + getUserInventoryFieldHeight(i) + 20
        end
    end
    -- love.graphics.rectangle("fill", thisX, y, 100, getFullUserInventoryFieldHeight())
end

function inventoryItemField(thisX, thisY, field)
    love.graphics.printf(inventoryFields[field], thisX, thisY, 483)
    thisY = thisY + 18
    for i = 0, #userInventory[field] - 1 do
        if i <= 3 then
            drawInventoryItemOriginal(thisX + ((i - 0) * 42), thisY + 0, field, i + 1)
            userInventoryFieldHeight[field] = 42 + 15
        elseif i >= 4 and i <= 7 then
            drawInventoryItemOriginal(thisX + ((i - 4) * 42), thisY + 42, field, i + 1)
        elseif i >= 8 and i <= 11 then
            drawInventoryItemOriginal(thisX + ((i - 8) * 42), thisY + 84, field, i + 1)
        elseif i >= 12 and i <= 15 then
            drawInventoryItemOriginal(thisX + ((i - 12) * 42), thisY + 126, field, i + 1)
        elseif i >= 16 and i <= 19 then
            drawInventoryItemOriginal(thisX + ((i - 16) * 42), thisY + 168, field, i + 1)
        end
    end
end

function getUserInventoryFieldHeightOriginal(field)
    local i = #userInventory[field]
    local j = 2
    if i <= 0 then
        return j
    elseif i >= 1 and i <= 3 then
        return j + 42
    elseif i >= 4 and i <= 7 then
        return j + 84
    elseif i >= 8 and i <= 11 then
        return j + 126
    elseif i >= 12 and i <= 15 then
        return j + 168
    elseif i >= 16 and i <= 19 then
        return j + 168
    end
end



function drawInventoryItemOriginal(thisX, thisY, field, item)
    if isMouseOver(thisX*scale, thisY*scale, 32*scale, 32*scale) then
        love.graphics.setColor(0.6, 0.6, 0.6,inventoryOpacity)
        setTooltip(userInventory[field][item].Item.Name,
            "+" .. userInventory[field][item].Item.Val .. " " .. userInventory[field][item].Item.Type .. "\n" ..
                userInventory[field][item].Item.Desc)
        selectedItem = userInventory[field][item].Item
    end
    love.graphics.draw(inventoryItemBackground, thisX, thisY) -- Background

    if string.sub(userInventory[field][item].Item.Type, 1, 4) == "arm_" then
        love.graphics.setColor(1,1,1,inventoryOpacity*0.3)
        love.graphics.draw(playerImg, thisX + 3, thisY + 3)
    end
    love.graphics.setColor(1, 1, 1,inventoryOpacity)
    love.graphics.draw(itemImg[userInventory[field][item].Item.ImgPath], thisX + 3, thisY + 3) -- Item
end

function drawInventory()
    loadInventory()
    love.graphics.draw(inventory, 0, toolbarY)

    love.graphics.stencil(drawInventoryStencil, "replace", 1) -- stencils inventory
    love.graphics.setStencilTest("greater", 0) -- push

    drawInventoryFields(70, toolbarY + 40 + posYInventory)
   
    love.graphics.setStencilTest() -- pop
end

function drawInventoryStencilOriginal()
    love.graphics.rectangle("fill", 70, toolbarY + 40, 180, 483)
end

function checkInventoryMousePressedOriginal()
    if selectedItem ~= nil and selectedItem.ID ~= nil and
        isMouseOver(0, toolbarY * scale, inventory:getWidth() * scale, inventory:getHeight() * scale) then

        apiGET(api.url .. "/item/" .. player.name .. "/" .. selectedItem.ID)
    end
end
