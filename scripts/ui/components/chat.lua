--[[
    This file contains chat functions.
    It'll be replaced by Dan's chat later on
]]

isTypingInChat = false -- this global will be used on other screens to ensure that movement isn't happening whilst chatting

function initChat()
    profilePic = love.graphics.newImage("assets/ui/hud/chat/profile.png")
	chatCorner = love.graphics.newImage("assets/ui/hud/chat/corner.png")
	chatHeight = 0
    chatWidth = 400
	chatSpacing = 14

	messages = {}


	enteredChatText = ""
	previousUsername = ""
end

function checkChatMousePressed() 
	-- if isMouseOver((uiX-48)*(scale),(uiY-32)*(scale), 45*(scale),45*(scale)) then
	-- 	chatData = {
	-- 		["PlayerName"] = "Pebsie",
	-- 		["Channel"] = "Global",
	-- 		["Message"] = enteredChatText,
	-- 		["Created"] = os.time(os.date("!*t"))
	-- 	}

	-- 	c, h = http.request{url = api.url.."/chat", method="POST", source=ltn12.source.string(json:encode(chatData)), headers={["Content-Type"] = "application/json",["Content-Length"]=string.len(json:encode(chatData)),["token"]=token}}
	 
	-- 	enteredChatText = ""
	-- end
end

function checkKeyPressedChat(key) 
	if key == "return" then
		if not isTypingInChat then
			isTypingInChat = true
		elseif enteredChatText ~= "" then
			chatData = {
				["PlayerName"] = me.Name,
				["Channel"] = "Global",
				["Message"] = enteredChatText,
				["Created"] = os.time(os.date("!*t"))
			}
	
			c, h = http.request{url = api.url.."/chat", method="POST", source=ltn12.source.string(json:encode(chatData)), headers={["Content-Type"] = "application/json",["Content-Length"]=string.len(json:encode(chatData)),["token"]=token}}
		 
			enteredChatText = ""
			isTypingInChat = false
		end
	elseif key == "backspace" and isTypingInChat then
        enteredChatText = string.sub( enteredChatText, 1, string.len( enteredChatText) - 1)
	end
end

function checkChatTextinput(key)
	if isTypingInChat then
		enteredChatText = enteredChatText .. key
	end
end

function drawChatPanel(x, y) -- the function to recall it all
	love.graphics.setFont(font)
	local yChatEnter1 = y
	local y = y - getEnterChatBoxHeight(enteredChatText)
	local yChatEnter2 = y
	local y = y + posyChat
	
	for i = 1, tableLength(messages) do
		y = y - getFullChatHeight(messages[i].username, messages[i].text, i)
		drawChatbox(x-(chatWidth+130), y, messages[i].username, messages[i].text,  messages[i].player, i)
		previousUsername = messages[i].username
	end
	-- drawChatSendButton(x, yChatEnter1)
	drawEnterChatBox(x-(chatWidth+130), yChatEnter2, enteredChatText)
end

function drawChatboxBackground(x, y, text)
	love.graphics.setColor(0,0,0,0.7)
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

function drawChatbox(x, y, username, text, player, i) 
	if i == 1 then
		if username == me.Name then
			drawProfilePic(x+chatWidth+(chatCorner:getWidth()*2)+8, y, 1, "left", username, player)
			drawChatboxBackground(x, y, text)
			drawChatboxText(x, y, text)
		else
			local i = x+profilePic:getWidth()+8
			local j = y+font:getHeight()
			drawProfilePic(x, y, 1, "right")
			drawChatboxBackground(i, j, text)
			drawChatboxText(i, j, text)
			drawChatboxUsernameText(i, y, username)
		end

	elseif	username == previousUsername then
		if username == me.Name then
			-- drawProfilePic(x+chatWidth+(chatCorner:getWidth()*2)+8, y, 1, "left", username, player)
			drawChatboxBackground(x, y, text)
			drawChatboxText(x, y, text)
		else
			local i = x+profilePic:getWidth()+8
			drawChatboxBackground(i, y, text)
			drawChatboxText(i, y, text)
		end
	elseif username == me.Name then
		drawProfilePic(x+chatWidth+(chatCorner:getWidth()*2)+8, y, 1, "left", username, player)
		drawChatboxBackground(x, y, text)
		drawChatboxText(x, y, text)
	else
		local i = x+profilePic:getWidth()+8
		local j = y+font:getHeight()
		drawProfilePic(x, y, 1, "right")
		drawChatboxBackground(i, j, text)
		drawChatboxText(i, j, text)
		drawChatboxUsernameText(i, y, username)
	end
end

function getChatHeight(text) -- gets the chat height for recalling stuff
	local width, lines = font:getWrap( text, chatWidth )
	if #lines >= 1 then
	 	return ((#lines)*(font:getHeight()))+2
	else
		return font:getHeight()+2
	end
end

function getFullChatHeight(username, text, i) -- gets the chat height for recalling stuff
	if i == 1 then
		if username == me.Name then 
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
	elseif	username == previousUsername then
		return (getChatHeight(text)+(chatCorner:getHeight()*2))--+chatSpacing
	elseif username == me.Name then
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
	previousUsername = username
end

function getChatWidth()
	return chatWidth+130
end

function drawEnterChatBox(thisX, thisY, text)
	local enterChatWidth = chatWidth + 90
	
	if isTypingInChat then
		if chatCursor.on then text = text .. "|" end
		love.graphics.setColor(1,1,1,1)
	else
		love.graphics.setColor(1,1,1,1)
		
		love.graphics.setColor(0,0,0,0.7)
	end
	
	

	-- love.graphics.setColor(0,0,0,0.7)
	for i = 0, 1 do 
		love.graphics.draw(chatCorner, thisX+(i*enterChatWidth)+(i*(chatCorner:getWidth()*2)), thisY, math.rad(0+(i*90)))
		love.graphics.draw(chatCorner, thisX+(i*enterChatWidth)+(i*(chatCorner:getWidth()*2)), thisY+getChatHeight(text)+(chatCorner:getHeight()*2), math.rad(-90-(i*90)))
		love.graphics.rectangle("fill", thisX+chatCorner:getWidth(), thisY+(i*(getChatHeight(text)+chatCorner:getHeight())), enterChatWidth, chatCorner:getHeight()) -- background rectangle
	end
	love.graphics.rectangle("fill", thisX, thisY+chatCorner:getHeight(), enterChatWidth+(chatCorner:getWidth()*2), getChatHeight(text)) -- background rectangle
	
	love.graphics.setColor(0,0,0,1)
	love.graphics.printf(text, thisX+chatCorner:getHeight(), thisY+chatCorner:getHeight(), enterChatWidth)
	love.graphics.setColor(1,1,1,1)
	if not isTypingInChat then
		love.graphics.printf("press enter to chat", thisX+chatCorner:getHeight(), thisY+chatCorner:getHeight(), enterChatWidth)
	end
end

function getEnterChatBoxHeight(text)
	return (getChatHeight(text)+(chatCorner:getHeight()*2))+chatSpacing
end

-- function drawChatSendButton(x, y)
-- 	i = 45
-- 	j = 14
-- 	roundRectangle("fill", x-i-j-26, y-i-j, 45, 45,  10)
-- end

function drawChatStencil()
	love.graphics.rectangle("fill", 70, toolbary+40, 180, 483)
end

