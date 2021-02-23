--[[
    These are the floating action numbers that appear when taking damage or giving damage
]]

floats = {}

levelUp = {
    amount = 0,
    cerp = 0,
}
addingFloats = false
addedStats = {}

function addFloat(type,x,y,text,color, amount)
    if type == "level" then addingFloats = true end
    addedStats = {type,x,y,text,color, amount}
    addFloatFromTable(type,x,y,text,color, amount)
end

function addFloatFromTable(type,x,y,text,color, amount)
    amount = amount or 1
    local range = 32
    local thisX, thisY

    if type == "level" then
        thisX, thisY = player.dx + 16, player.dy + 16
    else
        thisX, thisY = x, y
    end
    
    for i = 1, amount do
        floats[#floats+1] = {
            type = type or "text",
            x = thisX,
            y = thisY,
            prevX = thisX,
            prevY = thisY,
            vx = love.math.random(-32, 32) * 4,
            vy = love.math.random(-32, 32) * 4,
            text = text or "",
            color = color or {1,1,1},
            colorChange = 0,
            changeSpeed = love.math.random(3, 15),
            direction = intToBool(love.math.random(0,1)),
            alpha = 3,
        }
    end
end

function intToBool(int)
    if int == 0 then return false else return true end
end

function drawFloats()
    for i,v in ipairs(floats) do
        if v.type == "text" then
            local bgAlpha = 0.6
            if v.alpha < bgAlpha then
                bgAlpha = v.alpha
            end
            love.graphics.setColor(0,0,0,bgAlpha)
            love.graphics.rectangle("fill",v.x,v.y,32,12, 2)
            love.graphics.setColor(v.color[1],v.color[2],v.color[3],v.alpha)
            love.graphics.printf(v.text, npcNameFont, v.x, v.y + 3, 32, "center")
        elseif v.type == "level" then
            love.graphics.setColor(v.color[1],v.color[2],v.color[3],v.alpha)
            love.graphics.draw(levelImg, v.x - levelImg:getWidth() * 0.5, v.y - levelImg:getHeight() * 0.5)
        end
    end
    love.graphics.setColor(1,1,1,1)
end

addFloatTick = 0
addFloatCount = 0

function updateFloats(dt)
    if addingFloats then
        addFloatTick = addFloatTick + 5 * dt
        if addFloatTick > 1 then
            addFloatCount = addFloatCount + 1
            addFloatTick = 0
            addFloatFromTable(unpack(addedStats))
            if addFloatCount >= 10 then
                addingFloats = false
                addFloatCount = 0
                addFloatTick = 0
            end
        end

        panelMovement(dt, levelUp, 1, "amount", 1)
        levelUp.cerp = cerp(0, 1, levelUp.amount)
    elseif levelUp.amount > 0 then
        panelMovement(dt, levelUp, -1, "amount", 1)
        levelUp.cerp = cerp(0, 1, levelUp.amount)
    end

    for i,v in ipairs(floats) do
        if v.type == "text" then
            v.y = v.y - 16 * dt
            v.alpha = v.alpha - 2*dt
            if v.alpha < 0 then
                table.remove(floats,i)
            end
        elseif v.type == "level" then
            v.alpha = v.alpha - 2 * dt
            if v.alpha < 0 then
                table.remove(floats,i)
            end

            v.colorChange = v.colorChange + 3 * dt
            v.color = {1, cerp(0, 0.6, v.colorChange), 0,}
            if v.colorChange > 2 then
                v.colorChange = 0
            end

            v.vx = v.vx - v.vx * dt
            v.vy = v.vy - v.vy * dt

            v.y = v.y - v.vy * dt 
            v.x = v.x - v.vx * dt 

            v.y = v.y - 30 * dt
            if v.vx < 1 then 
                if difference(v.prevX, v.x) < 10 then
                    if v.direction then
                        v.x = v.x + 10 * dt
                    else
                        v.x = v.x - 10 * dt
                    end
                else
                    v.direction = not v.direction
                    v.prevX = v.x
                end
            end
        end
    end
end