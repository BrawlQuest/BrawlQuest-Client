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

function checkKeyPressedChat(key) 
	if isTypingInChat then
		if key == "backspace" then
			enteredChatText = string.sub( enteredChatText, 1, string.len( enteredChatText) - 1)
		elseif key == "return" and enteredChatText ~= "" then
			chatData = {
				["PlayerName"] = me.Name,
				["Channel"] = "Global",
				["Message"] = enteredChatText,
				["Created"] = os.time(os.date("!*t"))
			}
			c, h = http.request{url = api.url.."/chat", method="POST", source=ltn12.source.string(json:encode(chatData)), headers={["Content-Type"] = "application/json",["Content-Length"]=string.len(json:encode(chatData)),["token"]=token}}
			enteredChatText = ""
		elseif key == "escape" then 
			isTypingInChat = false
			enteredChatText = ""
		end
	else
		if key == "return" then
			isTypingInChat = true
		end
	end
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
	local thisY = thisY + posyChat
	
	for i = 1, tableLength(messages) do -- the most important thing here
		thisY = thisY - getFullChatHeight(messages[i].username, messages[i].text, i)
		drawChatbox(thisX - (chatWidth+130), thisY, messages[i].username, messages[i].text,  messages[i].player, i)
		previousUsername = messages[i].username
	end

	drawEnterChatBox(thisX - (chatWidth+130), chatEnterY, enteredChatText)
end

function drawChatboxBackground(thisX, thisY, text)
	love.graphics.setColor(0,0,0,0.7)
	for i = 0, 1 do 
		love.graphics.draw(chatCorner, thisX + (i*chatWidth)+(i*(chatCorner:getWidth()*2)), thisY, math.rad(0+(i*90)))
		love.graphics.draw(chatCorner, thisX + (i*chatWidth)+(i*(chatCorner:getWidth()*2)), thisY + getChatHeight(text)+(chatCorner:getHeight()*2), math.rad(-90-(i*90)))
		love.graphics.rectangle("fill", thisX + chatCorner:getWidth(), thisY + (i*(getChatHeight(text)+chatCorner:getHeight())), chatWidth, chatCorner:getHeight()) -- background rectangle
	end
	love.graphics.rectangle("fill", thisX, thisY + chatCorner:getHeight(), chatWidth+(chatCorner:getWidth()*2), getChatHeight(text)) -- background rectangle
	love.graphics.setColor(1,1,1,1)
end

function drawChatboxText(thisX, thisY, text)
	love.graphics.printf(text, thisX + chatCorner:getHeight(), thisY + chatCorner:getHeight(), chatWidth)
end

function drawChatboxUsernameText(thisX, thisY, username)
	love.graphics.printf(username, thisX, thisY - 6, chatWidth+(chatCorner:getWidth()*2), "center")
end

function drawChatbox(thisX, y, username, text, player, i) 
	if i == 1 then
		if username == me.Name then
			drawProfilePic(thisX+chatWidth+(chatCorner:getWidth()*2)+8, y, 1, "left", username, player)
			drawChatboxBackground(thisX, y, text)
			drawChatboxText(thisX, y, text)
		else
			local i = thisX + profilePic:getWidth()+8
			local j = y+chatFont:getHeight()
			drawProfilePic(thisX, y, 1, "right")
			drawChatboxBackground(i, j, text)
			drawChatboxText(i, j, text)
			drawChatboxUsernameText(i, y, username)
		end

	elseif username == previousUsername then
		if username == me.Name then
			drawChatboxBackground(thisX, y, text)
			drawChatboxText(thisX, y, text)
		else
			local i = thisX + profilePic:getWidth()+8
			drawChatboxBackground(i, y, text)
			drawChatboxText(i, y, text)
		end
	elseif username == me.Name then
		drawProfilePic(thisX + chatWidth+(chatCorner:getWidth()*2)+8, y, 1, "left", username, player)
		drawChatboxBackground(thisX, y, text)
		drawChatboxText(thisX, y, text)
	else
		local i = thisX+profilePic:getWidth()+8
		local j = y+chatFont:getHeight()
		drawProfilePic(thisX, y, 1, "right")
		drawChatboxBackground(i, j, text)
		drawChatboxText(i, j, text)
		drawChatboxUsernameText(i, y, username)
	end
end

function getChatHeight(text) -- gets the chat height for recalling stuff
	local width, lines = chatFont:getWrap( text, chatWidth )
	if #lines >= 1 then
	 	return ((#lines)*(chatFont:getHeight()))+2
	else
		return chatFont:getHeight()+2
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
			if getChatHeight(text)+(chatCorner:getHeight()*2)+chatFont:getHeight() < profilePic:getHeight() then
				return (profilePic:getHeight())+chatSpacing
			end
			
			return (getChatHeight(text)+(chatCorner:getHeight()*2)+chatFont:getHeight())+chatSpacing	
		end
	elseif	username == previousUsername then
		return (getChatHeight(text)+(chatCorner:getHeight()*2))--+chatSpacing
	elseif username == me.Name then
		if getChatHeight(text)+(chatCorner:getHeight()*2) < profilePic:getHeight() then
		    return (profilePic:getHeight())+chatSpacing
        end

		return (getChatHeight(text)+(chatCorner:getHeight()*2))+chatSpacing
		
	else
		if getChatHeight(text)+(chatCorner:getHeight()*2)+chatFont:getHeight() < profilePic:getHeight() then
			return (profilePic:getHeight())+chatSpacing
        end
        
        return (getChatHeight(text)+(chatCorner:getHeight()*2)+chatFont:getHeight())+chatSpacing
		
	end
	previousUsername = username
end

function getChatWidth()
	return chatWidth+130
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
		love.graphics.printf("Press Enter to Chat", thisX+chatCorner:getHeight(), thisY+chatCorner:getHeight(), enterChatWidth)
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

