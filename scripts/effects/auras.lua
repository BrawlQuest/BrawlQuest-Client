auras = {}
auraParticles = {}
auraAuras = {} -- don't ask
auraColors = {
    HP = {1,0,0},
    INT = {0,0,1},
    LUCK = {1,1,0},
    ATK = {0.96, 0.52, 0.26}
}


function drawAuras()
    for i,v in ipairs(auraAuras) do
        if v.Stat == "HP" then
            love.graphics.setColor(1,0,0,0.2*v.alpha)
        elseif v.Stat == "INT" then
            love.graphics.setColor(0,0,1,0.2*v.alpha)
        elseif v.Stat == "LUCK" then
            love.graphics.setColor(1,1,0,0.2*v.alpha)
        elseif v.Stat == "ATK" then
            love.graphics.setColor(0.96, 0.52, 0.26, 0.2*v.alpha)
        elseif v.Stat == "STA" then
            love.graphics.setColor(0.4, 0.4, 0.4, 0.2*v.alpha)
        end
        local x,y = v.X*32, v.Y*32
        x = x +16
        y = y + 16

        love.graphics.circle("fill",x,y,v.width/2)
    end
    for i,v in ipairs(auraParticles) do
        love.graphics.setColor(1,1,1,v.alpha)
        love.graphics.draw(v.img, v.x, v.y)
    end 
end

function drawAuraHeadings()
    love.graphics.setColor(1,1,1,1)
    local x = (uiX-36)
    for i,v in ipairs(auras) do
        local img = getImgIfNotExist(v.Item.ImgPath)

        love.graphics.setColor(1,1,1)
        love.graphics.draw(img,x,4)
        if isMouseOver(x*scale,4*scale,32*scale,32*scale) then

            setTooltip(v.Stat, "Your "..v.Stat.." is being increased by "..v.Value.." for the next "..v.TimeLeft.." seconds")

        end
        x = x - 36
    end
end

function tickAuras()
   -- auraAuras = {}
    for i,v in ipairs(auras) do
        local img = getImgIfNotExist("assets/auras/"..v.Stat..".png")
        local x = v.X - v.Radius
        local y = v.Y - v.Radius
        auraAuras[#auraAuras+1] = {
            X = v.X,
            Y = v.Y,
            width = 0,
            Stat = v.Stat,
            alpha = 1,
            Radius = v.Radius,
            lightID =    Luven.addFlashingLight(16 + v.X * 32, 16 + v.Y * 32, auraColors[v.Stat], 2, 3)
        }
        while x < v.X + v.Radius do
            while y < v.Y + v.Radius do
                if love.math.random(1,10) == 1 then
                    auraParticles[#auraParticles+1] = {
                        x = x*32 + 16,
                        y = y*32 + 16,
                        xv = love.math.random(-32,32),
                        ox = x*32 + 16,
                        stat = v.Stat,
                        alpha = 2,
                        img =  getImgIfNotExist("assets/auras/"..v.Stat..".png"),
                        Radius = v.Radius
                    }
                
                end
                y = y + 1
            end
            x = x + 1
            y = v.Y - v.Radius
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
     
     
        if v.width > (32*(v.Radius*2)) then
            v.alpha = v.alpha - 0.7*dt
            v.width = v.width + 16*dt
        else
            v.width = v.width + (32*(v.Radius*2))*dt
            v.alpha = v.alpha - 0.4*dt
        end
        if v.alpha < 0 then
       --     Luven.removeLight(v.lightID)
            table.remove(auraAuras, i)
        else
            auraAuras[i] = v
        end
       
    end
end
