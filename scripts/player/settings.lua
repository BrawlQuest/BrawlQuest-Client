
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
        "things",
    }


function initSettings()
    
    initSettingsPanel()

    isSettingsWindowOpen = false
    musicVolume = 1
    sfxVolume = 1  
    highdpi = false
    fullscreen = false
    chatRepeat = false
    display = 1
    

    displayWidth, displayHeight = love.window.getDesktopDimensions(display)

    screenDimentions = {width = 1920, height = 1080,}
    window = {x = (displayWidth * 0.5) - (screenDimentions.width * 0.5), y = (displayHeight * 0.5) - (screenDimentions.height * 0.5)}
    showChat = true
    openUiOnHover = true
    showClouds = false
    showShadows = false
    showWorldMask = true
    showWorldAnimations = true

    useItemColor = {}
    hotbar = {}
    for i = 1, 7 do
        hotbar[#hotbar + 1] = {item = null,}
        useItemColor[#useItemColor + 1] = 0 
    end
    
    info = love.filesystem.getInfo("settings.txt")
    getSettingsVersion()

    if info ~= null and getSettingsVersion() then
        -- print ("Initiating Saved Settings")
        display = contents["display"]
        window = contents["window"]
        screenDimentions = contents["screenDimentions"]
        keybinds = contents["keybinds"]
        musicVolume = contents["musicVolume"]
        sfxVolume = contents["sfxVolume"]
        selectedServer = contents["selectedServer"]
        highdpi = contents["highdpi"]
        fullscreen = contents["fullscreen"]
        chatRepeat = contents["chatRepeat"]
        settPan.scaleValue = contents["scaleValue"]
        showChat = contents["showChat"]
        showClouds = contents["showClouds"]
        showShadows = contents["showShadows"]
        showWorldMask = contents["showWorldMask"]
        showWorldAnimations = contents["showWorldAnimations"]
        openUiOnHover = contents["openUiOnHover"]
        hotbar = contents["hotbar"]
        api.url = servers[selectedServer].url
    else
        writeSettings()
    end  
    setWindowOptions()


    settings = {    
        {
            title = "Graphics",
            {name = "Render Quality", v = highdpi, type = "button", "Full", "Fast",},
            {name = "Fullscreen", v = fullscreen, type = "button", "On", "Off",},
            {name = "Clouds", v = showClouds, type = "button", "On", "Off",},
            {name = "Shadows (Alpha)", v = showShadows, type = "button", "On", "Off",},
            {name = "World Mask", v = showWorldMask, type = "button", "On", "Off",},
            {name = "World Animtions", v = showWorldAnimations, type = "button", "On", "Off",},
        },
        {
            title = "Sound",
            {name = "Music Volume", type = "fader",},
            {name = "SFX Volume", type = "fader",},       
        },
        {
            title = "HUD",
            {name = "GUI Scale", v = settPan.scaleTypes[settPan.scaleValue], type = "button",},
            {name = "Open on Mouse Over", v = openUiOnHover, type = "button",},
            {name = "Show Chat", v = showChat, type = "button",},
            {name = "Chat Remain On Enter", v = chatRepeat, type = "button",},
        },
    }
end

function writeSettings()
    success,msg = love.filesystem.write("settings.txt", json:encode({
        version = version .. " " .. versionNumber,
        keybinds = keybinds,
        musicVolume = musicVolume,
        sfxVolume = sfxVolume,
        selectedServer = selectedServer,
        highdpi = highdpi,
        fullscreen = fullscreen,
        window = window,
        chatRepeat = chatRepeat,
        scaleValue = settPan.scaleValue,
        screenDimentions = screenDimentions,
        display = display,
        showChat = showChat,
        showClouds = showClouds,
        showShadows = showShadows,
        showWorldMask = showWorldMask,
        showWorldAnimations = showWorldAnimations,
        openUiOnHover = openUiOnHover,
        hotbar = hotbar,
    }))
end

function checkSettingsMousePressed(button)
    if button == 1 and settPan.isMouseOver then
        for ai,av in ipairs(settings) do
            for bi,bv in ipairs(settings[ai]) do -- loops through every option
                if settPan.mouseOver == (ai * 10) + bi then -- if the mouse is over the correct button
                    if settPan.mouseOver == 31 then
                        scaleHUD("up")
                    elseif settPan.mouseOver == 11 or settPan.mouseOver == 12 then
                        bv.v = not bv.v
                        highdpi = settings[1][1].v
                        fullscreen = settings[1][2].v
                        setWindowOptions()
                        createWorld()
                    else
                        bv.v = not bv.v
                    end
                    openUiOnHover = settings[3][2].v -- sets the values
                    showChat = settings[3][3].v
                    chatRepeat = settings[3][4].v
                    showClouds = settings[1][3].v
                    showShadows = settings[1][4].v
                    showWorldMask = settings[1][5].v
                    showWorldAnimations = settings[1][6].v
                end
            end
        end
    end

    if button == 2 and settPan.mouseOver == 31 then
        scaleHUD("down")
    end

    local x,y = love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5
    local width, height = (settPan.width * 0.5) - (settPan.padding * 2), 40
    local thisX, thisY = x + settPan.padding, y + (settPan.height * 0.5) - settPan.padding - height
    if isMouseOver(thisX, thisY, width, height) and button == 1 then
        writeSettings()
        checkIfReadyToQuit()
    end
end


function setWindowOptions()
    love.window.setMode(screenDimentions.width, screenDimentions.height, {
        display = display,
        centered = false,
        x = window.x,
        y = window.y,
        highdpi = highdpi,
        fullscreen = fullscreen,
        resizable = not fullscreen,
        usedpiscale = false,
        vsync = 0,
    })
    scale = settPan.scaleTypes[settPan.scaleValue]
    uiX, uiY = love.graphics.getWidth()/scale, love.graphics.getHeight()/scale
    loadSliders()
    initLogin()
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

function checkSettingsButtonPressed(key)
    if key == "escape" or key == "w" or key == "a" or key == "s" or key == "d" then
        getDisplay()
        writeSettings()
        isSettingsWindowOpen = false
    end
    if key == "return" then
        writeSettings()
        checkIfReadyToQuit()
    end
end

function getDisplay()
    local x, y, thisdisplay = love.window.getPosition( )
    display = thisdisplay
    if not fullscreen then
        window = {x = x, y = y}
        screenDimentions = {width = love.graphics.getWidth(), height = love.graphics.getHeight(),}
    end
end