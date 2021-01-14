function initSettingsPanel()
    
    
    settings = {
        {
            title = "Controls",
            keybinds = {title = "Keybinds", v = {
                {name = "UP", v = "w", sel = false,},
                {name = "DOWN", v = "s", sel = false,},
                {name = "LEFT", v = "a", sel = false,},
                {name = "RIGHT", v = "d", sel = false,},
                {name = "ATTACK_UP", v = "up", sel = false,},
                {name = "ATTACK_DOWN", v = "down", sel = false,},
                {name = "ATTACK_LEFT", v = "left", sel = false,},
                {name = "ATTACK_RIGHT", v = "right", sel = false,},
                {name = "SHIELD", v = "lshift", sel = false,},
                {name = "CRAFTING", v = "f", sel = false,},
                {name = "INTERACT", v = "e", sel = false,},
                {name = "QUESETS", v = "q", sel = false,},
                }, 
            },
        },
        {
            title = "Graphics",
            renderQuality = {title = "Render Quality", v = false, },
            fullscreen = {title = "Fullscreen", v = false, },
        },
        {
            title = "Sound",
            musicVolume = {title = "Music Volume", v = 1,},
            sfxVolume = {title = "SFX Volume", v = 1,},       
        },
        {
            title = "HUD",
            openOnMouseOver = {title = "Open on Mouse Over", v = true},
            showChat = {title = "Show Chat", v = true}
        },
    }

    sliderPosition = {
        music = {0, 0,},
        sfx = {0, 0,},
    }

    settPan = {
        width = 335 * 2,
        height = 496,
        padding = 20,
        movement = {x = 0, y = 0, speed = {x = 0.2, y = 0.1},},
        opacity = 0,
        opacityCERP = 0,
        opacitySpeed = 6,
        title = "love",
        titleOffset = 100,
    }

    

    questPopUpWidth = 335
    questPopUpHeight = 496
end

function updateSettingsPanel(dt)
    settPan.opacity = settPan.opacity + settPan.opacitySpeed * dt
    if settPan.opacity > 1 then settPan.opacity = 1 end
    settPan.movement.x = (settPan.movement.x) - settPan.movement.speed.x * dt
    settPan.movement.y = (settPan.movement.y)- settPan.movement.speed.y * dt
end

function drawLargeSettingsPanel()

    local noiseFactor = 0.23 -- 0.18
    local gridSize = 16
    local x, y = 0, 0
    while x < love.graphics.getWidth() do
        while y < love.graphics.getHeight() do
            local noise = ((love.math.noise(((x + player.dx) * 0.01) + settPan.movement.x , ((y + player.dy) * 0.01) + settPan.movement.y )) * noiseFactor)
            love.graphics.setColor(noise * 1 ,noise * 1 ,noise , settPan.opacityCERP * 0.2)
            love.graphics.rectangle("fill", x, y, gridSize, gridSize)
            y = y + gridSize
        end
        x = x + gridSize
        y = 0
    end

    local x,y = love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5
    local thisX, thisY = x - (settPan.width * 0.5), y - (settPan.height * 0.5)

    love.graphics.setColor(0,0,0,settPan.opacityCERP * 0.7)
    roundRectangle("fill", thisX, thisY, settPan.width, settPan.height, 10) -- draws the background
    love.graphics.setColor(1,1,1, settPan.opacityCERP * 1)

    volumeSlider:draw()
    sfxSlider:draw()

    setSettingsStencil()
    local thisX, thisY = x - (settPan.width * 0.5) + settPan.padding, y - (settPan.height * 0.5) + settPan.padding + settPan.titleOffset
    for i,v in ipairs(settings[1].keybinds.v) do
        roundRectangle("fill", thisX, thisY, 43, 43, 10)
        thisY = thisY + 43 + 10
    end
end

function setSettingsStencil()
    local x,y = love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5
    local thisX, thisY = x - (settPan.width * 0.5) + settPan.padding, y - (settPan.height * 0.5)  + settPan.padding + settPan.titleOffset
    roundRectangle("fill", thisX, thisY, (settPan.width * 0.5) - (settPan.padding * 2), (settPan.height) - (settPan.padding * 2) - settPan.titleOffset, 6)
end

function loadSliders()
    local thisX, thisY = love.graphics.getWidth()/2 - (questPopUpWidth/2) + (settPan.width * 0.5), (love.graphics.getHeight()/2)-(questPopUpHeight/2)+150
    local spacing = 75
    local width = questPopUpWidth - 68
    volumeSlider = newSlider(thisX, thisY + (spacing*0), width, musicVolume, 0, 1, sliderValueA(v))
    sfxSlider = newSlider(thisX, thisY + (spacing*1), width, sfxVolume, 0, 1, sliderValueA(v))
end

function updateSliders()
    if isSettingsWindowOpen then
        volumeSlider:update()
        sfxSlider:update()
    end
end

function sliderValueA(v) end