lanterns = {}

function initLanterns()
    lanternImg = love.graphics.newImage("assets/world/objects/lantern.png")

    for i = 1, 8 do
        lanterns[i] = {
            x = love.math.random(0,love.graphics.getWidth()/32),
            y = love.math.random(0,love.graphics.getHeight()/32)
        }
        Luven.addNormalLight(16+lanterns[i].x*32,16+lanterns[i].y*32,{1,0.5,0}, 1)
    end
end

function drawLanterns()
    for i,v in ipairs(lanterns) do
        if isTileLit(v.x,v.y) then
            love.graphics.setColor(1,1,1)
        else
            love.graphics.setColor(0.2,0.2,0.2)
        end
        love.graphics.draw(lanternImg, v.x*32, v.y*32)
    end
end