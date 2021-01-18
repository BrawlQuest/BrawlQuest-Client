tooltip = {
    x = 0,
    y = 0,
    title = "Tooltip",
    desc = "Tooltip",
    alpha = 0,
    padding = 4,
    spacing = 2
}

function setTooltip(title, desc)
    tooltip.x, tooltip.y = love.mouse.getPosition()

    tooltip.x = (tooltip.x + 16)/scale -- avoid getting cut off by the mouse
   
  
    tooltip.y = (tooltip.y + 16)/scale
    tooltip.alpha = 1
    tooltip.title = title
    tooltip.desc = desc

    local e = explode(desc,"{")
    if #e > 1 then
        local e2 = explode(e[2],"}")
        local eq = e2[1]
        eq = eq:gsub("INT", me["INT"])
        print(eq)
        func = assert(loadstring("return " .. eq))
        y = func()
        print(y)
        tooltip.desc = e[1]..tostring(y)..e2[2]
    end
end

function setItemTooltip(item)
    love.graphics.setColor(0.6, 0.6, 0.6)
    local valString = "Item"
    if item.Type == "wep" then
        valString = "+" .. item.Val .. " Weapon"
    elseif item.Type == "arm_head" then
        valString = "+" .. item.Val .. " Head Armour"
    elseif item.Type == "arm_chest" then
        valString = "+" .. item.Val .. " Chest Armour"
    elseif item.Type == "arm_leg" then
        valString = "+" .. item.Val .. " Leg Armour"
    elseif item.Type == "spell" then
        valString = "Spell (" .. item.Val .. " Mana)"
    elseif item.Type == "hp_potion" then
        valString = "Restores " .. item.Val .. " HP"
    elseif item.Type == "mana_potion" then
        valString = "Restores " .. item.Val .. " Mana"
    elseif item.Type == "reagent" then
        valString = "Reagent"
    elseif item.Type == "buddy" then
        valString = "Buddy"
    end

    setTooltip(item.Name, valString .. "\n" .. item.Desc)
end

function drawTooltip(thisX, thisY)
    love.graphics.setColor(0,0,0,tooltip.alpha)
    if (tooltip.x - tooltip.padding) + (150 + (tooltip.padding*2)) > uiX then
        tooltip.x = uiX - (150 + (tooltip.padding*2))
    end
    love.graphics.rectangle("fill", tooltip.x - tooltip.padding,tooltip.y - tooltip.padding, 150 + (tooltip.padding*2), getToolTipTitleHeight(tooltip.title) + getToolTipDescHeight(tooltip.desc) + (tooltip.padding*2) + tooltip.spacing)
    love.graphics.setColor(1,1,1,tooltip.alpha)
    love.graphics.printf(tooltip.title, npcChatFont, tooltip.x,tooltip.y,150,"left")
    love.graphics.printf(tooltip.desc, playerNameFont, tooltip.x,tooltip.y+getToolTipTitleHeight(tooltip.title)+tooltip.spacing,150,"left")
    love.graphics.setColor(1,1,1,1)
end

function getToolTipTitleHeight(title)
    local width, lines = npcChatFont:getWrap( title, 150 )
    return ((#lines)*(npcChatFont:getHeight()))
end

function getToolTipDescHeight(title)
    local width, lines = playerNameFont:getWrap( title, 150 )
    return ((#lines)*(playerNameFont:getHeight()))
end

function updateTooltip(dt)
    tooltip.alpha = tooltip.alpha - 8*dt
end

