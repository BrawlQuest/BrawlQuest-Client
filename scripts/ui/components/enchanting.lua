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
        },
        flash = {
            light = false,
            amount = 0,
        },
        mouseOver = {
            endPhaseOne = false,
        }
    }
end

function updateEnchanting(dt)
    local e = enchanting
    e.flash.amount = e.flash.amount + 10 * dt
    if e.flash.amount > 1 then
        e.flash.light = not e.flash.light
        e.flash.amount = 0
    end
end

function drawEnchanting()
    local e = enchanting
    love.graphics.setColor(0,0,0,0.8)
    love.graphics.rectangle("fill",0,0,uiX, uiY)
    local titleScale = 8
    local textScale = 3
    local itemWidth = 32 * e.itemScale 
    local w = (itemWidth + 30) * #e.itemNames
    
    if e.phase == 1 then

        local x, y = uiX / 2 - w / 2, uiY / 2 - getTextHeight(e.text.desc, w / textScale, e.font) * textScale -- e.font:getHeight() * titleScale -- itemWidth

        love.graphics.setFont(e.font)
        love.graphics.setColor(1,1,1)
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
        local x, y = uiX / 2 - w / 2, uiY / 2
        if me and me.HeadArmour then
            for i,v in ipairs(e.itemNames) do -- draws armour and base images if needed
                local dx, dy = x + (itemWidth + 30) * (i-1), y
                love.graphics.setColor(0,0,0,0.8)
                love.graphics.rectangle("fill", dx - 10, dy - 10, itemWidth + 20, itemWidth + 20, 10)
                if isMouseOver(dx,dy, itemWidth, itemWidth) then love.graphics.setColor(1,0,1) else  love.graphics.setColor(1,1,1) end

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
    end
end

function checkEnchantingKeyPressed(key)
    local e = enchanting
    if key == "return" then
        e.phase = 2
    elseif key == "f" or checkMoveOrAttack(key) then
        e.open = false
    end
end

function checkEnchantingMousePressed(button)
    local e = enchanting
    if e.mouseOver.endPhaseOne then
        e.phase = 2
    end
end
