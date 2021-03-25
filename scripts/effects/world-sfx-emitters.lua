--[[
    This file plays ambient sounds based on world tiles that are near the player.
]]

worldEmitters = {}

function addWorldEmitter(worldTile)
    if love.math.random(1,100) == 1 then
        if isTileType(worldTile.ForegroundTile, "Tree") then
            worldEmitters[#worldEmitters+1] = {
                x = worldTile.X*32,
                y = worldTile.Y*32,
                sound = love.audio.newSource("assets/sfx/ambient/forest/jungle.ogg", "stream")
            }
        elseif isTileType(worldTile.ForegroundTile, "Anvil") then
            worldEmitters[#worldEmitters+1] = {
                x = worldTile.X*32,
                y = worldTile.Y*32,
                sound = love.audio.newSource("assets/sfx/ambient/blacksmith.ogg", "stream")
            }
        elseif isTileType(worldTile.ForegroundTile, "Lava") then
            worldEmitters[#worldEmitters+1] = {
                x = worldTile.X*32,
                y = worldTile.Y*32,
                sound = love.audio.newSource("assets/sfx/ambient/lava.ogg", "stream")
            }
        elseif isTileType(worldTile.ForegroundTile, "Water") then
            worldEmitters[#worldEmitters+1] = {
                x = worldTile.X*32,
                y = worldTile.Y*32,
                sound = love.audio.newSource("assets/sfx/ambient/water.ogg", "stream")
            }
        end
    end
end

function updateWorldEmitters()
    for i,v in pairs(worldEmitters) do
        
        if distanceToPoint(player.dx, player.dy, v.x, v.y) < 256 then
            if v.sound:isPlaying() then
                if v.sound:getChannelCount() == 1 then
                    v.sound:setPosition(v.x/32,v.y/32)
                end
            elseif love.math.random(1,100) then
                if v.sound:getChannelCount() == 1 then
                    v.sound:setPosition(v.x/32,v.y/32)
                end
                v.sound:play()
            end
        end
    end
end