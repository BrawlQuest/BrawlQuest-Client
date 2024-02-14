local style = {track = "line", knob = "rectangle", width = 28}

function initEnchanting()
    enchanting = {
        open = false,
        amount = 0,
        cerp = 0,
        phase = 1,
        floor = 1,
        itemnames = {
            "legarmour", "chestarmour", "headarmour", "Shield", "Weapon",
            "Mount"
        },
        items = {
            ["legarmour"] = {armour = true},
            ["chestarmour"] = {armour = true},
            ["headarmour"] = {armour = true},
            ["Weapon"] = {armour = false},
            ["Mount"] = {armour = false},
            ["Shield"] = {armour = true}
        },
        itemScale = 3,
        font = love.graphics.newFont("assets/ui/fonts/C&C Red Alert [INET].ttf",
                                     13),
        text = {
            desc = "The mana has chosen you. To enchant an item your character will be reset to Level 1 as well as all of your quests and NPC conversations.\nYou don't lose any of your items, although your stats will be reset to 1 and your armour and weapon will be unequipped.",
            ifNot = "If you haven't equipped an item you'd like to enchant, come back with the item you'd like to enchant equipped",
            final = "Are you sure you want to enchant this item? You will be sent back to the level shown below, and will not be able to use your high level items again until you level up.",
            already = "This item already has an enchantment on it and you can only have one enchantment per item. There are two options:",
            options = {
                {
                    title = "Upgrade Enchantment",
                    text = "You can boost this item's current enchantment up to your current level. The amount of levels you put into the enchantment will be taken away from your current level. The perk will stay the same."
                }, {
                    title = "Change Enchantment",
                    text = "You can change the enchantment type for this item, but you will loose all the levels you previously spent on it. This has the same effect as enchanting a completely new item."
                }
            }
        },
        mouseOver = {
            endPhaseOne = false,
            perk = 0,
            item = "",
            commit = false,
            back3 = false,
            return3 = false,
            options = 0
        },
        chosenItem = "legarmour",
        chosenItemCount = 1,
        perks = {
            ["Armour"] = {
                {
                    title = "STR",
                    desc = "+40 Strength (STR) whilst wearing this armour",
                    img = love.graphics.newImage("assets/ui/enchantment/0.png")
                }, {
                    title = "INT",
                    desc = "+40 Intelligence (INT) whilst wearing this armour",
                    img = love.graphics.newImage("assets/ui/enchantment/1.png")
                }, {
                    title = "STA",
                    desc = "+40 Stamina (STA) whilst wearing this armour",
                    img = love.graphics.newImage("assets/ui/enchantment/2.png")
                }
            },
            ["Weapon"] = {
                {
                    title = "Val",
                    desc = "+40 Damage whilst using this weapon",
                    img = love.graphics.newImage("assets/ui/enchantment/0.png")
                }
            },
            ["Mount"] = {
                {
                    title = "Val",
                    desc = "+0.8 m/s speed boost whilst riding this mount",
                    img = love.graphics.newImage("assets/ui/enchantment/1.png")
                }
            },
            ["Shield"] = {
                {
                    title = "Val",
                    desc = "+40 defence boost whilst using this shield",
                    img = love.graphics.newImage("assets/ui/enchantment/2.png")
                }
            }
        },
        selectedPerk = 1,
        itemLevel = 25
    }
end

function updateEnchanting(dt)
    local e = enchanting
    if e.open then
        panelMovement(dt, enchanting, 1, "amount", 0.1)
        if e.phase == 3 then
            enchantingSliderPhase3:update()
        elseif e.phase == 5 then
            enchantingSliderPhase5:update()
        end
    else
        panelMovement(dt, enchanting, -1, "amount", 0.5)
        if e.amount < 0.01 then e.amount = 0 end
    end
    e.cerp = cerp(0, 1, e.amount)
end

