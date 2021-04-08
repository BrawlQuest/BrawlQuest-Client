isWorldCreated = false
worldCanvas = {}
worldLookup = {}
lightSource = {}
chunkSize = 128
halfChunk = chunkSize / 2

function tickWorld()
    player.wx, player.wy = math.floor((player.x + halfChunk) / chunkSize), math.floor((player.y + halfChunk) / chunkSize)
    player.worldPosition = player.wx .. "," .. player.wy
    if player.worldPosition ~= player.prevWorldPosition then
        player.prevWorldPosition = player.worldPosition
        recreateWorld()
    end
end

function drawSimplexNoise(x, y)
    local noiseFactor = 0.23 -- 0.18
    local noise = 1 - ((love.math.noise( x * 0.06, y * 0.06) - (love.math.noise( x * 0.5, y * 0.5) * 0.2)) * noiseFactor)
    love.graphics.setColor(noise * 1 ,noise * 1 ,noise )
end

function createWorld()
    -- for key, v in next, worldChunks do
    --     if orCalc(key, {player.wx - 1 ..","..player.wy - 1, player.wx..","..player.wy - 1, player.wx - 1 ..","..player.wy, player.wx..","..player.wy,}) then
    --         for i, tile in ipairs(v) do
                
    --         end
    --     end
    -- end

    -- for i,v in ipairs(world) do
    --     if not worldLookup[v.X] then worldLookup[v.X] = {} end
    --     worldLookup[v.X][v.Y] = copy(v)
    -- end

    recreateWorld()

    if player.x and player.y then
        createNPCChatBackground(player.x,player.y)
    else
        createNPCChatBackground(0,0)
    end
end

function recreateWorld()
    recalculateLighting()
    leaves = {}
    critters = {}
    worldEmitters = {}
    worldLookup = {}

    for key,tiles in next, worldChunks do
        if orCalc(key, {player.wx - 1 ..","..player.wy - 1, player.wx..","..player.wy - 1, player.wx - 1 ..","..player.wy, player.wx..","..player.wy,}) then
            for i,v in ipairs(tiles) do
                if not worldLookup[v.X] then worldLookup[v.X] = {} end
                worldLookup[v.X][v.Y] = copy(v)

                addWorldEmitter(v)
                if not isTileType(v.ForegroundTile, "Dead") and isTileType(v.ForegroundTile, "Tree") and love.math.random(1,5) == 1 then
                    if isTileType(v.ForegroundTile, "Snowy") then addLeaf(v.X*32 + 16, v.Y*32 + 16, "snowy tree")
                    else addLeaf(v.X*32 + 16, v.Y*32 + 16, "tree") end
                elseif isTileType(v.ForegroundTile, "Campfire") then
                    addLeaf(v.X*32 + 16, v.Y*32 + 8, "fire")
                elseif isTileType(v.ForegroundTile, "Sand") then
                    -- addLeaf(v.X*32 + 16, v.Y*32 + 16, "sand")
                elseif isTileType(v.GroundTile, "Murky") then
                    addLeaf(v.X*32, v.Y*32+16, "murky")
                end
    
                if lightGivers[v.ForegroundTile] and not lightSource[v.X .. "," .. v.Y] then
                    lightSource[v.X .. "," .. v.Y] = true
                    Luven.addNormalLight(16 + (v.X * 32), 16 + (v.Y * 32), lightGivers[v.ForegroundTile].color, lightGivers[v.ForegroundTile].brightness)
                end
            end
        end
    end

    for key, v in next, worldCanvas do v.map:release( ) end

    local dim = {32 * chunkSize, 32 * chunkSize}
    worldCanvas = {}

    for cx = player.wx - 1, player.wx do
        for cy = player.wy - 1, player.wy do
            worldCanvas[cx..","..cy] = {cx = cx, cy = cy, map = love.graphics.newCanvas(unpack(dim))}
            love.graphics.setCanvas(worldCanvas[cx .. "," .. cy].map)
            love.graphics.clear()
            love.graphics.setColor(1, love.math.random(), love.math.random(), 0.8)

            local originalTiles = {}
            for key,tiles in next, worldChunks do
                if orCalc(key, {player.wx - 1 ..","..player.wy - 1, player.wx..","..player.wy - 1, player.wx - 1 ..","..player.wy, player.wx..","..player.wy,}) then
                    for i,v in ipairs(tiles) do
                        if v.X >= cx * chunkSize and v.X < (cx + 1) * chunkSize and v.Y >= cy * chunkSize and v.Y < (cy + 1) * chunkSize then
                            drawTile(v, cx, cy)
                            addCritters(v)
                            local x,y = v.X - cx * chunkSize, v.Y - cy * chunkSize
                            if v.GroundTile and v.GroundTile ~= "" then originalTiles[x..","..y] = true end
                        end
                    end
                end
            end

            local groundTiles = {}
            for x = 0, chunkSize - 1 do
                for y = 0, chunkSize - 1 do
                    if not originalTiles[x..","..y] then drawGroundImages(cx,cy,x,y,groundTiles) end
                end
            end

            love.graphics.setCanvas()
        end
    end
