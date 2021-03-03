isWorldCreated = false
worldLookup = {}
lightSource = {}
lowestX = 0
lowestY = 0


function drawSimplexNoise(x, y)
    local noiseFactor = 0.23 -- 0.18
    local noise = 1 - ((love.math.noise( x * 0.06, y * 0.06) - (love.math.noise( x * 0.5, y * 0.5) * 0.2)) * noiseFactor)
    love.graphics.setColor(noise * 1 ,noise * 1 ,noise )
end

function createWorld()
    leaves = {}
    lightSource = {}
    highestX = 0
    highestY = 0
    lowestX = 0
    lowestY = 0
    for i,v in ipairs(world) do
        if not worldLookup[v.X] then
            worldLookup[v.X] = {}
        end

        worldLookup[v.X][v.Y] = copy(v)

        if v.X > highestX then
            highestX = v.X
        end
        if v.Y > highestY then
            highestY = v.Y
        end
        if v.X < lowestX then
            lowestX = v.X
        end
        if v.Y < lowestY then
            lowestY = v.Y
        end

        if not isTileType(v.ForegroundTile, "Dead") and isTileType(v.ForegroundTile, "Tree") and love.math.random(1,5) == 1 then
            if isTileType(v.ForegroundTile, "Snowy") then
                addLeaf(v.X*32 + 16, v.Y*32 + 16, "snowy tree")
            else
                addLeaf(v.X*32 + 16, v.Y*32 + 16, "tree")
            end
        elseif isTileType(v.ForegroundTile, "Campfire") then
            addLeaf(v.X*32 + 16, v.Y*32 + 8, "fire")
        elseif isTileType(v.ForegroundTile, "Sand") then
            -- addLeaf(v.X*32 + 16, v.Y*32 + 16, "sand")
        end
    end

    reinitLighting(32*(highestX+math.abs(lowestX)+2), 32*(highestY+math.abs(lowestY)+2))
    -- worldCanvas = love.graphics.newCanvas(32*((worldEdit.worldSize * 2)), 32*((worldEdit.worldSize * 2)))
    -- reinitLighting(32*((worldEdit.worldSize)), 32*((worldEdit.worldSize)))


    local dim = {32 * (128), 32 * (128)}
    worldCanvas = {} 
    for cx = 0, 0 do
        if not worldCanvas[cx] then worldCanvas[cx] = {} end
        for cy = 0, 0 do
            worldCanvas[cx][cy] = {}
            worldCanvas[cx][cy] = love.graphics.newCanvas(unpack(dim))
            love.graphics.setCanvas(worldCanvas[cx][cy])
                love.graphics.clear()
                love.graphics.setColor(1, 1, 1)
                
                -- for x = worldEdit.worldSize * -1, worldEdit.worldSize do
                --     for y = worldEdit.worldSize * -1, worldEdit.worldSize do
                --         drawSimplexNoise(x, y)  -- sets background noise
                --         love.graphics.draw(groundImg, x * 32, y * 32)
                --     end
                -- end
                
                for i, v in ipairs(world) do
                    -- if v.X > cx * 128 and v.X < (cx + 1) * 128 and v.Y > cy * 128 and v.Y < (cy + 1) * 128 then
                        drawTile(v, cx, cy)
                    -- end
                end
            love.graphics.setCanvas()
        end
    end

    if player.x and player.y then
        createNPCChatBackground(player.x,player.y)
    else
        createNPCChatBackground(0,0)
    end
end

