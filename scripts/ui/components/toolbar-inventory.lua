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
    userInventory[9] = {}
    userInventory[10] = {}
    inventoryFieldLength = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

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

        fields = {"WEAPONS", "SPELLS", "ARMOUR", "ORES", "REAGENT", "CONSUMABLES", "MOUNTS", "BUDDIES", "BUILDABLES", "OTHER",},
        fieldLength = {0, 0, 0, 0, 0, 0, 0,0,0,0},

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
    if inventory.forceOpen or crafting.open then
        inventory.open = true
        inventory.amount = inventory.amount + 4 * dt
        if inventory.amount > 1 then inventory.amount = 1 end
    else
        if isMouseOver(0, 0, 313 * scale, (uiY - 97) * scale) and openInventoryOnHover and not crafting.open then
            inventory.open = true
            panelMovement(dt, inventory, 1)
        else
            inventory.open = false
            panelMovement(dt, inventory, -1)
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
    local t = 10
    if v.Item.Type == "wep" then t = 1
    elseif v.Item.Type == "spell" then t = 2
    elseif string.sub(v.Item.Type, 1, 4) == "arm_" or v.Item.Type == "shield" then t = 3
    elseif v.Item.Type == "ore" then t = 4
    elseif v.Item.Type == "reagent" then t = 5
    elseif v.Item.Type == "consumable" then t = 6
    elseif v.Item.Type == "mount" then t = 7
    elseif v.Item.Type == "buddy" then t = 8
    elseif v.Item.Type == "wall" or v.Item.Type == "floor" or v.Item.Type == "furniture" then t = 9
    end return t
end

function getInventory()
    userInventory = {}
    inventoryFieldLength = {}
    for i = 1, #inventory.fields do -- in ipairs(inventoryAlpha) do
        userInventory[i] = {}
        inventoryFieldLength[i] = 0
    end

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
    end return j
end

function checkInventoryMousePressed(button)
    if selectedItem ~= nil and selectedItem.ID ~= nil and inventory.isMouseOverInventoryItem then
        if  not usedItemThisTick then
            statStoreTimer = 0
            apiGET("/item/" .. player.name .. "/" .. selectedItem.ID)
            playSoundIfExists("assets/sfx/items/"..selectedItem.Name..".ogg", true)
            usedItemThisTick = true
        end
    end
end

function getItemAmount(item)
    local amount = 0
    if item then
        for i, v in ipairs(inventoryAlpha) do
            if v.Item.ID == item.ID then
                amount = v.Inventory.Amount
            end
        end
    end
    return amount
end

function isItemUnusable(item)
    if (item and me.LVL and not debugItems)  then
        return (item.Worth or 1) * 1 > me.LVL
    else return false end
end

function isSpellUnusable(item)
    return item and item.Type == "spell" and me and me.SpellCooldown and me.SpellCooldown > 0
end