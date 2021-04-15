local nf = {
    [1] = 0.009,  -- largeNoise - Main (creates islands)
    [2] = 0.07,   -- largeNoise - deviance
    [3] = 0.3,    -- smallNoise - mainly for putting in trees and stuff
    [4] = 0.08,  -- typeNoise  - where different tree types might be selected
    [5] = 0.0002  -- biomeNoise - different brackets from climate (0 cold, 1 hot)
}

function initBiomes()
    
end

function loadChunks(cx,cy)
    for x = 0, chunkSize - 1 do
        for y = 0, chunkSize - 1 do
            if not originalTiles[x + cx * chunkSize .. "," .. y + cy * chunkSize] then loadNoiseTiles(cx,cy,x,y) end
        end
    end
end

function loadNoiseTiles(cx,cy,x,y)
    local nx,ny = x + cx * chunkSize, y + cy * chunkSize

    local largeNoise = love.math.noise(nx * nf[1], ny * nf[1]) - love.math.noise(nx * nf[2], ny * nf[2]) * 0.1
    local smallNoise = love.math.noise(nx * nf[3], ny * nf[3]) * largeNoise
    local typeNoise = love.math.noise(nx * nf[4], ny * nf[4])
    local biomeNoise = love.math.noise(nx * nf[5], ny * nf[5])
    local groundColor = largeNoise * 1.5 - 0.5 - smallNoise * 0.04

    local biome
    local grass
    if biomeNoise < 0.3 + smallNoise * 0.01 then 
        biome = "Ice"
        grass = "assets/world/grounds/Snow.png"
    elseif biomeNoise < 0.6  - smallNoise * 0.01 then
        biome = "Grass"
        grass = "assets/world/grounds/grass/grass04.png"
    else
        biome = "Volcanic"
        grass = "assets/world/grounds/Cave Floor.png"
    end

    if largeNoise >= 0.8 - smallNoise * 0.05 then

        if biome == "Grass" then
            if smallNoise > 0.95 then
                createNoiseTile(grass, "assets/world/objects/lantern.png", cx,cy,x,y,nx,ny,groundColor)
            elseif smallNoise > 0.9 then
                local tree if typeNoise > 0.5 then tree = "assets/world/objects/Murky Tree.png" else tree = "assets/world/objects/tree.png" end
                createNoiseTile(grass, tree, cx,cy,x,y,nx,ny,groundColor)  -- draw Grass
            elseif smallNoise >= 0.8 then
                createNoiseTile(grass, "assets/world/objects/foliage/BQ Foliage-2.png", cx,cy,x,y,nx,ny,groundColor)  -- draw Grass
            else createNoiseTile(grass, nil, cx,cy,x,y,nx,ny,groundColor) end
        elseif biome == "Volcanic" then
            if largeNoise > 0.9 then createNoiseTile(grass, "assets/world/grounds/Lava.png", cx,cy,x,y,nx,ny,groundColor) 
            else createNoiseTile(grass, nil, cx,cy,x,y,nx,ny,groundColor) end
        else createNoiseTile(grass, nil, cx,cy,x,y,nx,ny,groundColor) end

    elseif largeNoise - smallNoise * 0.05 > 0.77 and biome ~= "Ice" then
        local blend
        if biome == "Grass" then blend = "assets/world/grounds/Sandy Grass.png" elseif biome == "Volcanic" then blend = "assets/world/grounds/Sandstone.png" end
        createNoiseTile(blend, nil, cx,cy,x,y,nx,ny,groundColor)
    elseif largeNoise > 0.7 then

        if largeNoise > 0.75 and smallNoise > 0.9 then
            createNoiseTile("assets/world/grounds/Sand.png", "assets/world/objects/Barrel.png", cx,cy,x,y,nx,ny,groundColor)
        elseif largeNoise > 0.71 and smallNoise > 0.94 then
            createNoiseTile("assets/world/grounds/Sand.png", "assets/world/objects/Cactus.png", cx,cy,x,y,nx,ny,groundColor)
        else
            createNoiseTile("assets/world/grounds/Sand.png", nil, cx,cy,x,y,nx,ny,groundColor) 
        end

    else createNoiseTile("assets/world/grounds/Water.png", nil, cx,cy,x,y,nx,ny, 0.6 + largeNoise * 0.4) end
end

function createNoiseTile(groundTile,foregroundTile,cx,cy,x,y,nx,ny,color)
    if not worldImg[groundTile] then worldImg[groundTile] = getImgIfNotExist(groundTile) end
    if not worldChunks[cx..","..cy] then worldChunks[cx..","..cy] = {} end
    local tile = {
        ["Collision"] = groundTile == "assets/world/grounds/Water.png",
        ["Enemy"] = "",
        ["ForegroundTile"] = foregroundTile or groundTile,
        ["GroundTile"] = groundTile,
        -- ["ID"] = 135248,
        ["Music"] = "Sax",
        ["Name"] = "Coastlands",
        ["X"] = nx,
        ["Y"] = ny,
        ["Color"] = color or 1,
    }
    worldChunks[cx..","..cy][#worldChunks[cx..","..cy]+1] = tile
    worldLookup[nx..","..ny] = tile
    if lightGivers[foregroundTile] and not lightSource[nx..","..ny] then
        lightSource[nx..","..ny] = true
        Luven.addNormalLight(16 + (nx * 32), 16 + (ny * 32), lightGivers[foregroundTile].color, lightGivers[foregroundTile].brightness)
    end
end