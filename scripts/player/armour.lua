function initArmour()
    armour = {
        leather = {
            HeadArmour =  love.graphics.newImage("assets/player/animations/leather/head.png"),
            ChestArmour = love.graphics.newImage("assets/player/animations/leather/chest.png"),
            LegArmour =  love.graphics.newImage("assets/player/animations/leather/legs.png"),
        },
        studded = {
            HeadArmour =  love.graphics.newImage("assets/player/animations/studded/head.png"),
            ChestArmour = love.graphics.newImage("assets/player/animations/studded/chest.png"),
            LegArmour =  love.graphics.newImage("assets/player/animations/studded/legs.png"),
        },
    }
end

function drawAnimatedArmourImage(v,type,x,y,dir,frame)
-- if v[type.."ID"] and v[type.."ID"] ~= 0 then
    if v.RedAlpha then love.graphics.setColor(1, 1-v.RedAlpha, 1-v.RedAlpha) else love.graphics.setColor(1, 1, 1) end
    if v.Invulnerability >= 0 then love.graphics.setColor(1,1,1,0.3)
    else love.graphics.setColor(1,1,1) end
    drawAnimatedItem(v, type, x, y, dir, frame)
    if v[type] and v[type].Enchantment ~= "None" then
        love.graphics.push()
            love.graphics.stencil(function()
                love.graphics.setShader(alphaShader)
                drawAnimatedItem(v, type, x, y, dir, frame)
                love.graphics.setShader()
            end)
            drawEnchantment(x - 16 * dir, y)
        love.graphics.pop()
    end
    -- end
end

function drawAnimatedItem(v, type, x, y, dir, frame)
    if string.find(v[type].Name, "Leather") then
        love.graphics.draw(armour.leather[type], baseImages[frame], x, y, 0, dir, 1)
    elseif string.find(v[type].Name, "Studded") then
        love.graphics.draw(armour.studded[type], baseImages[frame], x, y, 0, dir, 1)
    elseif string.find(v[type].Name, "Robe") then
        
    end
end