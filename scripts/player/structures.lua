--[[
    This file is player-built structures
]]

structures = {}

function updateWorldLookup() 
    for i,v in ipairs(structures) do
        worldLookup[v.X..","..v.Y] = v
    end
end

function drawStructures()
    for i,v in ipairs(structures) do
        local asset = getWorldAsset(v.ForegroundTile, v.X, v.Y)
        love.graphics.draw(worldImg[asset], v.X*32, v.Y*32)
    end
end