end

local nf = {0.009, 0.07, 0.1, 0.3} -- noise factors {0.006, 0.07, 0.1}
function drawGroundImages(cx,cy,x,y,groundTiles)
    local nx,ny = x + cx * chunkSize, y + cy * chunkSize
    -- drawSimplexNoise(nx,ny)  -- sets background noise
    -- love.graphics.draw(groundImg, x * 32, y * 32)

    local largeNoise = love.math.noise(nx * nf[1], ny * nf[1]) - love.math.noise(nx * nf[2], ny * nf[2]) * 0.1 - love.math.noise(nx * nf[3], ny * nf[3]) * 0.0
    local smallNoise = love.math.noise(nx * nf[4], ny * nf[4])

    local groundColor = largeNoise * 1.5 - 0.5 - smallNoise * 0.04
    love.graphics.setColor(groundColor, groundColor, groundColor)

    if largeNoise >= 0.8 - smallNoise * 0.05 then
        drawNoiseTile("assets/world/grounds/grass/grass04.png",x,y)
        if smallNoise > 0.9 and smallNoise < 0.85 and largeNoise > 0.83 then drawNoiseTile("assets/world/objects/Beach Tree.png",x,y) 
        elseif smallNoise >= 0.95 then 
            drawNoiseTile("assets/world/objects/lantern.png",x,y)
            Luven.addNormalLight(16 + (nx * 32), 16 + (ny * 32), lightGivers["assets/world/objects/lantern.png"].color, lightGivers["assets/world/objects/lantern.png"].brightness)
        end
        groundTiles[nx..","..ny] = true
    elseif largeNoise - smallNoise * 0.05 > 0.77 then
        drawNoiseTile("assets/world/grounds/Sandy Grass.png",x,y)
        groundTiles[nx..","..ny] = true
    elseif largeNoise > 0.7 then
        drawNoiseTile("assets/world/grounds/Sand.png",x,y)
        if smallNoise > 0.95 and largeNoise > 0.85 then drawNoiseTile("assets/world/objects/foliage/BQ Foliage-3.png",x,y) end
        groundTiles[nx..","..ny] = true
    end

    -- if not groundTiles[nx..","..ny] and smallNoise < largeNoise * 0.5 then
    --     drawNoiseTile("assets/world/grounds/Sand.png",x,y) groundTiles[nx..","..ny] = true
    -- end

    local waterColor = 0.6 + largeNoise * 0.4
    love.graphics.setColor(waterColor, waterColor, waterColor)
    if not groundTiles[nx..","..ny] then drawNoiseTile("assets/world/grounds/Water.png",x,y) end
end

function drawNoiseTile(asset,x,y)
    love.graphics.draw(worldImg[asset], x * 32, y * 32)
end

function drawTile(v, cx, cy)
    local x, y = v.X - cx * chunkSize, v.Y - cy * chunkSize -- draw
    local backgroundAsset = getWorldAsset(v.GroundTile, v.X, v.Y)
    local foregroundAsset = getWorldAsset(v.ForegroundTile, v.X, v.Y)
    drawSimplexNoise(v.X, v.Y)
    if worldImg[backgroundAsset] then love.graphics.draw(worldImg[backgroundAsset], x * 32, y * 32) end
    love.graphics.setColor(0,0,0,0.5)
    if worldLookup[v.X][v.Y-1] and (isTileWall(worldLookup[v.X][v.Y-1].ForegroundTile) or isTileWall(worldLookup[v.X][v.Y-1].GroundTile)) and not isTileWall(v.ForegroundTile) then
        love.graphics.rectangle("fill", x * 32, y * 32, 32, 16)
    elseif (isTileWall(v.GroundTile) or isTileWall(v.ForegroundTile)) and not worldLookup[v.X][v.Y+1] then -- no tile below us but we still need to cast a shadow
        love.graphics.rectangle("fill", x * 32, y * 32, 32, 16)
    end 
    love.graphics.setColor(1,1,1,1)
    if foregroundAsset ~= backgroundAsset and worldImg[foregroundAsset] then love.graphics.draw(worldImg[foregroundAsset], (x) * 32, (y) * 32) end
