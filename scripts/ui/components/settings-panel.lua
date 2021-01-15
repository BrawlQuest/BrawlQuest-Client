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
            {name = "Render Quality", v = false, type = "button", "Full", "Fast",},
            {name = "Fullscreen", v = false, type = "button", "On", "Off",},
        },
        {
            title = "Sound",
            {name = "Music Volume", v = 1, type = "fader",},
            {name = "SFX Volume", v = 1, type = "fader",},       
        },
        {
            title = "HUD",
            {name = "GUI Scale", v = 1, type = "button",},
            {name = "Open on Mouse Over", v = true, type = "button",},
            {name = "Show Chat", v = true, type = "button",},
            {name = "Chat Remain On Enter", v = true, type = "button",},
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
        objectPadding = 6,
        objectValueWidth = 80,
        headerSpacing = 30,
        buttonSpacing = 36,
        fontHeight = 0,
    }

    settSrl = {
        {posy = 0, vely = 0, max = -1000, prevmax = -0,},
        {posy = 0, vely = 0, max = -1000, prevmax = -0, prevposy = 0,},
    }

    settPan.fontHeight = (32 * 0.5) - (settPan.itemFont:getHeight() * 0.45)

    questPopUpWidth = 335
    questPopUpHeight = 496
end

function updateSettingsPanel(dt)
    settPan.opacity = settPan.opacity + settPan.opacitySpeed * dt
    if settPan.opacity > 1 then settPan.opacity = 1 end
    settPan.movement.x = (settPan.movement.x) - settPan.movement.speed.x * dt
    settPan.movement.y = (settPan.movement.y)- settPan.movement.speed.y * dt

    for i,v in ipairs(settSrl) do --scrolls the settings panels
        v.vely = v.vely - v.vely * math.min( dt * 15, 1 )
        v.posy = v.posy + v.vely * dt
        if v.posy > 0 then
            v.posy = 0
        elseif v.posy < v.max then
            v.posy = v.max
        end
    end

    if settSrl[2].posy > settSrl[2].prevposy + 1 or settSrl[2].posy < settSrl[2].prevposy - 1 then
        loadSliders()
        settSrl[2].prevposy = settSrl[2].posy
    end
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
    love.graphics.print("SETTINGS", thisX + settPan.padding, thisY + settPan.padding + 2, 0, 2) -- title
    love.graphics.print("CONTROLS", thisX + settPan.padding, thisY + settPan.titleOffset - 10) -- Subheader

    settings[1].selKeybindCount = 0

    love.graphics.stencil(drawSettingsStencilLeft, "replace", 1) -- stencils Left Side
    love.graphics.setStencilTest("greater", 0) -- push

        local thisX, thisY = x - (settPan.width * 0.5) + settPan.padding, y - (settPan.height * 0.5) + settPan.padding + settPan.titleOffset + settSrl[1].posy
        local width, height = (settPan.width * 0.5) - (settPan.padding * 2), 32
        local max = 0

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
            love.graphics.print(v.name, thisX + 10, thisY + settPan.fontHeight) -- prints the name of things
            love.graphics.printf("\"" .. v.v .. "\"", nextX, nextY + settPan.fontHeight, settPan.objectValueWidth, "center") -- prints the value of things

            thisY = thisY + height + settPan.objectPadding
            max = max + height + settPan.objectPadding
        end

        if settSrl[1].max ~= settSrl[1].prevmax then
            settSrl[1].max = (max - ((settPan.height) - (settPan.padding * 2) - settPan.titleOffset)) * -1
            settSrl[1].prevmax = settSrl[1].max
        end

    love.graphics.setStencilTest() -- pop

    love.graphics.stencil(drawSettingsStencilRight, "replace", 1) -- stencils Right Side
    love.graphics.setStencilTest("greater", 0) -- push

        -- Right Side Buttons
        local thisX, thisY = x + settPan.padding, y - (settPan.height * 0.5) + settPan.padding + settSrl[2].posy
        local width, height = (settPan.width * 0.5) - (settPan.padding * 2), 32
        local max = 0

        for ai,av in ipairs(settings) do
            love.graphics.setColor(1,1,1,settPan.opacityCERP)
            love.graphics.print(av.title, thisX, thisY + 5) -- Subheader
            thisY = thisY + settPan.headerSpacing
            max = max + settPan.headerSpacing
            for bi,bv in ipairs(settings[ai]) do
                if bv.type == "button" then
                    drawSettingsButton("description button", thisX, thisY, width, height, false, bv)
                    thisY = thisY + settPan.buttonSpacing
                    max = max + settPan.buttonSpacing
                elseif bv.type == "fader" then
                    love.graphics.setColor(0, 0, 0, settPan.opacityCERP * 0.5)   
                    roundRectangle("fill", thisX, thisY, width, 60, 6)
                    love.graphics.setColor(1,1,1, settPan.opacityCERP)
                    love.graphics.print(bv.name, thisX + 10, thisY + 10)
                    thisY = thisY + 60 + 6
                    max = max + 60 + 6
                end
            end
        end 

        if settSrl[2].max ~= settSrl[2].prevmax then
            settSrl[2].max = (max - ((settPan.height) - (settPan.padding * 2) - 40 - settPan.objectPadding)) * -1
            settSrl[2].prevmax = settSrl[2].max
        end

        volumeSlider:draw() -- sliders
        sfxSlider:draw()

    love.graphics.setStencilTest() -- pop

    local width, height = (settPan.width * 0.5) - (settPan.padding * 2), 40
    local thisX, thisY = x + settPan.padding, y + (settPan.height * 0.5) - settPan.padding - height

    love.graphics.setColor(1, 0, 0, settPan.opacityCERP * 1)    
    roundRectangle("fill", thisX, thisY, width, height, 6)
    love.graphics.setColor(1,1,1, settPan.opacityCERP * 1)    
    love.graphics.printf("CLOSE GAME", thisX, thisY + 20 - (settPan.itemFont:getHeight() * 0.5), width, "center") -- prints the name of things
