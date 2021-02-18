function initHotbar()
    hotbar = {}
    for i = 1, 7 do
        hotbar[#hotbar + 1] = {item = null,}
        useItemColor[#useItemColor + 1] = 0
    end

    -- print(#hotbar)
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
        -- print(i)
        drawInventoryItem(thisX + 9 + (43 * (i - 1)), thisY - 42, 0, v.item, 0, i)
    end
end

function checkHotbarKeyPressed(key)
    for i,v in ipairs(hotbar) do
        if key == tostring(i) or (i == 7 and key == "space") then
            if inventory.isMouseOverInventoryItem == true then
                hotbar[i].item = selectedItem
                break
            else
                if v.item ~= nil and v.item.ID ~= nil and not isItemUnusable(v.item) and not usedItemThisTick then
                    -- print(json:encode_pretty(v.item))
                    useHotbarItem(i,v)
                    break
                end
            end
        end
    end

    if key == "[" then
        -- success,msg = love.filesystem.write("userInventory.txt", json:encode_pretty(userInventory))
        -- print(json:encode_pretty(hotbar))
        debugItems = not debugItems
    end
end

debugItems = false

function checkHotbarMousePressed(button)
    if inventory.mouseOverButtonsAmount > 0 then
        for i,v in ipairs(hotbar) do
            if i == inventory.mouseOverButtonsAmount and v.item ~= nil and v.item.ID ~= nil and  not usedItemThisTick  then
                if button == 1  then
                    useHotbarItem(i,v)
                    break
                elseif button == 2 then
                    hotbar[i] = {item = null,}
                    break
                end
            end
        end
    end
end

function useHotbarItem(i,v)
    useItemColor[i] = 1
    useItemColorChanged = true
    apiGET("/item/" .. player.name .. "/" .. v.item.ID)
    usedItemThisTick = true
    -- checkHotbarChange()
end

function checkHotbarChange()
    for j, k in ipairs(hotbar) do
        if k.item then
            local found = false
            for field = 1, #inventory.fields do
                for i,v in ipairs(userInventory[field]) do
                    -- print(json:encode_pretty(v))
                    if v.Item.ID and k.item.ID == v.Item.ID then
                        print("BEFORE: " .. json:encode_pretty(hotbar[j].item))
                        print("I DID AN UPDATE")
                        hotbar[j].item = v.Item
                        print("AFTER: " .. json:encode_pretty(hotbar[j].item))
                        found = true
                        if found then break end
                    end
                end
                if found then break end
            end
        end
    end

    -- for i,v in ipairs(hotbar) do
    --     print(json:encode_pretty(v.item))
    -- end
end