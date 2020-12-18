keybinds = {
    UP = "w",
    DOWN = "s",
    LEFT = "a",
    RIGHT = "d",
    ATTACK_UP = "up",
    ATTACK_DOWN = "down",
    ATTACK_LEFT = "left",
    ATTACK_RIGHT = "right",
    SHIELD = "lshift",
    INTERACT = "e"
}

function love.keypressed(key) 
    if phase == "login" then
        if loginPhase == "login" then
            checkLoginKeyPressedPhaseLogin(key)
        elseif loginPhase == "creation" then
            checkLoginKeyPressedPhaseCreation(key)
        elseif loginPhase == "characters" then
            checkLoginKeyPressedPhaseCharacters(key)
        end
    else
        if key == "q" then love.event.quit() end
        if isWorldEditWindowOpen then
            if key == "backspace" then
                textfields[editingField] = string.sub(textfields[editingField], 1, string.len(textfields[editingField]) - 1)
            elseif key == "tab" or key == "return" then
                editingField = editingField + 1
            elseif key == "escape" or key == "'" then isWorldEditWindowOpen = false end
        elseif isSettingsWindowOpen then
            if key == "escape" or key == "w" or key == "a" or key == "s" or key == "d" then
                isSettingsWindowOpen = false
            end
            if key == "return" then
                love.event.quit()
            end
        elseif isTypingInChat then
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
                if not chatRepeat then isTypingInChat = false end
            elseif key == "escape" or (key == "return" and enteredChatText == "") then 
                isTypingInChat = false
            end
        elseif showNPCChatBackground then
            if key == keybinds.INTERACT or key == "escape" then showNPCChatBackground = false end
        else
            -- if key == "m" then beginMounting() end
            checkTargeting()

            if key == "/" then
                table.remove(quests[1], 1)
            end

            if key == "return" and not isSettingsWindowOpen then
                isTypingInChat = true
            end

            if key == keybinds.SHIELD then
                shieldUpSfx:play()
            end

            if key == "escape" then                 
                isSettingsWindowOpen = true
                loadSliders()
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
        end
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
    end
end

function love.keyreleased(key)
    if key == keybinds.SHIELD and not isTypingInChat and phase == "game" then
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