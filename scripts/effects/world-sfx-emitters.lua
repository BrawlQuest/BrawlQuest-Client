--[[
    This file plays ambient sounds based on world tiles that are near the player.
]]

worldEmitters = {}

worldEmitSounds = {
    jungle = love.audio.newSource("assets/sfx/ambient/forest/jungle.ogg", "stream"),
    blacksmith =  love.audio.newSource("assets/sfx/ambient/blacksmith.ogg", "stream"),
    lava = love.audio.newSource("assets/sfx/ambient/lava.ogg", "stream"),
    water = love.audio.newSource("assets/sfx/ambient/water.ogg", "stream")
}

function addWorldEmitter(worldTile)
    if love.math.random(1,5) == 1 then
        if isTileType(worldTile.ForegroundTile, "Tree") then
            worldEmitters[#worldEmitters+1] = {
                x = worldTile.X*32,
                y = worldTile.Y*32,
                sound = "jungle",
            }
        elseif isTileType(worldTile.ForegroundTile, "Anvil") then
            worldEmitters[#worldEmitters+1] = {
                x = worldTile.X*32,
                y = worldTile.Y*32,
                sound = "blacksmith",
            }
        elseif isTileType(worldTile.ForegroundTile, "Lava") then
            worldEmitters[#worldEmitters+1] = {
                x = worldTile.X*32,
                y = worldTile.Y*32,
                sound = "lava",
            }
        elseif isTileType(worldTile.ForegroundTile, "Water") then
            worldEmitters[#worldEmitters+1] = {
                x = worldTile.X*32,
                y = worldTile.Y*32,
                sound = "water"
            }
        end
    end
end

function updateWorldEmitters()
    for i,v in pairs(worldEmitters) do
        if distanceToPoint(player.dx, player.dy, v.x, v.y) < 256 then
            if love.math.random(1,10) == 1 and not worldEmitSounds[v.sound]:isPlaying()  then
                if worldEmitSounds[v.sound]:getChannelCount() == 1 then
                    worldEmitSounds[v.sound]:setPosition(v.x/32,v.y/32)
                end
                worldEmitSounds[v.sound]:setVolume(sfxVolume*0.2)
                worldEmitSounds[v.sound]:play()
            end
        end
    end
end