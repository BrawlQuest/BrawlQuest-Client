function initToolBarInventory()
    -- toolbar
    circleFont = love.graphics.newFont("assets/ui/fonts/rainyhearts.ttf", 16)
    smallTextFont = love.graphics.newFont("assets/ui/fonts/rainyhearts.ttf",12)
    a0sword = love.graphics.newImage("assets/player/gear/a0/sword.png")
    toolbarY = 0
    toolbarItems = {}
    toolbarTitles = {1,2,3,4,5,6,7,8,9,0}

    

    toolbarBg = love.graphics.newImage("assets/ui/hud/toolbar/toolbar-backing.png")
    toolbarItem = love.graphics.newImage("assets/ui/hud/toolbar/toolbarItem.png")
    top_left = love.graphics.newQuad(0, 0, 34, 34, a0sword:getDimensions())
    -- inventory = love.graphics.newImage("assets/ui/hud/inventory/inventoryBg.png")

    -- Inventory
    inventorySubHeaderFont = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 10)
    inventoryItemBackground = love.graphics.newImage("assets/ui/hud/inventory/inventoryItem.png")

    userInventory = {}
    userInventory[1] = {}
    userInventory[2] = {}
    userInventory[3] = {}
    userInventory[4] = {}
    userInventory[5] = {}
    userInventory[6] = {}
    userInventory[7] = {}
    userInventory[8] = {}
    inventoryFieldLength = {0, 0, 0, 0, 0, 0, 0, 0,}


    userInventoryFieldHeight = {}

    scrollInventory = {up = true, down = true,}

    inventory = {
        open = false,
        amount = 0,
        opacity = 0,
        usedItemThisTick = false,
        titleSpacing = 25,
        itemSpacing = 42,
        imageNumber = 0,
        items = {},

        fields = {"weapons", "spells", "armour", "reagent", "consumables", "mounts", "buddies", "other",},
        fieldLength = {0, 0, 0, 0, 0, 0, 0,},

        font = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 12),
        headerFont = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 26),
        itemFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 8),
        images = {
            itemBG = love.graphics.newImage("assets/ui/hud/character-inventory/item-bg.png"),
            numbers = {love.graphics.newImage("assets/ui/hud/character-inventory/01.png"),
                       love.graphics.newImage("assets/ui/hud/character-inventory/02.png"),
                       love.graphics.newImage("assets/ui/hud/character-inventory/03.png"),
                       love.graphics.newImage("assets/ui/hud/character-inventory/04.png"),
                       love.graphics.newImage("assets/ui/hud/character-inventory/05.png"),
                       love.graphics.newImage("assets/ui/hud/character-inventory/06.png"),
                       love.graphics.newImage("assets/ui/hud/character-inventory/07.png"),
                       love.graphics.newImage("assets/ui/hud/character-inventory/08.png"),
                       love.graphics.newImage("assets/ui/hud/character-inventory/09.png"),
                       love.graphics.newImage("assets/ui/hud/character-inventory/10.png")},
            numberBg = {love.graphics.newImage("assets/ui/hud/character-inventory/number-backgrounds/01.png"),
                        love.graphics.newImage("assets/ui/hud/character-inventory/number-backgrounds/02.png"),
                        love.graphics.newImage("assets/ui/hud/character-inventory/number-backgrounds/03.png"),
                        love.graphics.newImage("assets/ui/hud/character-inventory/number-backgrounds/04.png")}
        }
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
    userInventory[8] = {}
    inventoryFieldLength = {0, 0, 0, 0, 0, 0, 0, 0,}


    for i, v in ipairs(inventoryAlpha) do
        local t = 8

        if v.Item.Type == "wep" then
            t = 1
        elseif v.Item.Type == "spell" then
            t = 2
        elseif string.sub(v.Item.Type, 1, 4) == "arm_" or v.Item.Type == "shield" then
            t = 3
        elseif v.Item.Type == "reagent" then
            t = 4
        elseif v.Item.Type == "consumable" then 
            t = 5
        elseif v.Item.Type == "mount" then
            t = 6
        elseif v.Item.Type == "buddy" then
            t = 7
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
        if inventory.amount > 1 then
            inventory.amount = 1
        end

        if getFullUserInventoryFieldHeight() * scale > (uiY - 97 - 50 - 50) * scale then
            posYInventory = posYInventory + velyInventory * dt
            if posYInventory > 0 then
                posYInventory = 0
            elseif posYInventory < 0 - getFullUserInventoryFieldHeight() + (uiY - 97 - 50 - 50) then
                posYInventory = 0 - getFullUserInventoryFieldHeight() + (uiY - 97 - 50 - 50)
            end
        else
            posYInventory = 0
        end
    else
        inventory.open = false
        inventory.amount = inventory.amount - 4 * dt
        if inventory.amount < 0 then
            inventory.amount = 0
        end
    end
    inventory.opacity = cerp(0, 1, inventory.amount)
end

