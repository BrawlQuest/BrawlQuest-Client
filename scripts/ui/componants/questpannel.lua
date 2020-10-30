function drawQuestPannel(thisX, thisY)
    love.graphics.setFont(headerFont)
    thisX = thisX - questWidth
    -- if isMouseOver((thisX*scale)*0.5, (thisY*scale)*0.5, questWidth, (getQuestPannelDropDownHeight()*scale)*0.5) then
    --     drawQuestPannelDropDown(thisX, thisY, selectedQuest.title)
    -- end
    drawQuestPannelDropDown(thisX, thisY, selectedQuest.title)
    drawQuestPannelHeader(thisX, thisY)
end

function drawQuestPannelHeader(thisX, thisY)
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("fill", thisX, thisY, questWidth, 46)
    -- love.graphics.rectangle("fill", thisX+chatCorner:getHeight(), thisY+(46-chatCorner:getHeight()), questWidth-chatCorner:getHeight(), chatCorner:getHeight())
    -- love.graphics.draw(chatCorner, thisX, thisY+46, math.rad(-90))
    love.graphics.setColor(0,0,0,1)
    love.graphics.print("Quests", thisX+16, thisY+8)
    love.graphics.setColor(1,1,1,1)
end

function drawQuestPannelDropDown(thisX, thisY, title)

    love.graphics.setColor(0,0,0,0.8)
    love.graphics.rectangle("fill", thisX, thisY, questWidth, getQuestPannelDropDownHeight()-chatCorner:getHeight())
    love.graphics.draw(chatCorner, thisX, thisY+getQuestPannelDropDownHeight(), math.rad(-90))
    love.graphics.rectangle("fill", thisX+chatCorner:getHeight(), thisY+(getQuestPannelDropDownHeight()-chatCorner:getHeight()), questWidth-chatCorner:getHeight(), chatCorner:getHeight())
    drawQuestTitle(thisX, thisY, title)
    thisY = thisY + getQuestPannelTextHeight(title)+(5*2) + 42
    for i = 1, tableLength(selectedQuest) do 
        
        love.graphics.printf(selectedQuest[i], thisX+20+20, thisY+20, questWidth-20-10-20, "left")
        
        love.graphics.draw(questSmallBoxTrue, thisX+10, thisY+20+5)
        thisY = thisY + getQuestPannelItemTextHeight(selectedQuest[i])+10
    end
    questHeight = thisY
end

function drawQuestTitle(thisX, thisY, title)
    love.graphics.setColor(1,0,0,0.8)
    local i = 20
    thisY = thisY + 42 + i
    local spacing = 5
    love.graphics.rectangle("fill", thisX, thisY-spacing, questWidth, getQuestPannelTextHeight(title)+(spacing*2))
    thisX = thisX + i 
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf(title, thisX, thisY, questWidth-i-10, "left")
    love.graphics.setColor(1,1,1,1)
end

function getQuestPannelTextHeight(text) -- gets the chat height for recalling stuff
	local width, lines = headerFont:getWrap( text, questWidth-30 )
 	return ((#lines)*(headerFont:getHeight()))+2
end

function getQuestPannelItemTextHeight(text) -- gets the chat height for recalling stuff
	local width, lines = headerFont:getWrap( text, questWidth-20-10-20 )
 	return ((#lines)*(headerFont:getHeight()))+2
end

function getQuestPannelDropDownHeight()
    return questHeight+chatCorner:getHeight()+5
end