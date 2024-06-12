premiumMessage = {
    width = 600,
    height = 600,
    display = false,
    title = "Membership Required",
    subtitle = "The feature you’re trying to access requires a premium membership. 30 days of premium gametime can be purchased from Steam.",
    features = {
        {title = "Levels 1-40", free = true}, {title = "Crafting", free = true},
        {title = "Mounts", free = true},
        {title = "Full map exploration", free = true},
        {title = "Equip any item", free = true}, {title = "Classes"},
        {title = "Enchanting"}, {title = "Pets"}, {title = "Building"}
    },
    callToAction = "Purchase now via Steam",
    titleFont = love.graphics.newFont("assets/ui/fonts/BMmini.ttf", 48),
    subtitleFont = love.graphics
        .newFont("assets/ui/fonts/BMmini.ttf", 28),
    featureFont = love.graphics.newFont("assets/ui/fonts/BMmini.ttf", 24),
    crownImg = love.graphics.newImage("assets/ui/crown.png"),
    isCallToActionOver = false
}

restrictedItemTypes = {"Buildable", "Buddy"}

function drawPremiumMessage()
    if (premiumMessage.display) then
        local x, y = love.graphics.getWidth() / 2 - premiumMessage.width / 2,
                     love.graphics.getHeight() / 2 - premiumMessage.height / 2

        love.graphics.setColor(0, 0, 0, 0.8)

        love.graphics.rectangle("fill", x, y, premiumMessage.width,
                                premiumMessage.height, 40)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(bqLogo, x + 20, y + 20, 0, 2, 2)
        love.graphics.setFont(premiumMessage.titleFont)
        love.graphics.printf(premiumMessage.title,
                             x + premiumMessage.width - 300, y + 20, 300,
                             "center")

        love.graphics.setFont(premiumMessage.subtitleFont)
        love.graphics.printf(premiumMessage.subtitle, x + 20, y + 140,
                             premiumMessage.width - 40, "left")

        love.graphics.print("Free", x + 300, y + 230)
        love.graphics.print("Premium", x + premiumMessage.width - 140, y + 230)

        love.graphics.setFont(premiumMessage.featureFont)
        for i, v in ipairs(premiumMessage.features) do
            if i % 2 ~= 0 then
                love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
                love.graphics.rectangle("fill", x, y + 240 +
                                            (i *
                                                premiumMessage.featureFont:getHeight()) +
                                            8, premiumMessage.width,
                                        premiumMessage.featureFont:getHeight() +
                                            2)
                love.graphics.setColor(1, 1, 1)
            end
            love.graphics.printf(v.title, x + 20, y + 240 +
                                     (i * premiumMessage.featureFont:getHeight() +
                                         8), 200, "left")
            if (v.free) then
                love.graphics.draw(premiumMessage.crownImg, x + 314, y + 240 +
                                       (i *
                                           premiumMessage.featureFont:getHeight() +
                                           12))
            end
            love.graphics.draw(premiumMessage.crownImg,
                               x + premiumMessage.width - 110, y + 240 +
                                   (i * premiumMessage.featureFont:getHeight() +
                                       12))
        end

        love.graphics.setFont(premiumMessage.titleFont)
        if isMouseOver(x + 20, y + premiumMessage.height - 60,
                       premiumMessage.width - 40, 50) then
            love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
            love.graphics.rectangle("fill", x + 20,
                                    y + premiumMessage.height - 60,
                                    premiumMessage.width - 40, 50, 10)
            love.graphics.setColor(1, 1, 1, 1)
            premiumMessage.isCallToActionOver = true
                       else
                        premiumMessage.isCallToActionOver = false
        end
        love.graphics.rectangle("line", x + 20, y + premiumMessage.height - 60,
                                premiumMessage.width - 40, 50, 10)

        love.graphics.printf(premiumMessage.callToAction, x + 20, y +
                                 premiumMessage.height - 85 +
                                 (premiumMessage.titleFont:getHeight() / 2),
                             premiumMessage.width - 40, "center")

        if isMouseOver(x + premiumMessage.width - 16, y, 32, 32) then
            love.graphics.setColor(0.6, 0, 0)
            if isMouseDown() then
                premiumMessage.display = false
            end
        else
            love.graphics.setColor(0.8, 0, 0)
        end
        love.graphics.rectangle("fill", x + premiumMessage.width - 16, y, 32,
                                32, 5)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("x", x + premiumMessage.width - 16, y - 12, 32,
                             "center")
    end
end

function onPremiumMouseDown()
    if (premiumMessage.isCallToActionOver) then
        apiGET("/micro")
    end
end