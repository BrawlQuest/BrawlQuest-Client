local t
function initReputation()
    reputation = {
        open = true,
        amount = 1,
        fw = 620,
        fh = 0,
        w = 540,
        h = 60,
        items = {
            {
                title = "Fish Slice",
                rep = love.math.random(-150,150),
            },{
                title = "Big Bad Wolf",
                rep = love.math.random(-150,150),
    
            },{
                title = "Fish Slice",
                rep = love.math.random(-150,150),
            },{
                title = "Big Bad Wolf",
                rep = love.math.random(-150,150),
    
            },{
                title = "Big Bad Wolf",
                rep = love.math.random(-150,150),
    
            },{
                title = "Fish Slice",
                rep = love.math.random(-150,150),
            },{
                title = "Big Bad Wolf",
                rep = love.math.random(-150,150),
    
            },{
                title = "Big Bad Wolf",
                rep = love.math.random(-150,150),
    
            },{
                title = "Fish Slice",
                rep = love.math.random(-150,150),
            },{
                title = "Big Bad Wolf",
                rep = love.math.random(-150,150),
    
            },
        },
    }
    t = reputation
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

    love.graphics.print("Reputation", x + 20, y + 10, 0, 2)



    love.graphics.stencil(function ()
        roundRectangle("fill", x, y + 70, w, h - 70, 10, {false, false, true, true})
    end, "replace", 1) -- stencils inventory
    love.graphics.setStencilTest("greater", 0) -- push

    x, y = x + 40, y + 80

    love.graphics.setColor(1,1,1,0.7)
    love.graphics.line(x, y, x + t.w, y)

    for i,v in ipairs(t.items) do
        drawReputationItem(i, v, x, y)
        y = y + t.h
    end

    love.graphics.setStencilTest() -- pop
end

function drawReputationItem(i, v, x, y)
    love.graphics.setColor(1,1,1,0.7)
    love.graphics.line(x, y + t.h, x + t.w, y + t.h)

    love.graphics.setColor(1,1,1)
    love.graphics.print(v.title, x + 10, y + t.h/2 - chatFont:getHeight() * 0.5, 0, 1)

    if v.rep > 0 then love.graphics.setColor(0,1,0)
    elseif v.rep < 0 then love.graphics.setColor(1,0,0) end

    love.graphics.printf(v.rep, x + 10, y + t.h/2 - chatFont:getHeight() * 0.5, t.w - 20, "right", 0, 1)

end

function checkReputationKeyPressed(key)

end

function checkReputationMousePressed(button)

end

function openReputation()
    
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