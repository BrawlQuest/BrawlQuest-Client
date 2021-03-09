function initEnchanting()
    enchanting = {
        open = false,
        amount = 0,
        phase = 1,
        itemNames = {"LegArmour","ChestArmour","HeadArmour","Shield","Weapon","Mount"},
        items = {
            ["LegArmour"] = {
                x = 0,
                y = 0,
                armour = true
            },
            ["ChestArmour"] = {
                x = 0,
                y = 0,
                armour = true
            },
            ["HeadArmour"] = {
                x = 0,
                y = 0,
                armour = true
            },
            ["Weapon"] = {
                x = 0,
                y = 0,
                armour = false
            },
            ["Mount"] = {
                x = 0,
                y = 0,
                armour = false
            },
            ["Shield"] = {
                x = 0,
                y = 0,
                armour = true
            },
        },
        itemScale = 3,
        font = love.graphics.newFont("assets/ui/fonts/C&C Red Alert [INET].ttf", 13),
        text = {
            desc = "The mana has chosen you. To enchant an item your character will be reset to Level 1 as well as all of your quests and NPC conversations. You gain a permanent double XP buff, meaning that getting back to Level 25 on your character should take half the time.\nYou don't lose any of your items, although your stats will be reset to 1 and your armour and weapon will be unequipped.",
            ifNot = "If you haven't equipped an item you'd like to enchant, come back with the item you'd like to enchant equipped",
        },
        flash = {
            light = false,
            amount = 0,
        },
        mouseOver = {
            endPhaseOne = false,
            perk = 0,
            item = "",
            commit = false,
        },
        chosenItem = "",
        chosenItemCount = 0,
        perks = {
            ["Armour"] = {
                    {
                        desc = "+25 Strength whilst wearing this armour",
                        img = love.graphics.newImage("assets/ui/enchantment/0.png"),
                    }, {
                        desc = "+25 Intelligence whilst wearing this armour",
                        img = love.graphics.newImage("assets/ui/enchantment/1.png"),
                    }, {
                        desc = "+25 Stamina whilst wearing this armour",
                        img = love.graphics.newImage("assets/ui/enchantment/2.png"),
                    },
                },
            ["Weapon"] = {
                {
                    desc = "+25 Damage whilst using this weapon",
                    img = love.graphics.newImage("assets/ui/enchantment/0.png"),
                }, 
            },
            ["Mount"] = {                
                {
                    desc = "+0.8 m/s speed boost whilst riding this mount",
                    img = love.graphics.newImage("assets/ui/enchantment/0.png"),
                },
            },
            ["Shield"] = {
                {
                    desc = "+25 defence boost whilst using this shield",
                    img = love.graphics.newImage("assets/ui/enchantment/0.png"),
                },
            },
        },
        selectedPerk = 0,
    }
end

function updateEnchanting(dt)
    local e = enchanting
end

