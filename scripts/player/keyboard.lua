function love.keypressed(key)
    if phase == "login" then
        if loginPhase == "prelaunch" then checkLoginKeyPressedPhasePrelaunch(key)
        elseif loginPhase == "login" or loginPhase == "loading" then checkLoginKeyPressedPhaseLogin(key)
        elseif loginPhase == "dev" then devLogin(key)
        elseif loginPhase == "creation" then checkLoginKeyPressedPhaseCreation(key)
        elseif loginPhase == "characters" then checkCharacterSelectorKeyPressed(key)
        end
    elseif phase == "game" then
        checkKeyPressedPhaseGame(key)
        if not worldEdit.isTyping and not isTypingInChat and versionType == "dev" then
            if key == "." then scaleHUD("up") writeSettings() end
            if key == "," then scaleHUD("down") writeSettings() end
        end
    end
end

function checkKeyPressedPhaseGame(key)
    showMouse = false
    if worldEdit.open then checkWorldEditKeyPressed(key)
    elseif forging.open then checkForgingKeyPressed(key)
    elseif challenges.open then checkChallengesKeyPressed(key)
    elseif enchanting.open then checkEnchantingKeyPressed(key)
    elseif worldEdit.isTyping then
    elseif isSettingsWindowOpen then checkSettingKeyPressed(key)
    elseif controls.currentKeybind > 0 then
    elseif tutorialOpen then checkTutorialKeyPressed(key)
    elseif isTypingInChat then
        if key == "backspace" and string.len(enteredChatText) > 0 then enteredChatText = deleteText(enteredChatText)
        elseif key == "return" and enteredChatText ~= "" then sendChatText()
        elseif key == "escape" or (key == "return" and enteredChatText == "") then isTypingInChat = false end
    elseif showNPCChatBackground then
        checkNPCChatKeyPressed(key)
        if key == keybinds.INTERACT or key == "escape" or checkMoveOrAttack(key, "move") then showNPCChatBackground = false end
    elseif crafting.open then checkCraftingKeyPressed(key) checkHotbarKeyPressed(key)
    else
        checkHotbarKeyPressed(key)
        checkTargetingPress(key)
        if key == "return" and not isSettingsWindowOpen then isTypingInChat = true end
        if me and me.ShieldID ~= 0 and key == keybinds.SHIELD then shieldUpSfx:setRelative(true) setEnvironmentEffects(shieldUpSfx) shieldUpSfx:play() end
        if key == "escape" then
            settPan.movement.x, settPan.movement.y = 0, 0
            isSettingsWindowOpen = true
            loadSliders()
        end
        if key == "tab" then
            showHUD = not showHUD
            if not showHUD then zoneChange("UI Hidden. Press TAB to turn UI back on.", 2) end
            settings[3][1].v = showHUD
            writeSettings()
        end
        if key == "'" and versionType == "dev" then worldEdit.open = not worldEdit.open end
        if key == keybinds.INVENTORY and inventory.notNPC then inventory.forceOpen = not inventory.forceOpen end
        local nearbyAnvil = isNearbyTile("assets/world/objects/Anvil.png")
        if key == keybinds.QUESETS and not nearbyAnvil then questsPanel.forceOpen = not questsPanel.forceOpen end
        if key == keybinds.INTERACT then -- Hello Mr HackerMan! Removing the isNearbyTile will allow you to open the crafting menu from anywhere, but won't allow you to actually craft any items. Sorry! =(
            if isNearbyTile("assets/world/objects/Portal.png") and me.LVL == 30 then
                openEnchanting()
            elseif isNearbyTile("assets/world/objects/Furnace.png") then
                forging.enteredItems = {}
                for i,v in ipairs(inventoryAlpha) do
                    if v.Item.Type == "ore" then
                        forging.enteredItems[#forging.enteredItems+1] = v
                    end
                end
                forging.open = true
            elseif nearbyAnvil then
                getRecipesHeight()
                crafting.open = true
                steam.friends.setRichPresence("steam_display", "#StatusCrafting")
                steam.friends.setRichPresence("location", zoneTitle.title)
                -- inventory.notNPC = true
            else
                startConversation()
            end
        end
        if (key == "f" and versionType == "dev") then openEnchanting() end
    end
end

function love.keyreleased(key)
    if phase == "game" then
        if checkAttack(key) then checkTargetingRelease(key) end
        if me and me.ShieldID ~= 0 and key == keybinds.SHIELD and not isTypingInChat and not worldEdit.isTyping then shieldDownSfx:setRelative(true) setEnvironmentEffects(shieldDownSfx) shieldDownSfx:play() end
    end
end

function love.textinput(key)
    if phase == "login" then
        checkLoginTextInput(key)
    elseif isWorldEditWindowOpen and key ~= "'" then
        checkEditWorldTextInput(key)
    elseif isTypingInChat then
        checkChatTextInput(key)
    elseif worldEdit.isTyping then
        checkWorldEditTextInput(key)
    end
end

local keys = {"UP", "DOWN", "LEFT", "RIGHT", "ATTACK_UP", "ATTACK_DOWN", "ATTACK_LEFT", "ATTACK_RIGHT"}
function checkMoveOrAttack(key, type)
    local push, pop = 1, 8
    if type then if type == "move" then push, pop = 1, 4 elseif type == "attack" then push, pop = 4, 8 end end
    local output = false
    if key == "escape" then return true end
    for i = push, pop do if key == keybinds[keys[i]] then output = true break end end
    return output
end
