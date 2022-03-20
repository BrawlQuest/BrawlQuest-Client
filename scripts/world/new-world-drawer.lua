worldCanvas = love.graphics.newCanvas(32 * 101, 32 * 101)
isWorldCreated = false
lightSource = {}

function initWorldTable(world)
    worldChunks = {}
    worldLookup = {}
    worldEmitters = {}
    critters = {}
    for i, tile in ipairs(world) do
        worldLookup[tile.X .. "," .. tile.Y] = tile
        if tile then
            addLeavesAndLights(tile)
            addCritters(tile)
        end
    end
    initWorldMap()
end

function addLeavesAndLights(v)
    addWorldEmitter(v)
    if not isTileType(v.ForegroundTile, "Dead") and
        isTileType(v.ForegroundTile, "Tree") and love.math.random(1, 5) == 1 then
        if isTileType(v.ForegroundTile, "Snowy") then
            addLeaf(v.X * 32 + 16, v.Y * 32 + 16, "snowy tree")
        else
            addLeaf(v.X * 32 + 16, v.Y * 32 + 16, "tree")
        end
    elseif isTileType(v.ForegroundTile, "Campfire") then
        addLeaf(v.X * 32 + 16, v.Y * 32 + 8, "fire")
    elseif isTileType(v.ForegroundTile, "Sand") then -- addLeaf(v.X*32 + 16, v.Y*32 + 16, "sand")
    elseif isTileType(v.GroundTile, "Murky") then
        addLeaf(v.X * 32, v.Y * 32 + 16, "murky")
    end
end


function drawWorld()

    love.graphics.setColor(1, 1, 1)

    local maxX, maxY = (love.graphics.getWidth() / 2) / 32,
                       (love.graphics.getHeight() / 2) / 32

    for x = player.x - maxX, player.x + maxX do
        for y = player.y - maxY, player.y + maxY do
            groundImg, foregroundImg = getWorldTiles(math.floor(x),
                                                     math.floor(y))
            love.graphics.draw(groundImg, x * 32 - 8, y * 32 - 8)
            love.graphics.draw(foregroundImg, x * 32 - 8, y * 32 - 8)
        end
    end

end

--[[
    This function returns the images of the tiles to be drawn at the given x & y position
    groundImg, foregroundImg
]]

function getWorldTiles(x, y)
    if (worldLookup[x .. ',' .. y]) then
        local groundImgPath = worldLookup[x .. ',' .. y].GroundTile
        local foregroundImgPath = worldLookup[x .. ',' .. y].ForegroundTile

        if isTileType(groundImgPath, "water") then
            groundImgPath = getDrawableWater(groundImgPath, x, y)
        end

        if isTileWall(foregroundImgPath) then
            foregroundImgPath = getDrawableWall(foregroundImgPath, x, y)
        end

        return getImgIfNotExist(groundImgPath),
               getImgIfNotExist(foregroundImgPath)
    end

end

function isNearbyTile(name)
    return worldLookup[player.x + 1 .. "," .. player.y] and
               worldLookup[player.x - 1 .. "," .. player.y] and
               worldLookup[player.x .. "," .. player.y + 1] and
               worldLookup[player.x .. "," .. player.y - 1] and
               (worldLookup[player.x + 1 .. "," .. player.y].ForegroundTile ==
                   name or
                   worldLookup[player.x - 1 .. "," .. player.y].ForegroundTile ==
                   name or
                   worldLookup[player.x .. "," .. player.y + 1].ForegroundTile ==
                   name or
                   worldLookup[player.x .. "," .. player.y - 1].ForegroundTile ==
                   name)
end

function getDrawableWall(tileName, x, y) -- this is used to smooth the corners of walls appropriately
    local fp = explode(tileName, "/")
    tileName = explode(fp[#fp], ".")[1]
    local nearby = {top = false, left = false, right = false, bottom = false}

    if worldLookup[x - 1 .. "," .. y] and
        isTileWall(worldLookup[x - 1 .. "," .. y].ForegroundTile) then
        nearby.left = true
    end
    if worldLookup[x + 1 .. "," .. y] and
        isTileWall(worldLookup[x + 1 .. "," .. y].ForegroundTile) then
        nearby.right = true
    end
    if worldLookup[x .. "," .. y + 1] and
        isTileWall(worldLookup[x .. "," .. y + 1].ForegroundTile) then
        nearby.bottom = true
    end
    if worldLookup[x .. "," .. y - 1] and
        isTileWall(worldLookup[x .. "," .. y - 1].ForegroundTile) then
        nearby.top = true
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
end
