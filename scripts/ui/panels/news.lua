function initNews()
    news = {
        open = false,
        closing = false,
        amount = 0,
        alpha = 0,
        mouseOver = {
            item = 0,
            exit = false
        },
        selected = {
            item = 1,
            cerp = 0,
            exit = false
        },
        items = {{
            header = "1",
            desc = "This is a general bug update. It should all be good.",
            action = function()
                print("I WANT YOU")
            end,
            img = love.graphics.newImage("assets/ui/news/01.png")
        }, {
            header = "2",
            desc = "This is a generl be good.",
            action = function()
                print("Second")
            end,
            img = love.graphics.newImage("assets/ui/news/02.png")
        }, {
            header = "3",
            desc = "This is a generl be good.",
            action = function()
                print("Second")
            end,
            img = love.graphics.newImage("assets/ui/news/03.png")
        }},
        exit = {
            text = "Start Playing",
            action = function()
                news.closing = true
            end
        },
        gradient = love.graphics.newImage("assets/ui/news/00.png")
    }

end

function getNews()

    b, c, h = http.request("https://api.steampowered.com/ISteamNews/GetNewsForApp/v2/?appid=871940&count=3")
    newsItems = lunajson.decode(b)

    news.items = {}
    for i,newsItem in ipairs(newsItems.appnews.newsitems) do
        news.items[#news.items + 1] = {
            header = newsItem.title,
            desc = newsItem.feedlabel,
            action = function()
                love.system.openURL(newsItem.url)
            end,
            img = love.graphics.newImage("assets/ui/steamimg/patch/spotlight.png")
        }
    end
end

function updateNews(dt)
    if news.closing then
        panelMovement(dt, news, -1, "alpha", 1.5)
        if news.alpha <= 0 then
            news.closing = false
            news.open = false
        end
    end

    if news.open then
        panelMovement(dt, news, 1, "amount", 0.2)
    end
    if news.amount >= 1 then
        news.amount = 0
        news.selected.item = news.selected.item + 1
        if news.selected.item > #news.items then
            news.selected.item = 1
        end
    end

    local speed = (news.selected.item - news.selected.cerp) * 6
    news.selected.cerp = news.selected.cerp + speed * dt
end

function drawNews()
    love.graphics.setFont(font)
    local w, h = 600, 424
    local x, y = uiX / 2 - w / 2, uiY / 2 - h / 2
    love.graphics.setColor(0, 0, 0, 0.8 * news.alpha)

    love.graphics.rectangle("fill", 0, 0, uiX, uiY)
    drawButtonBg(x, y, w, h, 10, {1, 1, 1, news.alpha})

    love.graphics.setColor(1, 1, 1, news.alpha)
    love.graphics.print("Welcome back " .. me.name .. "!", x + 20, y + 25, 0, 4)

    dx, dy = x + 20, y + 70
    dw, dh = w - 40, 260

    news.mouseOver.item = 0
    drawGeneralButton(dx, dy, {
        w = dw,
        h = dh,
        mouseOverColor = {1, 0, 0, 0.8 * news.alpha},
        bgColor = {0, 0, 0, 0.8 * news.alpha},
        lineColor = {1, 1, 1, news.alpha},
        mouseFunc = function()
            news.mouseOver.item = news.selected.item
        end,
        func = function()
            local mouseOver
            love.graphics.setColor(1, 1, 1, news.alpha)
            if news.mouseOver.item > 0 and news.mouseOver.item == news.selected.item then
                mouseOver = true
                dy = dy - 2
            else
                mouseOver = false
            end
            love.graphics.stencil(function()
                love.graphics.rectangle("fill", dx + 1, dy + 1, dw - 2, dh - 2, 5)
            end, "replace", 1)
            love.graphics.setStencilTest("greater", 0) -- push

            local cx, cy = dx - dw * (news.selected.cerp - 1), dy
            for i, item in ipairs(news.items) do
                love.graphics.draw(item.img, cx, cy)
                cx = cx + dw
            end

            if mouseOver then
                love.graphics.setColor(1, 0, 0, news.alpha)
            else
                love.graphics.setColor(0, 0, 0, news.alpha)
            end
            love.graphics.draw(news.gradient, dx, dy)

            dw, dh = dw - 32, dh
            dx, dy = dx + 16, dy + dh - 10
            love.graphics.setColor(1, 1, 1, news.alpha)
            love.graphics.printf(news.items[news.selected.item].header, dx,
                dy - getTextHeight(news.items[news.selected.item].header, dw, font, 5) - 10 -
                    getTextHeight(news.items[news.selected.item].description, dw, font, 2), dw / 5, "left", 0, 5)
            love.graphics.printf(news.items[news.selected.item].description, dx,
                dy - getTextHeight(news.items[news.selected.item].description, dw, font, 2), dw / 2, "left", 0, 2)
            love.graphics.setStencilTest()
        end
    })

    dw, dh = w - 40, 55
    x, y = x + 20, uiY / 2 + h / 2 - 20 - dh -- x, y + h + 30
    
    love.graphics.setColor(0, 0, 0, 0.8 * news.alpha)
    news.mouseOver.exit = false
    drawGeneralButton(x, y, {
        mouseOverColor = {1, 0, 0, 0.8 * news.alpha},
        bgColor = {0, 0, 0, 0.8 * news.alpha},
        lineColor = {1, 1, 1, news.alpha},
        w = dw,
        h = dh,
        text = news.exit.text,
        textX = "center",
        mouseFunc = function()
            news.mouseOver.exit = true
        end
    })
