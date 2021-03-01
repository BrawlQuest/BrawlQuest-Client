function initHotbar()
    hotbar = {}
    for i = 1, 7 do
        hotbar[#hotbar + 1] = {item = null, amount = 0}
        useItemColor[#useItemColor + 1] = 0
    end
    hotbarChanged = false
    hotbarChangeCount = 0
end

function updateHotbar(dt)
    if useItemColorChanged then
        local colorCount = 0
        for i, v in ipairs(useItemColor) do
            if v > 0 then
                useItemColor[i] = v - 2 * dt
            else
                useItemColor[i] = 0
            end
            colorCount = colorCount + v
        end
        if colorCount == 0 then
            useItemColorChanged = false
        end
    end
end

function drawHotbar(thisX, thisY)
    love.graphics.setColor(1,1,1)
    for i,v in ipairs(hotbar) do
        drawInventoryItem(thisX + 9 + (43 * (i - 1)), thisY - 42, 0, v.item, v.amount, i)
    end
end

function checkHotbarKeyPressed(key)
    for i,v in ipairs(hotbar) do
        if key == tostring(i) or (i == 7 and key == "space") then
            if inventory.isMouseOverInventoryItem == true then
                hotbar[i].item = selectedItem
                hotbar[i].amount = selectedItemAmount
                writeSettings()
                hotbarChanged = true
                break
            else
                if v.item ~= nil and v.item.ID ~= nil and not isItemUnusable(v.item) and not usedItemThisTick then
                    useHotbarItem(i,v)
                    hotbarChanged = true
                    break
                end
            end
        end
    end
end

debugItems = false

function checkHotbarMousePressed(button)
    if inventory.mouseOverButtonsAmount > 0 then
        for i,v in ipairs(hotbar) do
            if i == inventory.mouseOverButtonsAmount and v.item ~= nil and v.item.ID ~= nil and  not usedItemThisTick  then
                if button == 1  then
                    useHotbarItem(i,v)
                    hotbarChanged = true
                    break
                elseif button == 2 then
                    hotbar[i] = {item = null, amount = 0}
                    hotbarChanged = true
                    writeSettings()
                    break
                end
                hotbarChanged = true
            end
        end
    end
end

function useHotbarItem(i,v)
    useItemColor[i] = 1
    useItemColorChanged = true
    apiGET("/item/" .. player.name .. "/" .. v.item.ID)
    usedItemThisTick = true
    writeSettings()
end

function checkHotbarChange()
    for j, k in ipairs(hotbar) do
        if k.item then
            local found = false
            for field = 1, #inventory.fields do
                for i,v in ipairs(userInventory[field]) do
                    if v.Item.ID and k.item.ID == v.Item.ID then
                        hotbar[j].item = v.Item
                        local amount = getItemAmount(v.Item)
                        hotbar[j].amount = amount
                        if amount < 1 then hotbar[j] = {item = null, amount = 0} end
                        found = true
                        break
                    end
                end
                if found then break end
            end
        end
    end
    writeSettings()
end