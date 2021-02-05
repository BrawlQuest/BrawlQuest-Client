--[[
    These are the floating action numbers that appear when taking damage or giving damage
]]

floats = {}

function addFloat(x,y,text,color)
    floats[#floats+1] = {
        x = x,
        y = y,
        text = text,
        color = color,
        alpha = 3
    }
end

function drawFloats()
    for i,v in ipairs(floats) do
        local bgAlpha = 0.6
        if v.alpha < bgAlpha then
            bgAlpha = v.alpha
        end
        love.graphics.setColor(0,0,0,bgAlpha)
        roundRectangle("fill",v.x,v.y,32,12, 2)
        love.graphics.setColor(v.color[1],v.color[2],v.color[3],v.alpha)
        love.graphics.printf(v.text,v.x,v.y + 3,32,"center")
    end
    love.graphics.setColor(1,1,1,1)
end

function updateFloats(dt)
    for i,v in ipairs(floats) do
        v.y = v.y - 16*dt
        v.alpha = v.alpha - 2*dt
        if v.alpha < 0 then
            table.remove(floats,i)
        end
    end
end