end

function checkNewsKeyPressed(key)
    if checkMoveOrAttack(key, "move") then
        news.closing = true
    end
end

function checkNewsMousePressed(button)
    if news.mouseOver.exit then
        news.exit.action()
    end
    if news.mouseOver.item > 0 then news.items[news.mouseOver.item].action() end
end

function drawGeneralButton(x, y, tab)

    local w, h, c = tab.w or 400, tab.h or 50, tab.c or 6
    local i = tab.i or 0
    if isMouseOver(x * scale, y * scale, w * scale, h * scale) then
        if tab.mouseOverColor then
            love.graphics.setColor(unpack(tab.mouseOverColor))
        else
            love.graphics.setColor(1, 0, 0, 0.8)
        end
        if tab.mouseFunc then
            tab.mouseFunc()
        end
        y = y - 2
    elseif tab.elseFunc and tab.elseFunc() then -- tab.page and tab.page.selected.item == i
        y = y - 2
        if tab.mouseOverColor then
            love.graphics.setColor(unpack(tab.mouseOverColor))
        else
            love.graphics.setColor(1, 0, 0, 0.8)
        end
    elseif tab.bgColor then
        love.graphics.setColor(unpack(tab.bgColor))
    else
        love.graphics.setColor(0, 0, 0, 0.8)
    end

    drawButtonBg(x, y, w, h, 6, tab.lineColor or {1, 1, 1, 1})

    if tab.text then
        if tab.textY and tab.textY == "bottom" then
            love.graphics.printf(tab.text, x + 15, y + h - getTextHeight(tab.text, w - 30, 3) - 4, (w - 30) / 3,
                tab.textX or "left", 0, 3)
        else
            love.graphics.printf(tab.text, x + 15, y + 18, (w - 30) / 3, tab.textX or "left", 0, 3)
        end
    end

    if tab.func then
        tab.func()
    end
end

function drawButtonBg(x, y, w, h, c, lineColor)
    love.graphics.rectangle("fill", x, y, w, h, c or 6)
    love.graphics.setLineWidth(2)
    if lineColor then
        love.graphics.setColor(unpack(lineColor))
    else
        love.graphics.setColor(1, 1, 1)
    end
    love.graphics.rectangle("line", x, y, w, h, c or 6)
end
