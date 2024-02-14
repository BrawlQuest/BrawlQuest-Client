function getWorldAsset(v,x,y,color)
    if isTileWall(v) then v = getDrawableWall(v, x,y) end
  --  if isTileWater(v) then v = getDrawableWater(v, x, y) end
    return v
end

function isTileType(tilename, typename)
    if tilename == nil then return false end
    return string.find(string.lower(tilename), string.lower(typename), 1)
end

function isTileWall(tilename)
    return isTileType(tilename, "Wall")
end

function getDrawableWall(tilename, x, y) -- this is used to smooth the corners of walls appropriately
    local fp = explode(tilename, "/")
    tilename = explode(fp[#fp], ".")[1]
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
        if v and (isTileWall(v.foregroundtile) or isTileWall(v.groundtile)) then
            if v.x == x - 1 and v.y == y then
                nearby.left = true
            elseif v.x == x + 1 and v.y == y then
                nearby.right = true
            elseif v.x == x and v.y == y + 1 then
                nearby.bottom = true
            elseif v.x == x and v.y == y - 1 then
                nearby.top = true
            end
        end
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
    -- else
    --     return "assets/world/objects/Wall/" .. tilename .. "/1.png"
    -- end
end


function getDrawableWater(tilename, x, y)
    -- if  worldLookup[x-1] and worldLookup[x+1] and worldLookup[x] and worldLookup[x-1][y] then
        local fp = explode(tilename, "/")
        tilename = explode(fp[#fp], ".")[1]

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
            if v.tile and (isTileType(v.tile.foregroundtile, "water") or isTileType(v.tile.groundtile, "water")) then
                if v.tile.x == x + v.x and v.tile.y == y + v.y then  nearby[v.key] = true end
                count = count + 1
            elseif not v.tile then nearby[v.key] = true end
        end

 

        local assetname = "1.png"
        if count == 8 then return "assets/world/water/12.png" end

        if nearby.top and nearby.bottom and nearby.left and nearby.right then
            assetname = "12.png"
            if not nearby.topLeft and not nearby.topRight and not nearby.bottomLeft and not nearby.bottomRight then
                assetname = "25.png"
            elseif not nearby.topRight and not nearby.bottomLeft and not nearby.bottomRight then
                assetname = "17.png"
            elseif not nearby.topLeft and not nearby.bottomLeft and not nearby.bottomRight then
                assetname = "18.png"
            elseif not nearby.topLeft and not nearby.topRight and not nearby.bottomRight then
                assetname = "19.png"
            elseif not nearby.topLeft and not nearby.topRight and not nearby.bottomLeft then
                assetname = "20.png"
            elseif not nearby.topLeft and not nearby.topRight then
                assetname = "28.png"
            elseif not nearby.topLeft and not nearby.bottomLeft then
                assetname = "26.png"
            elseif not nearby.topRight and not nearby.bottomRight then
                assetname = "24.png"
            elseif not nearby.bottomLeft and not nearby.bottomRight then
                assetname = "22.png"

            elseif not nearby.topLeft and not nearby.bottomRight then
                assetname = "30.png"
            elseif not nearby.bottomLeft and not nearby.topRight then
                assetname = "31.png"

            elseif not nearby.topLeft then
                assetname = "29.png"
            elseif not nearby.topRight then
                assetname = "27.png"
            elseif not nearby.bottomLeft then
                assetname = "23.png"
            elseif not nearby.bottomRight then
                assetname = "21.png"
            end

        elseif nearby.top and nearby.bottom and nearby.left then
            assetname = "13.png"
        elseif nearby.top and nearby.bottom and nearby.right then
            assetname = "11.png"
        elseif nearby.left and nearby.right and nearby.bottom then
            assetname = "9.png"
        elseif nearby.left and nearby.right and nearby.top then
            assetname = "15.png"
        elseif nearby.top and nearby.left then
            assetname = "16.png"
        elseif nearby.top and nearby.right then
            assetname = "14.png"
        elseif nearby.bottom and nearby.left then
            assetname = "10.png"
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
        else
            
        end

        return "assets/world/water/"  .. assetname
end

function isNearbyTile(name)
    return worldLookup[player.x+1 ..","..player.y] and worldLookup[player.x-1 ..","..player.y] and worldLookup[player.x ..","..player.y+1] and
      worldLookup[player.x..","..player.y-1] and
      (worldLookup[player.x+1 ..","..player.y].foregroundtile == name or worldLookup[player.x-1 ..","..player.y].foregroundtile == name or
      worldLookup[player.x..","..player.y+1].foregroundtile == name or  worldLookup[player.x..","..player.y-1].foregroundtile == name)
end