--[[
    This file contains chat functions.
    It'll be replaced by Dan's chat later on
]]

isTypingInChat = false -- this global will be used on other screens to ensure that movement isn't happening whilst chatting

function initChat()
    profilePic = love.graphics.newImage("assets/ui/hud/chat/profile.png")
	chatCorner = love.graphics.newImage("assets/ui/hud/chat/corner.png")
	chatHeight = 0
    chatWidth = 484
	chatSpacing = 14
	messages = {}
	enteredChatText = ""
	previousUsername = ""
end

function checkChatTextinput(key)
	if isTypingInChat then
		enteredChatText = enteredChatText .. key
	end
end

function drawChatPanel(thisX, thisY) -- the function to recall it all
	love.graphics.setFont(chatFont)
	local thisY = thisY - getEnterChatBoxHeight(enteredChatText)
	local chatEnterY = thisY
	local thisY = thisY + posYChat
	
	love.graphics.stencil(drawChatStencil, "replace", 1) -- stencils inventory
    love.graphics.setStencilTest("greater", 0) -- push

		for i = 1, #messages do -- the most important thing here
			thisY = thisY - getChatHeight(messages[i].username, messages[i].text, i)
			drawChatbox(thisX - (chatWidth+130), thisY, messages[i].username, messages[i].text,  messages[i].player, i)
			previousUsername = messages[i].username
		end

	love.graphics.setStencilTest() -- pop

	drawEnterChatBox(thisX - (chatWidth+130), chatEnterY, enteredChatText)
end

function getFullChatHeight()
	local height = 0
	for i = 1, #messages do
		height = height - getChatHeight(messages[i].username, messages[i].text, i)
		previousUsername = messages[i].username
	end
	return height * -0.5
end

function drawChatboxBackground(thisX, thisY, username, text)
	love.graphics.setColor(0,0,0,0.7)
	local width = getChatWidth(text)

	if username == me.Name then
		thisX = thisX + chatWidth - width
	end

	
	for i = 0, 1 do 
		love.graphics.draw(chatCorner, thisX + (i*width)+(i*(chatCorner:getWidth()*2)), thisY, math.rad(0+(i*90)))
		love.graphics.draw(chatCorner, thisX + (i*width)+(i*(chatCorner:getWidth()*2)), thisY + getChatTextHeight(text)+(chatCorner:getHeight()*2), math.rad(-90-(i*90)))
		love.graphics.rectangle("fill", thisX + chatCorner:getWidth(), thisY + (i*(getChatTextHeight(text)+chatCorner:getHeight())), width, chatCorner:getHeight()) -- background rectangle
	end
	love.graphics.rectangle("fill", thisX, thisY + chatCorner:getHeight(), width+(chatCorner:getWidth()*2), getChatTextHeight(text)) -- background rectangle

	love.graphics.setColor(1,1,1,1)
end

function drawChatboxText(thisX, thisY, text, orientation)
		love.graphics.printf(text, thisX + chatCorner:getHeight(), thisY + chatCorner:getHeight(), chatWidth, orientation)
end

function drawChatboxUsernameText(thisX, thisY, username)
	love.graphics.printf(username, thisX, thisY - 6, chatWidth+(chatCorner:getWidth()*2), "center")
end

function drawChatbox(thisX, thisY, username, text, player, i) 
	if i == 1 then
		drawChatboxProfilePic(thisX, thisY, username, text, player, i)
	elseif username == previousUsername then
		if username == me.Name then
			drawChatboxBackground(thisX, thisY, username, text, "right")
			drawChatboxText(thisX, thisY, text, "right")
		else
			local i = thisX + profilePic:getWidth()+8
			drawChatboxBackground(i, thisY, username, text, "left")
			drawChatboxText(i, thisY, text, "left")
		end
	else
		drawChatboxProfilePic(thisX, thisY, username, text, player, i)
	end
end

