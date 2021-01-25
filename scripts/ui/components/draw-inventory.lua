--[[
    This is where all the draw functions for the inventory are held, there are a lot of them.
]]

function drawToolBarInventory(thisX, thisY)
    getInventory()
    love.graphics.setColor(unpack(characterHub.backgroundColor))
    inventory.isMouseOverInventoryItem = false

    roundRectangle("fill", thisX, 
    thisY - 97 - 23 - cerp(0, 0 + (uiY - 97 - 23), inventory.amount), 
    313,
    23 + cerp(0, 0 + (uiY - 97 - 23), inventory.amount), 
    cerp(10, 0, inventory.amount),
    {false, true, false, false} )
    thisX, thisY = thisX, thisY - 97
    love.graphics.setColor(1, 1, 1, 1)

    inventory.mouseOverButtonsAmount = 0
    for i,v in ipairs(hotbar) do
        drawInventoryItem(thisX + 9 + (43 * (i - 1)), thisY - 42, 0, v.item, getItemAmount(v.item), i)
    end

    if inventory.open then
        love.graphics.setColor(1, 1, 1, inventory.opacity)
        thisY = thisY - cerp(0, (uiY - 97), inventory.amount)

        love.graphics.setFont(inventory.headerFont)
        love.graphics.print("INVENTORY", thisX + 8, thisY + 14)

        love.graphics.stencil(drawInventoryStencil, "replace", 1) -- stencils inventory
        love.graphics.setStencilTest("greater", 0) -- push
        thisY = thisY + 50 + posYInventory
        
        for i = 1, #inventory.fields do -- Draws each inventory field
            if inventoryFieldLength[i] ~= 0 then
                drawInventoryItemField(thisX + 8, thisY, i)
                thisY = thisY + getUserInventoryFieldHeight(i)
            end
        end
        love.graphics.setStencilTest() -- pop
    end
end

function drawInventoryItem(thisX, thisY, field, item, amount, number)
    love.graphics.setFont(inventory.itemFont)
    if number then

        local height = 19
        amount = inventory.amount
        if isMouseOver(thisX * scale, thisY * scale, 34 * scale, 34 * scale) then
            love.graphics.setColor(1,
            cerp(0, 1, useItemColor[number]),
            cerp(0, 1, useItemColor[number]),
            1)
            inventory.mouseOverButtonsAmount = number
            height = inventory.images.itemBG:getHeight()
            thisY = thisY - 2
        else
            love.graphics.setColor(
                cerp(useItemColor[number], 1, amount),
                cerp(useItemColor[number], 1 - useItemColor[number], amount),
                cerp(useItemColor[number], 1 - useItemColor[number], amount),
                cerp(useItemColor[number] + (0.7 * (1 - useItemColor[number])), 1, amount))
        end

        if inventory.amount < 0.02 then 
            roundRectangle("fill", thisX, thisY, inventory.images.itemBG:getWidth(), height, 4, {true, true, false, false})
        end

        drawItemBacking(thisX, thisY)

        love.graphics.setColor(1,1,1,1)
        if item and itemImg[item.ImgPath] then
            if itemImg[item.ImgPath]:getWidth() <= 32 and itemImg[item.ImgPath]:getHeight() <= 32 then
                love.graphics.draw(itemImg[item.ImgPath],
                    thisX + 18 - (itemImg[item.ImgPath]:getWidth() / (2 - useItemColor[number])),
                    thisY + 18 - (itemImg[item.ImgPath]:getHeight() / (2 - useItemColor[number])),  0, 1 + useItemColor[number])
            else
                love.graphics.draw(itemImg[item.ImgPath], thisX + 2 - (16 * useItemColor[number]), thisY + 2 - (16 * useItemColor[number]), 0, 1 + useItemColor[number]) -- Item
            end       
        end 

        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(inventory.images.numbers[number], thisX - 3, thisY + 26)

    else
        if isMouseOver(thisX * scale, thisY * scale, 34 * scale, 34 * scale) and item then
            setItemTooltip(item)
            selectedItem = item
            inventory.isMouseOverInventoryItem = true
            love.graphics.setColor(1,0,0,1)
            thisY = thisY - 2
        end
        drawItemBacking(thisX, thisY)

        love.graphics.setColor(1,1,1,1)
        if item and itemImg[item.ImgPath] then

            if string.sub(item.Type, 1, 4) == "arm_" then
                love.graphics.draw(playerImg, thisX + 2, thisY + 2)
            end
          
            if inventory.usedItemThisTick then
                love.graphics.setColor(1,1,1,0.4)
            end

            if itemImg[item.ImgPath]:getWidth() <= 32 and itemImg[item.ImgPath]:getHeight() <= 32 then
                love.graphics.draw(itemImg[item.ImgPath],
                    thisX + 18 - (itemImg[item.ImgPath]:getWidth() / 2),
                    thisY + 18 - (itemImg[item.ImgPath]:getHeight() / 2))
            else
                love.graphics.draw(itemImg[item.ImgPath], thisX + 2, thisY + 2) -- Item
            end
        end

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
        love.graphics.setColor(1,1,1)
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
            drawInventoryItem(thisX + (43 * (i - 1)), thisY + (inventory.itemSpacing * 1), field, v.Item, v.Inventory.Amount)
        elseif i > 14 and i <= 21 then
            drawInventoryItem(thisX + (43 * (i - 1)), thisY + (inventory.itemSpacing * 2), field, v.Item, v.Inventory.Amount)
        elseif i > 21 and i <= 28 then
            drawInventoryItem(thisX + (43 * (i - 1)), thisY + (inventory.itemSpacing * 3), field, v.Item, v.Inventory.Amount)
        elseif i > 28 and i <= 35 then
            drawInventoryItem(thisX + (43 * (i - 1)), thisY + (inventory.itemSpacing * 4), field, v.Item, v.Inventory.Amount)
        else
            drawInventoryItem(thisX + (43 * (i - 1)), thisY + (inventory.itemSpacing * 5), field, v.Item, v.Inventory.Amount)
        end
    end
end

function drawItemBacking(thisX, thisY)
    roundRectangle("fill", thisX, thisY, inventory.images.itemBG:getWidth(), inventory.images.itemBG:getHeight(), 4)
end

function drawInventoryItemBackings(thisX, thisY, field)
    love.graphics.setColor(1,1,1,0.2)    
    for i,v in ipairs(userInventory) do
        inventroyItemBackings(thisX, thisY + (inventory.itemSpacing * 0), #v, 0, 7)
        inventroyItemBackings(thisX, thisY + (inventory.itemSpacing * 1), #v, 7, 14)
        inventroyItemBackings(thisX, thisY + (inventory.itemSpacing * 2), #v, 14, 21)
        inventroyItemBackings(thisX, thisY + (inventory.itemSpacing * 3), #v, 21, 28)
        inventroyItemBackings(thisX, thisY + (inventory.itemSpacing * 4), #v, 28, 35)
        inventroyItemBackings(thisX, thisY + (inventory.itemSpacing * 5), #v, 35, 42)
    end
    love.graphics.setColor(1,1,1,1)    
end

function inventroyItemBackings(thisX, thisY, value, min, max)
    if value > min and value <= max then
        for i = 1, 7 do 
            -- love.graphics.draw(inventory.images.itemBG, thisX + (43 * (i - 1)), thisY)
            drawItemBacking(thisX + (43 * (i - 1)), thisY)
        end
    end
end

function drawInventoryStencil()
    love.graphics.rectangle("fill", (0), (0 + 50), 313, (uiY - 97 - 50 - 50))
end