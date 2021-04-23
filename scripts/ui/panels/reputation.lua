local t
function initReputation()
    reputation = {
        open = false,
        amount = 0,
        fw = 600,
        fh = 0,
        w = 560,
        h = 40,
        order = {title = "Stoic Order", rep = 23,},
        images = {
            ["Mage Order"] = love.graphics.newImage("assets/ui/reputation/01.png"),
            ["Warrior Order"] = love.graphics.newImage("assets/ui/reputation/02.png"),
            ["Stoic Order"] = love.graphics.newImage("assets/ui/reputation/03.png"),
        },
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
    local x,y = math.floor(uiX/2 - t.fw/2) , 100
    local w,h = t.fw, uiY - 200
    love.graphics.setFont(font)
    love.graphics.setColor(0,0,0,0.8)
    love.graphics.rectangle("fill", x, y, w, h, 10)
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf("REPUTATION", x + 20, y + 20, t.w/6, "center", 0, 6)

    love.graphics.stencil(function ()
        roundRectangle("fill", x, y + 80, w, h - 80, 10, {false, false, true, true})
    end, "replace", 1) -- stencils inventory
    love.graphics.setStencilTest("greater", 0) -- push

        local offset = 0
        if me.Order and me.Order ~= "" then offset = 160 end
        addScroller("reputation", 0, #t.items * (t.h + 15) + offset, h - 100)
        x, y = x + 20, y + 80 - scrollers.reputation.position

        if me and me.Order and me.Order ~= "" then
            drawOrderReputation(x, y)
            y = y + 150 + 15
        end

        for i,v in ipairs(t.items) do
            drawReputationItem(v, x, y, t.w, t.h)
            y = y + t.h + 15
        end

    love.graphics.setStencilTest() -- pop
end

function drawOrderReputation(x, y)
    love.graphics.setColor(0,0,0,0.8)
    love.graphics.rectangle("fill", x, y, t.w, 150, 6)
    love.graphics.setColor(1,1,1)
    if t.images[me.Order] then love.graphics.draw(t.images[me.Order], x, y, 0, 1) end
    love.graphics.print(me.Order, x + t.w * 0.4, y + 10, 0, 4)
    drawReputationItem(t.order, x + t.w * 0.4, y + 110, t.w * 0.6 - 10, 30)
end

function drawReputationItem(v, x, y, dw, dh)

    dw, dh = dw or t.w, dh or t.h
    love.graphics.setColor(0,0,0,0.8)
    love.graphics.rectangle("fill", x, y, dw, dh, 6)

    local w, h = dw, dh
    local dx, dy = x, y
    local tab = {true, true, true, true}
    if v.rep < 0 then
        love.graphics.setColor(0.7,0,0,0.8)
        w = calcProgressBar(-v.rep, 300, dw)
        dx = x + dw - w
        tab = {false, true, true, false}
    elseif v.rep > 0 then
        love.graphics.setColor(0,0.7,0,0.8)
        tab = {true, false, false, true}
        w = calcProgressBar(v.rep, 300, dw)
    end
    roundRectangle("fill",dx,dy,w,h,6,tab)
    local ts = 2
    dx,dy = x + 10, y + dh/2 - (font:getHeight() * ts) * 0.4
    love.graphics.setColor(1,1,1)
    love.graphics.print(v.title, dx, dy, 0, ts)
    love.graphics.printf(v.rep, dx, dy, (dw - 20) / ts, "right", 0, ts)
    love.graphics.printf(v.repName, dx, dy, (dw - 20 - 60) / ts, "right", 0, ts)
end

function checkReputationKeyPressed(key)
    if checkMoveOrAttack(key) then t.open = false end
end

function checkReputationMousePressed(button)

end

function openReputation()
    --for each reputation thing, add to the rep.items table
    -- t.items = {}
    -- for each item in me.rep do
    t.open = true
    Reputation = {
        {
            ID = 1,
            PlayerID = 2,
            Faction = "Mage Order",
            Value = 82
        },{
            ID = 1,
            PlayerID = 2,
            Faction = "Stoic Order",
            Value = 23
        },{
            ID = 1,
            PlayerID = 2,
            Faction = "Warrior Order",
            Value = 23
        },{
            ID = 1,
            PlayerID = 2,
            Faction = "Love Budddies",
            Value = 51
        },{
            ID = 1,
            PlayerID = 2,
            Faction = "Fish Slice",
            Value = 250
        },{
            ID = 1,
            PlayerID = 2,
            Faction = "Personal Order",
            Value = -270
        },
    }

    t.items = {}

    for i,v in ipairs(Reputation) do
        local repName, repNumber = getRepInfo(v.Value)
        if v.Faction == me.Order then t.order = {title = v.Faction, rep = v.Value,}
            t.order = {
                title = v.Faction,
                rep = v.Value,
                repName = repName,
                repNumber = repNumber,
            }
        elseif not orCalc(v.Faction, {"Mage Order", "Warrior Order", "Stoic Order",}) then
            t.items[#t.items+1] = {
                title = v.Faction,
                rep = v.Value,
                repName = repName,
                repNumber = repNumber,
            }
        end
    end
end

function getRepInfo(rep)
    if rep <= -200 then return "Cursed", -4
    elseif rep <= -125 then return "Detested", -3
    elseif rep <= -50 then return "Shunned", -2
    elseif rep <= -10 then return "Disliked", -1
    elseif rep <= 10 then return "Neutral", 0
    elseif rep <= 50 then return "Friendly", 1
    elseif rep <= 125 then return "Praised", 2
    elseif rep <= 200 then return "Revered", 3
    elseif rep <= 300 then return "Exalted", 4
    end
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

function calcProgressBar(current, maximum, width) return math.clamp(0, current / (maximum / width), width) end