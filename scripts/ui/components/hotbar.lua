sortedHotbar = {nil, nil, nil, nil, nil, nil, nil}

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
        if colorCount == 0 then useItemColorChanged = false end
    end
end

function drawHotbar(thisX, thisY)

    for i = 1, 7 do
        v = sortedHotbar[i]
        if v and v.inventoryitem then
            drawInventoryItem(thisX + 9 + (43 * (i - 1)), thisY - 42,
                              v.inventoryitem.item,
                              v.inventoryitem.inventory.amount, i,
                              v.inventoryitem.inventory.id)
        else
            drawInventoryItem(thisX + 9 + (43 * (i - 1)), thisY - 42, nil, 0, i,
                              nil)
        end
    end
end

function checkHotbarKeyPressed(key)

    -- for i, v in ipairs(e/) do
    --     if key == tostring(i) or (i == 7 and key == "space") then

    --         if v.item ~= nil and v.item.id ~= nil and not isItemUnusable(v.item) and
    --             not isSpellUnusable(v.item) then
    --             useHotbarItem(i, v)
    --             hotbarChanged = true
    --             break
    --         end
    --     end
    -- end

    for i = 1, 7 do
        if sortedHotbar[i] then
            if key == tostring(i) then
                useHotbarItem(i, sortedHotbar[i])
            end
        else
            --     drawInventoryItem(thisX + 9 + (43 * (i - 1)), thisY - 42, nil, 0)
        end
    end
end

debugItems = false

function checkHotbarMousePressed(button)

    -- local i, v = inventory.mouseOverButtonsAmount,
    --              copy(hotbar[inventory.mouseOverButtonsAmount])
    -- if v.item and v.item.id and not usedItemThisTick then
    --     if button == 1 then
    --         useHotbarItem(i, v)
    --         hotbarChanged = true
    --     elseif button == 2 then
    --         hotbar[i] = {item = null, amount = 0}
    --         hotbarChanged = true
    --         writeSettings()
    --     end
    --     hotbarChanged = true
    -- end

end

function useHotbarItem(i, v)
   
        useItemColor[i] = 1
        useItemColorChanged = true
        apiGET("/item/" .. player.name .. "/" .. v.inventoryitem.item.id)
        playSoundIfExists("assets/sfx/items/" .. v.inventoryitem.item.name ..
                              ".ogg", true)
        usedItemThisTick = true
        writeSettings()
  

end

function checkHotbarChange()
    -- for j, k in ipairs(hotbar) do
    --     if k.item then
    --         local found = false
    --         for field = 1, #inventory.fields do
    --             for i, v in ipairs(userInventory[field]) do
    --                 if v.item.id and k.item.id == v.item.id then
    --                     hotbar[j].item = v.item
    --                     local amount = getItemAmount(v.item)
    --                     hotbar[j].amount = amount
    --                     -- if amount < 1 then hotbar[j] = {item = null, amount = 0} end
    --                     found = true
    --                     break
    --                 end
    --             end
    --             if found then break end
    --         end
    --         -- if me.lvl and not found then hotbar[j] = {item = null, amount = 0} end
    --     end
    -- end
    -- writeSettings()
end
