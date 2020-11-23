function drawPerks()
     
    local perkTitleWidth = 60
    local padding = 10
    local spacing = 5
    local thisX, thisY = 70+padding, 0+padding
    love.graphics.draw(perksBg)
    love.graphics.setFont(inventorySubHeaderFont)
    love.graphics.printf("Character Perks", thisX, thisY, 180, "center")
    local thisY = thisY + 20
    love.graphics.draw(mouseUp, thisX, thisY)
    love.graphics.draw(mouseDown, thisX+mouseUp:getWidth()+spacing, thisY)
    love.graphics.draw(perksReserve, thisX+((mouseUp:getWidth()+spacing)*2), thisY)
    love.graphics.print(perks.reserve, thisX+((mouseUp:getWidth()+spacing)*2)+14-(inventorySubHeaderFont:getWidth(perks.reserve)/2), thisY+5)
    love.graphics.setFont(headerTinyFont)
    love.graphics.print("available\npoints", thisX+((mouseUp:getWidth()+spacing)*2)+perksReserve:getWidth()+spacing, thisY+4)
    local thisY = thisY + 30
    for i = 1, 3 do
        love.graphics.setFont(headerTinyFont)
        local thisX = thisX + (perkTitleWidth*(i-1))
        love.graphics.print(perkTitles[i], thisX-(headerTinyFont:getWidth(perkTitles[i])/2)+19, thisY)
        
        if isMouseOver(thisX*scale, (thisY+14)*scale, 38*scale, 38*scale) then
            love.graphics.setColor(0.6, 0.6, 0.6)
            selectedPerk = i
        end

        love.graphics.draw(perkImages[i], thisX, thisY+14)
        love.graphics.setColor(0,0,0,1)
        love.graphics.setFont(circleFont)
        love.graphics.print(perks[i], thisX-(circleFont:getWidth(perks[i])/2)+34, thisY+14+27)
        love.graphics.setColor(1,1,1,1)
    end

    love.graphics.setFont(font)
end

function checkPerksMousePressed(button)
    
    if isMouseOver(0,0,perksBg:getWidth()*scale,perksBg:getHeight()*scale) then
        if perks.reserve > 0 and button == 1 then
            if selectedPerk == 1 then
                perks[1] = perks[1] + 1
            elseif selectedPerk == 2 then
                perks[2] = perks[2] + 1
            elseif selectedPerk == 3 then
                perks[3] = perks[3] + 1
            end
            perks.reserve = perks.reserve - 1
        end

        if perks.reserve < perks.total then
            if button == 2 then
                if selectedPerk == 1 and perks[1] > 0 then
                    perks[1] = perks[1] - 1
                elseif selectedPerk == 2 and perks[2] > 0 then
                    perks[2] = perks[2] - 1
                elseif selectedPerk == 3 and perks[3] > 0 then
                    perks[3] = perks[3] - 1
                end
                perks.reserve = perks.reserve + 1
            end
        end
    end
end
