--[[
    This file plays ambient sounds based on world tiles that are near the player.
]]

worldEmitters = {}
playingAmbience = {}

function addWorldEmitter(worldTile)
    if love.math.random(1,20) == 1 then
        if isTileType(worldTile.foregroundtile, "Tree") then
            worldEmitters[#worldEmitters+1] = {
                x = worldTile.x*32,
                y = worldTile.y*32,
                sound = "assets/sfx/ambient/forest/jungle.ogg",
            }
        elseif isTileType(worldTile.foregroundtile, "Anvil") then
            worldEmitters[#worldEmitters+1] = {
                x = worldTile.x*32,
                y = worldTile.y*32,
                sound = "assets/sfx/ambient/blacksmith.ogg",
            }
        elseif isTileType(worldTile.foregroundtile, "Lava") then
            worldEmitters[#worldEmitters+1] = {
                x = worldTile.x*32,
                y = worldTile.y*32,
                sound = "assets/sfx/ambient/lava.ogg",
            }
        elseif isTileType(worldTile.foregroundtile, "Water") then
            worldEmitters[#worldEmitters+1] = {
                x = worldTile.x*32,
                y = worldTile.y*32,
                sound = "assets/sfx/ambient/water.ogg"
            }
        elseif isTileType(worldTile.foregroundtile, "Class Machine") then
            worldEmitters[#worldEmitters+1] = {
                x = worldTile.x*32,
                y = worldTile.y*32,
                sound = "assets/sfx/ambient/voltage.ogg",
            }
        elseif isTileType(worldTile.foregroundtile, "Fire") or isTileType(worldTile.foregroundtile, "Furnace") then
            worldEmitters[#worldEmitters+1] = {
                x = worldTile.x*32,
                y = worldTile.y*32,
                sound = "assets/sfx/ambient/fire.ogg"
            }
        end
    end
end

local playedThisTick = {}
local playAmount = 0
local playSpeed = 1

function updateWorldEmitters(dt)
    playAmount = playAmount + playSpeed * dt
    if playAmount >= 1 then
        playAmount = 0
        playSpeed = 1 - love.math.random() * 0.5
        playedThisTick = {}
        for i,v in pairs(worldEmitters) do
            if distanceToPoint(player.dx, player.dy, v.x, v.y) < 256 and not playingAmbience[v.x..","..v.y] and not arrayContains(playedThisTick, v.sound) and love.audio.getActiveSourceCount( ) < 15 then
                playAmbience(v)
            end
        end

        for key, source in next, playingAmbience do
            if source:isPlaying() then
                local v = explode(key, ",")
                source:setVolume(sfxVolume*0.3)
                if distanceToPoint(player.dx, player.dy, v[1], v[2]) > 256 * 3 then stopSource(source, key) end
            else
                stopSource(source, key)
            end
        end
    end
end

function stopSource(source, key)
    source:stop()
    source:release()
    table.removekey(playingAmbience, key)
end

function playAmbience(v)
    playingAmbience[v.x..","..v.y] = love.audio.newSource(v.sound, "stream")
    if  playingAmbience[v.x..","..v.y]:getChannelCount() == 1 then
        playingAmbience[v.x..","..v.y]:setPosition(v.x/32,v.y/32)
        playingAmbience[v.x..","..v.y]:setRolloff(1)
     
        setEnvironmentEffects(playingAmbience[v.x..","..v.y])
    end
    playingAmbience[v.x..","..v.y]:setVolume(sfxVolume*0.3)
        playingAmbience[v.x..","..v.y]:play()
    playedThisTick[#playedThisTick+1] = v.sound
end