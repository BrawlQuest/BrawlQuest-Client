function initOrders()
    orders = {
        open = true,
        amount = 1,
        selAmount = 0,
        w = 200,
        h = 380,
        fw = 200 * 3 + 20,
        fh = 380,

        title = "Choose an Order to join to get perks, unique items and to improve your order reputation. You can join a different Order at any time, but will lose all of your existing Reputation with your previous Order.",
        mouseOver = {
            item = 0,
        },
        selected = {
            item = 0,
        },
        items = {
            {
                title = "Mage",
                features = {"+50 INT", "2 exclusive spells", "Restricts access to medium/heavy armour and weapons",},
                image = love.graphics.newImage("assets/ui/orders/01.png"),
                action = function ()
                    print("LET ME DO SOMETHING 1")
                end,
                isMouse = false,
                amount = 0,
                redAlpha = 0,
            },{
                title = "Warrior",
                features = {"+50 STR", "Exclusive Medium armour set & mount", "Restricts access to heavy armour and high-mastery spells",},
                image = love.graphics.newImage("assets/ui/orders/02.png"),
                action = function ()
                    print("LET ME DO SOMETHING 2")
                end,
                isMouse = false,
                amount = 0,
                redAlpha = 0,
            },{
                title = "Stoic",
                features = {"+50 STA", "Exclusive Heavy armour set & mount", "Restricts access to heavy weapons and high-mastery spells",},
                image = love.graphics.newImage("assets/ui/orders/03.png"),
                action = function ()
                    print("LET ME DO SOMETHING 3")
                end,
                isMouse = false,
                amount = 0,
                redAlpha = 0,
            },
        },
    }
end

function updateOrders(dt)
    local o = orders
    for orderI, order in ipairs(orders.items) do
        if order.isMouse or o.selected.item == orderI then panelMovement(dt, order, 1, "amount", 4)
        else panelMovement(dt, order, -1, "amount", 4) end
        order.redAlpha = cerp(0,1,order.amount)
    end
    if o.open then panelMovement(dt, orders, 1, "amount", 3)
    else panelMovement(dt, orders, -1, "amount", 3) end

    if o.selected.item > 0 then panelMovement(dt, orders, 1, "selAmount", 2)
    else panelMovement(dt, orders, -1, "selAmount", 2) end
    o.selCerp = cerp(0,1,o.selAmount)
end

function drawOrders()
    local o = orders
    o.mouseOver.item = 0
    love.graphics.setFont(font)
    local x,y = uiX / 2 - o.fw / 2, uiY / 2 - o.fh / 2 - o.fh * o.selCerp
    for orderI, order in ipairs(orders.items) do drawOrderBox(x + (o.w + 10) * (orderI - 1), y, orderI, order) end
    love.graphics.setColor(1,1,1,(1-o.selCerp) * o.amount)
    love.graphics.printf(o.title, x, y - getTextHeight(o.title, o.fw, font, 2) - 20, o.fw / 2, "center", 0, 2)
    
    if o.selected.item > 0 or o.selAmount > 0 then
        dx,dy = x,y + o.fh + 10
        local order = o.items[o.selected.item]
        love.graphics.setColor(0,0,0,(0.8 * o.selAmount) * o.amount)
        love.graphics.rectangle("fill", dx, dy, o.fw, o.fh, 10)
    end
end

function drawOrderBox(x, y, orderI, order)
    local o = orders

    order.isMouse = isMouseOver(x * scale, y * scale, o.w * scale, o.h * scale)
    if order.isMouse then o.mouseOver.item = orderI end
    love.graphics.setColor(order.redAlpha, 0, 0, 0.8 * o.amount)
    y = y - 4 * order.redAlpha
    love.graphics.rectangle("fill", x, y, o.w, o.h, 10)
    if o.selected.item > 0 and o.selected.item ~= orderI then love.graphics.setColor(1,1,1, o.amount - 0.5 * o.selAmount)
    else love.graphics.setColor(1,1,1, o.amount) end

    love.graphics.draw(order.image, x, y)

    local dx, dy = x + 15, y + 140
    love.graphics.printf(order.title, dx, dy, 172 / 4, "center", 0, 4)
    dy = dy + font:getHeight() * 4 + 15
    local text = ""
    for i,v in ipairs(order.features) do text = text.."- "..v.."\n\n" end
    love.graphics.printf(text, dx, dy, 172/2, "left", 0, 2)
end

function checkOrdersKeyPressed(key)
    local o = orders
    if checkMoveOrAttack(key) then o.open = false end
end

function checkOrdersMousePressed(button)
    local o = orders
    if o.mouseOver.item > 0 then
        if o.selected.item == o.mouseOver.item then o.selected.item = 0
        else o.selected.item = o.mouseOver.item end
    end -- o.items[o.mouseOver.item].action() end
end