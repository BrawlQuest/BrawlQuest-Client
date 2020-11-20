--[[
    This file contains chat functions.
    It'll be replaced by Dan's chat later on
]]
--[[
    This file contains chat functions.
    It'll be replaced by Dan's chat later on
]]

function drawChatPanel(x, y) -- the function to recall it all
	love.graphics.setFont(font)
	local yChatEnter1 = y
	local y = y - getEnterChatBoxHeight(enteredChatText)
	local yChatEnter2 = y
	local y = y + posyChat
	for i = 1, tableLength(messages) do
		y = y - getFullChatHeight(messages[i].username, messages[i].text)
		drawChatbox(x-(chatWidth+130), y, messages[i].username, messages[i].text)
	end
	drawChatSendButton(x, yChatEnter1)
	drawEnterChatBox(x-(chatWidth+130), yChatEnter2, enteredChatText)
end

function drawChatboxBackground(x, y, text)
	love.graphics.setColor(0,0,0,0.5)
	for i = 0, 1 do 
		love.graphics.draw(chatCorner, x+(i*chatWidth)+(i*(chatCorner:getWidth()*2)), y, math.rad(0+(i*90)))
		love.graphics.draw(chatCorner, x+(i*chatWidth)+(i*(chatCorner:getWidth()*2)), y+getChatHeight(text)+(chatCorner:getHeight()*2), math.rad(-90-(i*90)))
		love.graphics.rectangle("fill", x+chatCorner:getWidth(), y+(i*(getChatHeight(text)+chatCorner:getHeight())), chatWidth, chatCorner:getHeight()) -- background rectangle
	end
	love.graphics.rectangle("fill", x, y+chatCorner:getHeight(), chatWidth+(chatCorner:getWidth()*2), getChatHeight(text)) -- background rectangle
	love.graphics.setColor(1,1,1,1)
end

function drawChatboxText(x, y, text)
	love.graphics.printf(text, x+chatCorner:getHeight(), y+chatCorner:getHeight(), chatWidth)
end

function drawChatboxUsernameText(x, y, username)
	love.graphics.printf(username, x, y-6, chatWidth+(chatCorner:getWidth()*2), "center")
end

function drawChatboxProfile(x, y)
	love.graphics.draw(profilePic, x, y)
end

function drawChatbox(x, y, username, text) -- TODO: If statement for different user modes
	if username == playerName then
		drawChatboxProfile(x+chatWidth+(chatCorner:getWidth()*2)+8, y)
		drawChatboxBackground(x, y, text)
		drawChatboxText(x, y, text)
	else
		-- more stuff needed
		local i = x+profilePic:getWidth()+8
		local j = y+font:getHeight()
		drawChatboxProfile(x, y)
		drawChatboxBackground(i, j, text)
		drawChatboxText(i, j, text)
		drawChatboxUsernameText(i, y, username)
	end
end

function getChatHeight(text) -- gets the chat height for recalling stuff
	local width, lines = font:getWrap( text, chatWidth )
 	return ((#lines)*(font:getHeight()))+2
end

function getFullChatHeight(username, text) -- gets the chat height for recalling stuff
	if username == playerName then
		if getChatHeight(text)+(chatCorner:getHeight()*2) < profilePic:getHeight() then
		    return (profilePic:getHeight())+chatSpacing
        end

		return (getChatHeight(text)+(chatCorner:getHeight()*2))+chatSpacing
		
	else
		if getChatHeight(text)+(chatCorner:getHeight()*2)+font:getHeight() < profilePic:getHeight() then
			return (profilePic:getHeight())+chatSpacing
        end
        
        return (getChatHeight(text)+(chatCorner:getHeight()*2)+font:getHeight())+chatSpacing
    
	end
end

function getChatWidth()
	return chatWidth+130
end

function drawEnterChatBox(thisX, thisY, text)
	drawChatboxBackground(thisX, thisY, text)
	drawChatboxText(thisX, thisY, text)
end

function getEnterChatBoxHeight(text)
	return (getChatHeight(text)+(chatCorner:getHeight()*2))+chatSpacing
end

function drawChatSendButton(x, y)
	local i = 45
	local j = 14
	roundRectangle("fill", x-i-j-26, y-i-j, i, i, 10)
end

function drawChatStencil()
	love.graphics.rectangle("fill", 70, toolbary+40, 180, 483)
end