end

function drawWorld()
    love.graphics.setColor(1,1,1,1)
    love.graphics.setBlendMode("alpha", "premultiplied")
    for key, canvas in next, worldCanvas do
        love.graphics.draw(worldCanvas[key].map, canvas.cx * (32 * chunkSize), canvas.cy * (32 * chunkSize))
    end
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(1,1,1)
end

function drawCanvases(x, y, canvas, lowX, lowY, highX, highY)
    love.graphics.draw(canvas.map, lowX, lowY)
    local modes = {{x,0}, {0,y}, {x,y},}
    for i,v in ipairs(modes) do
        local key = canvas.cx + v[1] .. "," .. canvas.cy + v[2]
        if worldCanvas[key] then love.graphics.draw(worldCanvas[key].map, (canvas.cx + v[1]) * (32 * chunkSize), (canvas.cy + v[2]) * (32 * chunkSize)) end
    end
end

function getWorldAsset(v,x,y)
    if isTileWall(v) then v = getDrawableWall(v, x,y) end
    if isTileWater(v) then v = getDrawableWater(v, x, y) end
    return v
end

function isTileType(tileName, typeName)
    return  string.find(string.lower(tileName), string.lower(typeName), 1)
end

function isTileWall(tileName)
    return isTileType(tileName, "Wall")
end

