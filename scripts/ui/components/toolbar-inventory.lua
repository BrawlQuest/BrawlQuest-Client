function initToolBarInventory()
    inventory = {
        open = false,
        amount = 0,
        opacity = 0,
        titleSpacing = 25,
        itemSpacing = 42,
        items = {},
        fields = {"weapons", "spells", "armour", "reagent", "mounts", "buddies", "other",},
        fieldLength = {0, 0, 0, 0, 0},
        font = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 12),
        headerFont = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 26),
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
    userInventory[6] = {}
    userInventory[7] = {}
    inventoryFieldLength = {0, 0, 0, 0, 0, 0, 0,}

    for i, v in ipairs(inventoryAlpha) do
        local t = 7

        if v.Item.Type == "wep" then
            t = 1
        elseif v.Item.Type == "spell" then
            t = 2
        elseif string.sub(v.Item.Type, 1, 4) == "arm_" or v.Item.Type == "shield" then
            t = 3
        elseif v.Item.Type == "reagent" then
            t = 4
        elseif v.Item.Type == "mount" then
            t = 5
        elseif v.Item.Type == "buddy" then
            t = 6
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

function updateToolBarInventory(dt)
    if isMouseOver(0, 0, 313 * scale, (uiY - 97) * scale) then
        inventory.open = true
        inventory.amount = inventory.amount + 4 * dt
        if inventory.amount > 1 then inventory.amount = 1 end

        if getFullUserInventoryFieldHeight() * scale > (uiY - 97 - 50 - 50) * scale then
            posYInventory = posYInventory + velyInventory * dt
            if posYInventory > 0 then
                posYInventory = 0
            elseif posYInventory < 0 - getFullUserInventoryFieldHeight() + (uiY - 97 - 50 - 50) then
                posYInventory = 0 - getFullUserInventoryFieldHeight() + (uiY - 97 - 50 - 50)
            end
        else posYInventory = 0
        end
    else
        inventory.open = false
        inventory.amount = inventory.amount - 4 * dt
        if inventory.amount < 0 then inventory.amount = 0 end
    end
    inventory.opacity = cerp(0, 1, inventory.amount)
end

function drawToolBarInventory(thisX, thisY)
    love.graphics.setColor(unpack(characterHub.backgroundColor))
  
    love.graphics.rectangle("fill", thisX, thisY - 97, 313, 0 - cerp(23, 23 + (uiY - 97 - 23), inventory.amount))
    thisX, thisY = thisX, thisY - 97
    love.graphics.setColor(1,1,1,1)
    for i = 0, 6 do 
        drawInventoryItem(thisX + 9 + (43 * i), thisY - 42, 0, toolbarItems[i+1], i + 1)
    end

    if inventory.open then 
        getInventory()
        love.graphics.setColor(1,1,1,inventory.opacity)
        thisY = thisY - cerp(0, (uiY - 97), inventory.amount)

        love.graphics.setFont(inventory.headerFont)
        love.graphics.print("Inventory", thisX + 8, thisY + 14)
        love.graphics.setFont(inventory.font)

        love.graphics.stencil(drawInventoryStencil, "replace", 1) -- stencils inventory
        love.graphics.setStencilTest("greater", 0) -- push
            thisY = thisY + 50 + posYInventory
            for i = 1, #inventory.fields do -- Draws each inventory field
                if inventoryFieldLength[i] ~= 0 then
                    drawInventoryItemField(thisX + 8, thisY, i)
                    -- love.graphics.setColor(1,1,1, 0.25 * inventory.opacity)
                    -- love.graphics.rectangle("fill", thisX, thisY, 313, getUserInventoryFieldHeight(i))
                    -- love.graphics.setColor(1,1,1, 1 * inventory.opacity)
                    thisY = thisY + getUserInventoryFieldHeight(i)
                end
            end
        love.graphics.setStencilTest() -- pop
    end
    
end

