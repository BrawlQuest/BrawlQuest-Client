function drawBattlebar(thisX, thisY)
    -- local thisX, thisY =  uiX/2, uiY
    if enemiesInAggro == 0 then
        battlebarPlayer(thisX-(battlebarBgnd:getWidth()/2), thisY)
    elseif enemiesInAggro > 0 then
        battlebarPlayer(thisX-(battlebarBgnd:getWidth()+3), thisY)
        battlebarEnemy(thisX+3, thisY, "Skellington", 39, 19)
    end
end

function battlebarPlayer(thisX, iy)
    local thisY = iy-battlebarBgnd:getHeight()
    love.graphics.draw(battlebarBgnd, thisX, thisY)
    love.graphics.draw(profilePic, thisX+10, thisY+10)
    battlebarNameAndBars(thisX, thisY, player.displayName, player.hp, player.mhp)
end

function battlebarEnemy(thisX, iy, name, hp, mana)
    local thisY = iy-battlebarBgnd:getHeight()
    love.graphics.draw(battlebarBgnd, thisX, thisY)
    love.graphics.draw(profilePic, thisX+270, thisY+10)
    battlebarNameAndBars(thisX, thisY, name, hp, mana)
end

function battlebarNameAndBars(ix, iy, name, hp, mana)
    if name == player.displayName then
        thisX, thisY = ix+84, iy+36
        love.graphics.printf(player.displayName, thisX, iy+6, 250)
    else
        thisX, thisY = ix+10, iy+36
        love.graphics.printf(name, thisX, iy+6, 250, "right")
    end

    love.graphics.setColor(1,1,1,1)
    roundRectangle("fill", thisX, thisY, 250, 16, 2)
    roundRectangle("fill", thisX, thisY+22, 250, 16, 2)

    love.graphics.setColor(1,0,0,1)
    roundRectangle("fill", thisX, thisY, hp*2.5, 16, 2)
    love.graphics.setColor(0,0,1,1)
    roundRectangle("fill", thisX, thisY+22, mana*2.5, 16, 2)
    love.graphics.setColor(1,1,1,1)
end