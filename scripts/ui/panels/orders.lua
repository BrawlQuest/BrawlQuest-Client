function initOrders()
    orders = {
        open = true,
        amount = 1,
        w = 200,
        h = 380,
        fw = 200 * 3 + 20,
        fh = 380,

        items = {
            {
                title = "Mage Order",
                features = {"+50 INT", "2 exclusive spells", "Restricts access to medium/heavy armour and weapons",},
                image = love.graphics.newImage("assets/ui/orders/01.png"),
            },{
                title = "Warrior Order",
                features = {"+50 STR", "Exclusive Medium armour set & mount", "Restricts access to heavy armour and high-mastery spells",},
                image = love.graphics.newImage("assets/ui/orders/02.png"),
            },{
                title = "Stoic Order",
                features = {"+50 STA", "Exclusive Heavy armour set & mount", "Restricts access to heavy weapons and high-mastery spells",},
                image = love.graphics.newImage("assets/ui/orders/03.png"),
            },
        },
    }
end

function updateOrders(dt)
    local o = orders
end

function drawOrders()
    local o = orders
    local x,y = (uiX / 2 - o.fw / 2), (uiY / 2 - o.fh / 2)
    for orderI, order in ipairs(orders.items) do drawOrderBox(x + (o.w + 10) * (orderI - 1), y, orderI, order) end
end

function drawOrderBox(x, y, orderI, order)
    local o = orders
    love.graphics.setColor(0,0,0,0.8)
    love.graphics.rectangle("fill", x, y, o.w, o.h, 10)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(order.image, x, y)
end

function checkOrdersKeyPressed(key)
    local o = orders
end

function checkOrdersMousePressed(button)
    local o = orders
end

--[[
initOrders()
updateOrders(dt)
drawOrders()
if orders.open then updateOrders(dt) end
if orders.open then drawOrders() end
elseif orders.open then checkOrdersKeyPressed(key)
if orders.open then checkOrdersMousePressed(button) end
]]