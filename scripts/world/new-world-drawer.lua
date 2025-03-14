worldCanvas = love.graphics.newCanvas(32 * 101, 32 * 101)
isWorldCreated = false
waterPhase = 1
waterPhases = {}
lightSource = {}
show3D = true -- Toggle between 2D and 3D modes

-- Camera variables for 3D mode
camera = {
    x = 0,
    y = 0,
    angle = 0, -- Horizontal angle (yaw) in radians
    pitch = 0, -- Vertical angle (pitch) in radians
    fov = math.pi / 2 -- Field of view (60 degrees)
}

-- Global table to store transparency information, using tile paths as keys
textureTransparency = {}

-- Helper function to check if a texture has transparency (precomputed)
function hasTransparency(tilePath)
    if not tilePath then return false end
    if textureTransparency[tilePath] ~= nil then
        return textureTransparency[tilePath]
    end
    return false
end

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
    for i, path in ipairs({
        "assets/world/grounds/water/1.png",
        "assets/world/grounds/water/2.png",
        "assets/world/grounds/water/3.png"
    }) do
        textureTransparency[path] = false
    end
    for i, tile in ipairs(world) do
        worldLookup[tile.X .. "," .. tile.Y] = tile
        if tile then
            addLeavesAndLights(tile)
            addCritters(tile)
            if tile.GroundTile and not textureTransparency[tile.GroundTile] then
                textureTransparency[tile.GroundTile] = checkTransparency(getImgIfNotExist(tile.GroundTile), tile.GroundTile)
            end
            if tile.ForegroundTile and not textureTransparency[tile.ForegroundTile] then
                textureTransparency[tile.ForegroundTile] = checkTransparency(getImgIfNotExist(tile.ForegroundTile), tile.ForegroundTile)
            end
        end
    end
    initWorldMap()
    camera.x = player.x * 32 + 16
    camera.y = player.y * 32 + 16
end


function drawWorld()
    love.graphics.setColor(1, 1, 1)
    
    if show3D then
        drawWorld3D()
    else
        drawWorld2D()
    end
end

function drawWorld2D()
    local offsetY = 0
    local offsetX = 0
    maxX = 10
    maxY = 10
    for x = player.x - maxX, player.x + maxX do
        for y = player.y - maxY, player.y + maxY do
            love.graphics.setColor(1,1,1, getEntityAlpha(x*32,y*32,250))
            groundImg, foregroundImg = getWorldTiles(math.floor(x), math.floor(y))
            if not groundImg then
                love.graphics.draw(waterPhases[math.floor(waterPhase)], x * 32 - offsetX, y * 32 - offsetY)
            end

            if worldLookup[math.floor(x) .. "," .. math.floor(y)] and
                isTileType(worldLookup[math.floor(x) .. "," .. math.floor(y)].GroundTile, "Water") then
                love.graphics.draw(waterPhases[math.floor(waterPhase)], x * 32 - offsetX, y * 32 - offsetY)
            elseif groundImg and foregroundImg then
                love.graphics.draw(groundImg, x * 32 - offsetX, y * 32 - offsetY)
                love.graphics.draw(foregroundImg, x * 32 - offsetX, y * 32 - offsetY)
            end
        end
    end
end-- Assuming existing globals: worldLookup, camera, player, waterPhases, waterPhase
local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()
local stoneWallTexture = love.graphics.newImage("assets/world/objects/Stone Wall.png")
textureTransparency = textureTransparency or {} -- Cache transparency status

function love.load()
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    stoneWallTexture:setFilter("nearest", "nearest")
    -- Precompute transparency for stone wall
    textureTransparency["assets/world/objects/Stone Wall.png"] = checkTransparency(stoneWallTexture)
end

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
    for i, path in ipairs({
        "assets/world/grounds/water/1.png",
        "assets/world/grounds/water/2.png",
        "assets/world/grounds/water/3.png"
    }) do
        local texture = getImgIfNotExist(path)
        if texture then
            textureTransparency[path] = checkTransparency(texture)
        end
    end
    for i, tile in ipairs(world) do
        worldLookup[tile.X .. "," .. tile.Y] = tile
        if tile then
            addLeavesAndLights(tile)
            addCritters(tile)
            -- Precompute transparency for ground tiles
            if tile.GroundTile then
                local texture = getImgIfNotExist(tile.GroundTile)
                if texture and not textureTransparency[tile.GroundTile] then
                    textureTransparency[tile.GroundTile] = checkTransparency(texture)
                end
            end
            if tile.ForegroundTile then
                local texture = getImgIfNotExist(tile.ForegroundTile)
                if texture and not textureTransparency[tile.ForegroundTile] then
                    local isTransparent = isTileType(tile.ForegroundTile, "Tree") or
                                         isTileType(tile.ForegroundTile, "Campfire")
                    textureTransparency[tile.ForegroundTile] = isTransparent or checkTransparency(texture)
                end
            end
        end
    end
    initWorldMap()
    camera.x = player.x * 32 + 16
    camera.y = player.y * 32 + 16
