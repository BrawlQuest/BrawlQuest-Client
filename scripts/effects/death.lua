function initDeath()
    death = {
        open = false,
        amount = 0,
        previousPosition = {x = 0, y = 0}
    }
end

function updateDeath(dt)
    panelMovement(dt, death, 1, "amount", 0.4)
    local x = cerp(death.previousPosition.x * 32, player.x * 32, death.amount)
    player.cx = x
    player.dx = x
    local y = cerp(death.previousPosition.y * 32, player.y * 32, death.amount)
    player.cy = y
    player.dy = y

    worldMask.opacity = 0.6 * (death.amount * death.amount)
    worldMask.opacity2 = 0.8 * (death.amount * death.amount)
    if death.amount >= 1 then
        death.open = false
        death.amount = 0
    end
end

function drawDeath()
    love.graphics.setColor(1,0,0,cerp(0.7, 0, death.amount))
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end