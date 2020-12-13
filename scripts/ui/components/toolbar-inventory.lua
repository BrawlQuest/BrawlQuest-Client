function initToolBarInventory()
    inventory = {
        open = false,
        amount = 0,
        items = {},
        fields = {"weapons", "spells", "armour", "mounts", "other"},
        fieldLength = {0, 0, 0, 0, 0},
        font = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 12),
        images = {
            itemBG = love.graphics.newImage("assets/ui/hud/character-inventory/item-bg.png"),
            numbers = {
                love.graphics.newImage("assets/ui/hud/character-inventory/01.png"),
                love.graphics.newImage("assets/ui/hud/character-inventory/02.png"),
                love.graphics.newImage("assets/ui/hud/character-inventory/03.png"),
                love.graphics.newImage("assets/ui/hud/character-inventory/04.png"),
                love.graphics.newImage("assets/ui/hud/character-inventory/05.png"),
                love.graphics.newImage("assets/ui/hud/character-inventory/06.png"),
                love.graphics.newImage("assets/ui/hud/character-inventory/07.png"),
                love.graphics.newImage("assets/ui/hud/character-inventory/08.png"),
                love.graphics.newImage("assets/ui/hud/character-inventory/09.png"),
                love.graphics.newImage("assets/ui/hud/character-inventory/10.png"),
            },
        },
    }
end

function getInventory()
    
    userInventory = {}
    userInventory[1] = {}
    userInventory[2] = {}
    userInventory[3] = {}
    userInventory[4] = {}
    userInventory[5] = {}
    inventoryFieldLength = {0, 0, 0, 0, 0}

    for i, v in ipairs(inventoryAlpha) do
        local t = 5

        if v.Item.Type == "wep" then
            t = 1
        elseif v.Item.Type == "spell" then
            t = 2
        elseif string.sub(v.Item.Type, 1, 4) == "arm_" or v.Item.Type == "shield" then
            t = 3
        elseif v.Item.Type == "mount" then
            t = 4
        end
        inventoryFieldLength[t] = inventoryFieldLength[t] + 1
        if not itemImg[v.Item.ImgPath] then
            if love.filesystem.getInfo(v.Item.ImgPath) then
                itemImg[v.Item.ImgPath] = love.graphics.newImage(v.Item.ImgPath)
            else
                itemImg[v.Item.ImgPath] = love.graphics.newImage("assets/error.png")
            end
        end
        userInventory[t][#userInventory[t] + 1] = v 
        -- print(inventoryFieldLength[1] .. " " .. inventoryFieldLength[2] .. " " .. inventoryFieldLength[3] .. " " .. inventoryFieldLength[4] .. " " .. inventoryFieldLength[5])
    end
   
end

function updateToolBarInventory(dt)
    if isMouseOver(0, 0, 313 * scale, (uiY - 97) * scale) then
        inventory.open = true
        inventory.amount = inventory.amount + 4 * dt
        if inventory.amount > 1 then inventory.amount = 1 end
    else
        inventory.open = false
        inventory.amount = inventory.amount - 4 * dt
        if inventory.amount < 0 then inventory.amount = 0 end
    end
    -- print(inventory.amount)
end

function drawToolBarInventory(thisX, thisY)
    love.graphics.setColor(unpack(characterHub.backgroundColor))
    love.graphics.setFont(inventory.font)
    love.graphics.rectangle("fill", thisX + 313, thisY - 97, -313, 0 - cerp(23, 23 + (uiY - 97 - 23), inventory.amount))
    thisX, thisY = thisX, thisY - 97
    love.graphics.setColor(1,1,1,1)
    for i = 0, 6 do 
        drawInventoryItem(thisX + 9 + (43 * i), thisY - 42, 0, toolbarItems[i+1], i + 1)
    end

    if inventory.open then 
        getInventory()
        love.graphics.setColor(1,1,1,cerp(0, 1, inventory.amount))
        thisY = thisY - cerp(0, (uiY - 23 - 97), inventory.amount)
        for i = 1, #inventory.fields do -- Draws each inventory field
            if inventoryFieldLength[i] ~= 0 then
                drawInventoryItemField(thisX + 8, thisY + 0, i)
                thisY = thisY + getUserInventoryFieldHeight(i) + 20
            end
        end
    end
end

function drawInventoryItem(thisX, thisY, field, item, number)
    love.graphics.draw(inventory.images.itemBG, thisX, thisY)
    
    -- if isMouseOver(thisX*scale, thisY*scale, 34*scale, 34*scale) then
    --     love.graphics.setColor(0.6, 0.6, 0.6,inventoryOpacity)
    --     setTooltip(userInventory[field][item].Item.Name,
    --         "+" .. userInventory[field][item].Item.Val .. " " .. userInventory[field][item].Item.Type .. "\n" ..
    --             userInventory[field][item].Item.Desc)
    --     selectedItem = userInventory[field][item].Item
    -- end

    if number ~= null then  
        if item ~= null then love.graphics.draw(item, top_left, thisX + 2, thisY + 2) end
        love.graphics.draw(inventory.images.numbers[number], thisX - 3, thisY + 26)
    else
        if string.sub(userInventory[field][item].Item.Type, 1, 4) == "arm_" then
            love.graphics.setColor(1,1,1,inventoryOpacity*0.3)
            love.graphics.draw(playerImg, thisX + 2, thisY + 2)
        end
        love.graphics.draw(itemImg[userInventory[field][item].Item.ImgPath], thisX + 2, thisY + 2) -- Item
    end

end

function drawInventoryItemField(thisX, thisY, field)
    love.graphics.printf(inventory.fields[field], thisX + 9, thisY, 483)
    thisY = thisY + 20
    for i = 0, #userInventory[field] - 1 do
        if i <= 3 then
            drawInventoryItem(thisX + 9 + (43 * i), thisY + 0, field, i + 1)
            --drawInventoryItem(thisX + 9 + (43 * i), thisY + 0, field,  + 1)
        elseif i >= 4 and i <= 7 then
            drawInventoryItem(thisX + 9 + (43 * i), thisY + 42, field, i + 1)
        elseif i >= 8 and i <= 11 then
            drawInventoryItem(thisX + 9 + (43 * i), thisY + 84, field, i + 1)
        elseif i >= 12 and i <= 15 then
            drawInventoryItem(thisX + 9 + (43 * i), thisY + 126, field, i + 1)
        elseif i >= 16 and i <= 19 then
            drawInventoryItem(thisX + 9 + (43 * i), thisY + 168, field, i + 1)
        end
    end
end

function getUserInventoryFieldHeight(field)
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

function getFullUserInventoryFieldHeight()
    local j = 0
    for i = 1, #inventory.fields do
        if inventoryFieldLength[i] ~= 0 then
            if inventoryFieldLength[i] ~= 0 then
                j = j + getUserInventoryFieldHeight(i) + 18 + 20
            end
        end
    end
    return j
end
