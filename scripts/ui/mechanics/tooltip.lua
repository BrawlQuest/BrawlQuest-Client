tooltip = {
    x = 0,
    y = 0,
    title = "Tooltip",
    desc = "Tooltip",
    additional = {{
        desc = "Example",
        color = {0, 1, 0}
    }},
    alpha = 0,
    padding = 4,
    spacing = 2,
    perks = {{
        title = "Strength",
        desc = "Increases melee damage output by 1 for each point."
    }, {
        title = "Intelligence",
        desc = "Increases the potency of your spells. Each point increases the impact of spells (check spell tooltips to see updated values)"
    }, {
        title = "Stamina",
        desc = "Increases your character's HP. You gain an extra 10 HP per point."
    }}
}

function setTooltip(title, desc, additional)
    tooltip.x, tooltip.y = love.mouse.getPosition()

    tooltip.x = (tooltip.x + 16) / scale -- avoid getting cut off by the mouse
    

    tooltip.y = (tooltip.y + 16) / scale
    tooltip.alpha = 1
    tooltip.title = title
    tooltip.description = desc
    tooltip.additional = additional

    local e = explode(desc, "{")
    if me and me.sta and #e > 1 then
        local e2 = explode(e[2], "}")
        local eq = e2[1]
        eq = eq:gsub("INT", me["INT"])
        eq = eq:gsub("STA", me["STA"])
        -- print(eq)
        func = assert(loadstring("return " .. eq))
        y = func()
        -- print(y)
        tooltip.description = e[1] .. tostring(y) .. e2[2]
    end
end

function setPerkTooltip(i)
    local v = tooltip.perks[i]
    setTooltip(v.title, v.description)
end

function setItemTooltip(item)
    love.graphics.setColor(0.6, 0.6, 0.6)
    valueAdditional = {
        desc = "Item",
        color = {0.4, 0.4, 0.4}
    }
    local valString = "Item"
    if item.type == "wep" then
        valueAdditional.description = "+" .. item.val .. " Weapon"
        valueAdditional.color = {1, 0.6, 0}
    elseif item.type == "arm_head" then
        valueAdditional.description = "+" .. item.val .. " Head Armour"
        valueAdditional.color = {0.5, 0.87, 0.47}
    elseif item.type == "arm_chest" then
        valueAdditional.description = "+" .. item.val .. " Chest Armour"
        valueAdditional.color = {0.5, 0.87, 0.47}
    elseif item.type == "arm_legs" then
        valueAdditional.description = "+" .. item.val .. " Leg Armour"
        valueAdditional.color = {0.5, 0.87, 0.47}
    elseif item.type == "shield" then
        valueAdditional.description = "+" .. item.val .. " Shield"
        valueAdditional.color = {0.5, 0.87, 0.47}
    elseif item.type == "spell" then
        valueAdditional.description = "Spell (" .. item.val .. " Mana)"
        valueAdditional.color = {0.6, 0.6, 1}
    elseif item.type == "hp_potion" then
        valueAdditional.description = "Restores " .. item.val .. " HP"
        valueAdditional.color = {1, 0.5, 0.5}
    elseif item.type == "mana_potion" then
        valueAdditional.description = "Restores " .. item.val .. " Mana"
        valueAdditional.color = {0.5, 0.5, 1}
    elseif item.type == "reagent" then
        valueAdditional.description = "Reagent"
        valueAdditional.color = {0.73, 1, 0}
    elseif item.type == "buddy" then
        valueAdditional.description = "Buddy"
        valueAdditional.color = {0.8, 0, 1}
    elseif item.type == "mount" then
        valueAdditional.description = item.val / 32 .. "m/s Mount"
        valueAdditional.color = {0.8, 0.2, 1}
    elseif item.type == "wall" then
        valueAdditional.description = "Placeable Wall"
        valueAdditional.color = {0.8,0.8,0.8}
    elseif item.type == "furniture" then
        valueAdditional.description = "Placeable Furniture"
        valueAdditional.color = {0.8,0.8,0.8}
    elseif item.type == "floor" then
        valueAdditional.description = "Placeable Flooring"
        valueAdditional.color = {0.8,0.8,0.8}
    end
    if item.subtype ~= "None" and getUsableSubtypeString(item) then
       valueAdditional.description = valueAdditional.description.." ("..item.subtype..")"
    end
   
    if me and me.lvl and item and item.worth and me.lvl >= item.worth then
        setTooltip(item.name, "", {valueAdditional, {
            desc = item.description,
            color = {0.8, 0.8, 0.8}
        }, {
            desc = "Requires Level " .. item.worth,
            color = {0, 1, 0}
        }})
    else
        setTooltip(item.name, "", {valueAdditional, {
            desc = item.description,
            color = {0.8, 0.8, 0.8}
        }, {
            desc = "Requires Level " .. item.worth,
            color = {1, 0, 0}
        }})
    end
    if getUsableSubtypeString(item) then
        tooltip.additional[#tooltip.additional + 1] = {
            desc = getUsableSubtypeString(item),
            color = {1,1,1}
        }
    end
    if item.attributes and item.attributes ~= "None" then
        att = explode(item.attributes, ";")
        for i,v in ipairs(att) do
            thisAttribute = explode(v, ",")
            tooltip.additional[#tooltip.additional + 1] = {
                desc = "Grants +"..thisAttribute[2].." "..thisAttribute[1],
                color = {0.6,0.6,1}
            }
        end
    end
    if me and item and item.enchantment and item.enchantment ~= "None" then
        ench = explode(item.enchantment, ",")
        if string.sub(item.type,1,3) == "arm" then

            tooltip.additional[#tooltip.additional + 1] = {
                desc = "Enchanted with +"..ench[2].." "..ench[1],
                color = {0.7,0,1}
            }
        elseif item.type == "wep" then
            tooltip.additional[#tooltip.additional + 1] = {
                desc = "Enchanted with +"..ench[2].." Attack Damage",
                color = {0.7,0,1}
            }
        elseif item.type == "mount" then
            tooltip.additional[#tooltip.additional + 1] = {
                desc = "Enchanted with +0.8m/s movement speed",
                color = {0.7,0,1}
            }
      
        end
        
    end

    if item.type == "wall" or item.type == "furniture" or item.type == "floor" then
        tooltip.additional[#tooltip.additional + 1] = {
            desc = "This item is placeable within any zone called 'Foundation Forest' or 'Dominion of "..me.name.."'",
            color = {0.6,0.6,1}
        }
    end

    if item.type == "spell" and me and me.SpellCooldown and me.SpellCooldown > 0 then
        tooltip.additional[#tooltip.additional + 1] = {
            desc = "Global spell cooldown. Can be used in "..me.SpellCooldown.." seconds.",
            color = {1,0,0}
        }
    end

   