function getDrawableWall(tileName, x, y) -- this is used to smooth the corners of walls appropriately
    local fp = explode(tileName, "/")
    tileName = explode(fp[#fp], ".")[1]
    local nearby = {
        top = false,
        left = false,
        right = false,
        bottom = false,
    }
    if  worldLookup[x-1] and 
    worldLookup[x+1] and 
    worldLookup[x] then
    local worldToCheck = {
        worldLookup[x-1][y],
        worldLookup[x+1][y],
        worldLookup[x][y-1],
        worldLookup[x][y+1]
    }
 

    for i = 1, 4 do
        v = worldToCheck[i]
            if v and (isTileWall(v.ForegroundTile) or isTileWall(v.GroundTile)) then
                if v.X == x - 1 and v.Y == y then
                    nearby.left = true
                elseif v.X == x + 1 and v.Y == y then
                    nearby.right = true
                elseif v.X == x and v.Y == y + 1 then
                    nearby.bottom = true
                elseif v.X == x and v.Y == y - 1 then
                    nearby.top = true
                end
            end
        end

        local assetName = "1.png"

        if nearby.top and nearby.bottom and nearby.left and nearby.right then
            assetName = "12.png"
        elseif nearby.top and nearby.bottom and nearby.left then
            assetName = "15.png"
        elseif nearby.top and nearby.bottom and nearby.right then
            assetName = "9.png"
        elseif nearby.left and nearby.right and nearby.bottom then
            assetName = "11.png"
        elseif nearby.left and nearby.right and nearby.top then
            assetName = "13.png"
        elseif nearby.top and nearby.left then
            assetName = "16.png"
        elseif nearby.top and nearby.right then
            assetName = "10.png"
        elseif nearby.bottom and nearby.left then
            assetName = "14.png"
        elseif nearby.bottom and nearby.right then
            assetName = "8.png"
        elseif nearby.left and nearby.right then
            assetName = "6.png"
        elseif nearby.top and nearby.bottom then
            assetName = "3.png"
        elseif nearby.top then
            assetName = "4.png"
        elseif nearby.bottom then
            assetName = "2.png"
        elseif nearby.left then
            assetName = "7.png"
        elseif nearby.right then
            assetName = "5.png"
        end

        return "assets/world/objects/Wall/" .. tileName .. "/" .. assetName
    else
        return "assets/world/objects/Wall/" .. tileName .. "/1.png"
    end
end

function isTileWater(tileName)
   return isTileType(tileName, "Water")
end

function getDrawableWater(tileName, x, y)
    if  worldLookup[x-1] and worldLookup[x+1] and worldLookup[x] and worldLookup[x-1][y] then
        local fp = explode(tileName, "/")
        tileName = explode(fp[#fp], ".")[1]

        local nearby = {
            top = false,
            left = false,
            right = false,
            bottom = false,
            topLeft = false,
            topRight = false,
            bottomLeft = false,
            bottomRight = false
        }

        local worldToCheck = {
            worldLookup[x-1][y],
            worldLookup[x+1][y],
            worldLookup[x][y+1],
            worldLookup[x][y-1],
            worldLookup[x-1][y-1],
            worldLookup[x+1][y-1],
            worldLookup[x-1][y+1],
            worldLookup[x+1][y+1]
        }
    

        for i,v in ipairs(worldToCheck) do
            if v and (isTileWater(v.ForegroundTile) or isTileWater(v.GroundTile)) then
                if v.X == x - 1 and v.Y == y then
                    nearby.left = true
                elseif v.X == x + 1 and v.Y == y then
                    nearby.right = true
                elseif v.X == x and v.Y == y + 1 then
                    nearby.bottom = true
                elseif v.X == x and v.Y == y - 1 then
                    nearby.top = true
                elseif v.X == x - 1 and v.Y == y - 1 then
                    nearby.topLeft = true
                elseif v.X == x + 1 and v.Y == y - 1 then
                    nearby.topRight = true
                elseif v.X == x - 1 and v.Y == y + 1 then
                    nearby.bottomLeft = true
                elseif v.X == x + 1 and v.Y == y + 1 then
                    nearby.bottomRight = true
                end
            end
        end

        local assetName = "1.png"

        if nearby.top and nearby.bottom and nearby.left and nearby.right then
            assetName = "12.png"
            if not nearby.topLeft and not nearby.topRight and not nearby.bottomLeft and not nearby.bottomRight then
                assetName = "25.png"
            elseif not nearby.topRight and not nearby.bottomLeft and not nearby.bottomRight then
                assetName = "17.png"
            elseif not nearby.topLeft and not nearby.bottomLeft and not nearby.bottomRight then
                assetName = "18.png"
            elseif not nearby.topLeft and not nearby.topRight and not nearby.bottomRight then
                assetName = "19.png"
            elseif not nearby.topLeft and not nearby.topRight and not nearby.bottomLeft then
                assetName = "20.png"
            elseif not nearby.topLeft and not nearby.topRight then
                assetName = "28.png"
            elseif not nearby.topLeft and not nearby.bottomLeft then
                assetName = "26.png"
            elseif not nearby.topRight and not nearby.bottomRight then
                assetName = "24.png"
            elseif not nearby.bottomLeft and not nearby.bottomRight then
                assetName = "22.png"

            elseif not nearby.topLeft and not nearby.bottomRight then
                assetName = "30.png"
            elseif not nearby.bottomLeft and not nearby.topRight then
                assetName = "31.png"

            elseif not nearby.topLeft then
                assetName = "29.png"
            elseif not nearby.topRight then
                assetName = "27.png"
            elseif not nearby.bottomLeft then
                assetName = "23.png"
            elseif not nearby.bottomRight then
                assetName = "21.png"
            end

        elseif nearby.top and nearby.bottom and nearby.left then
            assetName = "13.png"
        elseif nearby.top and nearby.bottom and nearby.right then
            assetName = "11.png"
        elseif nearby.left and nearby.right and nearby.bottom then
            assetName = "9.png"
        elseif nearby.left and nearby.right and nearby.top then
            assetName = "15.png"
        elseif nearby.top and nearby.left then
            assetName = "16.png"
        elseif nearby.top and nearby.right then
            assetName = "14.png"
        elseif nearby.bottom and nearby.left then
            assetName = "10.png"
        elseif nearby.bottom and nearby.right then
            assetName = "8.png"
        elseif nearby.left and nearby.right then
            assetName = "6.png"
        elseif nearby.top and nearby.bottom then
            assetName = "3.png"
        elseif nearby.top then
            assetName = "4.png"
        elseif nearby.bottom then
            assetName = "2.png"
        elseif nearby.left then
            assetName = "7.png"
        elseif nearby.right then
            assetName = "5.png"
        else
            
        end

        return "assets/world/water/"  .. assetName
    else
        return "assets/world/water/1.png" 
    end
end

function isNearbyTile(name)
    return worldLookup and worldLookup[player.x] and worldLookup[player.x+1] and worldLookup[player.x-1] and worldLookup[player.x+1][player.y] and worldLookup[player.x-1][player.y] and worldLookup[player.x][player.y+1] and worldLookup[player.x][player.y-1] and (worldLookup[player.x+1][player.y].ForegroundTile == name or worldLookup[player.x-1][player.y].ForegroundTile == name or  worldLookup[player.x][player.y+1].ForegroundTile == name or  worldLookup[player.x][player.y-1].ForegroundTile == name)
          
end
