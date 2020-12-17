function drawQuestPopUp(thisX, thisY)
    if player.x ~= null then
        if player.x == 4 and player.y == 1 then 
            drawQuestPopUpProfile(thisX, thisY)
            drawQuestPopUpQuest(thisX, thisY)
        else 
            --print("X: "..player.x.." Y: "..player.y.." ")
        end
    end
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
    local paddingX, paddingY = 25, 25
    local spacing = 10
    thisX, thisY = (thisX-questPopUpWidth)-(questPopUpPanelGap/2), thisY-(questPopUpHeight/2)
    drawQuestPopUpBackground(thisX, thisY)
    drawProfilePic(thisX+(questPopUpWidth/2)-64, thisY+paddingY, 2, "right", me.Name)
    love.graphics.setFont(headerBigFont)
    thisY = thisY+128+paddingY+spacing
    love.graphics.printf(selectedQuest.npcName, thisX+paddingX, thisY, questPopUpWidth-(paddingX*2))
    thisY = thisY+getTitleHeight(selectedQuest.npcName, questPopUpWidth-(paddingX*2))+spacing
    love.graphics.setFont(font)
    love.graphics.printf(selectedQuest.npcDialogue, thisX+paddingX, thisY, questPopUpWidth-(paddingX*2))
end

function drawQuestPopUpQuest(thisX, thisY)
    
    local paddingX, paddingY = 25, 20
    local spacing = 10
    thisX, thisY = thisX+(questPopUpPanelGap/2), thisY-(questPopUpHeight/2)
    local otherX, otherY = thisX, thisY
    drawQuestPopUpBackground(thisX, thisY)
    love.graphics.setFont(headerMediumFont)
    love.graphics.printf(selectedQuest.title, thisX+paddingX, thisY+paddingY, questPopUpWidth-(paddingX*2))
    thisY = thisY+getMediumTitleHeight(selectedQuest.title, questPopUpWidth-(paddingX*2))+spacing
    love.graphics.setFont(font)
    for i = 1, #selectedQuest do 
        love.graphics.printf(i .. ". " .. selectedQuest[i], thisX+paddingX, thisY+paddingY, questPopUpWidth-(paddingX*2), "left")
        thisY = thisY + getTextHeight(i .. ". " .. selectedQuest[i], questPopUpWidth-(paddingX*2))+spacing
    end
    local thisX, thisY = otherX+(questPopUpWidth/2)-(buttonBacking:getWidth()/2), otherY+questPopUpHeight-buttonBacking:getHeight()-paddingY
    drawQuestPopUpButton(thisX, thisY, "Decline", "red")
    local thisX, thisY = otherX+(questPopUpWidth/2)-(buttonBacking:getWidth()/2), otherY+questPopUpHeight-buttonBacking:getHeight()-paddingY-spacing-buttonBacking:getHeight()
    drawQuestPopUpButton(thisX, thisY, "Accept", "blue")
end

function drawQuestPopUpButton(thisX, thisY, text, color)
    if color == "red" then
        love.graphics.setColor(1,0.1,0.1,1)
    elseif color == "blue" then
        love.graphics.setColor(0.1,0.1,1,1)
    end
    love.graphics.draw(buttonBacking, thisX, thisY)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(buttonOutline, thisX, thisY)
    love.graphics.printf(text, thisX, thisY+8, buttonBacking:getWidth(), "center")
end

function getTitleHeight(text, width)
	local width, lines = headerBigFont:getWrap(text, width)
 	return ((#lines)*(headerBigFont:getHeight()))+2
end

function getMediumTitleHeight(text, width)
	local width, lines = headerMediumFont:getWrap(text, width)
 	return ((#lines)*(headerBigFont:getHeight()))+2
end

-- function getTextHeight(text, width)
-- 	local width, lines = font:getWrap(text, width)
--  	return ((#lines)*(font:getHeight()))+2
-- end