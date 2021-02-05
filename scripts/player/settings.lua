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
    INTERACT = "e",
    QUESETS = "q",
    IVENTORY = "e",
    CRAFTING = "f",
    HOTBAR = {1,2,3,4,5,6,"space"},
}
defaultKeybinds = copy(keybinds)

function initSettings()
    
    initSettingsPanel()
    isSettingsWindowOpen = false
    musicVolume = 1
    sfxVolume = 1 
    if love.system.getOS( ) == "Windows" then highdpi = true else highdpi = false end
    fullscreen = false
    chatRepeat = false
    display = 1

    displayWidth, displayHeight = love.window.getDesktopDimensions(display)
    screenDimentions = {width = displayWidth, height = displayHeight,}
    window = {x = 0, y = 0}
    showChat = true
    openUiOnHover = true
    showClouds = false
    showShadows = false
    showWorldMask = true
    showWorldAnimations = true
    showHUD = true

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
        showHUD = contents["showHUD"]
        openUiOnHover = contents["openUiOnHover"]
        hotbar = contents["hotbar"]
        api.url = servers[selectedServer].url
    else
        writeSettings()
    end  
    setWindowOptions()

    controls = {
        title = "Controls",
        selKeybindCount = 0,
        currentKeybind = 0,
        previousKeybind = 0,
        keybinds = {title = "Keybinds", reset = false, v = setDefualtKeybinds(),},
    }

    settings = {    
        {
            title = "Graphics",
            {name = "Render Quality", v = highdpi, type = "button", "Full", "Fast",},
            {name = "Fullscreen", v = fullscreen, type = "button", "On", "Off",},
            {name = "Clouds", v = showClouds, type = "button", "On", "Off",},
            -- {name = "Shadows (Alpha)", v = showShadows, type = "button", "On", "Off",},
            -- {name = "World Mask", v = showWorldMask, type = "button", "On", "Off",},
            {name = "World Animtions", v = showWorldAnimations, type = "button", "On", "Off",},
        },
        {
            title = "Sound",
            {name = "Music Volume", type = "fader",},
            {name = "SFX Volume", type = "fader",},       
        },
        {
            title = "HUD",
            {name = "Show HUD", v = showHUD, type = "button",},
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
        showHUD = showHUD,
        showWorldAnimations = showWorldAnimations,
        openUiOnHover = openUiOnHover,
        hotbar = hotbar,
    }))
end

function setDefualtKeybinds()
    return {
        {name = "UP", v = keybinds.UP, sel = false,},
        {name = "DOWN", v = keybinds.DOWN, sel = false,},
        {name = "LEFT", v = keybinds.LEFT, sel = false,},
        {name = "RIGHT", v = keybinds.RIGHT, sel = false,},
        {name = "ATTACK_UP", v = keybinds.ATTACK_UP, sel = false,},
        {name = "ATTACK_DOWN", v = keybinds.ATTACK_DOWN, sel = false,},
        {name = "ATTACK_LEFT", v = keybinds.ATTACK_LEFT, sel = false,},
        {name = "ATTACK_RIGHT", v = keybinds.ATTACK_RIGHT, sel = false,},
        {name = "USE SHIELD", v = keybinds.SHIELD, sel = false,},
        {name = "INTERACT", v = keybinds.INTERACT, sel = false,},
        {name = "OPEN CRAFTING", v = keybinds.CRAFTING, sel = false,},
        {name = "OPEN INVENTORY", v = keybinds.IVENTORY, sel = false,},
        {name = "QUESETS", v = keybinds.QUESETS, sel = false,},
        {name = "HOTKEY 1", v = keybinds.QUESETS, sel = false,},
    }
end

function checkSettingsMousePressed(button)
    if button == 1 then
        if settPan.isMouseOver then
            for ai,av in ipairs(settings) do
                for bi,bv in ipairs(settings[ai]) do -- loops through every option
                    if settPan.mouseOver == (ai * 10) + bi then -- if the mouse is over the correct button
                        if settPan.mouseOver == 32 then
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
                        showHUD = settings[3][1].v
                        openUiOnHover = settings[3][3].v -- sets the values
                        showChat = settings[3][4].v
                        chatRepeat = settings[3][5].v
                        showClouds = settings[1][3].v
                        -- showShadows = settings[1][4].v
                        -- showWorldMask = settings[1][5].v
                        showWorldAnimations = settings[1][4].v
                    end
                end
            end
        elseif controls.selKeybindCount > 0 then
            if  controls.selKeybindCount ~= controls.previousKeybind then
                controls.currentKeybind = controls.selKeybindCount
                controls.previousKeybind = controls.currentKeybind
            else
                controls.currentKeybind = 0
            end
        end

        if controls.keybinds.reset == true then
            keybinds = copy(defaultKeybinds)
            controls.keybinds.v = setDefualtKeybinds()
        end
    end

    if button == 2 and settPan.mouseOver == 32 then
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

function checkSettingKeyPressed(key)
    if controls.currentKeybind > 0 then
        controls.keybinds.v[controls.currentKeybind].v = key
        keybinds[controls.keybinds.v[controls.currentKeybind].name] = key
        controls.currentKeybind = 0
        writeSettings()
    else
        if key == "escape" or key == "w" or key == "a" or key == "s" or key == "d" then
            getDisplay()
            writeSettings()
            isSettingsWindowOpen = false
        elseif key == "return" then
            writeSettings()
            checkIfReadyToQuit()
        end
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

function getDisplay()
    local x, y, thisdisplay = love.window.getPosition( )
    display = thisdisplay
    if not fullscreen then
        window = {x = x, y = y}
        screenDimentions = {width = love.graphics.getWidth(), height = love.graphics.getHeight(),}
    end
end