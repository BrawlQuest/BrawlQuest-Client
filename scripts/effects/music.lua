--[[
    This file contains the logic for the music system.
    This is a dynamic system that fades music in and out as it's replaced.
]]
function loadMusic()
    currentTrack = "PuerLavari"
    nextTrack = "Titans"
    isSwitching = false
    playMusic = true
    previousMusicVolume = musicVolume

    music = {
        PuerLavari = love.audio.newSource("assets/music/album1/PuerLavari.mp3", "stream"),
        Mining = love.audio.newSource("assets/music/album1/Mining.mp3", "stream"),
        Sax = love.audio.newSource("assets/music/album1/Sax.mp3", "stream"),
        Titans = love.audio.newSource("assets/music/album1/Titans.mp3", "stream"),
        Skirmish = love.audio.newSource("assets/music/album1/Skirmish.mp3", "stream"),
        Skirmish2 = love.audio.newSource("assets/music/album1/Skirmish2.mp3", "stream"),
        CaperOfCruelty = love.audio.newSource("assets/music/album1/CAPER_OF_CRUELTY_1.0.mp3", "stream"),
        ToFindTheOne = love.audio.newSource("assets/music/album1/To Find The one.mp3", "stream"),
        Heat = love.audio.newSource("assets/music/album1/HEAT 2.0.mp3", "stream"),
        HIJINKS = love.audio.newSource("assets/music/album1/HIJINKS 2.0.mp3", "stream"),
        Longing = love.audio.newSource("assets/music/album1/Longing.mp3", "stream"),
        Permafrost = love.audio.newSource("assets/music/temp/Some-Dreamy-Place.mp3", "stream"),
        Enchantment = love.audio.newSource("assets/music/ambient/enchant.mp3", "stream"),
        ["Enchantment Haunt"] = love.audio.newSource("assets/music/ambient/enchant haunt.mp3", "stream"),
        ["Dreamlands"] = love.audio.newSource("assets/music/temp/Dreamlands.mp3", "stream"),
        ["Of-Legends-and-Fables-2"] = love.audio.newSource("assets/music/temp/Of-Legends-and-Fables-2.mp3", "stream"),
        ["Of-Legends-and-Fables"] = love.audio.newSource("assets/music/temp/Of-Legends-and-Fables.mp3", "stream"),
        ["The-Castle-Mice"] = love.audio.newSource("assets/music/temp/The-Castle-Mice.mp3", "stream"),
        Warrior = love.audio.newSource("assets/music/classes/Warrior.mp3", "stream"),
        Mage = love.audio.newSource("assets/music/classes/Mage.mp3", "stream"),
        Stoic = love.audio.newSource("assets/music/classes/Stoic.mp3", "stream"),
        Jungle = love.audio.newSource("assets/music/temp/Lost-Meadow_Looping.mp3", "stream"),
        Foglands = love.audio.newSource("assets/music/temp/foglands.mp3", "stream")
    }
  

    worldMusic = {"Foglands", "Warrior", "Mage", "Stoic", "The-Castle-Mice", "Of-Legends-and-Fables", "PuerLavari", "Mining", "Sax", "ToFindTheOne", "Heat", "Longing", "Permafrost", "Enchantment", "Enchantment Haunt", "Dreamlands", "Of-Legends-and-Fables-2", "Jungle"}
    battleMusic = {"Titans", "Skirmish", "Skirmish2", "CaperOfCruelty", "HIJINKS", }

    musicSwitchAmount = 0

    titleMusic = love.audio.newSource("assets/music/album1/Longing Startup - Bass.mp3", "stream")
    previousMusicTile = null

    if musicVolume ~= 0 then
        currentPlaying = titleMusic:play()
        -- titleMusicFade:setVolume(musicVolume)
        titleMusic:setVolume(musicVolume)
    end
end

function updateMusic(dt)
    if volumeSlider:getValue() ~= previousMusicVolume then
        musicVolume = volumeSlider:getValue()
        previousMusicVolume = musicVolume
        if musicVolume == 0 then
            music[currentTrack]:stop()
            playMusic = false
        else
            playMusic = true
            checkMusic()
        end
    end

    if playMusic then
        if worldLookup[player.x..","..player.y] then
            local foundMusic = worldLookup[player.x..","..player.y].Music
            if foundMusic ~= (previousMusicTile) and not isSwitching then
                switchMusic(foundMusic)
                previousMusicTile = foundMusic
            end
        end

        if isSwitching then
            if arrayContains(battleMusic, nextTrack) then
                musicSwitchAmount = musicSwitchAmount - 2 * dt
            else
                musicSwitchAmount = musicSwitchAmount - 0.5 * dt
            end
            if musicSwitchAmount <= 0 then musicSwitchAmount = 0 end

            if musicSwitchAmount > 0 then
                music[currentTrack]:setVolume(cerp(0, musicVolume, musicSwitchAmount))
                music[nextTrack]:setVolume(cerp(musicVolume, 0, musicSwitchAmount))
            else
                music[currentTrack]:stop()
                isSwitching = false
                currentTrack = nextTrack
            end
        end
    end
end

function switchMusic(newTrack)

    if music[newTrack] ~= nil and newTrack ~= currentTrack then
        nextTrack = newTrack
        isSwitching = true
        musicSwitchAmount = 1
        music[nextTrack]:setVolume(musicVolume)
        music[nextTrack]:setLooping(true)
        currentPlaying = music[nextTrack]:play()
    -- elseif newTrack == currentTrack then
        -- print("Attempted to restart playback of already playing track.")
    -- else
        -- print("Attempted to play a track that doesn't exist: " .. newTrack)
    end
end

function checkMusic()
    if worldLookup[player.x..","..player.y] and worldLookup[player.x..","..player.y].Music and worldLookup[player.x..","..player.y].Music ~= "*" then
        setEnvironmentEffects(music[worldLookup[player.x..","..player.y].Music])
        currentPlaying = music[worldLookup[player.x..","..player.y].Music]:play()
    else
        currentPlaying = music["PuerLavari"]:play()
    end  
    music[currentTrack]:setVolume(musicVolume)
    music[currentTrack]:setLooping(true)
end