function drawEnchanting()
    local e = enchanting
    love.graphics.setColor(0,0,0,0.8)
    love.graphics.rectangle("fill",0,0,uiX, uiY)
    local titleScale = 8
    local textScale = 3
    local smallPrintScale = 2
    local itemWidth = 32 * e.itemScale 
    local w = (itemWidth + 30) * #e.itemNames

    love.graphics.setFont(e.font)
    love.graphics.setColor(1,1,1)
    
    if e.phase == 1 then

        local x, y = uiX / 2 - w / 2, uiY / 2 - getTextHeight(e.text.desc, w / textScale, e.font) * textScale -- e.font:getHeight() * titleScale -- itemWidth
        love.graphics.printf("Enchanting", x - 10, y, w / titleScale, "center", 0, titleScale)
        y = y + e.font:getHeight() * titleScale + 10
        love.graphics.printf(e.text.desc, x - 10, y, w / textScale, "center", 0, textScale)
        y = y + (getTextHeight(e.text.desc, w / textScale, e.font) * textScale) + 20
        -- if e.flash.light then love.graphics.setColor(1,0,0) end
        e.mouseOver.endPhaseOne = false
        if isMouseOver(x - 20, y, w, e.font:getHeight() * textScale + 20) then
            love.graphics.setColor(1,0,0)
            love.graphics.rectangle("fill", x - 20, y, w, e.font:getHeight() * textScale + 20, 10)
            love.graphics.setColor(1,1,1)
            e.mouseOver.endPhaseOne = true
        end
        love.graphics.printf("Press return to continue", x - 10, y + 8, w / textScale, "center", 0, textScale)

    elseif e.phase == 2 then 
        local x, y = uiX / 2 - w / 2, uiY / 6
        love.graphics.setColor(1,1,1)
        love.graphics.printf("Choose which item you want to enchant", x - 10, y - e.font:getHeight() * textScale - 10, w / textScale, "center", 0, textScale)
        e.mouseOver.item = ""
        if me and me.HeadArmour then
            for i,v in ipairs(e.itemNames) do -- draws armour and base images if needed
                local dx, dy = x + (itemWidth + 30) * (i-1), y + 10
                if e.chosenItem == v then love.graphics.setColor(1,1,1) else love.graphics.setColor(0,0,0,0.8) end
                love.graphics.rectangle("fill", dx - 10, dy - 10, itemWidth + 20, itemWidth + 20, 10)
                if isMouseOver(dx,dy, itemWidth, itemWidth) then
                    love.graphics.setColor(1,0,1)
                    e.mouseOver.item = v
                else love.graphics.setColor(1,1,1) end

                if v ~= "Mount" then
                    if e.items[v].armour then
                        dx = dx - 10
                        love.graphics.draw(playerImg, dx, dy, 0, e.itemScale)
                    end
                    if me[v.."ID"] ~= 0 then drawItemIfExists(me[v].ImgPath, dx, dy, "", 1, e.itemScale) end
                elseif me.Mount and me.Mount.Name ~= "None" then
                    drawItemIfExists(me[v].ImgPath, dx, dy, "", 1, e.itemScale)
                end
            end
        end
        x, y = x - 10, y + itemWidth + 30
        love.graphics.printf(e.text.ifNot, x, y, w / smallPrintScale, "center", 0, smallPrintScale)
        local picScale =  8
        y = y + getTextHeight(e.text.ifNot, w / smallPrintScale, e.font) * smallPrintScale + 20
        love.graphics.setColor(0,0,0,0.8)
        love.graphics.rectangle("fill", x, y, 32 * picScale, 84 * 3 + e.font:getHeight() * textScale + 20, 10)
        love.graphics.setColor(1,1,1)
        

        if e.chosenItem ~= "" then
            local dx, dy = x + 32, y + 32
            local offset = 0
            if e.chosenItem ~= "Mount" then
                if e.items[e.chosenItem].armour then
                    offset = 20
                    love.graphics.draw(playerImg, dx - offset, dy, 0, picScale - 2) 
                end
                if me[e.chosenItem.."ID"] ~= 0 then drawItemIfExists(me[e.chosenItem].ImgPath, dx - offset, dy, "", 1, picScale - 2) end
            elseif me.Mount and me.Mount.Name ~= "None" then drawItemIfExists(me[e.chosenItem].ImgPath, dx - offset, dy, "", 1, picScale - 2) end
            love.graphics.printf(me[e.chosenItem].Name, x, y + 32 * picScale, (32 * picScale) / smallPrintScale, "center",  0, smallPrintScale)
        else 
            love.graphics.setColor(0.5,0.5,0.5)
            love.graphics.draw(playerImg, x + 32 - 20, y + 32, 0, picScale - 2)
        end

        local dx, dy = x + 32 * picScale + 20, y
        local width = w - 32 * picScale - 30
        x = x + 32 * picScale + 20
        y = y - 5
        love.graphics.setColor(1,1,1)
        love.graphics.printf("Choose an enchantment", x, y, width / textScale, "left", 0, textScale)
        y = y + e.font:getHeight() * textScale + 5


        dx, dy = x, y
        love.graphics.setColor(0,0,0,0.8)
        for i = 1, 3 do
            love.graphics.rectangle("fill", dx, dy + 94 * (i-1), width, 84, 10)
        end

        if e.chosenItem ~= "" then
            local perk
            if e.chosenItem == "HeadArmour" or e.chosenItem == "ChestArmour" or e.chosenItem == "LegArmour" then perk = "Armour"
            else perk = e.chosenItem end
            for i,v in ipairs(e.perks[perk]) do
                if e.selectedPerk == i then
                    love.graphics.setColor(1,1,1)
                    love.graphics.rectangle("fill", dx, dy, width, 84, 10)
                elseif isMouseOver(dx, dy, width, 84) then
                    love.graphics.setColor(1,0,0)
                    love.graphics.rectangle("fill", dx, dy, width, 84, 10)
                end
                love.graphics.setColor(1,1,1)
                love.graphics.rectangle("fill", dx + 10, dy + 10, 64, 64, 6)
                love.graphics.draw(v.img, dx + 10, dy + 10, 0, 2)
                if e.selectedPerk == i then love.graphics.setColor(0,0,0) end
                love.graphics.printf(v.desc, dx + 84, dy + 42 - (getTextHeight(v.desc, (width - 84) / smallPrintScale, e.font) * smallPrintScale) * 0.5, (width - 84) / smallPrintScale, "left", 0, smallPrintScale)
                dy = dy + 84 + 10
            end
        end

        x = x - 32 * picScale - 20
        y = y + 94 * 3
        w = w - 10

        e.mouseOver.commit = false
        if isMouseOver(x, y, w, 64) and e.chosenItem ~= "" then
            e.mouseOver.commit = true
            love.graphics.setColor(1,0,0)
        else love.graphics.setColor(0,0,0,0.8) end
        
        love.graphics.rectangle("fill", x, y, w, 64, 10)
        love.graphics.setColor(1,1,1)
        love.graphics.printf("Enchant Selected Item", x, y + 32 - (e.font:getHeight() * textScale) * 0.5, w / textScale, "center", 0, textScale)
    end
