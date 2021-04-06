--[[
    This file plays ambient sounds based on world tiles that are near the player.
]]

worldEmitters = {}
playingAmbience = {}

function addWorldEmitter(worldTile)
    if love.math.random(1,20) == 1 then
        if isTileType(worldTile.ForegroundTile, "Tree") then
            worldEmitters[#worldEmitters+1] = {
                x = worldTile.X*32,
                y = worldTile.Y*32,
                sound = "assets/sfx/ambient/forest/jungle.ogg",
            }
        elseif isTileType(worldTile.ForegroundTile, "Anvil") then
            worldEmitters[#worldEmitters+1] = {
                x = worldTile.X*32,
                y = worldTile.Y*32,
                sound = "assets/sfx/ambient/blacksmith.ogg",
            }
        elseif isTileType(worldTile.ForegroundTile, "Lava") then
            worldEmitters[#worldEmitters+1] = {
                x = worldTile.X*32,
                y = worldTile.Y*32,
                sound = "assets/sfx/ambient/lava.ogg",
            }
        elseif isTileType(worldTile.ForegroundTile, "Water") then
            worldEmitters[#worldEmitters+1] = {
                x = worldTile.X*32,
                y = worldTile.Y*32,
                sound = "assets/sfx/ambient/water.ogg"
            }
        elseif isTileType(worldTile.ForegroundTile, "Fire") or isTileType(worldTile.ForegroundTile, "Furnace") then
            worldEmitters[#worldEmitters+1] = {
                x = worldTile.X*32,
                y = worldTile.Y*32,
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
            if distanceToPoint(player.dx, player.dy, v.x, v.y) < 256 and not playingAmbience[v.x..","..v.y] and not arrayContains(playedThisTick, v.sound) and love.audio.getActiveSourceCount( ) < 10 then
                playAmbience(v)

            end
        end

        for key, source in next, playingAmbience do
            if source:isPlaying() then source:setVolume(sfxVolume*0.3)
            else table.removekey(playingAmbience, key) end
        end
    end
end

function playAmbience(v)
    local count = #playingAmbience + 1
    playingAmbience[v.x..","..v.y] = love.audio.newSource(v.sound, "stream")
    playingAmbience[v.x..","..v.y]:setPosition(v.x/32,v.y/32)
    playingAmbience[v.x..","..v.y]:setRolloff(1)
    playingAmbience[v.x..","..v.y]:setVolume(sfxVolume*0.3)
    setEnvironmentEffects(playingAmbience[v.x..","..v.y])
    playingAmbience[v.x..","..v.y]:play()
    playedThisTick[#playedThisTick+1] = v.sound
end