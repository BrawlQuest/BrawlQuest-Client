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

    useItemColorChanged = false
    userInventoryFieldHeight = {}

    scrollInventory = {up = true, down = true,}

    inventory = {
        isMouseOverInventoryItem = false,
        forceOpen = false,
        notNPC = true,
        open = false,
        amount = 0,
        opacity = 0,
        usedItemThisTick = false,
        titleSpacing = 25,
        itemSpacing = 42,
        imageNumber = 0,
        items = {},
        mouseOverButtonsAmount = 0,

        fields = {"WEAPONS", "SPELLS", "ARMOUR", "REAGENT", "CONSUMABLES", "MOUNTS", "BUDDIES", "OTHER",},
        fieldLength = {0, 0, 0, 0, 0, 0, 0,},

        font = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 16),
        headerFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 32),
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

    inventory.font:setFilter( "nearest", "nearest" )
    inventory.headerFont:setFilter( "nearest", "nearest" )
    inventory.itemFont:setFilter( "nearest", "nearest" )

end

function updateToolBarInventory(dt)
    if inventory.forceOpen then
        inventory.open = true
        inventory.amount = inventory.amount + 4 * dt
        if inventory.amount > 1 then inventory.amount = 1 end
    else
        if isMouseOver(0, 0, 313 * scale, (uiY - 97) * scale) and openUiOnHover then
            inventory.open = true
            inventory.amount = inventory.amount + 4 * dt
            if inventory.amount > 1 then inventory.amount = 1 end
        else
            inventory.open = false
            inventory.amount = inventory.amount - 4 * dt
            if inventory.amount < 0 then
                inventory.amount = 0
            end
        end
    end


    
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
        
    if inventory.open then 
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

        inventory.opacity = cerp(0, 1, inventory.amount)
    end
end

function getItemType(v)
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

    return t
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
        local t = getItemType(v)

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

function checkInventoryKeyPressed(key)
    for i,v in ipairs(hotbar) do
        if love.keyboard.isDown(i) or (i == 7 and love.keyboard.isDown("space")) then
            if inventory.isMouseOverInventoryItem then
                v.item = selectedItem
                print(getItemAmount(v.item))
            else
                if v.item ~= nil and v.item.ID ~= nil then
                    useItemColor[i] = 1
                    useItemColorChanged = true
                    apiGET("/item/" .. player.name .. "/" .. v.item.ID)
                    usedItemThisTick = true
                else
                    hotbar[i] = {item = null,}
                end
            end
        end
    end
end

function checkInventoryMousePressed(button)

    if inventory.mouseOverButtonsAmount > 0 then
        for i,v in ipairs(hotbar) do
            if i == inventory.mouseOverButtonsAmount and v.item ~= nil and v.item.ID ~= nil then
                if button == 1  then
                    useItemColor[i] = 1
                    useItemColorChanged = true
                    apiGET("/item/" .. player.name .. "/" .. v.item.ID)
                    usedItemThisTick = true
                elseif button == 2 then
                    hotbar[i] = {item = null,}
                end 
            end
        end
    end

    if selectedItem ~= nil and selectedItem.ID ~= nil and
        isMouseOver((0) * scale, (0 + 50) * scale, 313 * scale, (uiY - 97 - 50 - 50) * scale) then

        if love.keyboard.isDown("lshift") then

            for i,v in ipairs(hotbar) do
                if love.keyboard.isDown("lshift") and love.keyboard.isDown(i) then
                    v.item = selectedItem
                end
            end

        elseif crafting.open and selectedItem.Type == "reagent" then

            local hasItem = false
            local maxItemUsed = false
            for i,v in ipairs(crafting.enteredItems) do
                if v.item == selectedItem and getItemAmount(selectedItem) > v.amount then
                    v.amount = v.amount + 1
                    hasItem = true
                elseif v.item == selectedItem and getItemAmount(selectedItem) <= v.amount then
                    hasItem = false
                    maxItemUsed = true
                end
                crafting.enteredItems[i] = v
            end

            if not hasItem and maxItemUsed == false then
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
            if b[1] ~= nil then
             crafting.craftableItems = json:decode(b[1])
            end
        else
            apiGET("/item/" .. player.name .. "/" .. selectedItem.ID)
            usedItemThisTick = true
        end
       
    end
end

function getItemAmount(item)
    local amount = null
    if item ~= null then
        for i, v in ipairs(inventoryAlpha) do
            -- print(json:encode(v.Item) .. "    " .. json:encode(item))
            if v.Item == item then
                amount = v.Inventory.Amount
            end
        end
    end

    return amount
end