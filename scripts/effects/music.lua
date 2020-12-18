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
        Skirmish2 = love.audio.newSource("assets/music/album1/Skirmish2.mp3", "stream")
    }

    worldMusic = {"PuerLavari", "Mining", "Sax"}

    titleMusic = love.audio.newSource("assets/music/album1/Longing.mp3", "stream")

    battleMusic = {"Titans", "Skirmish", "Skirmish2"}

    if musicVolume ~= 0 then
        currentPlaying = titleMusic:play()
        titleMusic:setVolume(musicVolume)
    end

end

function updateMusic(dt)
    if volumeSlider:getValue() ~= previousMusicVolume then
        musicVolume = volumeSlider:getValue()
        music[currentTrack]:setVolume(musicVolume)
        previousMusicVolume = musicVolume
        print("Music Volume: " .. musicVolume)
        writeSettings()
        if musicVolume == 0 then
            playMusic = false
        else
            playMusic = true
        end
    end

    if playMusic then
        if enemiesInAggro == 0 and not arrayContains(worldMusic, currentTrack) then
            switchMusic(worldMusic[love.math.random(1, #worldMusic)])
        elseif not arrayContains(battleMusic, currentTrack) and enemiesInAggro > 0 then
            switchMusic(battleMusic[love.math.random(1, #battleMusic)])
        end

        if isSwitching then
            if music[currentTrack]:getVolume() > 0.01 then
                music[currentTrack]:setVolume(music[currentTrack]:getVolume() - 0.3 * dt)
            else
                print("new track playing")
                music[currentTrack]:stop()
                isSwitching = false
                currentTrack = nextTrack
                music[currentTrack]:setVolume(musicVolume)
                music[currentTrack]:setLooping(true)
                currentPlaying = music[currentTrack]:play()
            end
        end
    end
end

function switchMusic(newTrack)

    if music[newTrack] ~= nil and newTrack ~= currentTrack then
        nextTrack = newTrack
        isSwitching = true
    elseif newTrack == currentTrack then
        print("Attempted to restart playback of already playing track.")
    else
        print("Attempted to play a track that doesn't exist: " .. newTrack)
    end
end
