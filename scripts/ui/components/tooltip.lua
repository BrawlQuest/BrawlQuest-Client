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
        desc = "Increases maximum potential bonus damage output by 1 for each point (damage is wep value plus 1 to STR)"
    }, {
        title = "Intelligence",
        desc = "Increases the potency of your spells. Each point increases the impact of spells (check spell tooltips to see updated values)"
    }, {
        title = "Stamina",
        desc = "Increases your character's HP. You gain an extra 15 HP per point."
    }}
}

function setTooltip(title, desc, additional)
    tooltip.x, tooltip.y = love.mouse.getPosition()

    tooltip.x = (tooltip.x + 16) / scale -- avoid getting cut off by the mouse
    

    tooltip.y = (tooltip.y + 16) / scale
    tooltip.alpha = 1
    tooltip.title = title
    tooltip.desc = desc
    tooltip.additional = additional

    local e = explode(desc, "{")
    if me and me.STA and #e > 1 then
        local e2 = explode(e[2], "}")
        local eq = e2[1]
        eq = eq:gsub("INT", me["INT"])
        eq = eq:gsub("STA", me["STA"])
        -- print(eq)
        func = assert(loadstring("return " .. eq))
        y = func()
        -- print(y)
        tooltip.desc = e[1] .. tostring(y) .. e2[2]
    end
end

function setPerkTooltip(i)
    local v = tooltip.perks[i]
    setTooltip(v.title, v.desc)
end

function setItemTooltip(item)
    love.graphics.setColor(0.6, 0.6, 0.6)
    valueAdditional = {
        desc = "Item",
        color = {0.4, 0.4, 0.4}
    }
    local valString = "Item"
    if item.Type == "wep" then
        valueAdditional.desc = "+" .. item.Val .. " Weapon"
        valueAdditional.color = {1, 0.6, 0}
    elseif item.Type == "arm_head" then
        valueAdditional.desc = "+" .. item.Val .. " Head Armour"
        valueAdditional.color = {0.5, 0.87, 0.47}
    elseif item.Type == "arm_chest" then
        valueAdditional.desc = "+" .. item.Val .. " Chest Armour"
        valueAdditional.color = {0.5, 0.87, 0.47}
    elseif item.Type == "arm_legs" then
        valueAdditional.desc = "+" .. item.Val .. " Leg Armour"
        valueAdditional.color = {0.5, 0.87, 0.47}
    elseif item.Type == "shield" then
        valueAdditional.desc = "+" .. item.Val .. " Shield"
        valueAdditional.color = {0.5, 0.87, 0.47}
    elseif item.Type == "spell" then
        valueAdditional.desc = "Spell (" .. item.Val .. " Mana)"
        valueAdditional.color = {0.6, 0.6, 1}
    elseif item.Type == "hp_potion" then
        valueAdditional.desc = "Restores " .. item.Val .. " HP"
        valueAdditional.color = {1, 0.5, 0.5}
    elseif item.Type == "mana_potion" then
        valueAdditional.desc = "Restores " .. item.Val .. " Mana"
        valueAdditional.color = {0.5, 0.5, 1}
    elseif item.Type == "reagent" then
        valueAdditional.desc = "Reagent"
        valueAdditional.color = {0.73, 1, 0}
    elseif item.Type == "buddy" then
        valueAdditional.desc = "Buddy"
        valueAdditional.color = {0.8, 0, 1}
    elseif item.Type == "mount" then
        valueAdditional.desc = item.Val / 32 .. "m/s Mount"
        valueAdditional.color = {0.8, 0.2, 1}
    elseif item.Type == "wall" then
        valueAdditional.desc = "Placeable Wall"
        valueAdditional.color = {0.8,0.8,0.8}
    elseif item.type == "furniture" then
        valueAdditional.desc = "Placeable Furniture"
        valueAdditional.color = {0.8,0.8,0.8}
    elseif item.type == "floor" then
        valueAdditional.desc = "Placeable Flooring"
        valueAdditional.color = {0.8,0.8,0.8}
    end
    if me and me.LVL and item and item.Worth and me.LVL >= item.Worth then
        setTooltip(item.Name, "", {valueAdditional, {
            desc = item.Desc,
            color = {0.8, 0.8, 0.8}
        }, {
            desc = "Requires Level " .. item.Worth,
            color = {0, 1, 0}
        }})
    else
        setTooltip(item.Name, "", {valueAdditional, {
            desc = item.Desc,
            color = {0.8, 0.8, 0.8}
        }, {
            desc = "Requires Level " .. item.Worth,
            color = {1, 0, 0}
        }})
    end
    if item.Attributes and item.Attributes ~= "None" then
        att = explode(item.Attributes, ";")
        for i,v in ipairs(att) do
            thisAttribute = explode(v, ",")
            tooltip.additional[#tooltip.additional + 1] = {
                desc = "Grants +"..thisAttribute[2].." "..thisAttribute[1],
                color = {0.6,0.6,1}
            }
        end
    end

    if item.Type == "spell" then
        tooltip.additional[#tooltip.additional + 1] = {
            desc = "Not consumed on use",
            color = {0.8,0.8,1}
        }
    end

    if me and item and item.Enchantment ~= "None" then
        ench = explode(item.Enchantment, ",")
        if string.sub(item.Type,1,3) == "arm" then

            tooltip.additional[#tooltip.additional + 1] = {
                desc = "Enchanted with +"..ench[2].." "..ench[1],
                color = {0.7,0,1}
            }
        elseif item.Type == "wep" then
            tooltip.additional[#tooltip.additional + 1] = {
                desc = "Enchanted with +"..ench[2].." Attack Damage",
                color = {0.7,0,1}
            }
        elseif item.Type == "mount" then
            tooltip.additional[#tooltip.additional + 1] = {
                desc = "Enchanted with +0.8m/s movement speed",
                color = {0.7,0,1}
            }
      
        end
        
    end

    if item.Type == "wall" or item.Type == "furniture" or item.Type == "floor" then
        tooltip.additional[#tooltip.additional + 1] = {
            desc = "This item is placeable within any zone called 'Foundation Forest' or 'Dominion of "..me.Name.."'",
            color = {0.6,0.6,1}
        }
    end

    if item.Type == "spell" and me and me.SpellCooldown and me.SpellCooldown > 0 then
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
    local height = getToolTipTitleHeight(tooltip.title) + getToolTipDescHeight(tooltip.desc) + (tooltip.padding * 2) +
                       tooltip.spacing
    if tooltip.additional then
        for i, v in ipairs(tooltip.additional) do
            height = height + getToolTipDescHeight(v.desc)
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
    local yPos = tooltip.y + getToolTipTitleHeight(tooltip.title) + tooltip.spacing + getToolTipDescHeight(tooltip.desc)
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

