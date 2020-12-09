function love.keypressed(key)

    if phase == "login" then
        checkLoginKeyPressed(key)
    else
        if not isTypingInChat then
            if isWorldEditWindowOpen then
                checkEditWorldKeyPressed(key)
            elseif isSettingsWindowOpen then
                if key == "escape" then
                    isSettingsWindowOpen = false
                end
                if key == "return" then
                    love.event.quit()
                end
            else
                if key == "m" then
                    beginMounting()
                end
                checkTargeting()
                if key == "." then
                    scale = scale * 1.25
                    uiX = love.graphics.getWidth()/scale -- scaling options
                    uiY = love.graphics.getHeight()/scale
                end
                if key == "," then
                    scale = scale / 1.25
                    uiX = love.graphics.getWidth()/scale -- scaling options
                    uiY = love.graphics.getHeight()/scale
                end
                if key == keybinds.SHIELD then
                    shieldUpSfx:play()
                end
                if key == "escape" then                 
                    isSettingsWindowOpen = true
                    loadSliders()
                end
            end
            if key == "'" then
                if isWorldEditWindowOpen then isWorldEditWindowOpen = false else isWorldEditWindowOpen = true end
            elseif key == "space" and love.keyboard.isDown("lshift") then
                c, h = http.request{url = api.url.."/world", method="POST", source=ltn12.source.string(json:encode(pendingWorldChanges)), headers={["Content-Type"] = "application/json",["Content-Length"]=string.len(json:encode(pendingWorldChanges)),["token"]=token}}
                pendingWorldChanges = {}
                local b = {}
                c, h = http.request{url = api.url.."/world", method="GET", source=ltn12.source.string(body), headers={["token"]=token}, sink=ltn12.sink.table(b)}
                world = json:decode(b[1])
                createWorld()
            elseif key == "lctrl" then
                pendingWorldChanges[#pendingWorldChanges+1] = {
                    GroundTile = textfields[5],
                    ForegroundTile = textfields[6],
                    Name =  textfields[7],
                    Music = "*",
                    Collision = thisTile.Collision,
                    Enemy = textfields[8],
                    X = player.x + 0,
                    Y = player.y + 0,
                }
            elseif key == keybinds.INTERACT then
                startConversation()
             
            end
            if key == "q" then
                love.event.quit()
            end
        end
        checkKeyPressedChat(key)
    end
end

function love.keyreleased(key)
    if key == keybinds.SHIELD and not isTypingInChat then
        shieldDownSfx:play()
    end
end

function love.textinput(key)
    if phase == "login" then
        checkLoginTextinput(key)
    elseif isWorldEditWindowOpen and key ~= "'" then
        checkEditWorldTextinput(key)
    elseif isTypingInChat then
        checkChatTextinput(key)
    end
end