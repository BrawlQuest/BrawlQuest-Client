--[[
    The "characters" phase of login is for selecting a character
]]
local json = require("scripts.libraries.json")
local http = require("socket.http")

function drawCharactersPhase()
    love.graphics.setFont(headerFont)
    loginImageX, loginImageY = math.floor(love.graphics.getWidth() / 2 - (loginEntryImage:getWidth() / 2)),
    math.floor(love.graphics.getHeight() / 2 - (loginEntryImage:getHeight() / 2))
    love.graphics.draw(charactersEntryImage, loginImageX, loginImageY)

    for i = 1,3 do
        local thisX,thisY = loginImageX+32,loginImageY+240+((i-1)*48)
        love.graphics.setColor(1,1,1)
        if isMouseOver(thisX,thisY,buttonImage:getWidth(), buttonImage:getHeight()) then
            love.graphics.setColor(0.168,0.525,1)
        else
            love.graphics.setColor(1,1,1)
        end
        love.graphics.draw(buttonImage,thisX,thisY)
        love.graphics.setColor(1,1,1)
        if characters[i] ~= null then
            if isMouseOver(thisX,thisY,buttonImage:getWidth(), buttonImage:getHeight()) then
                love.graphics.draw(playerImg,thisX+25,thisY+3)
                love.graphics.setColor(1,1,1)
            else
                love.graphics.draw(playerImg,thisX+20,thisY+3)
                love.graphics.setColor(0,0,0)
            end
            
            love.graphics.printf(characters[i]["Name"],thisX+60,thisY+5,buttonImage:getWidth()-80,"center")
        else
            love.graphics.setColor(0,0,0)
            love.graphics.printf("NEW CHARACTER",thisX+20,thisY+5,buttonImage:getWidth()-20,"center")
        end
    end
end

function checkClickLoginPhaseCharacter(x,y)
    for i = 1,3 do
        local thisX,thisY = loginImageX+32,loginImageY+240+((i-1)*48)
        if isMouseOver(thisX,thisY, buttonImage:getWidth(), buttonImage:getHeight()) then
            if characters[i] ~= nil then
                username = characters[i]["Name"]
                local b = {}
                c, h = http.request{url = "http://167.172.62.97:8080/players/"..username, method="GET", source=ltn12.source.string(body), headers={["token"]=token}, sink=ltn12.sink.table(b)}
                local response = json:decode(b[1])
                player.x = response['Me']['X']
                player.y = response['Me']['Y']
                player.dx = player.x*32
                player.dy = player.y*32
                totalCoverAlpha = 2
                love.audio.play(awakeSfx)
                
                phase = "game"
                love.audio.stop( titleMusic )
            end
        end
    end
end