end

function drawTooltip(thisX, thisY)
    love.graphics.setColor(0, 0, 0, tooltip.alpha)
    if (tooltip.x - tooltip.padding) + (150 + (tooltip.padding * 2)) > uiX then
        tooltip.x = uiX - (150 + (tooltip.padding * 2))
    end
    local height = getToolTipTitleHeight(tooltip.title) + getToolTipDescHeight(tooltip.description) + (tooltip.padding * 2) +
                       tooltip.spacing
    if tooltip.additional then
        for i, v in ipairs(tooltip.additional) do
            height = height + getToolTipDescHeight(v.description)
        end
    end
    if tooltip.y + height > uiY then
        tooltip.y = uiY - height
        tooltip.x = tooltip.x + 6
    end
    love.graphics.rectangle("fill", tooltip.x - tooltip.padding, tooltip.y - tooltip.padding,
        150 + (tooltip.padding * 2), height)
    love.graphics.setColor(1, 1, 1, tooltip.alpha)
    love.graphics.printf(tooltip.title, npcChatFont, tooltip.x, tooltip.y, 150, "left")
    love.graphics.printf(tooltip.desc, characterHub.font, tooltip.x,
        tooltip.y + getToolTipTitleHeight(tooltip.title) + tooltip.spacing, 150, "left")
    local yPos = tooltip.y + getToolTipTitleHeight(tooltip.title) + tooltip.spacing + getToolTipDescHeight(tooltip.description)
    if tooltip.additional then
        for i, v in ipairs(tooltip.additional) do
            love.graphics.setColor(v.color[1], v.color[2], v.color[3], tooltip.alpha)
            love.graphics.printf(v.desc, characterHub.font, tooltip.x, yPos, 150, "left")
            yPos = yPos + getToolTipDescHeight(v.desc)
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function getToolTipTitleHeight(title)
    local width, lines = npcChatFont:getWrap(title, 150)
    return ((#lines) * (npcChatFont:getHeight()))
end

function getToolTipDescHeight(title)
    if title then
        local width, lines = characterHub.font:getWrap(title, 150)
        return ((#lines) * (characterHub.font:getHeight()))
    else
        return 0
    end
end

function updateTooltip(dt)
    tooltip.alpha = tooltip.alpha - 8 * dt
end