end

function checkEnchantingKeyPressed(key)
    local e = enchanting
    local perk = "HeadArmour"
    if e.chosenItem == "HeadArmour" or e.chosenItem == "ChestArmour" or e.chosenItem == "LegArmour" then perk = "Armour"
    else perk = e.chosenItem end

    if key == keybinds.ATTACK_RIGHT then 
        if e.chosenItemCount < #e.itemNames then 
            e.chosenItemCount = e.chosenItemCount + 1
        else e.chosenItemCount = 1 end
        e.chosenItem = e.itemNames[e.chosenItemCount]
        e.selectedPerk = 1
    elseif key == keybinds.ATTACK_LEFT then 
        if e.chosenItemCount > 1 then 
            e.chosenItemCount = e.chosenItemCount - 1
        else e.chosenItemCount = #e.itemNames end
        e.chosenItem = e.itemNames[e.chosenItemCount]
        e.selectedPerk = 1
    elseif key == keybinds.ATTACK_DOWN and e.chosenItem ~= "" then 
        if e.selectedPerk < #e.perks[perk] then 
            e.selectedPerk = e.selectedPerk + 1
        else e.selectedPerk = 1 end
    elseif key == keybinds.ATTACK_UP and e.chosenItem ~= "" then 
        if e.selectedPerk > 1 then
            e.selectedPerk = e.selectedPerk - 1
        else e.selectedPerk = #e.perks[perk] end
    end
    if key == keybinds.ATTACK_UP and e.chosenItem ~= "" then
        
    end
    if key == "return" then
        e.phase = 2
    elseif key == "f" or checkMoveOrAttack(key, "move") then
        e.open = false
    end
end

function checkEnchantingMousePressed(button)
    local e = enchanting
    if e.mouseOver.endPhaseOne then
        e.phase = 2
    elseif e.mouseOver.item ~= "" then
        e.chosenItem = e.mouseOver.item
        for i,v in ipairs(e.itemNames) do
            if e.chosenItem == v then e.chosenItemCount = i end
        end
    elseif e.mouseOver.perk > 0 then
        e.selectedPerk = e.mouseOver.perk
    elseif e.mouseOver.commit then
        e.phase = 3
    end
end