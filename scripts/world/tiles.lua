function getWorldAsset(v,x,y,color)
    if isTileWall(v) then v = getDrawableWall(v, x,y) end
  --  if isTileWater(v) then v = getDrawableWater(v, x, y) end
    return v
end

function isTileType(tileName, typeName)
    return string.find(string.lower(tileName), string.lower(typeName), 1)
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

    local worldToCheck = {
        worldLookup[x-1 ..","..y],
        worldLookup[x+1 ..","..y],
        worldLookup[x..","..y-1],
        worldLookup[x..","..y+1],
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
    -- else
    --     return "assets/world/objects/Wall/" .. tileName .. "/1.png"
    -- end
end


function getDrawableWater(tileName, x, y)
    -- if  worldLookup[x-1] and worldLookup[x+1] and worldLookup[x] and worldLookup[x-1][y] then
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
            {x = -1, y = 0, key = "left", tile = worldLookup[x-1 ..","..y],},
            {x = 1, y = 0, key = "right", tile = worldLookup[x+1 ..","..y],},
            {x = 0, y = 1, key = "bottom", tile = worldLookup[x..","..y+1],},
            {x = 0, y = -1, key = "top", tile = worldLookup[x..","..y-1],},
            {x = -1, y = -1, key = "topLeft", tile = worldLookup[x-1 ..","..y-1],},
            {x = 1, y = -1, key = "topRight", tile = worldLookup[x+1 ..","..y-1],},
            {x = -1, y = 1, key = "bottomLeft", tile = worldLookup[x-1 ..","..y+1],},
            {x = 1, y = 1, key = "bottomRight", tile = worldLookup[x+1 ..","..y+1],},
        }

        local count = 0
    
        -- checks if water is nearby
        for i,v in ipairs(worldToCheck) do
            if v.tile and (isTileType(v.tile.ForegroundTile, "water") or isTileType(v.tile.GroundTile, "water")) then
                if v.tile.X == x + v.x and v.tile.Y == y + v.y then  nearby[v.key] = true end
                count = count + 1
            elseif not v.tile then nearby[v.key] = true end
        end

 

        local assetName = "1.png"
        if count == 8 then return "assets/world/water/12.png" end

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
end

function isNearbyTile(name)
    return worldLookup[player.x+1 ..","..player.y] and worldLookup[player.x-1 ..","..player.y] and worldLookup[player.x ..","..player.y+1] and
      worldLookup[player.x..","..player.y-1] and
      (worldLookup[player.x+1 ..","..player.y].ForegroundTile == name or worldLookup[player.x-1 ..","..player.y].ForegroundTile == name or
      worldLookup[player.x..","..player.y+1].ForegroundTile == name or  worldLookup[player.x..","..player.y-1].ForegroundTile == name)
end