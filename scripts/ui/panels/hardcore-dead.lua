deathMessage = {
    width = 600,
    height = 600,
    display = false,
    title = "You've died!",
    subtitle = "As a hardcore character, you aren't able to revive yourself from death. You can reset this character, and try again.",
   
    callToAction = "RESET CHARACTER",
    titleFont = love.graphics.newFont("assets/ui/fonts/VT323-Regular.ttf", 48),
    subtitleFont = love.graphics
        .newFont("assets/ui/fonts/VT323-Regular.ttf", 28),
    featureFont = love.graphics.newFont("assets/ui/fonts/VT323-Regular.ttf", 24),
    isCallToActionOver = false
}


function drawDeathMessage()
    if (deathMessage.display) then
        local x, y = love.graphics.getWidth() / 2 - deathMessage.width / 2,
                     love.graphics.getHeight() / 2 - deathMessage.height / 2

        love.graphics.setColor(0, 0, 0, 0.8)

        love.graphics.rectangle("fill", x, y, deathMessage.width,
                                deathMessage.height, 40)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(bqLogo, x + 20, y + 20, 0, 2, 2)
        love.graphics.setFont(deathMessage.titleFont)
        love.graphics.printf(deathMessage.title,
                             x + deathMessage.width - 300, y + 20, 300,
                             "center")

        love.graphics.setFont(deathMessage.subtitleFont)
        love.graphics.printf(deathMessage.subtitle, x + 20, y + 140,
                             deathMessage.width - 40, "left")

       

        love.graphics.setFont(deathMessage.titleFont)
        if isMouseOver(x + 20, y + deathMessage.height - 60,
        deathMessage.width - 40, 50) then
            love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
            love.graphics.rectangle("fill", x + 20,
                                    y + deathMessage.height - 60,
                                    deathMessage.width - 40, 50, 10)
            love.graphics.setColor(1, 1, 1, 1)
            deathMessage.isCallToActionOver = true
        else
            deathMessage.isCallToActionOver = false
        end
        love.graphics.rectangle("line", x + 20, y + deathMessage.height - 60,
        deathMessage.width - 40, 50, 10)

        love.graphics.printf(deathMessage.callToAction, x + 20, y +
        deathMessage.height - 85 +
                                 (deathMessage.titleFont:getHeight() / 2),
                                 deathMessage.width - 40, "center")

        if isMouseOver(x + deathMessage.width - 16, y, 32, 32) then
            love.graphics.setColor(0.6, 0, 0)
            if isMouseDown() then
                deathMessage.display = false
            end
        else
            love.graphics.setColor(0.8, 0, 0)
        end
        love.graphics.rectangle("fill", x + deathMessage.width - 16, y, 32,
                                32, 5)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("x", x + deathMessage.width - 16, y - 12, 32,
                             "center")
    end
end


function onHardcoreMouseDown()
    if (deathMessage.isCallToActionOver) then
        apiGET("/reset/" .. me.name)
        deathMessage.display = false
        deathMessage.isCallToActionOver = false
    end
end