function drawEnchanting()
    local e = enchanting
    love.graphics.setColor(0, 0, 0, 0.9)
    love.graphics.rectangle("fill", 0, 0, uiX, uiY)
    local titleScale = 8
    local textScale = 3
    local smallPrintScale = 2
    local itemWidth = 32 * e.itemScale
    local w = 756

    love.graphics.setFont(e.font)
    love.graphics.setColor(1, 1, 1)

    if e.phase == 1 then

        local x, y = uiX / 2 - w / 2, uiY / 2 -
                         getTextHeight(e.text.description, w / textScale, e.font) *
                         textScale -- e.font:getHeight() * titleScale -- itemWidth
        love.graphics.printf("Enchanting", x - 10, y, w / titleScale, "center",
                             0, titleScale)
        y = y + e.font:getHeight() * titleScale + 10
        love.graphics.printf(e.text.description, x - 10, y, w / textScale, "center", 0,
                             textScale)
        y =
            y + (getTextHeight(e.text.description, w / textScale, e.font) * textScale) +
                20
        -- if e.flash.light then love.graphics.setColor(1,0,0) end
        e.mouseOver.endPhaseOne = false
        if isMouseOver(x - 20 * scale, y * scale, w * scale,
                       (e.font:getHeight() * textScale + 20) * scale) then
            love.graphics.setColor(1, 0, 0)
            love.graphics.rectangle("fill", x - 20, y, w,
                                    e.font:getHeight() * textScale + 20, 10)
            love.graphics.setColor(1, 1, 1)
            e.mouseOver.endPhaseOne = true
        end
        love.graphics.printf("Press return to continue", x - 10, y + 8,
                             w / textScale, "center", 0, textScale)

    elseif e.phase == 2 then
        local x, y = uiX / 2 - w / 2, uiY / 2 - 300
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Choose which item you want to enchant", x - 10,
                             y - e.font:getHeight() * textScale - 10,
                             w / textScale, "center", 0, textScale)
        e.mouseOver.item = ""
        if me and me.headarmour then
            for i, v in ipairs(e.itemnames) do -- draws armour and base images if needed
                local dx, dy = x + (itemWidth + 30) * (i - 1), y + 10
                local offset = 0
                if e.chosenItem == v then
                    love.graphics.setColor(1, 1, 1)
                else
                    love.graphics.setColor(0, 0, 0, 0.8)
                end
                love.graphics.rectangle("fill", dx - 10, dy - 10,
                                        itemWidth + 20, itemWidth + 20, 10)
                love.graphics.setColor(1, 1, 1)
                if isMouseOver(dx * scale, dy * scale, itemWidth * scale,
                               itemWidth * scale) then
                    e.mouseOver.item = v
                    offset = 3
                end
                if v ~= "Mount" then
                    if e.items[v].armour then
                        dx = dx - 10
                        love.graphics.draw(playerImg, dx, dy - offset, 0,
                                           e.itemScale)
                    end
                    if me[v .. "ID"] ~= 0 then
                        drawItemIfExists(me[v].imgpath, dx, dy - offset, "", 1,
                                         e.itemScale)
                    end
                elseif me.mount and me.mount.name ~= "None" and me.mount.name ~=
                    "" then
                    drawItemIfExists(me[v].imgpath, dx, dy - offset, "", 1,
                                     e.itemScale)
                end
            end
        end
        love.graphics.setColor(1, 1, 1)
        x, y = x - 10, y + itemWidth + 30
        love.graphics.printf(e.text.ifNot, x, y, w / smallPrintScale, "center",
                             0, smallPrintScale)
        local picScale = 8
        y = y + getTextHeight(e.text.ifNot, w / smallPrintScale, e.font) *
                smallPrintScale + 20
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.rectangle("fill", x, y, 32 * picScale,
                                84 * 3 + e.font:getHeight() * textScale + 20, 10)
        love.graphics.setColor(1, 1, 1)

        if e.chosenItem ~= "" then
            local dx, dy = x + 32, y + 32
            local offset = 0
            if e.chosenItem ~= "Mount" then
                if e.items[e.chosenItem].armour then
                    offset = 20
                    love.graphics.draw(playerImg, dx - offset, dy, 0,
                                       picScale - 2)
                end
                if me[e.chosenItem .. "ID"] ~= 0 then
                    drawItemIfExists(me[e.chosenItem].imgpath, dx - offset, dy,
                                     "", 1, picScale - 2)
                end
            elseif me.mount and me.mount.name ~= "None" and me.mount.name ~= "" then
                drawItemIfExists(me[e.chosenItem].imgpath, dx - offset, dy, "",
                                 1, picScale - 2)
            end
            love.graphics.printf(me[e.chosenItem].name .. "\nEnchantment: " ..
                                     me[e.chosenItem].enchantment, x,
                                 y + 30 * picScale,
                                 (32 * picScale) / smallPrintScale, "center", 0,
                                 smallPrintScale)
        else
            love.graphics.setColor(0.5, 0.5, 0.5)
            love.graphics.draw(playerImg, x + 32 - 20, y + 32, 0, picScale - 2)
        end

        local dx, dy = x + 32 * picScale + 20, y
        local width = w - 32 * picScale - 30
        x = x + 32 * picScale + 20
        y = y - 5
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Choose an enchantment", x, y, width / textScale,
                             "left", 0, textScale)
        y = y + e.font:getHeight() * textScale + 5

        dx, dy = x, y
        love.graphics.setColor(0, 0, 0, 0.8)
        for i = 1, 3 do
            love.graphics
                .rectangle("fill", dx, dy + 94 * (i - 1), width, 84, 10)
        end

        e.mouseOver.perk = 0
        if e.chosenItem ~= "" and me[enchanting.chosenItem] and
            me[enchanting.chosenItem].name ~= "None" then
            local perk
            if e.chosenItem == "headarmour" or e.chosenItem == "chestarmour" or
                e.chosenItem == "legarmour" then
                perk = "Armour"
            else
                perk = e.chosenItem
            end
            for i, v in ipairs(e.perks[perk]) do
                if e.selectedPerk == i then
                    love.graphics.setColor(1, 1, 1)
                    love.graphics.rectangle("fill", dx, dy, width, 84, 10)
                elseif isMouseOver(dx * scale, dy * scale, width * scale,
                                   84 * scale) then
                    e.mouseOver.perk = i
                    love.graphics.setColor(1, 0, 0)
                    love.graphics.rectangle("fill", dx, dy, width, 84, 10)
                end
                love.graphics.setColor(1, 1, 1)
                love.graphics.rectangle("fill", dx + 10, dy + 10, 64, 64, 6)
                love.graphics.draw(v.img, dx + 10, dy + 10, 0, 2)
                if e.selectedPerk == i then
                    love.graphics.setColor(0, 0, 0)
                end
                love.graphics.printf(v.description, dx + 84, dy + 42 -
                                         (getTextHeight(v.description, (width - 84) /
                                                            smallPrintScale,
                                                        e.font) *
                                             smallPrintScale) * 0.5,
                                     (width - 84) / smallPrintScale, "left", 0,
                                     smallPrintScale)
                dy = dy + 84 + 10
            end
        end

        x = x - 32 * picScale - 20
        y = y + 94 * 3
        w = w - 10

        e.mouseOver.commit = false
        if isMouseOver(x * scale, y * scale, w * scale, 64 * scale) and
            e.chosenItem ~= "" then
            e.mouseOver.commit = true
            love.graphics.setColor(1, 0, 0)
        else
            love.graphics.setColor(0, 0, 0, 0.8)
        end

        love.graphics.rectangle("fill", x, y, w, 64, 10)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Enchant Selected Item", x,
                             y + 32 - (e.font:getHeight() * textScale) * 0.5,
                             w / textScale, "center", 0, textScale)
    elseif e.phase == 3 then
        local picScale = 8
        local width = 32 * picScale
        local x, y = uiX / 2 - w * 0.5, uiY / 2 - width * 0.5

        local perk = "headarmour"
        if e.chosenItem == "headarmour" or e.chosenItem == "chestarmour" or
            e.chosenItem == "legarmour" then
            perk = "Armour"
        else
            perk = e.chosenItem
        end

        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.rectangle("fill", x, y, w, width, 10)
        love.graphics.setColor(1, 1, 1)

        local dx, dy = x + 32, y + 32
        local offset = 0
        if e.chosenItem ~= "Mount" then
            if e.items[e.chosenItem].armour then
                offset = 20
                love.graphics.draw(playerImg, dx - offset, dy, 0, picScale - 2)
            end
            if me[e.chosenItem .. "ID"] ~= 0 then
                drawItemIfExists(me[e.chosenItem].imgpath, dx - offset, dy, "",
                                 1, picScale - 2)
            end
        elseif me.mount and me.mount.name ~= "None" then
            drawItemIfExists(me[e.chosenItem].imgpath, dx - offset, dy, "", 1,
                             picScale - 2)
        end

        dx, dy = x + width, dy - 10
        width = w - (width + 40)

        local floor = 25
        if e.floor > 25 then floor = e.floor end
        local levelCalc = math.floor(lerp(floor, me.lvl,
                                          enchantingSliderPhase3:getValue()))
        e.itemLevel = levelCalc
        love.graphics.printf(me[e.chosenItem].name, dx, dy, width / textScale,
                             "left", 0, textScale)
        dy = dy +
                 (getTextHeight(me[e.chosenItem].name, width / textScale, e.font) *
                     textScale)
        love.graphics.printf(e.perks[perk][e.selectedPerk].description, dx, dy,
                             width / smallPrintScale, "left", 0, smallPrintScale)
        dy = dy +
                 getTextHeight(e.perks[perk][e.selectedPerk].description, width,
                               e.font, smallPrintScale) + 10
        love.graphics.printf("Item Enchantment Level:", dx, dy,
                             width / smallPrintScale, "left", 0, smallPrintScale)
        love.graphics.printf(levelCalc, dx, dy, width / smallPrintScale,
                             "right", 0, smallPrintScale)
        dy = dy + e.font:getHeight() * smallPrintScale
        love.graphics.printf("Levels Deducted:", dx, dy,
                             width / smallPrintScale, "left", 0, smallPrintScale)
        love.graphics.printf(levelCalc - e.floor, dx, dy,
                             width / smallPrintScale, "right", 0,
                             smallPrintScale)
        dy = dy + e.font:getHeight() * smallPrintScale
        love.graphics.printf("Your Level After Enchanting:", dx, dy,
                             width / smallPrintScale, "left", 0, smallPrintScale)
        love.graphics.printf(
            math.clamp(1, me.lvl - (levelCalc - e.floor), 1000), dx, dy,
            width / smallPrintScale, "right", 0, smallPrintScale)

        enchantingSliderPhase3:draw()

        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(e.text.final, x + 10, y -
                                 (getTextHeight(e.text.final,
                                                (w - 20) / textScale, e.font) *
                                     (textScale + 0.5)), (w - 20) / textScale,
                             "center", 0, textScale)
        -- love.graphics.setColor(1,0,0)
        -- textScale = textScale + 1
        -- love.graphics.printf("ONLY ONE ENCHANTMENT PER ITEM", x + 10, y - (e.font:getHeight() * textScale) - 20, (w - 20) / textScale, "center", 0, textScale)

        y = y + 32 * picScale + 10 -- draw underneath boxes
        drawEnchantmentButton(x, y, w * 0.5 - 5, 64, "Go Back (escape)", "back3")

        x = x + w * 0.5 + 5
        drawEnchantmentButton(x, y, w * 0.5 - 5, 64, "Enchant Item (return)",
                              "return3")

    elseif e.phase == 4 then
        local picScale = 8
        x, y = uiX / 2 - w / 2, uiY / 2 - 16 * picScale
        love.graphics.printf(e.text.already, x, y -
                                 getTextHeight(e.text.already, w, e.font, 3) -
                                 20, w / 3, "center", 0, 3)
        e.mouseOver.options = 0
        for i, v in ipairs(e.text.options) do
            if isMouseOver(x * scale, y * scale, w * scale, 200 * scale) then
                love.graphics.setColor(1, 0, 0, 1)
                e.mouseOver.options = i
            else
                love.graphics.setColor(0, 0, 0, 0.8)
            end
            love.graphics.rectangle("fill", x, y, w, 200, 10)
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.printf(v.title, x + 30, y + 20, w / 3 - 60, "left", 0,
                                 3)
            love.graphics.printf(v.text, x + 30,
                                 y + 20 + e.font:getHeight() * 3, w / 2 - 60,
                                 "left", 0, 2)
            y = y + 200 + 20
        end
    elseif e.phase == 5 then
        enchantingSliderPhase5:draw()
        -- love.graphics.print(math.floor(lerp(25, 30, enchantingSliderPhase5:getValue())), -200, -50, 0, 4)
    end
