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
    tooltip.x = tooltip.x + 16 -- avoid getting cut off by the mouse
    tooltip.y = tooltip.y + 16
    tooltip.alpha = 1
    tooltip.title = title
    tooltip.desc = desc
end

function drawTooltip()
    love.graphics.setColor(0,0,0,tooltip.alpha)
    love.graphics.rectangle("fill", tooltip.x - tooltip.padding,tooltip.y - tooltip.padding, 150 + (tooltip.padding*2), getToolTipTitleHeight(tooltip.title) + getToolTipDescHeight(tooltip.desc) + (tooltip.padding*2) + tooltip.spacing)
    love.graphics.setColor(1,1,1,tooltip.alpha)
    love.graphics.setFont(inventorySubHeaderFont)
    
    love.graphics.printf(tooltip.title,tooltip.x,tooltip.y,150,"left")
    love.graphics.setFont(smallTextFont)
    love.graphics.printf(tooltip.desc,tooltip.x,tooltip.y+getToolTipTitleHeight(tooltip.title)+tooltip.spacing,150,"left")
    love.graphics.setColor(1,1,1,1)
end

function getToolTipTitleHeight(title)
    local width, lines = inventorySubHeaderFont:getWrap( title, 150 )
    return ((#lines)*(inventorySubHeaderFont:getHeight()))
end

function getToolTipDescHeight(title)
    local width, lines = smallTextFont:getWrap( title, 150 )
    return ((#lines)*(smallTextFont:getHeight()))
end

function updateTooltip(dt)
    tooltip.alpha = tooltip.alpha - 1*dt
end

