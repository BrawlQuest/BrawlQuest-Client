function love.keypressed(key) 
    if phase == "login" then
        if loginPhase == "prelaunch" then
            launch.inAmount = 1
            launch.outAmount = 1
            launch.outCERP = 1
            loginPhase = "login"
            loginViaSteam()
          
            -- love.audio.stop(titleMusicFade)
            -- love.audio.play(titleMusic)
            if key == "escape" then love.event.quit() end
        elseif loginPhase == "login" then
            if key == "escape" then love.event.quit() end
            checkLoginKeyPressedPhaseLogin(key)
        elseif loginPhase == "creation" then
            checkLoginKeyPressedPhaseCreation(key)
        elseif loginPhase == "characters" then
            checkCharacterSelectorKeyPressed(key)
            -- checkLoginKeyPressedPhaseCharacters(key)
        end
        -- if key == "escape" then love.event.quit() end
    else
        if worldEdit.open then 
            checkWorldEditKeyPressed(key)
        elseif worldEdit.isTyping then
        elseif isSettingsWindowOpen then
            checkSettingKeyPressed(key)
        elseif controls.currentKeybind > 0 then
        elseif tutorialOpen then
            checkTutorialKeyPressed(key)
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
            if key == keybinds.INTERACT or key == "escape" then
                crafting.open = false
                crafting.enteredItems = {}
                crafting.craftableItems = {}
                crafting.craftable = false
                crafting.selectedField = {i = 0, j = 0}
            end
        else
            checkInventoryKeyPressed(key)
            checkTargetingPress(key)

            if key == "return" and not isSettingsWindowOpen then isTypingInChat = true end

            if key == keybinds.SHIELD then shieldUpSfx:play() end

            if key == "escape" then
                settPan.movement.x, settPan.movement.y = 0, 0 
                isSettingsWindowOpen = true
                loadSliders()
            end

            if key == "tab" then
                showHUD = not showHUD
                settings[3][1].v = showHUD
                writeSettings()
            end

            if key == "'" and versionType == "dev" then
                worldEdit.open = not worldEdit.open
            end

            if key == keybinds.INTERACT then startConversation() end

            if key == keybinds.INVENTORY and inventory.notNPC then
                inventory.forceOpen = not inventory.forceOpen
            end

            local nearbyAnvil = isNearbyTile("assets/world/objects/Anvil.png")

            if key == keybinds.QUESETS and not nearbyAnvil then
                questsPanel.forceOpen = not questsPanel.forceOpen
            end

            if key == keybinds.INTERACT and nearbyAnvil then -- Hello Mr HackerMan! Removing the isNearbyTile will allow you to open the crafting menu from anywhere, but won't allow you to actually craft any items. Sorry! =(
                crafting.open = true
                -- inventory.notNPC = true
            end
        end
        
        if not isTypingInChat and not worldEdit.isTyping then
            if key == "." then
                scaleHUD("up")
                writeSettings()
            end

            if key == "," then
                scaleHUD("down")
                writeSettings()
            end
        end
    end

    if key == "p" and love.keyboard.isDown("lgui") and versionType == "dev" then
        love.event.quit()
    end
end

function love.keyreleased(key)
    if key == keybinds.SHIELD and not isTypingInChat and phase == "game" and not worldEdit.isTyping then
        shieldDownSfx:play()
    end
    if phase == "game" and (key == keybinds.ATTACK_UP or key == keybinds.ATTACK_DOWN or key == keybinds.ATTACK_LEFT or key == keybinds.ATTACK_RIGHT) then
        tutorialQuickTriggers.attack.active = true
        checkTargetingRelease(key)
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