end

function drawEnchantmentButton(x, y, w, h, text, bool)
    local e = enchanting
    if isMouseOver(x * scale, y * scale, w * scale, h * scale) then
        e.mouseOver[bool] = true
        love.graphics.setColor(1, 0, 0)
    else
        love.graphics.setColor(0, 0, 0, 0.8)
        e.mouseOver[bool] = false
    end
    love.graphics.rectangle("fill", x, y, w, h, 10)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(text, x, y + h * 0.5 - (e.font:getHeight() * 3) / 2,
                         w / 3, "center", 0, 3)
end

function checkEnchantingKeyPressed(key)
    local e = enchanting
    local perk = "headarmour"
    if e.chosenItem == "headarmour" or e.chosenItem == "chestarmour" or
        e.chosenItem == "legarmour" then
        perk = "Armour"
    else
        perk = e.chosenItem
    end

    if e.phase == 1 then
        if key == "return" then e.phase = 2 end
        if key == "f" or checkMoveOrAttack(key, "move") then
            e.open = false
        end
    elseif e.phase == 2 then
        if key == keybinds.ATTACK_RIGHT then
            if e.chosenItemCount < #e.itemnames then
                e.chosenItemCount = e.chosenItemCount + 1
            else
                e.chosenItemCount = 1
            end
            if e.itemnames[e.chosenItemCount] == "Mount" and
                (me.mount.name == "None" or me.mount.name == "") then
                e.chosenItemCount = e.chosenItemCount - 1
            else
                e.chosenItem = e.itemnames[e.chosenItemCount]
                e.selectedPerk = 1
            end
        elseif key == keybinds.ATTACK_LEFT then
            if e.chosenItemCount > 1 then
                e.chosenItemCount = e.chosenItemCount - 1
            else
                e.chosenItemCount = #e.itemnames
            end
            if e.itemnames[e.chosenItemCount] == "Mount" and
                (me.mount.name == "None" or me.mount.name == "") then
                e.chosenItemCount = e.chosenItemCount + 1
            else
                e.chosenItem = e.itemnames[e.chosenItemCount]
                e.selectedPerk = 1
            end
        elseif key == keybinds.ATTACK_DOWN and e.chosenItem ~= "" then
            if e.selectedPerk < #e.perks[perk] then
                e.selectedPerk = e.selectedPerk + 1
            else
                e.selectedPerk = 1
            end
        elseif key == keybinds.ATTACK_UP and e.chosenItem ~= "" then
            if e.selectedPerk > 1 then
                e.selectedPerk = e.selectedPerk - 1
            else
                e.selectedPerk = #e.perks[perk]
            end
        elseif key == "return" and me[enchanting.chosenItem] and
            me[enchanting.chosenItem].name ~= "None" then
            transitionToEnchantingPhase4()
        elseif key == "f" or checkMoveOrAttack(key, "move") then
            e.open = false
        end
    elseif e.phase == 3 then
        if key == "return" then
            enchantItem()
        elseif key == "escape" then
            e.phase = 2
        elseif checkMoveOrAttack(key, "move") then
            e.open = false
        end
    elseif e.phase == 4 then
        if key == "return" then
            enchantItem()
        elseif key == "escape" then
            e.phase = 2
        elseif checkMoveOrAttack(key, "move") then
            e.open = false
        end
    elseif e.phase == 5 then
        if key == "escape" then
            e.phase = 4
        elseif checkMoveOrAttack(key, "move") then
            e.open = false
        end
    end