end

function love.mousemoved(x, y, dx, dy)
    if show3D then
        camera.angle = camera.angle + dx * 0.005
        camera.angle = camera.angle % (2 * math.pi)
        camera.pitch = camera.pitch - dy * 0.005
        camera.pitch = math.max(-math.pi / 4, math.min(math.pi / 4, camera.pitch)) -- Clamp pitch
    end
end
function drawWorld3D()
   -- Ensure screen dimensions are up-to-date
   screenWidth = love.graphics.getWidth()
   screenHeight = love.graphics.getHeight()

   -- Calculate horizon based on camera pitch
   local horizon = screenHeight / 2 + (screenHeight * math.tan(camera.pitch))
   horizon = math.max(0, math.min(screenHeight, horizon))

   -- Raycasting parameters for walls
   local stripWidth = 8
   local rayCount = math.ceil(screenWidth / stripWidth)
   local rayAngleStep = camera.fov / rayCount

   -- Draw sky across the full screen width
   love.graphics.setColor(0.529, 0.808, 0.922) -- Sky color
   love.graphics.rectangle("fill", 0, 0, screenWidth, horizon)

   -- Cast rays for wall rendering
   local hits = {}
   for i = 0, rayCount - 1 do
       local rayAngle = camera.angle - (camera.fov / 2) + (i * rayAngleStep)
       hits[i] = castRay(rayAngle)
   end

   -- Floor rendering (corrected projection)
   love.graphics.setColor(1, 1, 1)
   local cameraHeight = 16 -- Camera height above ground (adjust if needed)
   local defaultTexture = love.graphics.newImage("assets/world/grounds/default.png") -- Fallback texture

   -- Precompute ray directions for left and right edges
   local rayDirX0 = math.cos(camera.angle - camera.fov / 2)
   local rayDirY0 = math.sin(camera.angle - camera.fov / 2)
   local rayDirX1 = math.cos(camera.angle + camera.fov / 2)
   local rayDirY1 = math.sin(camera.angle + camera.fov / 2)

   -- Debug: Print loop start
   print("Floor rendering starting at y = " .. horizon)

   for y = horizon, screenHeight - 1, 4 do
       -- Calculate perspective distance for this row
       local perspective = (y - horizon) / (screenHeight / 2)
       if perspective <= 0 then
           perspective = 0.001 -- Avoid division by zero
       end
       local rowDistance = cameraHeight / perspective

       -- Debug: Print rowDistance
       if y == math.floor(horizon) then
           print("Row distance at horizon: " .. rowDistance)
       end

       for x = 0, screenWidth - 1, 4 do
           -- Interpolate ray direction across the screen
           local t = x / screenWidth
           local rayDirX = rayDirX0 + (rayDirX1 - rayDirX0) * t
           local rayDirY = rayDirY0 + (rayDirY1 - rayDirY0) * t

           -- Calculate floor position
           local floorX = camera.x + rowDistance * rayDirX
           local floorY = camera.y + rowDistance * rayDirY
           local mapX, mapY = math.floor(floorX / 32), math.floor(floorY / 32)
           local tile = worldLookup[mapX .. "," .. mapY]

           -- Fallback if tile or texture is nil
           local texture = nil
           if tile then
               texture = getTileTexture(tile) -- Ground texture
           end
           if not texture then
               texture = defaultTexture
               -- Debug: Log missing tile/texture
               if not tile then
                   print("No tile at (" .. mapX .. "," .. mapY .. ")")
               else
                   print("No texture for tile at (" .. mapX .. "," .. mapY .. ")")
               end
           end

           -- Draw the floor
           local texX = math.floor(floorX % 32)
           local texY = math.floor(floorY % 32)
           local quad = love.graphics.newQuad(texX, texY, 1, 1, 32, 32)
           love.graphics.draw(texture, quad, x, y, 0, 8, 8)
       end
   end
    -- Draw walls
    love.graphics.setBlendMode("alpha")
    for i = 0, rayCount - 1 do
        local hit = hits[i]
        if hit then
            local correctedDist = hit.distance * math.cos(hit.angle - camera.angle)
            local wallHeight = (32 * screenHeight) / correctedDist
            local top = horizon - (wallHeight / 2)
            local bottom = top + wallHeight

            if top < screenHeight and bottom > 0 then
                local texX = math.floor(hit.texX)
                local quad = love.graphics.newQuad(texX, 0, 1, 32, 32, 32)
                love.graphics.setColor(1, 1, 1)
                local tile = worldLookup[hit.mapX .. "," .. hit.mapY]
                local texture = getTileTexture(tile, true) or stoneWallTexture
                love.graphics.draw(texture, quad, i * stripWidth, top, 0, stripWidth, wallHeight / 32)
            end
        end
    end
    love.graphics.setBlendMode("alpha")
