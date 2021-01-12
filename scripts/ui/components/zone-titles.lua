zoneTitle = {
    y = 0,
    title = "Spooky Forest",
    previousTitle = "Spooky Forest2",
    font = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 64)
}

function drawZoneTitle()
    love.graphics.setFont(zoneTitle.font)
    local x = love.graphics.getWidth()
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill",  x, zoneTitle.y, zoneTitle.font:getWidth(zoneTitle.title)+12, 72)
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf(zoneTitle.title, x, zoneTitle.y + 4, zoneTitle.font:getWidth(zoneTitle.title), "center")
end