function drawToolBarInventory(thisX, thisY)
    love.graphics.setColor(unpack(characterHub.backgroundColor))

    love.graphics.rectangle("fill", thisX, thisY - 97, 313, 0 - cerp(23, 23 + (uiY - 97 - 23), inventory.amount))
    thisX, thisY = thisX, thisY - 97
    love.graphics.setColor(1, 1, 1, 1)
    for i = 0, 6 do
        drawInventoryItem(thisX + 9 + (43 * i), thisY - 42, 0, null, 1, i + 1)
    end

    if inventory.open then
        getInventory()
        love.graphics.setColor(1, 1, 1, inventory.opacity)
        thisY = thisY - cerp(0, (uiY - 97), inventory.amount)

        love.graphics.setFont(inventory.headerFont)
        love.graphics.print("Inventory", thisX + 8, thisY + 14)

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

function drawInventoryItem(thisX, thisY, field, item, amount, number)
    love.graphics.setFont(inventory.itemFont)
    if number then
        love.graphics.draw(inventory.images.itemBG, thisX, thisY)
        if item then love.graphics.draw(item, top_left, thisX + 2, thisY + 2) end

        love.graphics.draw(inventory.images.numbers[number], thisX - 3, thisY + 26)
        -- love.graphics.setColor(1,1,1,1)
    else
        if isMouseOver(thisX * scale, thisY * scale, 34 * scale, 34 * scale) and item then
            setItemTooltip(item)
            selectedItem = item
        end
      
        love.graphics.draw(inventory.images.itemBG, thisX, thisY)

        if item and itemImg[item.ImgPath] then
            if string.sub(item.Type, 1, 4) == "arm_" then
             
                love.graphics.draw(playerImg, thisX + 2, thisY + 2)
              
            end
          
            if inventory.usedItemThisTick then
                love.graphics.setColor(1,1,1,0.4)
            end
            if itemImg[item.ImgPath]:getWidth() <= 32 and
                itemImg[item.ImgPath]:getHeight() <= 32 then
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
    love.graphics.printf(inventory.fields[field], thisX + 2, thisY + 2, 483)

    thisY = thisY + inventory.titleSpacing

    local itemWidth = 7
    for i = 1, #userInventory[field] do
      
        if i <= 7 then
            drawInventoryItem(thisX + (43 * (i - 1)), thisY + (inventory.itemSpacing * 0), field, userInventory[field][i].Item, userInventory[field][i].Inventory.Amount)
        elseif i > 7 and i <= 14 then
            drawInventoryItem(thisX + (43 * (i - 1)), thisY + (inventory.itemSpacing * 1), field, userInventory[field][i].Item, userInventory[field][i].Inventory.Amount)
        elseif i > 14 and i <= 21 then
            drawInventoryItem(thisX + (43 * (i - 1)), thisY + (inventory.itemSpacing * 2), field, userInventory[field][i].Item, userInventory[field][i].Inventory.Amount)
        elseif i > 21 and i <= 28 then
            drawInventoryItem(thisX + (43 * (i - 1)), thisY + (inventory.itemSpacing * 3), field, userInventory[field][i].Item, userInventory[field][i].Inventory.Amount)
        elseif i > 28 and i <= 35 then
            drawInventoryItem(thisX + (43 * (i - 1)), thisY + (inventory.itemSpacing * 4), field, userInventory[field][i].Item, userInventory[field][i].Inventory.Amount)
        else
            drawInventoryItem(thisX + (43 * (i - 1)), thisY + (inventory.itemSpacing * 5), field, userInventory[field][i].Item, userInventory[field][i].Inventory.Amount)
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
        if crafting.open then
            local hasItem = false
            for i,v in ipairs(crafting.enteredItems) do
                if v.item == selectedItem and getItemAmount(selectedItem) > v.amount then
                    v.amount = v.amount + 1
                    hasItem = true
                end
                crafting.enteredItems[i] = v
            end

            if not hasItem then
                crafting.enteredItems[#crafting.enteredItems+1] = {
                    item = selectedItem,
                    amount = 1,
                    random = {X = math.random()*100, Y = math.random()*100},
                }
            end
            local itemsSoFar = {}
            for i,v in ipairs(crafting.enteredItems) do
                itemsSoFar[#itemsSoFar+1] = {
                    ItemID = v.item.ID,
                    Amount = v.amount
                }
            end
            local b = {}
            body = json:encode(itemsSoFar)
            c, h = http.request{url = api.url.."/craft/"..player.name, method="GET", source=ltn12.source.string(body), headers={["token"]=token,["Content-Length"]=#body}, sink=ltn12.sink.table(b)}
            crafting.craftableItems = json:decode(b[1])
        else
            apiGET("/item/" .. player.name .. "/" .. selectedItem.ID)
            usedItemThisTick = true
        end
       
    end
end

function drawInventoryStencil()
    love.graphics.rectangle("fill", (0), (0 + 50), 313, (uiY - 97 - 50 - 50))
end

function getItemAmount(item)
    local amount = 0
    for i, v in ipairs(inventoryAlpha) do
        if v.Item == item then
            amount = v.Inventory.Amount
        end
    end

    return amount
end