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
    love.graphics.print(player.cp, thisX+((mouseUp:getWidth()+spacing)*2)+14-(inventorySubHeaderFont:getWidth(perks.reserve)/2), thisY+5)
    love.graphics.setFont(headerTinyFont)
    love.graphics.print("available\npoints", thisX+((mouseUp:getWidth()+spacing)*2)+perksReserve:getWidth()+spacing, thisY+4)
    local thisY = thisY + 30
    for i = 1, 3 do
        if me[perkTitles[i]] then
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
            love.graphics.print(me[perkTitles[i]], thisX-(circleFont:getWidth(perks[i])/2)+34, thisY+14+27)
            love.graphics.setColor(1,1,1,1)
        end
    end  

    love.graphics.setFont(font)
end

function checkPerksMousePressed(button)
    local perkTitleWidth = 60
    local padding = 10
    local thisX, thisY = 70+padding, 50+padding
    for i = 1, 3 do
        local thisX = thisX + (perkTitleWidth*(i-1))
        if isMouseOver(thisX*scale, (thisY+14)*scale, 38*scale, 38*scale) then
            if player.cp > 0 and button == 1 then
                -- if selectedPerk == i then
                --     perks[i] = perks[i] + 1
                -- end
                -- perks.reserve = perks.reserve - 1
                c, h = http.request{url = api.url.."/stat/"..player.name.."/"..perkTitles[i], method="GET", headers={["token"]=token}}
		
            elseif button == 2 then 
                c, h = http.request{url = api.url.."/stat/"..player.name.."/"..perkTitles[i], method="DELETE", headers={["token"]=token}}
            end
        end
    end
end