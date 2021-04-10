isWorldCreated = false
worldImages = {}
worldLookup = {}
lightSource = {}
noiseLights = {}
originalTiles = {}
chunkSize = 16
halfChunk = chunkSize / 2
chunkMap = {-3, 2, -2, 1}
chunkCount = 0

function tickWorld()
    player.wx, player.wy = math.floor((player.x + halfChunk) / chunkSize), math.floor((player.y + halfChunk) / chunkSize)
    player.worldPosition = player.wx .. "," .. player.wy
    if player.worldPosition ~= player.prevWorldPosition then
        player.prevWorldPosition = player.worldPosition
        createWorld()
    end
end

function drawSimplexNoise(x, y)
    local noiseFactor = 0.23 -- 0.18
    local noise = 1 - ((love.math.noise( x * 0.06, y * 0.06) - (love.math.noise( x * 0.5, y * 0.5) * 0.2)) * noiseFactor)
    love.graphics.setColor(noise * 1 ,noise * 1 ,noise )
end

function createWorld()
    if not love.filesystem.getInfo( "img" ) then love.filesystem.createDirectory( "img" ) end
    recalculateLighting()
    leaves = {}
    critters = {}
    worldEmitters = {}
    worldLookup = {}
    originalTiles = {}

    local tab = {}
    for x = chunkMap[1], chunkMap[2] do for y = chunkMap[3], chunkMap[4] do tab[#tab+1] = player.wx + x .."," .. player.wy + y end end

    for key,tiles in next, worldChunks do
        if orCalc(key, tab) then
            for i,v in ipairs(tiles) do

                worldLookup[v.X..","..v.Y] = copy(v)
                addWorldEmitter(v)
                
                if not isTileType(v.ForegroundTile, "Dead") and isTileType(v.ForegroundTile, "Tree") and love.math.random(1,5) == 1 then
                    if isTileType(v.ForegroundTile, "Snowy") then addLeaf(v.X*32 + 16, v.Y*32 + 16, "snowy tree")
                    else addLeaf(v.X*32 + 16, v.Y*32 + 16, "tree") end
                elseif isTileType(v.ForegroundTile, "Campfire") then addLeaf(v.X*32 + 16, v.Y*32 + 8, "fire")
                elseif isTileType(v.ForegroundTile, "Sand") then -- addLeaf(v.X*32 + 16, v.Y*32 + 16, "sand")
                elseif isTileType(v.GroundTile, "Murky") then addLeaf(v.X*32, v.Y*32+16, "murky") end
    
                if lightGivers[v.ForegroundTile] and not lightSource[v.X .. "," .. v.Y] then
                    lightSource[v.X .. "," .. v.Y] = true
                    Luven.addNormalLight(16 + (v.X * 32), 16 + (v.Y * 32), lightGivers[v.ForegroundTile].color, lightGivers[v.ForegroundTile].brightness)
                end
                if v.GroundTile and v.GroundTile ~= "" then originalTiles[v.X..","..v.Y] = true end
            end
        end
    end

    for key, v in next, worldImages do if not orCalc(key, tab) then v:release( ) table.removekey(worldImages, key) end end

    for cx = player.wx + chunkMap[1], player.wx + chunkMap[2] do
        for cy = player.wy + chunkMap[3], player.wy + chunkMap[4] do
            if not worldImages[cx..","..cy] then
                loadChunks(cx,cy)
                drawChunks(cx,cy)
            end
        end
    end

    -- for key,light in next, noiseLights do
    --     Luven.addNormalLight(16 + (light.x * 32), 16 + (light.y * 32), lightGivers["assets/world/objects/lantern.png"].color, lightGivers["assets/world/objects/lantern.png"].brightness)
    -- end

    -- if player.x and player.y then
    --     createNPCChatBackground(player.x,player.y)
    -- else
    --     createNPCChatBackground(0,0)
    -- end
end

function loadChunks(cx,cy)
    for x = 0, chunkSize - 1 do
        for y = 0, chunkSize - 1 do
            if not originalTiles[x + cx * chunkSize .. "," .. y + cy * chunkSize] then loadNoiseTiles(cx,cy,x,y) end
            -- generate new tiles
            -- add to worldLookup
            -- iterate through new tiles to find isTileWall or isTileWater
            -- draw new tiles end
        end
    end
end

function drawChunks(cx,cy)
    local fileString = "img/" .. cx .. "," .. cy .. ".tga"
    local info = love.filesystem.getInfo( fileString )
    if info then worldImages[cx..","..cy] = love.graphics.newImage(fileString) else
        chunkCanvas = love.graphics.newCanvas(32 * chunkSize, 32 * chunkSize)
        love.graphics.setCanvas(chunkCanvas)

        local originalTiles = {}
        for key,tiles in next, worldChunks do
            if key == cx .. "," .. cy then
                for i,v in ipairs(tiles) do
                    drawTile(v, cx, cy)
                    -- love.filesystem.write("tile.txt", json:encode_pretty(v))
                    addCritters(v)
                    local x,y = v.X - cx * chunkSize, v.Y - cy * chunkSize
                    
                end
            end
        end
        
        love.graphics.setCanvas()
        local imageData = chunkCanvas:newImageData( )
        imageData:encode("tga", "img/" .. cx .. "," .. cy .. ".tga")
        worldImages[cx..","..cy] = love.graphics.newImage(imageData)
    end
end

local nf = {0.009, 0.07, 0.002, 0.3} -- noise factors {0.006, 0.07, 0.1}
function loadNoiseTiles(cx,cy,x,y)
    local nx,ny = x + cx * chunkSize, y + cy * chunkSize
    -- drawSimplexNoise(nx,ny)  -- sets background noise
    -- love.graphics.draw(groundImg, x * 32, y * 32)

    local largeNoise = love.math.noise(nx * nf[1], ny * nf[1]) - love.math.noise(nx * nf[2], ny * nf[2]) * 0.1-- + love.math.noise(nx * nf[3], ny * nf[3]) * 0.2
    local smallNoise = love.math.noise(nx * nf[4], ny * nf[4])

    local groundColor = largeNoise * 1.5 - 0.5 - smallNoise * 0.04
    if largeNoise >= 0.8 - smallNoise * 0.05 then createNoiseTile("assets/world/grounds/grass/grass04.png",cx,cy,x,y,nx,ny,groundColor)
        if smallNoise > 0.9 and smallNoise < 0.85 and largeNoise > 0.83 then createNoiseTile("assets/world/objects/Beach Tree.png",cx,cy,x,y,nx,ny,groundColor)
        elseif smallNoise >= 0.95 then  createNoiseTile("assets/world/objects/lantern.png",cx,cy,x,y,nx,ny,groundColor)
            noiseLights[nx..","..ny] = {x = nx, y = ny,}
        end
    elseif largeNoise - smallNoise * 0.05 > 0.77 then createNoiseTile("assets/world/grounds/Sandy Grass.png",cx,cy,x,y,nx,ny,groundColor)
    elseif largeNoise > 0.7 then createNoiseTile("assets/world/grounds/Sand.png",cx,cy,x,y,nx,ny,groundColor)
        if smallNoise > 0.95 and largeNoise > 0.85 then createNoiseTile("assets/world/objects/foliage/BQ Foliage-3.png",cx,cy,x,y,nx,ny,groundColor) end
    else
        local waterColor = 0.6 + largeNoise * 0.4

        createNoiseTile("assets/world/grounds/Water.png",cx,cy,x,y,nx,ny,waterColor)
    end
end

function createNoiseTile(asset,cx,cy,x,y,nx,ny,color,foreground)
    if not worldImg[asset] then worldImg[asset] = getImgIfNotExist(asset) end
    love.graphics.draw(worldImg[asset], x * 32, y * 32)
    if not worldChunks[cx..","..cy] then worldChunks[cx..","..cy] = {} end
    worldChunks[cx..","..cy][#worldChunks[cx..","..cy]+1] = {
        ["Collision"] = asset == "assets/world/grounds/Water.png",
        ["Enemy"] = "",
        ["ForegroundTile"] = foreground or asset,
        ["GroundTile"] = asset,
        -- ["ID"] = 135248,
        ["Music"] = "Sax",
        ["Name"] = "Coastlands",
        ["X"] = nx,
        ["Y"] = ny,
        ["Color"] = color or 1,
    }
    worldLookup[nx..","..ny] = {
        ["Collision"] = asset == "assets/world/grounds/Water.png",
        ["Enemy"] = "",
        ["ForegroundTile"] = foreground or asset,
        ["GroundTile"] = asset,
        -- ["ID"] = 135248,
        ["Music"] = "Sax",
        ["Name"] = "Coastlands",
        ["X"] = nx,
        ["Y"] = ny,
        ["Color"] = color or 1,
    }
end

function drawTile(v, cx, cy)
    local x, y = v.X - cx * chunkSize, v.Y - cy * chunkSize -- draw
    local backgroundAsset = getWorldAsset(v.GroundTile, v.X, v.Y)
    local foregroundAsset = getWorldAsset(v.ForegroundTile, v.X, v.Y)
    if v.Color then love.graphics.setColor(v.Color, v.Color, v.Color) else drawSimplexNoise(v.X, v.Y) end
    if worldImg[backgroundAsset] then love.graphics.draw(worldImg[backgroundAsset], x * 32, y * 32) end
    love.graphics.setColor(0,0,0,0.5)
    if worldLookup[v.X..","..v.Y-1] and (isTileWall(worldLookup[v.X..","..v.Y-1].ForegroundTile) or isTileWall(worldLookup[v.X..","..v.Y-1].GroundTile)) and not isTileWall(v.ForegroundTile) then
        love.graphics.rectangle("fill", x * 32, y * 32, 32, 16)
    elseif (isTileWall(v.GroundTile) or isTileWall(v.ForegroundTile)) and not worldLookup[v.X..","..v.Y+1] then -- no tile below us but we still need to cast a shadow
        love.graphics.rectangle("fill", x * 32, y * 32, 32, 16)
    end 
    love.graphics.setColor(1,1,1,1)
    if foregroundAsset ~= backgroundAsset and worldImg[foregroundAsset] then love.graphics.draw(worldImg[foregroundAsset], (x) * 32, (y) * 32) end
end

function drawWorld()
    love.graphics.setColor(1,1,1,1)
    for key,img in next, worldImages do
        v = explode(key, ",")
        love.graphics.draw(img, v[1] * (32 * chunkSize), v[2] * (32 * chunkSize))
    end
end