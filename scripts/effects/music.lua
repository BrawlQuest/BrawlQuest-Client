--[[
    This file contains the logic for the music system.
    This is a dynamic system that fades music in and out as it's replaced.
]]

currentTrack = "PuerLavari"
nextTrack = "Titans"
isSwitching = false

function loadMusic() 
    music = {
        PuerLavari = love.audio.newSource("assets/music/album1/PuerLavari.mp3", "stream"),
        Titans = love.audio.newSource("assets/music/album1/Titans.mp3", "stream"),
        Skirmish = love.audio.newSource("assets/music/album1/Skirmish.mp3", "stream"),
        Skirmish2 = love.audio.newSource("assets/music/album1/Skirmish2.mp3", "stream")
    }

    battleMusic = {
        "Titans",
        "Skirmish",
        "Skirmish2"
    }
    
    currentPlaying = music["PuerLavari"]:play()
end

function updateMusic(dt)
    if enemiesInAggro == 0 and currentTrack ~= "PuerLavari" then
        switchMusic("PuerLavari")
    elseif not arrayContains(battleMusic, currentTrack) and enemiesInAggro > 0 then
        switchMusic(battleMusic[love.math.random(1,#battleMusic)])
    end
    
    if isSwitching then
        if music[currentTrack]:getVolume() > 0.01 then
            music[currentTrack]:setVolume(music[currentTrack]:getVolume() - 0.3*dt)
        else
            music[currentTrack]:stop()
            isSwitching = false
            currentTrack = nextTrack
            music[currentTrack]:setVolume(1)
         --   music[currentTrack]:set
            currentPlaying = music[currentTrack]:play()
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
        print("Attempted to play a track that doesn't exist: "..newTrack)
    end
end