--[[
    This file contains the logic for the music system.
    This is a dynamic system that fades music in and out as it's replaced.
]]
currentTrack = "PuerLavari"
nextTrack = "Titans"
isSwitching = false
playMusic = true

function loadMusic()

    previousMusicVolume = musicVolume

    music = {
        PuerLavari = love.audio.newSource("assets/music/album1/PuerLavari.mp3", "stream"),
        Mining = love.audio.newSource("assets/music/album1/Mining.mp3", "stream"),
        Sax = love.audio.newSource("assets/music/album1/Sax.mp3", "stream"),
        Titans = love.audio.newSource("assets/music/album1/Titans.mp3", "stream"),
        Skirmish = love.audio.newSource("assets/music/album1/Skirmish.mp3", "stream"),
        Skirmish2 = love.audio.newSource("assets/music/album1/Skirmish2.mp3", "stream"),
        CaperOfCruelty = love.audio.newSource("assets/music/album1/CAPER_OF_CRUELTY_1.0.mp3", "stream"),
    }

    worldMusic = {"PuerLavari", "Mining", "Sax"}
    battleMusic = {"Titans", "Skirmish", "Skirmish2", "CaperOfCruelty"}

    musicSwitchAmount = 0

    titleMusic = love.audio.newSource("assets/music/album1/Longing.mp3", "stream")
    previousMusicTile = null

    if musicVolume ~= 0 then
        currentPlaying = titleMusic:play()
        titleMusic:setVolume(musicVolume)
    end
end

function updateMusic(dt)
    if volumeSlider:getValue() ~= previousMusicVolume then
        musicVolume = volumeSlider:getValue()
        previousMusicVolume = musicVolume
        -- print("Music Volume: " .. musicVolume)
        if musicVolume == 0 then
            playMusic = false
        else
            playMusic = true
            currentPlaying = "PuerLavari"
            music[currentTrack]:setVolume(musicVolume)
        end
        writeSettings()
    end

    if playMusic then
        if worldLookup[player.x] and worldLookup[player.x][player.y] then
            local foundMusic = worldLookup[player.x][player.y].Music
            if foundMusic ~= (previousMusicTile) then
                -- if foundMusic == "*" then
                --     switchMusic("PuerLavari")
                --     previousMusicTile = "PuerLavari"
                -- else
                    switchMusic(foundMusic)
                    previousMusicTile = foundMusic
                -- end
            end
        end

        -- if enemiesInAggro == 0 and not arrayContains(worldMusic, currentTrack) then
        --     switchMusic(worldMusic[love.math.random(1, #worldMusic)])
        -- elseif not arrayContains(battleMusic, currentTrack) and enemiesInAggro > 0 then
        --     switchMusic(battleMusic[love.math.random(1, #battleMusic)])
        -- end

        if isSwitching then
            musicSwitchAmount = musicSwitchAmount - 1 * dt
            if musicSwitchAmount <= 0 then musicSwitchAmount = 0 end

            if musicSwitchAmount > 0 then
                music[currentTrack]:setVolume(cerp(0, musicVolume, musicSwitchAmount))
                music[nextTrack]:setVolume(cerp(musicVolume, 0, musicSwitchAmount))
            else
                music[currentTrack]:stop()
                isSwitching = false
                currentTrack = nextTrack
            end
            --[[
            if music[currentTrack]:getVolume() > 0.01 then
                if arrayContains(battleMusic, nextTrack) then
                    music[currentTrack]:setVolume(music[currentTrack]:getVolume() - 2 * dt)
                else
                    music[currentTrack]:setVolume(music[currentTrack]:getVolume() - 0.8 * dt)
                end
            else
                music[currentTrack]:stop()
                isSwitching = false
                currentTrack = nextTrack
                music[currentTrack]:setVolume(musicVolume)
                music[currentTrack]:setLooping(true)
                currentPlaying = music[currentTrack]:play()
            end
            ]]
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