function drawInventoryItem(thisX, thisY, field, item, number)
    if number ~= null then  
        love.graphics.draw(inventory.images.itemBG, thisX, thisY)
        if item ~= null then love.graphics.draw(item, top_left, thisX + 2, thisY + 2) end
        love.graphics.draw(inventory.images.numbers[number], thisX - 3, thisY + 26)
    else
        if isMouseOver(thisX*scale, thisY*scale, 34*scale, 34*scale) and isMouseOver((0) * scale, (0 + 50) * scale, 313 * scale, (uiY - 97 - 50 - 50) * scale) then
            love.graphics.setColor(0.6, 0.6, 0.6,inventory.opacity)
            setTooltip(userInventory[field][item].Item.Name,
                "+" .. userInventory[field][item].Item.Val .. " " .. userInventory[field][item].Item.Type .. "\n" ..
                    userInventory[field][item].Item.Desc)
            selectedItem = userInventory[field][item].Item
        end
        love.graphics.draw(inventory.images.itemBG, thisX, thisY)
        if string.sub(userInventory[field][item].Item.Type, 1, 4) == "arm_" then
            love.graphics.setColor(1,1,1,inventory.opacity*0.5)
            love.graphics.draw(playerImg, thisX + 2, thisY + 2)
            love.graphics.setColor(1,1,1,inventory.opacity)
        end
        love.graphics.setColor(1,1,1,inventory.opacity)
        if itemImg[userInventory[field][item].Item.ImgPath]:getWidth() <= 32 and itemImg[userInventory[field][item].Item.ImgPath]:getHeight() <= 32 then
            love.graphics.draw(itemImg[userInventory[field][item].Item.ImgPath], thisX + 18 - (itemImg[userInventory[field][item].Item.ImgPath]:getWidth() / 2),
            thisY + 18 - (itemImg[userInventory[field][item].Item.ImgPath]:getHeight() / 2))
        else
            love.graphics.draw(itemImg[userInventory[field][item].Item.ImgPath], thisX + 2, thisY + 2) -- Item
        end
        
    end
end

function drawInventoryItemField(thisX, thisY, field)
    love.graphics.printf(inventory.fields[field], thisX + 2, thisY + 2, 483)
    thisY = thisY + inventory.titleSpacing
    local itemWidth = 7
    for i = 1, #userInventory[field] do
        if i <= 7 then
            drawInventoryItem(thisX + (43 * (i - 1)), thisY + (inventory.itemSpacing * 0), field, i)
        elseif i > 7 and i <= 14 then
            drawInventoryItem(thisX + (43 * (i - 1)), thisY + (inventory.itemSpacing * 1), field, i)
        elseif i > 14 and i <= 21 then
            drawInventoryItem(thisX + (43 * (i - 1)), thisY + (inventory.itemSpacing * 2), field, i)
        elseif i > 21 and i <= 28 then
            drawInventoryItem(thisX + (43 * (i - 1)), thisY + (inventory.itemSpacing * 3), field, i)
        elseif i > 28 and i <= 35 then
            drawInventoryItem(thisX + (43 * (i - 1)), thisY + (inventory.itemSpacing * 4), field, i)
        else
            drawInventoryItem(thisX + (43 * (i - 1)), thisY + (inventory.itemSpacing * 5), field, i)
        end
    end
end

function getUserInventoryFieldHeight(field)
    local i = #userInventory[field]
    if i <= 0 then
        return (inventory.itemSpacing * 0) + inventory.titleSpacing
    elseif i > 0 and i <= 7 then
        return (inventory.itemSpacing * 1) + inventory.titleSpacing
    elseif i > 7 and i <= 14 then
        return (inventory.itemSpacing * 2) + inventory.titleSpacing
    elseif i > 14 and i <= 21 then
        return (inventory.itemSpacing * 3) + inventory.titleSpacing
    elseif i > 21 and i <= 28 then
        return (inventory.itemSpacing * 4) + inventory.titleSpacing
    elseif i > 28 and i <= 35 then
        return (inventory.itemSpacing * 5) + inventory.titleSpacing
    end
end

function getFullUserInventoryFieldHeight()
    local j = 0
    for i = 1, #inventory.fields do
        if inventoryFieldLength[i] ~= 0 then
            j = j + getUserInventoryFieldHeight(i)
        end
    end
    return j
end

function checkInventoryMousePressed()
    if selectedItem ~= nil and selectedItem.ID ~= nil and
        isMouseOver((0) * scale, (0 + 50) * scale, 313 * scale, (uiY - 97 - 50 - 50) * scale) then
        c, h = http.request {
            url = api.url .. "/item/" .. player.name .. "/" .. selectedItem.ID,
            headers = {
                ["token"] = token
            }
        }
    end
end

function drawInventoryStencil()
    love.graphics.rectangle("fill", (0), (0 + 50), 313, (uiY - 97 - 50 - 50))
end 