function love.keypressed(key) 
    if phase == "login" then
        if loginPhase == "login" then
            checkLoginKeyPressedPhaseLogin(key)
        elseif loginPhase == "creation" then
            checkLoginKeyPressedPhaseCreation(key)
        elseif loginPhase == "characters" then
            checkLoginKeyPressedPhaseCharacters(key)
        end
        if key == "escape" then love.event.quit() end
    else
        if isWorldEditWindowOpen then
            if key == "backspace" then
                textfields[editingField] = string.sub(textfields[editingField], 1, string.len(textfields[editingField]) - 1)
            elseif key == "tab" or key == "return" then
                editingField = editingField + 1
            elseif key == "escape" or key == "'" then isWorldEditWindowOpen = false end
        elseif worldEdit.open then 
            checkWorldEditKeyPressed(key)
        elseif worldEdit.isTyping then
        elseif isSettingsWindowOpen then
            if key == "escape" or key == "w" or key == "a" or key == "s" or key == "d" then
                isSettingsWindowOpen = false
            end
            if key == "return" then
                checkIfReadyToQuit()
            end
        elseif isTypingInChat then
            if key == "backspace" then
                enteredChatText = string.sub( enteredChatText, 1, string.len( enteredChatText) - 1)
            elseif key == "return" and enteredChatText ~= "" then
                posYChat = 0
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
        elseif crafting.open then
            if key == keybinds.CRAFTING or key == "escape" then
                crafting.open = false
            end
        else
            -- if key == "m" then beginMounting() end
            checkTargeting()

            if key == "/" then
                table.remove(quests[1], 1)
            end

            if key == "return" and not isSettingsWindowOpen then isTypingInChat = true end

            if key == keybinds.SHIELD then shieldUpSfx:play() end

            if key == "escape" then                 
                isSettingsWindowOpen = true
                loadSliders()
            end

            if key == "'" or key == "r" then 
                -- getWorldInfo() 
                worldEdit.open = not worldEdit.open 
            end

            if key == keybinds.INTERACT then startConversation() end

            if (key == "i" or key == "q") then
                inventory.forceOpen = not inventory.forceOpen
            end

            if key == "e" and inventory.notNPC then
                questsPanel.forceOpen = not questsPanel.forceOpen
            end

            if key == keybinds.CRAFTING then
                crafting.open = true
            end

            if key == "b" and buddies[player.name] ~= null then
                print(buddies[player.name].img)
                chatXpos = -64
                chatOpacity = 0
                chatWritten = ""
                npcChat = {
                    Title = ":)",
                    ImgPath = buddies[player.name].img,
                    Options = {
                        {
                            "Woohoo!",
                            "1"
                        },
                    }
                }
                showNPCChatBackground = true
            end
        end
        
        if not isTypingInChat and not worldEdit.isTyping then
            if key == "l" then
                worldScale = worldScale * 0.5
                writeSettings()
            end
            
            if key == ";" then
                worldScale = worldScale * 2
                writeSettings()
            end

            if key == "." then
                scale = scale * 1.5
                uiX = love.graphics.getWidth()/scale -- scaling options
                uiY = love.graphics.getHeight()/scale
                writeSettings()
            end

            if key == "," then
                scale = scale * 0.75
                uiX = love.graphics.getWidth()/scale -- scaling options
                uiY = love.graphics.getHeight()/scale
                writeSettings()
            end
        end
    end
end

function love.keyreleased(key)
    if key == keybinds.SHIELD and not isTypingInChat and phase == "game" and not worldEdit.isTyping then
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
    elseif worldEdit.isTyping then
        checkWorldEditTextinput(key)
    end
end