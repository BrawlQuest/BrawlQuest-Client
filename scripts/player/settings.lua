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


musicVolume = 1
sfxVolume = 1

function initSettings()
    
    info = love.filesystem.getInfo("settings.txt")

    if info then 
        contents, size = love.filesystem.read("string", "settings.txt")
        contents = json:decode(contents)
        keybinds = contents["keybinds"]
        musicVolume = contents["musicVolume"]
        sfxVolume = contents["sfxVolume"]
        selectedServer = contents["selectedServer"]
        api.url = servers[selectedServer].url

    else
        success,msg = love.filesystem.write("settings.txt", json:encode({
            keybinds = keybinds,
            musicVolume = musicVolume,
            sfxVolume = sfxVolume,
            selectedServer = 1
        }))
    end
end

function writeSettings()
    success,msg = love.filesystem.write("settings.txt", json:encode({
        keybinds = keybinds,
        musicVolume = musicVolume,
        sfxVolume = sfxVolume,
        selectedServer = selectedServer
    }))
end