end

function checkEnchantingMousePressed(button)
    local e = enchanting
    if e.phase == 1 then
        if e.mouseOver.endPhaseOne then e.phase = 2 end
    elseif e.phase == 2 then
        if e.mouseOver.item ~= "" then
            for i, v in ipairs(e.itemnames) do
                if e.mouseOver.item == v then
                    if v ~= "Mount" then
                        e.chosenItemCount = i
                        e.chosenItem = e.mouseOver.item
                    elseif me.mount and me.mount.name ~= "None" and
                        me.mount.name ~= "" then
                        e.chosenItemCount = i
                        e.chosenItem = e.mouseOver.item
                    end
                end
            end
        end
        if e.mouseOver.perk > 0 then e.selectedPerk = e.mouseOver.perk end
        if e.mouseOver.commit and me[enchanting.chosenItem] and
            me[enchanting.chosenItem].name ~= "None" then
            transitionToEnchantingPhase4()
        end
    elseif e.phase == 3 then
        if e.mouseOver.return3 == true then
            enchantItem()
        elseif e.mouseOver.back3 == true then
            e.phase = 2
        end
    elseif e.phase == 4 then
        if e.mouseOver.options == 1 then
            transitionToEnchantingPhase5()
        elseif e.mouseOver.options == 2 then
            transitionToEnchantingPhase3()
        end
    elseif e.phase == 5 then
    end
