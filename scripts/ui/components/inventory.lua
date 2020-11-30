selectedItem = {}

function loadInventory()

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
    end
end

function drawInventoryFeilds(thisX, y)
    love.graphics.setFont(inventorySubHeaderFont)
    thisY = y
    for i = 0, tableLength(inventoryFields) - 1 do -- Draws each inventory field
        if inventoryFieldLength[i+1] ~= 0 then
            inventoryItemField(thisX + 8, thisY + 0, i + 1)
            thisY = thisY + getUserInventoryFieldHeight(i + 1)
        end
    end
end

function inventoryItemField(thisX, y, field)
    love.graphics.printf(inventoryFields[field], thisX, thisY, 483)
    thisY = thisY + 18
    for i = 0, tableLength(userInventory[field]) - 1 do
        if i <= 3 then
            drawInventoryItem(thisX + ((i - 0) * 42), thisY + 0, field, i + 1)
            userInventoryFieldHeight[field] = 42 + 15
        elseif i >= 4 and i <= 7 then
            drawInventoryItem(thisX + ((i - 4) * 42), thisY + 42, field, i + 1)
        elseif i >= 8 and i <= 11 then
            drawInventoryItem(thisX + ((i - 8) * 42), thisY + 84, field, i + 1)
        elseif i >= 12 and i <= 15 then
            drawInventoryItem(thisX + ((i - 12) * 42), thisY + 126, field, i + 1)
        elseif i >= 16 and i <= 19 then
            drawInventoryItem(thisX + ((i - 16) * 42), thisY + 168, field, i + 1)
        end
    end
end

function getUserInventoryFieldHeight(field)
    local i = tableLength(userInventory[field]) - 1
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
    for i = 1, tableLength(userInventory) do
        j = j + getUserInventoryFieldHeight(i) + 18
    end
    return j
end

function drawInventoryItem(thisX, thisY, field, item)
    if isMouseOver(thisX*scale, thisY*scale, 32*scale, 32*scale) then
        love.graphics.setColor(0.6, 0.6, 0.6)
        setTooltip(userInventory[field][item].Item.Name,
            "+" .. userInventory[field][item].Item.Val .. " " .. userInventory[field][item].Item.Type .. "\n" ..
                userInventory[field][item].Item.Desc)
        selectedItem = userInventory[field][item].Item
    end
    love.graphics.draw(inventoryItemBgnd, thisX, thisY) -- Background
    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(itemImg[userInventory[field][item].Item.ImgPath], thisX + 3, thisY + 3) -- Item
end

function drawInventory()
    loadInventory()
    love.graphics.draw(inventory, 0, toolbary)

    love.graphics.stencil(drawInventoryStencil, "replace", 1) -- stencils inventory
    love.graphics.setStencilTest("greater", 0) -- push

    drawInventoryFeilds(70, toolbary + 40 + posyInventory)
   
    love.graphics.setStencilTest() -- pop
end

function drawInventoryStencil()
    love.graphics.rectangle("fill", 70, toolbary + 40, 180, 483)
end

function drawChatStencil()
    love.graphics.rectangle("fill", 70, toolbary + 40, 180, 483)
end

function checkInventoryMousePressed()
    if selectedItem ~= nil and selectedItem.ID ~= nil and
        isMouseOver(0, toolbary * scale, inventory:getWidth() * scale, inventory:getHeight() * scale) then
        c, h = http.request {
            url = api.url .. "/item/" .. player.name .. "/" .. selectedItem.ID,
            headers = {
                ["token"] = token
            }
        }
    end
end
