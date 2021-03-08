function initEnchanting()
    enchanting = {
        open = true,
        amount = 1,
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
            desc = "Congratulations Adventurer! You have succeeded in getting to level 25! To enchant an item your character will be reset to Level 1 as well as all of your quests and NPC conversations. You gain a permanent double XP buff, meaning that getting back to Level 25 on your character should take half the time.\nYou don't lose any of your items, although your stats will be reset to 1 and your armour and weapon will be unequipped.",
        },
    }
end

function updateEnchanting(dt)

end

function drawEnchanting()
    local e = enchanting
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill",0,0,uiX, uiY)
    local titleScale = 8
    local textScale = 3

    if e.phase == 1 then

        local itemWidth = 32 * e.itemScale 
        local w = (itemWidth + 30) * #e.itemNames
        local x, y = uiX / 2 - w / 2, uiY / 2 - getTextHeight(e.text.desc, w, e.font) * textScale - e.font:getHeight() * titleScale + 10-- itemWidth

        love.graphics.setFont(e.font)
        love.graphics.setColor(1,1,1)

        love.graphics.printf("Enchanting", x - 10, y, w / titleScale, "center", 0, titleScale)
        y = y + e.font:getHeight() * titleScale + 10
        love.graphics.printf(e.text.desc, x - 10, y, w / textScale, "left", 0, textScale)
        y = y + e.font:getHeight() * textScale + 20

    elseif e.phase == 2 then

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