worldCanvas = love.graphics.newCanvas(32 * 101, 32 * 101)
isWorldCreated = false
waterPhase = 1
waterPhases = {}
lightSource = {}

function initWorldTable(world)
    worldChunks = {}
    worldLookup = {}
    worldEmitters = {}
    critters = {}
    waterPhases = {
        getImgIfNotExist("assets/world/grounds/water/1.png"),
        getImgIfNotExist("assets/world/grounds/water/2.png"),
        getImgIfNotExist("assets/world/grounds/water/3.png")
    }
    for i, tile in ipairs(world) do
        worldLookup[tile.x .. "," .. tile.y] = tile
        if tile then
            addLeavesAndLights(tile)
            addCritters(tile)
        end
    end
    initWorldMap()
end

function addLeavesAndLights(v)
    addWorldEmitter(v)
    if not isTileType(v.foregroundtile, "Dead") and
        isTileType(v.foregroundtile, "Tree") and love.math.random(1, 5) == 1 then
        if isTileType(v.foregroundtile, "Snowy") then
            addLeaf(v.x * 32 + 16, v.y * 32 + 16, "snowy tree")
        else
            addLeaf(v.x * 32 + 16, v.y * 32 + 16, "tree")
        end
    elseif isTileType(v.foregroundtile, "Campfire") then
        addLeaf(v.x * 32 + 16, v.y * 32 + 8, "fire")
    elseif isTileType(v.foregroundtile, "Sand") then -- addLeaf(v.x*32 + 16, v.y*32 + 16, "sand")
    elseif isTileType(v.groundtile, "Murky") then
        addLeaf(v.x * 32, v.y * 32 + 16, "murky")
    end
end

function drawWorld()
    love.graphics.setColor(1, 1, 1)

    -- local maxx, maxy = math.floor((love.graphics.getWidth() / 2) / 32),
    --                    math.floor((love.graphics.getHeight() / 2) / 32)
    local offsety = 0
    local offsetx = 0
    maxx = 10
    maxy = 10
        for x = player.x - maxx, player.x + maxx do
            for y = player.y - maxy, player.y + maxy do
                love.graphics.setColor(1,1,1, getEntityAlpha(x*32,y*32,250))
                groundImg, foregroundImg = getWorldTiles(math.floor(x),
                                                        math.floor(y))
                if not groundImg then
                    love.graphics.draw(waterPhases[math.floor(waterPhase)],
                                    x * 32 - offsetx, y * 32 - offsety)
                end

                if worldLookup[math.floor(x) .. "," .. math.floor(y)] and
                    isTileType(
                        worldLookup[math.floor(x) .. "," .. math.floor(y)]
                            .groundtile, "Water") then
                    love.graphics.draw(waterPhases[math.floor(waterPhase)],
                                    x * 32 - offsetx, y * 32 - offsety)
                elseif groundImg and foregroundImg then
                    love.graphics.draw(groundImg, x * 32 - offsetx, y * 32 - offsety)
                    love.graphics.draw(foregroundImg, x * 32- offsetx, y * 32 - offsety)
                end

            end
        end
   
end

function updateWorld(dt)
    waterPhase = waterPhase + 0.7 * dt
    if waterPhase > 4 then waterPhase = 1 end
end

--[[
    This function returns the images of the tiles to be drawn at the given x & y position
    groundImg, foregroundImg
]]

function getWorldTiles(x, y)
    if (worldLookup[x .. ',' .. y]) then
        local groundImgPath = worldLookup[x .. ',' .. y].groundtile
        local foregroundImgPath = worldLookup[x .. ',' .. y].foregroundtile

        if isTileType(groundImgPath, "water") then
            groundImgPath = getDrawableWater(groundImgPath, x, y)
        end

        if isTileWall(foregroundImgPath)  then
            foregroundImgPath = getDrawableWall(foregroundImgPath, x, y)
            groundImgPath = getDrawableWall(foregroundImgPath, x, y)
        end
        if isTileWall(groundImgPath)  then
            groundImgPath = getDrawableWall(groundImgPath, x, y)
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
               (worldLookup[player.x + 1 .. "," .. player.y].foregroundtile ==
                   name or
                   worldLookup[player.x - 1 .. "," .. player.y].foregroundtile ==
                   name or
                   worldLookup[player.x .. "," .. player.y + 1].foregroundtile ==
                   name or
                   worldLookup[player.x .. "," .. player.y - 1].foregroundtile ==
                   name)
end

function getDrawableWall(tilename, x, y) -- this is used to smooth the corners of walls appropriately
    local fp = explode(tilename, "/")
    tilename = explode(fp[#fp], ".")[1]
    local nearby = {top = false, left = false, right = false, bottom = false}

    if worldLookup[x - 1 .. "," .. y] and
        (isTileWall(worldLookup[x - 1 .. "," .. y].foregroundtile) or isTileWall(worldLookup[x - 1 .. "," .. y].groundtile)) then
        nearby.left = true
    end
    if worldLookup[x + 1 .. "," .. y] and
        (isTileWall(worldLookup[x + 1 .. "," .. y].foregroundtile) or isTileWall(worldLookup[x + 1 .. "," .. y].groundtile) ) then
        nearby.right = true
    end
    if worldLookup[x .. "," .. y + 1] and
        (isTileWall(worldLookup[x .. "," .. y + 1].foregroundtile) or isTileWall(worldLookup[x .. "," .. y + 1].groundtile)) then
        nearby.bottom = true
    end
    if worldLookup[x .. "," .. y - 1] and
        (isTileWall(worldLookup[x .. "," .. y - 1].foregroundtile) or  isTileWall(worldLookup[x .. "," .. y - 1].groundtile)) then
        nearby.top = true
    end

    local assetname = "1.png"

    if nearby.top and nearby.bottom and nearby.left and nearby.right then
        assetname = "12.png"
    elseif nearby.top and nearby.bottom and nearby.left then
        assetname = "15.png"
    elseif nearby.top and nearby.bottom and nearby.right then
        assetname = "9.png"
    elseif nearby.left and nearby.right and nearby.bottom then
        assetname = "11.png"
    elseif nearby.left and nearby.right and nearby.top then
        assetname = "13.png"
    elseif nearby.top and nearby.left then
        assetname = "16.png"
    elseif nearby.top and nearby.right then
        assetname = "10.png"
    elseif nearby.bottom and nearby.left then
        assetname = "14.png"
    elseif nearby.bottom and nearby.right then
        assetname = "8.png"
    elseif nearby.left and nearby.right then
        assetname = "6.png"
    elseif nearby.top and nearby.bottom then
        assetname = "3.png"
    elseif nearby.top then
        assetname = "4.png"
    elseif nearby.bottom then
        assetname = "2.png"
    elseif nearby.left then
        assetname = "7.png"
    elseif nearby.right then
        assetname = "5.png"
    end

    return "assets/world/objects/Wall/" .. tilename .. "/" .. assetname
end
