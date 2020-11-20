function drawQuestPopUp(thisX, thisY)

    drawQuestPopUpProfile(thisX, thisY)
    drawQuestPopUpQuest(thisX, thisY)
    --love.graphics.rectangle("fill", thisX-(questPopUpWidth/2), thisY-(questPopUpHeight/2), 335, 496)
end

function drawQuestPopUpBackground(thisX, thisY)
    love.graphics.setColor(0,0,0,0.7)
    love.graphics.rectangle("fill", thisX, thisY+chatCorner:getWidth(), questPopUpWidth, questPopUpHeight-(chatCorner:getHeight()*2))
    for i = 0, 1 do 
		love.graphics.draw(chatCorner, thisX+((i*questPopUpWidth)), thisY, math.rad(0+(i*90)))
		love.graphics.draw(chatCorner, thisX+((i*questPopUpWidth)), thisY+(questPopUpHeight-(chatCorner:getHeight()*2))+(chatCorner:getHeight()*2), math.rad(-90-(i*90)))
		love.graphics.rectangle("fill", thisX+chatCorner:getWidth(), thisY+(i*((questPopUpHeight-(chatCorner:getHeight()*2))+chatCorner:getHeight())), questPopUpWidth-(chatCorner:getHeight()*2), chatCorner:getHeight()) -- background rectangle
    end
    love.graphics.setColor(1,1,1,1)
end

function drawQuestPopUpProfile(thisX, thisY)
    thisX, thisY = (thisX-questPopUpWidth)-(questPopUpPanelGap/2), thisY-(questPopUpHeight/2)
    drawQuestPopUpBackground(thisX, thisY)
end

function drawQuestPopUpQuest(thisX, thisY)
    thisX, thisY = thisX+(questPopUpPanelGap/2), thisY-(questPopUpHeight/2)
    drawQuestPopUpBackground(thisX, thisY)
end

