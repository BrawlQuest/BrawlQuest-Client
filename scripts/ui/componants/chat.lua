--[[
    This file contains chat functions.
    It'll be replaced by Dan's chat later on
]]
--[[
    This file contains chat functions.
    It'll be replaced by Dan's chat later on
]]

chat = {}

function initChat()
	profilePic = love.graphics.newImage("assets/ui/hud/chat/profile.png")
	chatCorner = love.graphics.newImage("assets/ui/hud/chat/corner.png")
	chatHeight = 0
	playerName = "Danjoe"
	chatWidth = 200
	chatSpacing = 14

	messages = {}
	messages[1] = {username = "Danjoe", text = "Hello there you lovely people who keep me company at night just for the fun of it"}
	messages[2] = {username = "Anyone", text = "Heyyyyyyyy, Red is sus Red is sus Red is sus Red is sus Red is sus Red is sus, he's being super weird right now, so... please be kind to him"}
	messages[3] = {username = "Lord Squabulus", text = "I love a lot of thisd stuff"}
	messages[4] = {username = "Boyo", text = "I just wanna have a good time"}
	messages[5] = {username = "Danjoe", text = "I love sd stuff that has real love to\n\n\n\n\nit"}
end

function drawChatPanel(x, y) -- the function to recall it all
	love.graphics.setFont(font)
	for i = 1, tableLength(messages) do
		y = y - getFullChatHeight(messages[i].username, messages[i].text)
		drawChatbox(x-(chatWidth+130), y-30, messages[i].username, messages[i].text)
	end
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
