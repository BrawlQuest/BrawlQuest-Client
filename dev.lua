function devLogin(key)
    if key == "home" then 
        quickLogin("Pebsie", 1)
    elseif key == "end" then
        quickLogin("Danjoe", 1)
    elseif key == "pageup" then
        quickLogin("Danjoe", 2)
    elseif key == "pagedown" then
        quickLogin("Danjoe", 3)
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
    elseif key == "right" or key == "d" then loginPhase = "login" end
    if key == "escape" then love.event.quit() end
end

function quickLogin(name, character, password)
    password = password or "password"
    textfields[1] = name
    textfields[2] = password
    textfields[3] = "********"
    editingField = 2
    login()
    cs.selectedCharacter = character
    if characters[cs.selectedCharacter] ~= null then
        transitionToPhaseGame()
    end
end