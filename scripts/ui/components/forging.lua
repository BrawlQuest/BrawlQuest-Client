
function initForging()
    forging = {
        open = true,
        amount = 1,
        w = 600,
        h = 400,
        r = 0,
        ra = 1,
        forging = false,
        forgeImg = love.graphics.newImage("assets/world/objects/Furnace.png"),
        font = crafting.font,
        mouseOver = {
            furnace = false,
        },
    }

end

function updateForging(dt)
    local f = forging
    if f.forging then
        f.ra = f.ra + 5 * dt
        if f.ra > 2 then f.ra = 0 end
        local offset = 4
        f.r = cerp(-offset, offset, f.ra)
    else f.r = 0 end
end

function drawForging()
    local f = forging
    local x,y = (uiX / 2), (uiY / 2)
    love.graphics.setFont(f.font)
    love.graphics.setColor(0,0,0,0.8)
    love.graphics.rectangle("fill", x - f.w / 2, y - f.h / 2, f.w, f.h, 10)
    love.graphics.setColor(1,1,1,1)

    love.graphics.push()
        love.graphics.translate(x + 100, y)
        love.graphics.rotate(math.rad(f.r))
        local offset = 0
        f.mouseOver.furnace = true
        if isMouseOver((x + 100 - 160) * scale, (y - 160) * scale, 320 * scale, 320 * scale) then
            offset = 3
            love.graphics.setColor(1, 0.5, 0.5)
            f.mouseOver.furnace = true
        else f.mouseOver.furnace = false end
        love.graphics.draw(f.forgeImg, -16 * 10, -16 * 10 - offset, 0, 10)
    love.graphics.pop()

    love.graphics.setColor(1,1,1,1)
    x,y = x - f.w / 2 + 10, y - f.h / 2 + 10
    love.graphics.print("FORGING", x + 10, y, 0, 4)

    y = y + f.font:getHeight() * 4
    love.graphics.print("Entered Ores", x + 10, y, 0, 3)

    x,y = uiX / 2 + f.w / 2, uiY / 2 - f.h / 2
    love.graphics.setColor(1,1,0)
    local minus = (f.font:getWidth("Press the furnace to forge!") ) / 2
    love.graphics.push()
        love.graphics.translate(x - 20, y + 20)
        love.graphics.rotate(math.rad(25))
        love.graphics.scale(3)
        love.graphics.print("Press the furnace to forge!", -f.font:getWidth("Press the furnace to forge!") / 2)
    love.graphics.pop()

end

function checkForgingKeyPressed(key)
    local f = forging
    if f.mouseOver.furnace then
        f.forging = true
        forgingSfx:play()
    end
    
    if checkMoveOrAttack(key) then f.open = false end
end

function checkForgingMousePressed(button)
    local f = forging
    if f.mouseOver.furnace then
        f.forging = true
        forgingSfx:play()
    end
end

--[[
initForging()
if forging.open then updateForging(dt) end
if forging.open then drawForging() end
if forging.open then checkForgingKeyPressed(key)
if forging.open then checkForgingMousePressed(button)
]]