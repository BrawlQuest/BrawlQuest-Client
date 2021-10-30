isWorldCreated = false
leaves = {}
worldEmitters = {}
worldImages = {}
worldLookup = {}
lightSource = {}
serverTiles = {}
worldToCreate = {}
worldToDestroy = {}
loadedChunks = {}
chunkSize = 4
halfChunk = chunkSize / 2
chunkMap = {-8, 8, -6, 6} --{-3, 2, -2, 1}
chunkCount = 0

--[[
Get chunks from api

]]

function initWorldTable(world)
    worldChunks = {}
    worldLookup = {}
    for i,tile in ipairs(world) do
        -- get chunk x and y values
        local x,y = math.floor((tile.X) / chunkSize), math.floor((tile.Y) / chunkSize)
        -- add tile to chunk, works perfectly
        if not worldChunks[x..","..y] then worldChunks[x..","..y] = {} end
        if player.world == 0 then worldChunks[x..","..y][#worldChunks[x..","..y] + 1] = copy(tile) end
        -- init world lookup table
        worldLookup[tile.X..","..tile.Y] = tile
          addLeavesAndLights(tile)
            addCritters(tile)
        loadedChunks = {}
    end
    initWorldMap()
end

function tickWorld()
    -- gets players position
    player.wx, player.wy = math.floor((player.x + halfChunk) / chunkSize), math.floor((player.y + halfChunk) / chunkSize)
    player.worldPosition = player.wx .. "," .. player.wy
    -- creates the world only when necessary
    if player.worldPosition ~= player.prevWorldPosition or not worldLookup[player.worldPosition] then
        player.prevWorldPosition = player.worldPosition
        createWorld()
    end
end

function updateWorld(dt)
    -- creates the world only when necessary
    if #worldToCreate > 0 then
        local v = worldToCreate[#worldToCreate]
        loadChunks(v.cx, v.cy)
        drawChunks(v.cx, v.cy)
        table.remove(worldToCreate, #worldToCreate)
    end

    if #worldToDestroy > 0 then
        local v = worldToDestroy[#worldToDestroy]
        destroyChunks(v)
        table.remove(worldToDestroy, #worldToDestroy)
    end
end

function destroyChunks(key)
    if worldImages[key] then
        worldImages[key]:release( )
        table.removekey(worldImages, key)
        table.removekey(loadedChunks, key)
    end
end

function createWorld()
    -- creates folder for images
    if not love.filesystem.getInfo( "img" ) then love.filesystem.createDirectory( "img" ) end

    local chunksAroundPlayer = {}
    -- create table entries
    for x = chunkMap[1], chunkMap[2] do
        for y = chunkMap[3], chunkMap[4] do
            chunksAroundPlayer[#chunksAroundPlayer+1] = {
                key = player.wx + x .. "," .. player.wy + y,
                cx = player.wx + x,
                cy = player.wy + y,
            }
        end
    end

    -- for each loaded chunk, destroy what's out of range
    for key, chunk in pairs(loadedChunks) do
        local found = false
        for i,v in pairs(chunksAroundPlayer) do
            if key == v.key then found = true end
        end
        if not found then worldToDestroy[#worldToDestroy+1] = key end
    end

    -- for players current position, load chunk only

    -- local key = player.wx..","..player.wy
    for oop, chunk in ipairs(chunksAroundPlayer) do
        -- if the chunk is a part of the world and if chunk is not already drawn
        if not loadedChunks[chunk.key] then
            if worldChunks[chunk.key] then
                for i, v in ipairs(worldChunks[chunk.key]) do
                    -- worldLookup[v.X..","..v.Y] = v
                    if v.GroundTile and v.GroundTile ~= "" then serverTiles[v.X..","..v.Y] = true end
                end
            end
            -- defines that this chunk is loaded ans does not need to be loaded again
            loadedChunks[chunk.key] = "true"
            worldToCreate[#worldToCreate+1] = {cx = chunk.cx, cy = chunk.cy,}
        end
    end
end

function addLeavesAndLights(v)
    if showWorldAnimations then -- add world animations such as leaves and smoke
        addWorldEmitter(v)
        if not isTileType(v.ForegroundTile, "Dead") and isTileType(v.ForegroundTile, "Tree") and love.math.random(1,5) == 1 then
            if isTileType(v.ForegroundTile, "Snowy") then addLeaf(v.X*32 + 16, v.Y*32 + 16, "snowy tree")
            else addLeaf(v.X*32 + 16, v.Y*32 + 16, "tree") end
        elseif isTileType(v.ForegroundTile, "Campfire") then addLeaf(v.X*32 + 16, v.Y*32 + 8, "fire")
        elseif isTileType(v.ForegroundTile, "Sand") then -- addLeaf(v.X*32 + 16, v.Y*32 + 16, "sand")
        elseif isTileType(v.GroundTile, "Murky") then addLeaf(v.X*32, v.Y*32+16, "murky") end
    end
    -- set the lights that the world gives
    if lightGivers[v.ForegroundTile] then--and not lightSource[v.X .. "," .. v.Y] then
        lightSource[v.X .. "," .. v.Y] = true
        Luven.addNormalLight(16 + (v.X * 32), 16 + (v.Y * 32), lightGivers[v.ForegroundTile].color, lightGivers[v.ForegroundTile].brightness)
    end
end

function drawChunks(cx,cy)
    local fileString = "img/" .. cx .. "," .. cy .. ".tga"
    local info = love.filesystem.getInfo( fileString )
    if info then
        worldImages[cx..","..cy] = love.graphics.newImage(fileString)
    else
        -- load chunk
        chunkCanvas = love.graphics.newCanvas(32 * chunkSize, 32 * chunkSize)
        love.graphics.setCanvas(chunkCanvas)

        local chunkTiles = worldChunks[cx .. "," .. cy]
        
        for i,v in ipairs(chunkTiles) do
            drawTile(v, cx, cy)
          
        end

        love.graphics.setCanvas()
        local imageData = chunkCanvas:newImageData( )
        -- imageData:encode("tga", "img/" .. cx .. "," .. cy .. ".tga")
        worldImages[cx..","..cy] = love.graphics.newImage(imageData)
    end
end

function drawTile(v, cx, cy)
    local x, y = v.X - cx * chunkSize, v.Y - cy * chunkSize -- draw

    -- get assets
    local backgroundAsset = getWorldAsset(v.GroundTile, v.X, v.Y)
    local foregroundAsset = getWorldAsset(v.ForegroundTile, v.X, v.Y)

    -- draw noise
    if v.Color then love.graphics.setColor(v.Color, v.Color, v.Color) else drawSimplexNoise(v.X, v.Y) end

    -- draw background
    if worldImg[backgroundAsset] then love.graphics.draw(worldImg[backgroundAsset], x * 32, y * 32) end

    -- shadows
    love.graphics.setColor(0,0,0,0.5)
    if worldLookup[v.X..","..v.Y-1] and (isTileWall(worldLookup[v.X..","..v.Y-1].ForegroundTile) or isTileWall(worldLookup[v.X..","..v.Y-1].GroundTile)) and not isTileWall(v.ForegroundTile) then
        love.graphics.rectangle("fill", x * 32, y * 32, 32, 16)
    elseif (isTileWall(v.GroundTile) or isTileWall(v.ForegroundTile)) and not worldLookup[v.X..","..v.Y+1] then -- no tile below us but we still need to cast a shadow
        love.graphics.rectangle("fill", x * 32, y * 32, 32, 16)
    end

    -- draw noise
    if v.Color then love.graphics.setColor(v.Color, v.Color, v.Color) else drawSimplexNoise(v.X, v.Y) end

    -- draw foreground
    if foregroundAsset ~= backgroundAsset and worldImg[foregroundAsset] then love.graphics.draw(worldImg[foregroundAsset], (x) * 32, (y) * 32) end
end

function drawWorld()
    love.graphics.setColor(1,1,1,1)
    for key,img in next, worldImages do
        v = explode(key, ",")
        love.graphics.draw(img, v[1] * (32 * chunkSize), v[2] * (32 * chunkSize))
    end
end

function drawSimplexNoise(x, y)
    local noise
    local noiseFactor = 0.23 -- 0.18
    local noises = {
        love.math.noise((x * 0.009) - player.world, (y * 0.009) + player.world),
        love.math.noise((x * 0.07) - player.world, (y * 0.07) + player.world) * 0.1,
        love.math.noise( (x * 0.06) - player.world, (y * 0.06) + player.world),
        love.math.noise( (x * 0.5) - player.world, (y * 0.5) + player.world) * 0.2,
        love.math.noise( (x * 0.06) - player.world, (y * 0.06) + player.world),
        love.math.noise( (x * 0.5) - player.world, (y * 0.5) + player.world) * 0.2,
    }
    islandNoise = math.clamp(0.8, noises[1] - noises[2], 1) + ((noises[3] - noises[4]) * 2 - 1) * 0.1
    if islandNoise > 0.85 then noise = islandNoise else noise = 1 - ((noises[5] - noises[6]) * noiseFactor) end
    noise = islandNoise
    love.graphics.setColor(noise * 1 ,noise * 1 ,noise )
end

