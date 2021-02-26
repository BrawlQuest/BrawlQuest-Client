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
    INVENTORY = "e",
    CRAFTING = "f",
    -- HOTBAR = {1,2,3,4,5,6,"space"},
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
    respawn = false

    local borders = {0.9, 0.1}
    displayWidth, displayHeight = love.window.getDesktopDimensions(display)
    screenDimensions = {width = displayWidth * 0.8, height =  displayHeight * 0.8,}
    window = {x = displayWidth * 0.1, y = displayHeight * 0.1}
    vsync = false
    showChat = true
    openUiOnHover = true
    openInventoryOnHover = true
    openQuestsOnHover = true
    showClouds = false
    showShadows = false
    showWorldMask = true
    showWorldAnimations = true
    showHUD = true
    oldTargeting = false

    useItemColor = {}
    initHotbar()
    
    info = love.filesystem.getInfo("settings.txt")

    if info ~= null then
        contents, size = love.filesystem.read("string", "settings.txt")
        contents = json:decode(contents)
        display = contents["display"] or display
        vsync = contents["vsync"] or vsync
        window = contents["window"] or window
        screenDimensions = contents["screenDimensions"] or screenDimensions
        keybinds = contents["keybinds"] or keybinds
        musicVolume = contents["musicVolume"] or musicVolume
        sfxVolume = contents["sfxVolume"] or sfxVolume
        selectedServer = contents["selectedServer"] or selectedServer
        highdpi = contents["highdpi"] or highdpi
        fullscreen = contents["fullscreen"] or fullscreen
        chatRepeat = contents["chatRepeat"] or chatRepeat
        settPan.scaleValue = contents["scaleValue"] or settPan.scaleValue
        showChat = contents["showChat"] or showChat
        showClouds = contents["showClouds"] or showClouds
        showShadows = contents["showShadows"] or showShadows
        showWorldMask = contents["showWorldMask"] or showWorldMask
        showWorldAnimations = contents["showWorldAnimations"] or showWorldAnimations
        showHUD = contents["showHUD"] or showHUD
        -- openUiOnHover = contents["openUiOnHover"] or openUiOnHover
        oldTargeting = contents["oldTargeting"] or oldTargeting
        hotbar = contents["hotbar"] or hotbar
        openInventoryOnHover = contents["openInventoryOnHover"] or openInventoryOnHover
        openQuestsOnHover = contents["openQuestsOnHover"] or openQuestsOnHover
        crafting.openField = contents["craftingFields"] or crafting.openField
        api.url = servers[selectedServer].url
    else
        writeSettings()
    end

    setWindowOptions()
    checkHotbarChange()

    controls = {
        title = "Controls",
        selKeybindCount = 0,
        currentKeybind = 0,
        previousKeybind = 0,
        keybinds = {title = "Keybinds", reset = false, v = setDefualtKeybinds(),},
    }

    settings = {
        {
            title = "Player",
            {name = "Respawn", v = respawn, type = "button", "Full", "Fast",},
            {name = "Hold to Attack", v = oldTargeting, type = "button", "Full", "Fast",},
        },
        {
            title = "Graphics",
            {name = "Render Quality", v = highdpi, type = "button", "Full", "Fast",},
            {name = "Fullscreen", v = fullscreen, type = "button", "On", "Off",},
            {name = "Clouds", v = showClouds, type = "button", "On", "Off",},
            -- {name = "Shadows (Alpha)", v = showShadows, type = "button", "On", "Off",},
            -- {name = "World Mask", v = showWorldMask, type = "button", "On", "Off",},
            {name = "World Animations", v = showWorldAnimations, type = "button", "On", "Off",},
            {name = "VSync", v = vsync, type = "button", "On", "Off",},
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
            {name = "Show Chat", v = showChat, type = "button",},
            {name = "Chat Remain On Enter", v = chatRepeat, type = "button",},
            {name = "Open Inventory on Hover", v = openInventoryOnHover, type = "button",},
            {name = "Open Quests on Hover", v = openQuestsOnHover, type = "button",},
        },
    }
end

function writeSettings()
    success,msg = love.filesystem.write("settings.txt", json:encode_pretty({
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
        screenDimensions = screenDimensions,
        display = display,
        showChat = showChat,
        showClouds = showClouds,
        showShadows = showShadows,
        showWorldMask = showWorldMask,
        showHUD = showHUD,
        showWorldAnimations = showWorldAnimations,
        -- openUiOnHover = openUiOnHover,
        openInventoryOnHover = openInventoryOnHover,
        openQuestsOnHover = openQuestsOnHover,
        hotbar = hotbar,
        oldTargeting = oldTargeting,
        craftingFields = crafting.openField,
        vsync = vsync,
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
        {name = "CRAFTING", v = keybinds.CRAFTING, sel = false,},
        {name = "INVENTORY", v = keybinds.INVENTORY, sel = false,},
        {name = "QUESETS", v = keybinds.QUESETS, sel = false,},
    }
end

function checkSettingsMousePressed(button)
    if button == 1 then
        if settPan.isMouseOver then
            for ai,av in ipairs(settings) do
                for bi,bv in ipairs(settings[ai]) do -- loops through every option
                    if settPan.mouseOver == (ai * 10) + bi then -- if the mouse is over the correct button
                        if settPan.mouseOver == 42 then
                            scaleHUD("up")
                        elseif settPan.mouseOver == 11 then
                            settings[1][1].v = false
                            -- TODO: kill yourself
                        elseif settPan.mouseOver == 21 or settPan.mouseOver == 22 or settPan.mouseOver == 25 then
                            bv.v = not bv.v
                            highdpi = settings[2][1].v
                            fullscreen = settings[2][2].v
                            vsync = settings[2][5].v
                            setWindowOptions()
                            createWorld()
                        else
                            bv.v = not bv.v
                        end
                        oldTargeting = settings[1][2].v
                        holdAttack = not oldTargeting
                        showHUD = settings[4][1].v
                        -- openUiOnHover = settings[4][3].v -- sets the values
                        showChat = settings[4][3].v
                        chatRepeat = settings[4][4].v
                        showClouds = settings[2][3].v
                        -- showShadows = settings[2][4].v
                        -- showWorldMask = settings[2][5].v
                        showWorldAnimations = settings[2][4].v
                        openInventoryOnHover = settings[4][5].v
                        openQuestsOnHover = settings[4][6].v
                        break
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

    if button == 2 and settPan.mouseOver == 42 then
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
        if key ~= "escape" then 
            controls.keybinds.v[controls.currentKeybind].v = key
            keybinds[controls.keybinds.v[controls.currentKeybind].name] = key
            controls.currentKeybind = 0
            controls.previousKeybind = 0
            writeSettings()
        else
            controls.currentKeybind = 0
            controls.previousKeybind = 0
        end
    else
        if checkMoveOrAttack(key) then
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
    love.window.setMode(screenDimensions.width, screenDimensions.height, {
        display = display,
        centered = false,
        x = window.x,
        y = window.y,
        highdpi = highdpi,
        fullscreen = fullscreen,
        resizable = not fullscreen,
        usedpiscale = false,
        vsync = boolToInt(vsync),
        borderless = false,
    })
    scale = settPan.scaleTypes[settPan.scaleValue]
    uiX, uiY = love.graphics.getWidth()/scale, love.graphics.getHeight()/scale
    loadSliders()
    initLogin()
end

function getDisplay()
    local x, y, thisdisplay = love.window.getPosition( )
    display = thisdisplay
    if not fullscreen then
        window = {x = x, y = y}
        screenDimensions = {width = love.graphics.getWidth(), height = love.graphics.getHeight(),}
    end
end