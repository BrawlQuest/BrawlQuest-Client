
musicVolume = 0
sfxVolume = 1

function initSettings()
    dpiScaling = true
    fullscreen = false
    chatRepeat = false
    
    info = love.filesystem.getInfo("settings.txt")
    isSettingsWindowOpen = false

    if info then -- ]]and 1 == 2  
        contents, size = love.filesystem.read("string", "settings.txt")
        contents = json:decode(contents)
        keybinds = contents["keybinds"]
        musicVolume = contents["musicVolume"]
        sfxVolume = contents["sfxVolume"]
        selectedServer = contents["selectedServer"]
        dpiScaling = contents["dpiScaling"]
        fullscreen = contents["fullscreen"]
        chatRepeat = contents["chatRepeat"]
        scale = contents["scale"]
        api.url = servers[selectedServer].url
        print("File Initiated")
    else
        success,msg = love.filesystem.write("settings.txt", json:encode({
            keybinds = keybinds,
            musicVolume = musicVolume,
            sfxVolume = sfxVolume,
            selectedServer = 1,
            dpiScaling = dpiScaling,
            fullscreen = fullscreen,
            chatRepeat = chatRepeat,
            scale = scale,
        }))
    end  

    uiX, uiY = love.graphics.getWidth()/scale, love.graphics.getHeight()/scale

    if not dpiScaling then dpiScaler(false) end

    if fullscreen then love.window.setFullscreen(true) end
    loadSliders()
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

function writeSettings()
    success,msg = love.filesystem.write("settings.txt", json:encode({
        keybinds = keybinds,
        musicVolume = musicVolume,
        sfxVolume = sfxVolume,
        selectedServer = selectedServer,
        dpiScaling = dpiScaling,
        fullscreen = fullscreen,
        chatRepeat = chatRepeat,
        scale = scale,
    }))
end

function drawSettingsPanel(thisX, thisY)
    if isSettingsWindowOpen then
        thisX, thisY = thisX - (questPopUpWidth/2), thisY - (questPopUpHeight/2)
        drawQuestPopUpBackground(thisX, thisY)
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
            if dpiScaling then
                dpiScaling = false
                dpiScaler(false)
            else
                dpiScaling = true
                dpiScaler(true)
            end
            writeSettings()
            createWorld()
            
        end

        if isMouseOver(thisX, thisY + (50 * 1), questPopUpWidth - (padding*2), 40) and button == 1 then
            if fullscreen then
                fullscreen = false
                love.window.setFullscreen(false)
                uiX = love.graphics.getWidth()/scale -- scaling options
                uiY = love.graphics.getHeight()/scale
            else
                fullscreen = true
                love.window.setFullscreen(true)
            end
            writeSettings()
            loadSliders()        
        end

        if isMouseOver(thisX, thisY + (50 * 2), questPopUpWidth - (padding*2), 40) and button == 1 then
            if chatRepeat then
                chatRepeat = false
            else
                chatRepeat = true
            end
            writeSettings()
        end
        
        if isMouseOver(thisX, thisY + (50 * 3), questPopUpWidth - (padding*2), 40) and button == 1 then
            love.event.quit()
        end
    end
end

function dpiScaler(thisDPI)
    return love.window.setMode(love.graphics.getWidth(), love.graphics.getHeight(), {
        highdpi = thisDPI,
        resizable = thisDPI,
        fullscreen = fullscreen,
    }) 
end    