end

function drawSettingsButton(type, thisX, thisY, width, height, bool, table)

    love.graphics.setColor(0, 0, 0, settPan.opacityCERP * 0.5)            
    roundRectangle("fill", thisX, thisY, width - 90 - settPan.objectPadding, height, 6)
    roundRectangle("fill", thisX + width - 90, thisY, 90, height, 6)
    love.graphics.setColor(1,1,1, settPan.opacityCERP)
    love.graphics.print(table.name, thisX + 10, thisY + settPan.fontHeight) -- prints the name of things
    love.graphics.printf(boolToString(table.v), thisX + width - 90, thisY + settPan.fontHeight, 90, "center") -- prints the value of things
end

function drawSettingsStencilLeft()
    local x,y = love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5
    local thisX, thisY = x - (settPan.width * 0.5) + settPan.padding, y - (settPan.height * 0.5)  + settPan.padding + settPan.titleOffset
    roundRectangle("fill", thisX, thisY, (settPan.width * 0.5) - (settPan.padding * 2), (settPan.height) - (settPan.padding * 2) - settPan.titleOffset, 6)
end

function drawSettingsStencilRight()
    local x,y = love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5
    local thisX, thisY = x + settPan.padding, y - (settPan.height * 0.5) + settPan.padding
    roundRectangle("fill", thisX, thisY, (settPan.width * 0.5) - (settPan.padding * 2), (settPan.height) - (settPan.padding * 2) - 40 - settPan.objectPadding, 6)
end

function loadSliders()
    local x,y = (love.graphics.getWidth() * 0.5), (love.graphics.getHeight() * 0.5)
    local thisX = x - (settPan.width * 0.25) + (settPan.width * 0.5)
    local thisY = y - (settPan.height * 0.5) + settPan.padding + settSrl[2].posy + 49 - 7
    local spacing = 75
    local width = (settPan.width * 0.5) - 10 - 68
    
    local style = {
        track = "line",
        knob = "rectangle",
        width = 18,
    } 

    volumeSlider = newSlider(thisX, thisY + 132, width, musicVolume, 0, 1, sliderValueA(v), style)
    sfxSlider = newSlider(thisX, thisY + 198, width, sfxVolume, 0, 1, sliderValueA(v), style)
end

function updateSliders()
    if isSettingsWindowOpen then
        volumeSlider:update()
        sfxSlider:update()
    end
end

function scrollSettings(dx, dy)
    local x,y = (love.graphics.getWidth() * 0.5), (love.graphics.getHeight() * 0.5)
    if isMouseOver(
        x - (settPan.width * 0.5) + settPan.padding, 
        y - (settPan.height * 0.5)  + settPan.padding + settPan.titleOffset, 
        (settPan.width * 0.5) - (settPan.padding * 2), 
        (settPan.height) - (settPan.padding * 2) - settPan.titleOffset) then

            settSrl[1].vely =  settSrl[1].vely + dy * 512
            print("Position: " .. settSrl[1].posy .. ", Maximum: " .. settSrl[1].max)

    elseif isMouseOver(
        x + settPan.padding, 
        y - (settPan.height * 0.5) + settPan.padding, 
        (settPan.width * 0.5) - (settPan.padding * 2), 
        (settPan.height) - (settPan.padding * 2) - 40 - settPan.objectPadding) then

            settSrl[2].vely =  settSrl[2].vely + dy * 512
            print("Position: " .. settSrl[2].posy .. ", Maximum: " .. settSrl[2].max)
    end
end

function sliderValueA(v) end
