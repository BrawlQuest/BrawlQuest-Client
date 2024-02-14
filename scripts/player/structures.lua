--[[
    This file is player-built structures
]]

structures = {}

function updateWorldLookup() 
    for i,v in ipairs(structures) do
        worldLookup[v.x..","..v.y] = v
    end
end

function drawStructures()
    for i,v in ipairs(structures) do
        local asset = getWorldAsset(v.foregroundtile, v.x, v.y)
        love.graphics.draw(getImgIfNotExist(v.foregroundtile), v.x*32, v.y*32)
    end
end