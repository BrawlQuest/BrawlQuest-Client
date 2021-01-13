function initSettings()

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
        CRAFTING = "f",
        INTERACT = "e",
        QUESETS = "q",
    }

    isSettingsWindowOpen = false
    musicVolume = 1
    sfxVolume = 1  
    dpiScaling = true
    fullscreen = false
    chatRepeat = false
    screenDimentions = {width = love.graphics.getWidth(), height = love.graphics.getHeight(),}
    
    info = love.filesystem.getInfo("settings.txt")
    getSettingsVersion()

    if info ~= null and getSettingsVersion() then
        print ("Initiating Saved Settings")
        screenDimentions = contents["screenDimentions"]
        keybinds = contents["keybinds"]
        musicVolume = contents["musicVolume"]
        sfxVolume = contents["sfxVolume"]
        selectedServer = contents["selectedServer"]
        dpiScaling = contents["dpiScaling"]
        fullscreen = contents["fullscreen"]
        chatRepeat = contents["chatRepeat"]
        scale = contents["scale"]
        api.url = servers[selectedServer].url
    else
        writeSettings()
    end  
    setWindowOptions()
end

function setWindowOptions()
    love.window.setMode(screenDimentions.width, screenDimentions.height, {
        fullscreen = fullscreen,
        highdpi = dpiScaling,
        resizable = not fullscreen,
        highdpi = thisDPI,
        -- stencil = true,
        vsync = 0,
    })
    uiX, uiY = love.graphics.getWidth()/scale, love.graphics.getHeight()/scale
    loadSliders()
    initLogin()
end

function writeSettings()
    print ("Writing Settings")
    success,msg = love.filesystem.write("settings.txt", json:encode({
        version = version .. " " .. versionNumber,
        keybinds = keybinds,
        musicVolume = musicVolume,
        sfxVolume = sfxVolume,
        selectedServer = selectedServer,
        dpiScaling = dpiScaling,
        fullscreen = fullscreen,
        chatRepeat = chatRepeat,
        scale = scale,
        screenDimentions = {width = love.graphics.getWidth(), height = love.graphics.getHeight(),},
    }))
end

function getSettingsVersion()
    if info ~= null then
        contents, size = love.filesystem.read("string", "settings.txt")
        contents = json:decode(contents)
        if  contents["version"] ~= version .. " " .. versionNumber then
            return false -- I didn't get the correct version
        else
            return true -- We're up to date
        end
    end
end

function loadSliders()
    local thisX, thisY = love.graphics.getWidth()/2, (love.graphics.getHeight()/2)-(questPopUpHeight/2)+150
    local spacing = 75
    local width = questPopUpWidth - 68
    -- settingSlider = newSlider(thisX, thisY, 0, 0, 1, sliderValue(v))
    volumeSlider = newSlider(thisX, thisY + (spacing*0), width, musicVolume, 0, 1, sliderValueA(v))
    sfxSlider = newSlider(thisX, thisY + (spacing*1), width, sfxVolume, 0, 1, sliderValueA(v))
end

function updateSliders()
    if isSettingsWindowOpen then
        volumeSlider:update()
        sfxSlider:update()
    end
end

function drawSettingsPanel(thisX, thisY)
    if isSettingsWindowOpen then
        thisX, thisY = thisX - (questPopUpWidth/2), thisY - (questPopUpHeight/2)
        love.graphics.setColor(0,0,0,0.7)
        roundRectangle("fill", thisX, thisY, questPopUpWidth, questPopUpHeight, 10)
        love.graphics.setColor(1,1,1,1)
        local padding = 20
        thisX, thisY = thisX + padding, thisY + padding

        volumeSlider:draw()
        sfxSlider:draw()

        love.graphics.setFont(headerBigFont)
        love.graphics.print("Settings", thisX, thisY)

        love.graphics.setFont(headerFont)
        local names = {"Music Volume", "SFX Volume", "Render Quality"}
        local spacing = 75
        for i = 1, #names do 
            love.graphics.print(names[i], thisX, thisY + 83)
            thisY = thisY + spacing
        end
        drawSettingsToggleButton(thisX, thisY, dpiScaling, "Highest", "Lowest",  padding)
        drawSettingsToggleButton(thisX, thisY + (50*1), fullscreen, "Fullscreen", "Windowed",  padding)
        drawSettingsToggleButton(thisX, thisY + (50*2), chatRepeat, "Chat Remain On Enter", "Chat Close On Enter",  padding)
        drawSettingsButton(thisX, thisY+ (50*3), "Quit Game (return)", padding)
    end
end

function drawSettingsButton(thisX, thisY, text, padding)
    roundRectangle("fill", thisX, thisY + 40, questPopUpWidth - (padding*2), 40, 10)
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf(text, thisX, thisY + 46, questPopUpWidth - (padding*2), "center")
end

function drawSettingsToggleButton(thisX, thisY, var, textA, textB,  padding)
    if var then
        love.graphics.setColor(1,0,0,1)
        drawSettingsButton(thisX, thisY, textA, padding)
    else
        love.graphics.setColor(0.1,0.1,1,1)
        drawSettingsButton(thisX, thisY, textB, padding)
    end
    love.graphics.setColor(1,0,0,1)
end

function sliderValueA(v) end

function checkSettingsMousePressed(button)
    if isSettingsWindowOpen then
        local padding = 20
        local spacing = 75
        local thisX, thisY = (love.graphics.getWidth()/2) - (questPopUpWidth/2)+20, (love.graphics.getHeight()/2)-(questPopUpHeight/2)+20+(75*3)+40
        if isMouseOver(thisX, thisY, questPopUpWidth - (padding*2), 40) and button == 1 then
            dpiScaling = not dpiScaling
            print(dpiScaling )
            setWindowOptions()
            writeSettings()
            createWorld()
        end

        if isMouseOver(thisX, thisY + (50 * 1), questPopUpWidth - (padding*2), 40) and button == 1 then
            fullscreen = not fullscreen
            setWindowOptions()
            writeSettings()  
        end

        if isMouseOver(thisX, thisY + (50 * 2), questPopUpWidth - (padding*2), 40) and button == 1 then
            chatRepeat = not chatRepeat
            writeSettings()
        end
        
        if isMouseOver(thisX, thisY + (50 * 3), questPopUpWidth - (padding*2), 40) and button == 1 then
            checkIfReadyToQuit()
        end
    end
end