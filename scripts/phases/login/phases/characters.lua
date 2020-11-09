--[[
    The "characters" phase of login is for selecting a character
]]
local json = require("scripts.libraries.json")
local http = require("socket.http")

characterSelected = 0

function drawCharactersPhase()
    love.graphics.setFont(headerFont)
    loginImageX, loginImageY = math.floor(love.graphics.getWidth() / 2 - (charactersEntryImage:getWidth() / 2)),
    math.floor(love.graphics.getHeight() / 2 - (charactersEntryImage:getHeight() / 2))
    love.graphics.draw(charactersEntryImage, loginImageX, loginImageY)
    love.graphics.setFont(headerBigFont)
    love.graphics.print("Choose Character", loginImageX+30, loginImageY+90)

    love.graphics.setFont(headerFont)
    love.graphics.print("Character Name", loginImageX+30, loginImageY+140)


    
    for i = 1,3 do
        local thisX,thisY = loginImageX+32,loginImageY+180+((i-1)*60)
        
        if isMouseOver(thisX,thisY,charactersButtonImage:getWidth(), charactersButtonImage:getHeight()) or characterSelected == i then
            love.graphics.setColor(0.168,0.525,1)
        else
            love.graphics.setColor(1,1,1)
        end
        love.graphics.draw(charactersButtonImage,thisX,thisY)

        love.graphics.setColor(1,1,1)
        if isMouseOver(thisX,thisY,charactersButtonImage:getWidth(), charactersButtonImage:getHeight()) or characterSelected == i then
            love.graphics.draw(playerImg,thisX+25,thisY+13)
            love.graphics.setColor(1,1,1)
        else
            love.graphics.draw(playerImg,thisX+20,thisY+13)
            love.graphics.setColor(0,0,0)
        end
        if characters[i] ~= null then
            love.graphics.printf(characters[i]["Name"],thisX+80,thisY+15,charactersButtonImage:getWidth()-80,"left")
        else
            love.graphics.printf("NEW CHARACTER",thisX+80,thisY+15,charactersButtonImage:getWidth()-80,"left")
        end
    end

    if characters[characterSelected] ~= null then
        drawLargeButton("ENTER WORLD", loginImageX+32, loginImageY+360)
    end
end

function checkClickLoginPhaseCharacter(x,y)
    for i = 1,3 do
        local thisX,thisY = loginImageX+32,loginImageY+180+((i-1)*60)
        if isMouseOver(thisX,thisY, charactersButtonImage:getWidth(), charactersButtonImage:getHeight()) then
            if characters[i] ~= null then
                characterSelected = i
            else
                newCharacterPosition = i

                loginPhase = "creation"
            end
        end
    end

    if isMouseOver(loginImageX+32, loginImageY+390, charactersButtonImage:getWidth(), charactersButtonImage:getHeight()) and characterSelected ~= 0 then
        transitionToPhaseGame()
    end
end

function transitionToPhaseGame()
    username = characters[characterSelected]["Name"]
    local b = {}
    c, h = http.request{url = api.url.."/players/"..username, method="GET", source=ltn12.source.string(body), headers={["token"]=token}, sink=ltn12.sink.table(b)}
    local response = json:decode(b[1])
    player.x = response['Me']['X']
    player.y = response['Me']['Y']
    player.dx = player.x*32
    player.dy = player.y*32
    totalCoverAlpha = 2
    local b = {}
    c, h = http.request{url = api.url.."/world", method="GET", source=ltn12.source.string(body), headers={["token"]=token}, sink=ltn12.sink.table(b)}
    world = json:decode(b[1])
 
    love.audio.play(awakeSfx)
    love.graphics.setBackgroundColor(0, 0, 0)
    phase = "game"
    love.audio.stop( titleMusic )
    createWorld()
end

function checkLoginKeyPressedPhaseCharacters(key)
   
    if characterSelected < 3 then
        if key == "down" then
            characterSelected = characterSelected + 1
        end
    end
    if characterSelected > 1 then
        if key == "up" then
            characterSelected = characterSelected - 1
        end
    end
    
    if characterSelected > 0 then
        if key == "return" then
            if characters[characterSelected] ~= null then
               transitionToPhaseGame() 
            else
                newCharacterPosition = characterSelected
                loginPhase = "creation"
            end
        end
    end
end