function drawTile(v, cx, cy)

    local x, y = v.X + cx * 128, v.Y + cy * 128

    local backgroundAsset = getWorldAsset(v.GroundTile, x, y)
    local foregroundAsset = getWorldAsset(v.ForegroundTile, x, y)

    if lightGivers[foregroundAsset] and not lightSource[x .. "," .. y] then
        lightSource[x .. "," .. y] = true
        Luven.addNormalLight(16 + x * 32, 16 + y * 32, {1, 0.5, 0}, lightGivers[foregroundAsset])
    end

    -- if v.Collision then
    --     if foregroundAsset == "assets/world/objects/Mountain.png" then
    --         treeMap[x .. "," .. y] = true
    --     end
    --     blockMap[x .. "," .. y] = true
    -- end

    -- drawSimplexNoise(v.X+math.abs(lowestX), v.Y+math.abs(lowestY)) -- sets background noise

    if worldImg[backgroundAsset] then
        love.graphics.draw(worldImg[backgroundAsset], (x) * 32, (y) * 32)  
    end 
    
    love.graphics.setColor(1,1,1) 

    -- if worldLookup[v.X][v.Y-1] and (isTileWall(worldLookup[v.X][v.Y-1].ForegroundTile) or isTileWall(worldLookup[v.X][v.Y-1].GroundTile)) and not isTileWall(v.ForegroundTile) then
    --     love.graphics.setColor(0,0,0,0.5)
    --     love.graphics.rectangle("fill", (v.X+math.abs(lowestX)) * 32 , (v.Y+math.abs(lowestY)) * 32, 32,16)
    --     love.graphics.setColor(1,1,1,1)
    -- elseif (isTileWall(v.GroundTile) or isTileWall(v.ForegroundTile)) and not worldLookup[v.X][v.Y+1] then -- no tile below us but we stil need to cast a shadow
    --     love.graphics.setColor(0,0,0,0.5)
    --     love.graphics.rectangle("fill", (v.X+math.abs(lowestX)) * 32 , (v.Y+1+math.abs(lowestY)) * 32, 32, 16)
    --     love.graphics.setColor(1,1,1,1)
    -- end 

    if foregroundAsset ~= backgroundAsset and worldImg[foregroundAsset] then love.graphics.draw(worldImg[foregroundAsset], (x) * 32, (y) * 32) end

end

function drawWorld()
    -- for x = player.x - (love.graphics.getWidth()/2)/32, player.x + (love.graphics.getWidth()/2)/32 do
    --     for y = player.y - (love.graphics.getHeight()/2)/32, player.y + (love.graphics.getHeight()/2)/32 do
    --         -- if isTileLit(x, y) then
    --         --     if not wasTileLit(x, y) then
    --         --         love.graphics.setColor(1 - oldLightAlpha, 1 - oldLightAlpha, 1 - oldLightAlpha) -- light up a tile
    --         --     else
    --         --         love.graphics.setColor(1, 1, 1)
    --         --     end
    --         -- elseif wasTileLit(x, y) and oldLightAlpha > 0.2 then
    --         --     love.graphics.setColor(oldLightAlpha, oldLightAlpha, oldLightAlpha)
    --         -- else
    --         --     love.graphics.setColor(0, 0, 0, 0)
    --         -- end
    --         love.graphics.setColor(1,1,1,1)
    --         love.graphics.draw(groundImg, x * 32, y * 32)
    --     end
    -- end
    love.graphics.setColor(1,1,1,1)
    love.graphics.setBlendMode("alpha", "premultiplied")

    for cx = 0, 0 do
        for cy = 0, 0 do
            love.graphics.draw(worldCanvas[cx][cy], cx * 128, cy * 128)
        end
    end

    love.graphics.setBlendMode("alpha")
    
    love.graphics.setColor(1,1,1)
end

function getWorldAsset(v,x,y,notFindWall)
  
    -- if not worldImg[v] then
    --     if love.filesystem.getInfo(v) then
    --         worldImg[v] = love.graphics.newImage(v)
    --     else
    --         worldImg[v] = love.graphics.newImage("assets/error.png")
    --     end
    -- end

    local foregroundAsset = v['ForegroundTile']
    local backgroundAsset = v['GroundTile']

    if not notFindWall then
        if isTileWall(v) then
            v = getDrawableWall(v, x,y)
        end
    end

    if isTileWater(v) then
        v = getDrawableWater(v, x, y)
    end

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
    if  worldLookup[x-1] and 
    worldLookup[x+1] and 
    worldLookup[x] and worldLookup[x-1][y]  then
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
    

        for i = 1, 8 do
            v = worldToCheck[i]
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
