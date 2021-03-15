--[[
    This is where all the draw functions for the inventory are held, there are a lot of them.
]]

function drawToolBarInventory(thisX, thisY)
    -- getInventory()
    love.graphics.setColor(characterHub.flashyCERP,0,0,0.7)
    inventory.isMouseOverInventoryItem = false

    roundRectangle("fill", thisX, 
    thisY - 97 - 23 - cerp(0, 0 + (uiY - 97 - 23), inventory.amount), 
    313,
    23 + cerp(0, 0 + (uiY - 97 - 23), inventory.amount), 
    cerp(10, 0, inventory.amount),
    {false, true, false, false} )
    thisX, thisY = thisX, thisY - 97
    love.graphics.setColor(1, 1, 1, 1)

    local elseY = thisY
    if inventory.open then
        -- getInventory()
        love.graphics.setColor(1, 1, 1, inventory.opacity)
        elseY = elseY - cerp(0, (uiY - 97), inventory.amount)

        love.graphics.setFont(inventory.headerFont)
        love.graphics.print("INVENTORY", thisX + 8, elseY + 14)

        elseY = elseY + 50 + posYInventory
        for i = 1, #inventory.fields do -- Draws each inventory field
            if inventoryFieldLength[i] ~= 0 then
                drawInventoryItemField(thisX + 8, elseY, i)
                elseY = elseY + getUserInventoryFieldHeight(i)
            end
        end
    end
    inventory.mouseOverButtonsAmount = 0
    drawHotbar(thisX, thisY)
end

function drawInventoryItem(thisX, thisY, field, item, amount, number)
    love.graphics.setFont(inventory.itemFont)
    if number then
        local height = 19
        local isMouse = isMouseOver(thisX * scale, thisY * scale, 34 * scale, 34 * scale)
        -- amount = inventory.amount

        if isMouse then inventory.mouseOverButtonsAmount = number end

        if item and isItemUnusable(item) then
            love.graphics.setColor(0.2, 0.2, 0.2)
            if isMouse and item then
                setItemTooltip(item)
            end
        elseif item and isMouse then
            setItemTooltip(item)
            love.graphics.setColor(1,
            cerp(0, 1, useItemColor[number]),
            cerp(0, 1, useItemColor[number]),
            1)
            height = inventory.images.itemBG:getHeight()
            thisY = thisY - 2
        else
            love.graphics.setColor(
                cerp(useItemColor[number], 1, inventory.amount),
                cerp(useItemColor[number], 1 - useItemColor[number], inventory.amount),
                cerp(useItemColor[number], 1 - useItemColor[number], inventory.amount),
                cerp(useItemColor[number] + (0.7 * (1 - useItemColor[number])), 1, inventory.amount))
        end
        if inventory.amount < 0.02 then
            roundRectangle("fill", thisX, thisY, inventory.images.itemBG:getWidth(), height, 4, {true, true, false, false})
        end

        drawItemBacking(thisX, thisY)
        love.graphics.setColor(1,1,1,1)
        if item then drawItem(thisX,thisY,item,number) end

        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(inventory.images.numbers[number], thisX - 3, thisY + 26)

        if amount and amount > 1 then
            if amount <= 9 then
                inventory.imageNumber = 1
            elseif amount > 9 and amount <= 99 then
                inventory.imageNumber = 2
            elseif amount > 99 and amount <= 999 then
                inventory.imageNumber = 3
            else
                inventory.imageNumber = 4
            end
            thisX, thisY = thisX + 39 - inventory.images.numberBg[inventory.imageNumber]:getWidth(),
                thisY + 39 - inventory.images.numberBg[inventory.imageNumber]:getHeight()
            love.graphics.draw(inventory.images.numberBg[inventory.imageNumber], thisX, thisY)
            love.graphics.setColor(0, 0, 0)
            love.graphics.print(amount, thisX + 5, thisY + 4)
        end

    else

        local isMouse = isMouseOver(thisX * scale, thisY * scale, 34 * scale, 34 * scale)

        if isItemUnusable(item) then
            if isMouse and item then
                selectedItem = item
                selectedItemAmount = amount
                setItemTooltip(item)
            end
            love.graphics.setColor(0.2, 0.2, 0.2)
        elseif isMouse and item then
            setItemTooltip(item)
            selectedItem = item
            selectedItemAmount = amount
            inventory.isMouseOverInventoryItem = true
            love.graphics.setColor(1,0,0,1)
            thisY = thisY - 2
        end
        drawItemBacking(thisX, thisY)

        love.graphics.setColor(1,1,1,1)
        if item then drawItem(thisX,thisY,item) end

        drawItemAmount(thisX, thisY, amount)
        love.graphics.setColor(1,1,1)
    end
end

