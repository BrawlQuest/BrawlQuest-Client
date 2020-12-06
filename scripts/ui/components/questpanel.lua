function drawQuestPanel(thisX, thisY)
    love.graphics.setFont(headerFont)
    thisX = thisX - questWidth
    -- if isMouseOver((thisX*scale)*0.5, (thisY*scale)*0.5, questWidth, (getQuestPanelDropDownHeight()*scale)*0.5) then
    --     drawQuestPanelDropDown(thisX, thisY, selectedQuest.title)
    -- end
    drawQuestPanelDropDown(thisX, thisY, selectedQuest.title)
    drawQuestPanelHeader(thisX, thisY)
end

function drawQuestPanelHeader(thisX, thisY)
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("fill", thisX, thisY, questWidth, 46)
    -- love.graphics.rectangle("fill", thisX+chatCorner:getHeight(), thisY+(46-chatCorner:getHeight()), questWidth-chatCorner:getHeight(), chatCorner:getHeight())
    -- love.graphics.draw(chatCorner, thisX, thisY+46, math.rad(-90))
    love.graphics.setColor(0,0,0,1)
    love.graphics.print("Quests", thisX+16, thisY+8)
    love.graphics.setColor(1,1,1,1)
end

function drawQuestPanelDropDown(thisX, thisY, title)

    love.graphics.setColor(0,0,0,0.8)
    love.graphics.rectangle("fill", thisX, thisY, questWidth, getQuestPanelDropDownHeight()-chatCorner:getHeight())
    love.graphics.draw(chatCorner, thisX, thisY+getQuestPanelDropDownHeight(), math.rad(-90))
    love.graphics.rectangle("fill", thisX+chatCorner:getHeight(), thisY+(getQuestPanelDropDownHeight()-chatCorner:getHeight()), questWidth-chatCorner:getHeight(), chatCorner:getHeight())
    drawQuestTitle(thisX, thisY, title)
    thisY = thisY + getQuestPanelTextHeight(title)+(5*2) + 42
    for i = 1, #selectedQuest do 
        
        love.graphics.printf(selectedQuest[i], thisX+20+20, thisY+20, questWidth-20-10-20, "left")
        
        love.graphics.draw(questSmallBoxTrue, thisX+10, thisY+20+5)
        thisY = thisY + getQuestPanelItemTextHeight(selectedQuest[i])+10
    end
    questHeight = thisY
end

function drawQuestTitle(thisX, thisY, title)
    love.graphics.setColor(1,0,0,0.8)
    local i = 20
    thisY = thisY + 42 + i
    local spacing = 5
    love.graphics.rectangle("fill", thisX, thisY-spacing, questWidth, getQuestPanelTextHeight(title)+(spacing*2))
    thisX = thisX + i 
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf(title, thisX, thisY, questWidth-i-10, "left")
    love.graphics.setColor(1,1,1,1)
end

function getQuestPanelTextHeight(text) -- gets the chat height for recalling stuff
	local width, lines = headerFont:getWrap( text, questWidth-30 )
 	return ((#lines)*(headerFont:getHeight()))+2
end

function getQuestPanelItemTextHeight(text) -- gets the chat height for recalling stuff
	local width, lines = headerFont:getWrap( text, questWidth-20-10-20 )
 	return ((#lines)*(headerFont:getHeight()))+2
end

function getQuestPanelDropDownHeight()
    return questHeight+chatCorner:getHeight()+5
end