end

function castRay(angle)
    local rayDirX = math.cos(angle)
    local rayDirY = math.sin(angle)
    local mapX = math.floor(camera.x / 32)
    local mapY = math.floor(camera.y / 32)
    local deltaDistX = math.abs(32 / rayDirX)
    local deltaDistY = math.abs(32 / rayDirY)
    local stepX, stepY, sideDistX, sideDistY

    if rayDirX > 0 then
        stepX = 1
        sideDistX = ((mapX + 1) * 32 - camera.x) * deltaDistX / 32
    else
        stepX = -1
        sideDistX = (camera.x - mapX * 32) * deltaDistX / 32
    end
    if rayDirY > 0 then
        stepY = 1
        sideDistY = ((mapY + 1) * 32 - camera.y) * deltaDistY / 32
    else
        stepY = -1
        sideDistY = (camera.y - mapY * 32) * deltaDistY / 32
    end

    local hit = false
    local side
    while not hit do
        if sideDistX < sideDistY then
            sideDistX = sideDistX + deltaDistX
            mapX = mapX + stepX
            side = 0
        else
            sideDistY = sideDistY + deltaDistY
            mapY = mapY + stepY
            side = 1
        end
        if worldLookup[mapX .. "," .. mapY] and worldLookup[mapX .. "," .. mapY].Collision then
            hit = true
        end
    end

    local distance = side == 0 and 
        (mapX - camera.x / 32 + (1 - stepX) / 2) / (rayDirX / 32) or 
        (mapY - camera.y / 32 + (1 - stepY) / 2) / (rayDirY / 32)

    local hitX = camera.x + distance * rayDirX
    local hitY = camera.y + distance * rayDirY
    local texX = side == 0 and (hitY % 32) or (hitX % 32)

    return {distance = distance, texX = texX, mapX = mapX, mapY = mapY, angle = angle}
end

function getTileTexture(tile, isForeground)
    local tileName = isForeground and tile.ForegroundTile or tile.GroundTile
    -- Rule 2: Water tiles on ground
    if tileName and tileName:find("Water") then
        local texture = getImgIfNotExist(tileName) or waterPhases[math.floor(waterPhase)]
        return texture
    end
    -- Rule 1: Check for transparency (already precomputed)
    local texturePath = tileName or "assets/world/grounds/default.png"
    -- if substring is assets/world/walls then replace with assets/world/objects/
    if texturePath:find("assets/world/walls") then
        texturePath = texturePath:gsub("walls", "objects")
    end
    local texture = getImgIfNotExist(texturePath)
    if texture and textureTransparency[texturePath] then
        return renderAsSprite(texture) -- Render as sprite with background
    end
    return texture
end

function checkTransparency(texture, tilePath)
    -- Convert texture to ImageData to check for transparency
    local imageData = love.image.newImageData(texture:getWidth(), texture:getHeight())
    local pathToUse = tilePath or "assets/world/grounds/default.png" -- Fallback if tilePath is nil
    imageData:paste(love.image.newImageData(pathToUse), 0, 0, 0, 0, texture:getWidth(), texture:getHeight())
    for y = 0, imageData:getHeight() - 1 do
        for x = 0, imageData:getWidth() - 1 do
            local r, g, b, a = imageData:getPixel(x, y)
            if a < 1 then
                return true
            end
        end
    end
    return false
end

function renderAsSprite(texture)
    -- Placeholder: Render sprite with background
    return texture
end

function updateWorld(dt)
    waterPhase = waterPhase + 0.7 * dt
    if waterPhase > 4 then waterPhase = 1 end
    if show3D then
        camera.x = player.x * 32 + 16
        camera.y = player.y * 32 + 16
    end
end
-- Rest of your original functions (addLeavesAndLights, getWorldTiles, etc.) remain unchanged
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
        (isTileWall(worldLookup[x - 1 .. "," .. y].ForegroundTile) or isTileWall(worldLookup[x - 1 .. "," .. y].GroundTile)) then
        nearby.left = true
    end
    if worldLookup[x + 1 .. "," .. y] and
        (isTileWall(worldLookup[x + 1 .. "," .. y].ForegroundTile) or isTileWall(worldLookup[x + 1 .. "," .. y].GroundTile) ) then
        nearby.right = true
    end
    if worldLookup[x .. "," .. y + 1] and
        (isTileWall(worldLookup[x .. "," .. y + 1].ForegroundTile) or isTileWall(worldLookup[x .. "," .. y + 1].GroundTile)) then
        nearby.bottom = true
    end
    if worldLookup[x .. "," .. y - 1] and
        (isTileWall(worldLookup[x .. "," .. y - 1].ForegroundTile) or  isTileWall(worldLookup[x .. "," .. y - 1].GroundTile)) then
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
