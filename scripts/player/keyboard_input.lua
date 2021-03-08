function love.keypressed(key) 
    if phase == "login" then
        if loginPhase == "prelaunch" then
            launch.inAmount = 1
            launch.outAmount = 1
            launch.outCERP = 1
            loginPhase = "loading"
            loginViaSteam()
            if key == "escape" and versionType == "dev" then love.event.quit() end
        elseif loginPhase == "login" or loginPhase == "loading" then
            if key == "escape" and versionType == "dev" then love.event.quit() end
            checkLoginKeyPressedPhaseLogin(key)
        elseif loginPhase == "dev" then
            if versionType == "dev" then
                devLogin(key)
            end
            if key == "left" or key == "a" then
                local originalID = steam.user.getSteamID()
                local str = tostring(originalID)
                if str ~= "nil" then
                    textfields[1] = str
                    textfields[2] = str
                    textfields[3] = str
                    login()
                end
            elseif key == "right" or key == "d" then
                loginPhase = "login"
            end
            if key == "escape" and versionType == "dev" then love.event.quit() end
        elseif loginPhase == "creation" then
            checkLoginKeyPressedPhaseCreation(key)
        elseif loginPhase == "characters" then
            checkCharacterSelectorKeyPressed(key)
        end
        if versionType == "dev" and key == "kpenter" then
            zoneChange("You did not login")
        end
    else
        if worldEdit.open then 
            checkWorldEditKeyPressed(key)
        elseif enchanting.open then checkEnchantingKeyPressed(key)
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
            checkNPCChatKeyPressed(key)
            if key == keybinds.INTERACT or key == "escape" or checkMoveOrAttack(key, "move") then 
                showNPCChatBackground = false
            end
        elseif crafting.open then
            checkCraftingKeyPressed(key)
            checkHotbarKeyPressed(key)
        else
            checkHotbarKeyPressed(key)
            checkTargetingPress(key)

            if key == "return" and not isSettingsWindowOpen then isTypingInChat = true end

            if key == keybinds.SHIELD then shieldUpSfx:play() end

            if key == "escape" then
                settPan.movement.x, settPan.movement.y = 0, 0 
                isSettingsWindowOpen = true
                loadSliders()
            end

            if key == "f" then
                enchanting.phase = 1
                enchanting.open = true
                enchanting.amount = 1
            end

            if key == "tab" then
                showHUD = not showHUD
                if not showHUD then zoneChange("UI Hidden. Press TAB to turn UI back on.", 2) end
                settings[3][1].v = showHUD
                writeSettings()
            end

            if key == "'" and versionType == "dev" then
                worldEdit.open = not worldEdit.open
            end

            if key == keybinds.INVENTORY and inventory.notNPC then
                inventory.forceOpen = not inventory.forceOpen
            end

            local nearbyAnvil = isNearbyTile("assets/world/objects/Anvil.png")

            if key == keybinds.QUESETS and not nearbyAnvil then
                questsPanel.forceOpen = not questsPanel.forceOpen
            end

            if key == keybinds.INTERACT then -- Hello Mr HackerMan! Removing the isNearbyTile will allow you to open the crafting menu from anywhere, but won't allow you to actually craft any items. Sorry! =(
                if nearbyAnvil then
                    getRecipesHeight()
                    crafting.open = true
                    steam.friends.setRichPresence("steam_display", "#StatusCrafting")
                    steam.friends.setRichPresence("location", zoneTitle.title)
                    -- inventory.notNPC = true
                else
                    startConversation()
                end
            end
        end
        
        if not worldEdit.isTyping and not isTypingInChat and versionType == "dev" then
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

local keys = {"UP", "DOWN", "LEFT", "RIGHT", "ATTACK_UP", "ATTACK_DOWN", "ATTACK_LEFT", "ATTACK_RIGHT",}
function checkMoveOrAttack(key, type)
    local push, pop = 1, 8
    if type then
        if type == "move" then
            push, pop = 1, 4
        elseif type == "attack" then
            push, pop = 4, 8
        end
    end
    local output = false
    if key == "escape" then return true end
    for i = push, pop do
        if key == keybinds[keys[i]] then
            output = true
            break
        end
    end
    return output
end