function initSettingsPanel()
    settings = {
        Controls = {
            title = "Controls",
            keybinds = {title = "Keybindds", value = {
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
                }, 
            },
        },
        Graphics = {
            title = "Graphics",
            renderQuality = {title = "Render Quality", value = false, },
            fullscreen = {title = "Fullscreen", value = false, },
        },
        Sound = {
            title = "Sound",
            musicVolume = {title = "Music Volume", value = 1,},
            sfxVolume = {title = "SFX Volume", value = 1,},       
        },
        HUD = {
            title = "HUD",
            openOnMouseOver = {title = "Open on Mouse Over", value = true},
            showChat = {title = "Show Chat", value = true}
        },
    }

    sliderPosition = {
        music = {0, 0,},
        sfx = {0, 0,},
    }

    settingsPanel = {
        width = 335,
        height = 496,
    }

    questPopUpWidth = 335
    questPopUpHeight = 496
end

function updateSettingsPanel(dt)

end

function drawLargeSettingsPanel()
    local x,y = love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5
    local width, height = 335 * 2, 496
    local thisX, thisY = x - (width * 0.5), y - (height * 0.5)

    love.graphics.setColor(0,0,0,0.7)
    roundRectangle("fill", thisX, thisY, width, height, 10) -- draws the background
    love.graphics.setColor(1,1,1,1)

    volumeSlider:draw()
    sfxSlider:draw()

end

function loadSliders()
    local thisX, thisY = love.graphics.getWidth()/2 - (questPopUpWidth/2), (love.graphics.getHeight()/2)-(questPopUpHeight/2)+150
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