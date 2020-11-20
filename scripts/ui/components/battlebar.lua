function drawBattlebar(thisX, thisY)
    -- local thisX, thisY =  uiX/2, uiY
    if enemiesInAggro == 0 then
        battlebarPlayer(thisX-(battlebarBgnd:getWidth()/2), thisY)
    elseif enemiesInAggro > 0 then
        battlebarPlayer(thisX-(battlebarBgnd:getWidth()+5), thisY)
        battlebarEnemy(thisX+5, thisY, "Skellington", 39, 19)
    end
end

function battlebarPlayer(thisX, iy)
    local thisY = iy-battlebarBgnd:getHeight()
    love.graphics.draw(battlebarBgnd, thisX, thisY)
    drawProfilePic(thisX+10, thisY+10, 1, me.Name)
    --love.graphics.draw(profilePic, thisX+10, thisY+10)
    if me and me.Weapon then
        love.graphics.push()
        love.graphics.scale(2,2)
        drawCharacter(me,thisX+10, thisY+10)
        love.graphics.pop()
    end
    battlebarNameAndBars(thisX, thisY, player.name, player.hp, player.mhp)
    if me and me.Weapon and itemImg[me.Weapon.ImgPath] then
     battlebarItem(thisX-44, thisY+18, itemImg[me.Weapon.ImgPath], "+"..me.Weapon.Val)
    end
end

function battlebarItem(thisX, thisY, item, stats)
    love.graphics.draw(battlebarItemBg, thisX, thisY)
    love.graphics.draw(item, thisX+1, thisY+1)
    love.graphics.printf(stats, thisX, thisY+32, battlebarItemBg:getWidth(), "center")
end

function battlebarEnemy(thisX, iy, name, hp, mana)
    local thisY = iy-battlebarBgnd:getHeight()
    love.graphics.draw(battlebarBgnd, thisX, thisY)
    -- love.graphics.draw(profilePic, thisX+270, thisY+10)
    drawProfilePic(thisX+270, thisY+10, 1, "left", me.Name)
   -- drawCharacter(me,thisX+270, thisY+10)
    battlebarNameAndBars(thisX, thisY, name, hp, mana)
    battlebarItem(thisX+354, thisY+18, a3sword, "+3")
end

function battlebarNameAndBars(ix, iy, name, hp, mana)
    love.graphics.setColor(1,1,1,1)
    if name == player.name then
        thisX, thisY = ix+84, iy+36
        love.graphics.printf(player.name, thisX, iy+6, 250)
    else
        thisX, thisY = ix+10, iy+36
        love.graphics.printf(name, thisX, iy+6, 250, "right")
    end
    love.graphics.setColor(1,1,1,0.5)
    roundRectangle("fill", thisX, thisY, 250, 16, 2)
    roundRectangle("fill", thisX, thisY+22, 250, 16, 2)
    love.graphics.setColor(1,0,0,1)
    if name == player.name then
        if hp > 0 then 
            roundRectangle("fill", thisX, thisY, hp*2.5, 16, 2)
        end 
        
        love.graphics.setColor(0,0,1,1)
        if mana > 0 then 
            roundRectangle("fill", thisX, thisY+22, mana*2.5, 16, 2)
        end
    else
        if hp > 0 then 
            roundRectangle("fill", thisX+250, thisY, hp*-2.5, 16, 2)
        end 
        
        love.graphics.setColor(0,0,1,1)
        if mana > 0 then 
            roundRectangle("fill", thisX+250, thisY+22, mana*-1, 16, 2)
        end
    end
    
    love.graphics.setColor(1,1,1,1)
end