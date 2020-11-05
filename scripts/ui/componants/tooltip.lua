tooltip = {
    x = 0,
    y = 0,
    title = "Tooltip",
    desc = "Tooltip",
    alpha = 0
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
    love.graphics.rectangle("fill", tooltip.x,tooltip.y,150,inventorySubHeaderFont:getHeight()*2 + smallTextFont:getWidth(tooltip.desc)/150*smallTextFont:getHeight())
    love.graphics.setColor(1,1,1,tooltip.alpha)
    love.graphics.setFont(inventorySubHeaderFont)
    love.graphics.printf(tooltip.title,tooltip.x,tooltip.y,150,"left")
    love.graphics.setFont(smallTextFont)
    love.graphics.printf(tooltip.desc,tooltip.x,tooltip.y+inventorySubHeaderFont:getHeight(),150,"left")
    love.graphics.setColor(1,1,1,1)
end

function updateTooltip(dt)
    tooltip.alpha = tooltip.alpha - 1*dt
end