function drawItem(x,y,item,number)
    if number then drawItemImageHotbar(x,y,item,number) else drawItemImage(x,y,item) end
    if item.Enchantment ~= "None" then
        love.graphics.push()
            love.graphics.stencil(function() 
                love.graphics.setShader(alphaShader)
                if number then drawItemImageHotbar(x,y,item,number) else drawItemImage(x,y,item) end
                love.graphics.setShader()
            end)
            drawEnchantment(x, y)
        love.graphics.pop()
        love.graphics.setColor(1,1,1)
    end
end

function drawItemImage(x,y,item)
    itemImg[item.ImgPath] = getImgIfNotExist(item.ImgPath)
    if string.sub(item.Type, 1, 4) == "arm_" then
        love.graphics.setColor(1,1,1,0.5)
        love.graphics.draw(playerImg, x + 2, y + 2)
        love.graphics.setColor(1,1,1,1)
    end
  
    if inventory.usedItemThisTick then
        love.graphics.setColor(1,1,1,0.4)
    end

    if itemImg[item.ImgPath]:getWidth() <= 32 and itemImg[item.ImgPath]:getHeight() <= 32 then
        love.graphics.draw(itemImg[item.ImgPath],
            x + 18 - (itemImg[item.ImgPath]:getWidth() / 2),
            y + 18 - (itemImg[item.ImgPath]:getHeight() / 2))
    else
        love.graphics.draw(itemImg[item.ImgPath], x + 2, y + 2) -- Item
    end
end

function drawItemImageHotbar(x,y,item,number)
    itemImg[item.ImgPath] = getImgIfNotExist(item.ImgPath)
    if itemImg[item.ImgPath]:getWidth() <= 32 and itemImg[item.ImgPath]:getHeight() <= 32 then
        love.graphics.draw(itemImg[item.ImgPath],
            x + 18 - (itemImg[item.ImgPath]:getWidth() / (2 - useItemColor[number])),
            y + 18 - (itemImg[item.ImgPath]:getHeight() / (2 - useItemColor[number])),  0, 1 + useItemColor[number])
    else
        love.graphics.draw(itemImg[item.ImgPath], x + 2 - (16 * useItemColor[number]), y + 2 - (16 * useItemColor[number]), 0, 1 + useItemColor[number]) -- Item
    end
end

function drawInventoryItemField(thisX, thisY, field)
    love.graphics.setFont(inventory.font)
    love.graphics.printf(inventory.fields[field], thisX + 2, thisY + 4, 483)
    thisY = thisY + inventory.titleSpacing

    for i,v in ipairs(userInventory[field]) do  
        if i <= 7 then
            drawInventoryItem(thisX + (43 * (i - 1)), thisY + (inventory.itemSpacing * 0), field, v.Item, v.Inventory.Amount)
        elseif i > 7 and i <= 14 then
            drawInventoryItem(thisX + (43 * (i - 8)), thisY + (inventory.itemSpacing * 1), field, v.Item, v.Inventory.Amount)
        elseif i > 14 and i <= 21 then
            drawInventoryItem(thisX + (43 * (i - 15)), thisY + (inventory.itemSpacing * 2), field, v.Item, v.Inventory.Amount)
        elseif i > 21 and i <= 28 then
            drawInventoryItem(thisX + (43 * (i - 22)), thisY + (inventory.itemSpacing * 3), field, v.Item, v.Inventory.Amount)
        elseif i > 28 and i <= 35 then
            drawInventoryItem(thisX + (43 * (i - 29)), thisY + (inventory.itemSpacing * 4), field, v.Item, v.Inventory.Amount)
        else
            drawInventoryItem(thisX + (43 * (i - 36)), thisY + (inventory.itemSpacing * 5), field, v.Item, v.Inventory.Amount)
        end
    end
end

function drawItemBacking(thisX, thisY)
    roundRectangle("fill", thisX, thisY, inventory.images.itemBG:getWidth(), inventory.images.itemBG:getHeight(), 4)
end

function drawItemAmount(x,y,amount, alpha)
    alpha = alpha or 1
    if amount and amount > 1 then
        if amount <= 9 then
            inventory.imageNumber = 1
        elseif amount > 9 and amount <= 99 then
            inventory.imageNumber = 2
        elseif amount > 99 and amount <= 999 then
            inventory.imageNumber = 3
        else
            inventory.imageNumber = 4
        end
        x, y = x + 39 - inventory.images.numberBg[inventory.imageNumber]:getWidth(),
            y + 39 - inventory.images.numberBg[inventory.imageNumber]:getHeight()
        love.graphics.draw(inventory.images.numberBg[inventory.imageNumber], x, y)
        love.graphics.setColor(0, 0, 0, alpha)
        love.graphics.print(amount, inventory.itemFont, x + 5, y + 4)
    end
end