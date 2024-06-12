auras = {}
auraParticles = {}
auraAuras = {} -- don't ask
previousAuras = {}
auraColors = {
    HP = {1,0,0},
    INT = {0,0,1},
    LUCK = {1,1,0},
    ATK = {0.96, 0.52, 0.26},
    DEF = {0.4, 0.4, 0.4},
    Bone = {0,0.8,0}
}


function drawAuras()
    love.graphics.setBlendMode("add")
    for i,v in ipairs(auraAuras) do
        if v.stat == "HP" then
            love.graphics.setColor(1,0,0,0.3 * v.alpha)
        elseif v.stat == "INT" then
            love.graphics.setColor(0,0,1,0.2 * v.alpha)
        elseif v.stat == "LUCK" then
            love.graphics.setColor(1,1,0,0.1 * v.alpha)
        elseif v.stat == "ATK" then
            love.graphics.setColor(0.96, 0.52, 0.26, 0.2 * v.alpha)
        elseif v.stat == "DEF" then
            love.graphics.setColor(0.4, 0.4, 0.4, 0.6 * v.alpha)
        elseif v.stat == "Bone" then
            love.graphics.setColor(0, 0.8, 0, 0.6 * v.alpha)
        end
        local x,y = v.x*32, v.y*32
        x = x +16
        y = y + 16

        love.graphics.circle("fill",x,y,v.width/2)
    end
    love.graphics.setBlendMode("alpha")
    for i,v in ipairs(auraParticles) do
        love.graphics.setColor(1,1,1,v.alpha * 0.5)
        love.graphics.draw(v.img, v.x, v.y)
    end
end

function drawAuraHeadings()
    love.graphics.setColor(1,1,1,1)
    local x = (uiX-256-36)
    for i,v in ipairs(auras) do
        local img = getImgIfNotExist(v.item.imgpath)

        love.graphics.setColor(1,1,1)
        love.graphics.draw(img,x,4)
        if isMouseOver(x*scale,4*scale,32*scale,32*scale) then
            setTooltip(v.stat, "Your "..v.stat.." is being increased by "..v.value.." for the next "..v.timeLeft.." seconds")
        end
        x = x - 36
    end
end

function tickAuras()
    for i,v in ipairs(auras) do
        local img = getImgIfNotExist("assets/auras/"..v.stat..".png")
        local x = v.x - v.radius
        local y = v.y - v.radius
        auraAuras[#auraAuras+1] = {
            x = v.x,
            y = v.y,
            width = 0,
            stat = v.stat,
            alpha = 1,
            radius = v.radius,
            lightID = Luven.addNormalLight(16 + v.x * 32, 16 + v.y * 32, auraColors[v.stat], 2),
            hasBurst = false,
            expanding = true,
            maxWidth = 0,
            amount = 0,
        }
        while x < v.x + v.radius do
            while y < v.y + v.radius do
                if love.math.random(1,10) == 1 and distanceToPoint(x, y, v.x, v.y) < v.radius then
                    auraParticles[#auraParticles+1] = {
                        x = x*32 + 16,
                        y = y*32 + 16,
                        xv = love.math.random(-32,32),
                        ox = x*32 + 16,
                        stat = v.stat,
                        alpha = 2,
                        img =  getImgIfNotExist("assets/auras/"..v.stat..".png"),
                        radius = v.radius
                    }
                end
                y = y + 1
            end
            x = x + 1
            y = v.y - v.radius
        end
    end
end

function updateAuras(dt)
    for i,v in ipairs(auraParticles) do
        v.y = v.y - 8*dt
        v.x = v.x + v.xv*dt
        if v.x > v.ox+8 then
            v.xv = love.math.random(-32,-8)
        elseif v.x < v.ox-8 then
            v.xv = love.math.random(8,32)
        end
        v.alpha = v.alpha - 1*dt
        if v.alpha < 0 then
            table.remove(auraParticles, i)
        else
            auraParticles[i] = v
        end
    end

    for i,v in ipairs(auraAuras) do
        if not v.hasBurst then -- and nextTick and lastTick then
            v.width = cerp(0, (32*(v.radius*2)), 1 - nextTick)
            v.width = v.width + (32*(v.radius*2)) * dt
            if 1 - nextTick >= (1 - lastTick) * 0.8 then
                v.hasBurst = true
                v.maxWidth = v.width
            end
        else
            v.width = cerp(v.maxWidth, v.maxWidth - (32 * v.radius) / 2, v.amount)
            v.amount = v.amount + 1 * dt
        end

     --   Luven.setLightPower(v.lightID, Luven.getLightPower(v.lightID)-1*dt)

        v.alpha = v.alpha - 0.3 * dt

        if v.alpha < 0 then
            Luven.removeLight(v.lightID) 
            table.remove(auraAuras, i)
        end
    end
end
