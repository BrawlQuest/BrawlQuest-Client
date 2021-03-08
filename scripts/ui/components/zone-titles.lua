zoneTitle = {
    y = 0,
    title = "Spooky Forest",
    previousTitle = "Spooky Forest2",
    font = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 48),
    alpha = 0,
    alphaUp = false
}

function drawZoneTitle()
    love.graphics.setFont(zoneTitle.font)
    local x = uiX - (zoneTitle.font:getWidth(zoneTitle.title)) * 0.5
    love.graphics.setColor(1,1,1,zoneTitle.alpha)
    love.graphics.printf(zoneTitle.title, x, 20, zoneTitle.font:getWidth(zoneTitle.title), "center")
end

function updateZoneTitle(dt)
    if worldLookup[player.x] and worldLookup[player.x][player.y] and worldLookup[player.x][player.y].Name ~= zoneTitle.title and worldLookup[player.x][player.y].Name  ~= "Spooky Forest" and worldLookup[player.x][player.y].Name ~= "" then
        zoneTitle.title = worldLookup[player.x][player.y].Name 
        -- zoneTitle.alphaUp = true
        -- zoneTitle.alpha = 0
        if love.system.getOS() ~= "Linux" then 
            steam.friends.setRichPresence("steam_display", "#StatusAdventuring")
            steam.friends.setRichPresence("location", zoneTitle.title)
        end
        zoneChange(worldLookup[player.x][player.y].Name)
    end

    if zoneTitle.alphaUp then
        zoneTitle.alpha = zoneTitle.alpha + 1 * dt
        if zoneTitle.alpha >= 2 then
            zoneTitle.alphaUp = false
        end
    elseif zoneTitle.alpha > 0 then
        zoneTitle.alpha = zoneTitle.alpha - 1 * dt
        if zoneTitle.alpha < 0 then zoneTitle.alpha = 0 end
    end
end