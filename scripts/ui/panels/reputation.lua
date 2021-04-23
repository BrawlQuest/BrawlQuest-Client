local t
function initReputation()
    reputation = {
        open = true,
        amount = 1,
        fw = 620,
        fh = 0,
        w = 540,
        h = 40,
        order = {title = "Stoic Order", rep = 23,},
        items = {
            {
                title = "Fish Slice",
                rep = love.math.random(-300,300),
                repName = "Legendary",
            },{
                title = "Big Bad Wolf",
                rep = love.math.random(-300,300),
                repName = "Legendary",
            },{
                title = "Fish Slice",
                rep = love.math.random(-300,300),
                repName = "Legendary",
            },{
                title = "Big Bad Wolf",
                rep = love.math.random(-300,300),
                repName = "Legendary",
            },{
                title = "Big Bad Wolf",
                rep = love.math.random(-300,300),
                repName = "Legendary",
            },{
                title = "Fish Slice",
                rep = love.math.random(-300,300),
                repName = "Legendary",
            },{
                title = "Big Bad Wolf",
                rep = love.math.random(-300,300),
                repName = "Legendary",
            },{
                title = "Big Bad Wolf",
                rep = love.math.random(-300,300),
                repName = "Legendary",
            },{
                title = "Fish Slice",
                rep = love.math.random(-300,300),
                repName = "Legendary",
            },{
                title = "Big Bad Wolf",
                rep = love.math.random(-300,300),
                repName = "Legendary",
            },
        },
    }
    t = reputation
    -- addScroller("reputation", 0, #t.items * (t.h + 10) + 160, boxMax, function () return reputation.open end)
end

function updateReputation(dt)
    
end

function drawReputation()
    local x,y = uiX/2 - t.fw/2 , 100
    local w,h = t.fw, uiY - 200
    love.graphics.setFont(chatFont)
    love.graphics.setColor(0,0,0,0.8)
    love.graphics.rectangle("fill", x, y, w, h, 10)
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("line", x, y, w, h, 10)

    love.graphics.print("Reputation", x + 40, y + 20, 0, 2)

    love.graphics.stencil(function ()
        roundRectangle("fill", x, y + 80, w, h - 80, 10, {false, false, true, true})
    end, "replace", 1) -- stencils inventory
    love.graphics.setStencilTest("greater", 0) -- push

    addScroller("reputation", 0, #t.items * (t.h + 10) + 160, h - 100)
    x, y = x + 40, y + 80 - scrollers.reputation.position

    -- love.graphics.setColor(1,1,1,0.7)
    -- love.graphics.line(x, y, x + t.w, y)

    drawOrderReputation(x, y)
    y = y + 150 + 10

    for i,v in ipairs(t.items) do
        drawReputationItem(i, v, x, y)
        y = y + t.h + 10
    end

    love.graphics.setStencilTest() -- pop
end

function drawOrderReputation(x, y)
    love.graphics.setColor(0,0,0,0.8)
    love.graphics.rectangle("fill", x, y, t.w, 150, 6)
    love.graphics.setColor(1,1,1)
end

function drawReputationItem(i, v, x, y)
    love.graphics.setColor(0,0,0,0.8)
    love.graphics.rectangle("fill", x, y, t.w, t.h, 6)

    local w, h = t.w, t.h
    local dx, dy = x, y
    local tab = {true, true, true, true}
    if v.rep < 0 then
        love.graphics.setColor(0.7,0,0)
        w = calcProgressBar(-v.rep, 300, t.w)
        dx = x + t.w - w
        tab = {false, true, true, false}
    elseif v.rep > 0 then
        love.graphics.setColor(0,0.7,0)
        tab = {true, false, false, true}
        w = calcProgressBar(v.rep, 300, t.w)
    end

    roundRectangle("fill",dx,dy,w,h,6,tab)
    love.graphics.setColor(1,1,1)
    love.graphics.print(v.title, x + 10, y + t.h/2 - chatFont:getHeight() * 0.5, 0, 1)
    love.graphics.printf(v.rep, x + 10, y + t.h/2 - chatFont:getHeight() * 0.5, t.w - 20, "right", 0, 1)
    love.graphics.printf(v.repName, x + 10, y + t.h/2 - chatFont:getHeight() * 0.5, t.w - 20 - 60, "right", 0, 1)
end

function checkReputationKeyPressed(key)

end

function checkReputationMousePressed(button)

end

function openReputation()
    --for each reputation thing, add to the rep.items table
    -- t.items = {}
    -- for each item in me.rep do
end

--[[
initReputation()
updateReputation(dt)
drawReputation()
if reputation.open then updateReputation(dt) end
if reputation.open then drawReputation() end
elseif reputation.open then checkReputationKeyPressed(key)
if reputation.open then checkReputationMousePressed(button) end
]]

function calcProgressBar(current, maximum, width) return current / (maximum / width) end