function initSettingsPanel()
    controls = {
        title = "Controls",
        selKeybindCount = 0,
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
    }
    
    settings = {    
        {
            title = "Graphics",
            {title = "Render Quality", v = false, },
            {title = "Fullscreen", v = false, },
        },
        {
            title = "Sound",
            {title = "Music Volume", v = 1,},
            {title = "SFX Volume", v = 1,},       
        },
        {
            title = "HUD",
            {title = "GUI Scale", v = 1},
            {title = "Open on Mouse Over", v = true},
            {title = "Show Chat", v = true}
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
        titleOffset = 75,
        titleFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 16),
        itemFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 16),
        objectPadding = 10,
        objectValueWidth = 80,
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

    local noiseFactor = 0.3 -- 0.18
    local gridSize = 16
    local x, y = 0, 0
    while x < love.graphics.getWidth() do  -- draws the clouds
        while y < love.graphics.getHeight() do
            local noise = ((love.math.noise(((x + player.dx) * 0.008) + settPan.movement.x , ((y + player.dy) * 0.008) + settPan.movement.y )) * noiseFactor)
            love.graphics.setColor(0.2,0.2,0.3, settPan.opacityCERP * noise)
            love.graphics.rectangle("fill", x, y, gridSize, gridSize)
            y = y + gridSize
        end
        x = x + gridSize
        y = 0
    end

    local x,y = love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5
    local thisX, thisY = x - (settPan.width * 0.5), y - (settPan.height * 0.5)

    love.graphics.setFont(settPan.itemFont)
    love.graphics.setColor(0,0,0,settPan.opacityCERP * 0.7)
    roundRectangle("fill", thisX, thisY, settPan.width, settPan.height, 10) -- draws the background
    love.graphics.setColor(1,1,1, settPan.opacityCERP * 1)
    roundRectangle("fill", x - 1, y - (settPan.height * 0.5) + settPan.padding, 2, settPan.height - (settPan.padding * 2), 2) -- divider
    love.graphics.print("SETTINGS", thisX + settPan.padding, thisY + settPan.padding, 0, 2) -- title
    love.graphics.print("CONTROLS", thisX + settPan.padding, thisY + settPan.titleOffset - 10) -- Subheader

    volumeSlider:draw() -- sliders
    sfxSlider:draw()

    settings[1].selKeybindCount = 0

    love.graphics.stencil(drawSettingsStencil, "replace", 1) -- stencils inventory
    love.graphics.setStencilTest("greater", 0) -- push

        local thisX, thisY = x - (settPan.width * 0.5) + settPan.padding, y - (settPan.height * 0.5) + settPan.padding + settPan.titleOffset
        local width, height = (settPan.width * 0.5) - (settPan.padding * 2), 32
        local fontHeight = (height * 0.5) - (settPan.itemFont:getHeight() * 0.45)

        for i,v in ipairs(controls.keybinds.v) do
            if isMouseOver(thisX, thisY, width, height) then
                controls.selKeybindCount = i
                love.graphics.setColor(1, 0, 0, settPan.opacityCERP * 1)            
            else
                love.graphics.setColor(0, 0, 0, settPan.opacityCERP * 0.5)            
            end

            roundRectangle("fill", thisX, thisY, width - (settPan.objectValueWidth + 10), height, 6) -- name backing
            local nextX, nextY = thisX + width - settPan.objectValueWidth, thisY
            roundRectangle("fill", nextX, nextY, settPan.objectValueWidth, height, 6) -- value backing
            love.graphics.setColor(1,1,1, settPan.opacityCERP * 1)
            love.graphics.print(v.name, thisX + 10, thisY + fontHeight) -- prints the name of things
            love.graphics.printf("\"" .. v.v .. "\"", nextX, nextY + fontHeight, settPan.objectValueWidth, "center") -- prints the value of things

            thisY = thisY + height + settPan.objectPadding
        end

    love.graphics.setStencilTest() -- pop

    -- Right Side Buttons
    local thisX, thisY = x + settPan.padding, y - (settPan.height * 0.5) + settPan.padding

    for i,v in ipairs(settings) do
        love.graphics.print(v.title, thisX, thisY) -- Subheader
        thisY = thisY + height + settPan.objectPadding
    end
end

function drawSettingsStencil()
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