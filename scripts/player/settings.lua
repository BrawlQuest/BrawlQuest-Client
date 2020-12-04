keybinds = {
    UP = "w",
    DOWN = "s",
    LEFT = "a",
    RIGHT = "d",
    ATTACK_UP = "up",
    ATTACK_DOWN = "down",
    ATTACK_LEFT = "left",
    ATTACK_RIGHT = "right",
    SHIELD = "lshift"
}


musicVolume = 0
sfxVolume = 1

function initSettings()
    dpiScaling = true
    
    info = love.filesystem.getInfo("settings.txt")
    isSettingsWindowOpen = false

    if info then 
        contents, size = love.filesystem.read("string", "settings.txt")
        contents = json:decode(contents)
        keybinds = contents["keybinds"]
        musicVolume = contents["musicVolume"]
        sfxVolume = contents["sfxVolume"]
        selectedServer = contents["selectedServer"]
        dpiScaling = contents["dpiScaling"]
        api.url = servers[selectedServer].url
    else
        success,msg = love.filesystem.write("settings.txt", json:encode({
            keybinds = keybinds,
            musicVolume = musicVolume,
            sfxVolume = sfxVolume,
            selectedServer = 1,
            dpiScaling = dpiScaling,
        }))
    end
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
    volumeSlider:update()
    sfxSlider:update()
end

function writeSettings()
    success,msg = love.filesystem.write("settings.txt", json:encode({
        keybinds = keybinds,
        musicVolume = musicVolume,
        sfxVolume = sfxVolume,
        selectedServer = selectedServer,
        dpiScaling = dpiScaling,
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
            thisX, thisY = thisX, thisY + spacing
        end

        -- if dpiScaling then
            love.graphics.setColor(1,0,0,1)
            roundRectangle("fill", thisX, thisY + 40, questPopUpWidth - (padding*2), 40, 10)
            love.graphics.setColor(1,1,1,1)
            love.graphics.printf("High", thisX, thisY + 46, questPopUpWidth - (padding*2), "center")
        -- end

        love.graphics.setColor(1,1,1,1)
    end
end

function sliderValueA(v)

end

function checkSettingsMousePressed(button)
    local thisX, thisY = (love.graphics.getWidth()/2) - (questPopUpWidth/2)+20, (love.graphics.getHeight()/2)-(questPopUpHeight/2)
    -- if isMouseOver(thisX*scale, (thisY+14)*scale, 38*scale, 38*scale) then
    --     if button == 1 then
            
    --     end
    -- end
end