function drawChatboxProfilePic(thisX, thisY, username, text, player, i)
	if username == me.Name then
		drawProfilePic(thisX+chatWidth+(chatCorner:getWidth() * 2) + 8, getProfilePicY(thisY, text, username), 1, "left", me.Name, player)
		drawChatboxBackground(thisX, thisY, username, text, "right")
		drawChatboxText(thisX, thisY, text, "right")
	else
		local i = thisX + profilePic:getWidth()+8
		local j = thisY + chatFont:getHeight()
		drawProfilePic(thisX, getProfilePicY(thisY, text, username)+chatFont:getHeight(), 1, "right", username)
		drawChatboxBackground(i, thisY, username, text, "left")
		drawChatboxText(i, thisY, text, "left")
		love.graphics.setColor(1,1,1,1)
		love.graphics.printf(username, i+4, thisY + getChatTextHeight(text)+(chatCorner:getHeight()*2)+10, chatWidth+(chatCorner:getWidth()*2), "left")
		-- drawChatboxUsernameText(i, thisY + getProfilePicY(thisY, text), username)
	end
end

function getProfilePicY(thisY, text, username)
	if username == me.Name then
		return thisY-profilePic:getHeight()+getChatTextHeight(text)+(chatCorner:getHeight()*2)
	else
		return thisY-profilePic:getHeight()+getChatTextHeight(text)+(chatCorner:getHeight()*2)+10
	end
end

function getChatboxProfilePicHeight(username, text, i)
	if username == me.Name then 
		return (getChatTextHeight(text)+(chatCorner:getHeight()*2))+chatSpacing
	else
		return (getChatTextHeight(text)+(chatCorner:getHeight()*2)+chatFont:getHeight())+chatSpacing+10
	end
end

function getChatTextHeight(text) -- gets the chat height for recalling stuff
	local width, lines = chatFont:getWrap( text, chatWidth )
	if #lines >= 1 then
	 	return ((#lines)*(chatFont:getHeight()))+2
	else
		return chatFont:getHeight()+2
	end
end

function getChatHeight(username, text, i) -- gets the chat height for recalling stuff
	if i == 1 then
		return getChatboxProfilePicHeight(username, text, i)
	elseif	username == previousUsername then
		return (getChatTextHeight(text)+(chatCorner:getHeight()*2))--+chatSpacing
	else
		return getChatboxProfilePicHeight(username, text, i)
	end
	previousUsername = username
end

function getChatWidth(text)
	if chatFont:getWidth(text) > chatWidth then
		return chatWidth
	else
		return chatFont:getWidth(text)
	end
end

function drawEnterChatBox(thisX, thisY, text)
	local enterChatWidth = chatWidth + 90
	
	if isTypingInChat then
		-- if chatCursor.on then text = text .. "£" end
		text = text .. "£"
		love.graphics.setColor(1,1,1,1)
	else
		love.graphics.setColor(1,1,1,1)
		
		love.graphics.setColor(0,0,0,0.7)
	end
	
	for i = 0, 1 do 
		love.graphics.draw(chatCorner, thisX+(i*enterChatWidth)+(i*(chatCorner:getWidth()*2)), thisY, math.rad(0+(i*90)))
		love.graphics.draw(chatCorner, thisX+(i*enterChatWidth)+(i*(chatCorner:getWidth()*2)), thisY+getChatTextHeight(text)+(chatCorner:getHeight()*2), math.rad(-90-(i*90)))
		love.graphics.rectangle("fill", thisX+chatCorner:getWidth(), thisY+(i*(getChatTextHeight(text)+chatCorner:getHeight())), enterChatWidth, chatCorner:getHeight()) -- background rectangle
	end
	love.graphics.rectangle("fill", thisX, thisY+chatCorner:getHeight(), enterChatWidth+(chatCorner:getWidth()*2), getChatTextHeight(text)) -- background rectangle
	
	if isTypingInChat then love.graphics.setColor(0,0,0,1) else love.graphics.setColor(1,1,1,1) end

	love.graphics.printf(text, thisX+chatCorner:getHeight(), thisY+chatCorner:getHeight(), enterChatWidth, "left")
	love.graphics.setColor(1,1,1,1)
	if not isTypingInChat and text == "" then
		love.graphics.printf("Press Enter to Chat", thisX+chatCorner:getHeight(), thisY+chatCorner:getHeight(), enterChatWidth, "left")
	end
end

function getEnterChatBoxHeight(text)
	return (getChatTextHeight(text)+(chatCorner:getHeight()*2))+chatSpacing
end

function drawChatStencil()
	love.graphics.rectangle("fill",
		((uiX - 313)/0.5),
		((0)/0.5),
		((313)/0.5),
		((cerp(cerp(uiY ,uiY - 134 + 14, questHub.amount), uiY - ((uiY/1.25)+5), questsPanel.amount))/0.5)
	)
end