end

function enchantItem()

    local e = enchanting
    local perk = "headarmour"
    if e.chosenItem == "headarmour" or e.chosenItem == "chestarmour" or
        e.chosenItem == "legarmour" then
        perk = "Armour"
    else
        perk = e.chosenItem
    end

    -- print("Trying to enchant " .. me[e.chosenItem].id)
    c, h = http.request {
        url = api.url .. "/enchant/" .. me.id .. "/" .. me[e.chosenItem].id ..
            "/" .. e.perks[perk][e.selectedPerk].title .. "/" .. e.itemLevel,
        method = "GET",
        headers = {["token"] = token}
    }


    e.open = false
    e.chosenItem = "legarmour"
    e.chosenItemCount = 1
    e.phase = 1
end

function openEnchanting()

 
        enchanting.phase = 1
        enchanting.open = true
        enchanting.amount = 0.01
   
end

function transitionToEnchantingPhase3()
    local e = enchanting
    e.floor = 1
    enchantingSliderPhase3 = newSlider(uiX / 2 + 108, uiY / 2 + 100, 448, 1, 0,
                                       1, function() end, style)
    e.phase = 3
end

function transitionToEnchantingPhase4()
    local e = enchanting
    if not me[enchanting.chosenItem].enchantment or
        me[enchanting.chosenItem].enchantment == "None" then
        transitionToEnchantingPhase3()
    elseif me[enchanting.chosenItem].enchantment ~= "None" then
        e.phase = 4 -- go to the choose an enchantment type phase
    end
end

function transitionToEnchantingPhase5()
    local e = enchanting
    local ench = explode(me[e.chosenItem].enchantment, ",")
    for i, v in ipairs(e.perks.Armour) do
        if ench[1] == v.title then e.selectedPerk = i end
    end
    e.floor = tonumber(ench[2])
    -- enchantingSliderPhase5 = newSlider(uiX / 2, uiY / 2, 400, 1, 0, 1, function() end, style)
    enchantingSliderPhase3 = newSlider(uiX / 2 + 108, uiY / 2 + 100, 448, 1, 0,
                                       1, function() end, style)
    e.phase = 3
end
