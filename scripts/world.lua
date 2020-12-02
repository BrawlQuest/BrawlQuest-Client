worldCanvas = love.graphics.newCanvas(32*101,32*101)
isWorldCreated = false
lightSource = {}
lowestX = 0
lowestY = 0

function createWorld()
    
    lightSource = {}
    local highestX = 0
    local highestY = 0
    lowestX = 0
    lowestY = 0
    for i,v in ipairs(world) do
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
    end
    worldCanvas = love.graphics.newCanvas(32*(highestX+math.abs(lowestX)+2), 32*(highestY+math.abs(lowestY)+2))
    reinitLighting(32*(highestX+math.abs(lowestX)+2), 32*(highestY+math.abs(lowestY)+2))
    love.graphics.setCanvas(worldCanvas)
        love.graphics.clear()
        love.graphics.setColor(1, 1, 1)
        -- print(#world)
        for i, v in ipairs(world) do
            if isTileLit(v.X, v.Y) then
                love.graphics.setColor(1, 1, 1)
            else
                love.graphics.setColor(0, 0, 0, 0)
            end
            if not worldImg[v['GroundTile']] then
                if love.filesystem.getInfo(v['GroundTile']) then
                    worldImg[v['GroundTile']] = love.graphics.newImage(v['GroundTile'])
                else
                    worldImg[v['GroundTile']] = love.graphics.newImage("assets/error.png")
                end
            end
            local foregroundAsset = v['ForegroundTile']
            local backgroundAsset = v['GroundTile']
            if isTileWall(v.ForegroundTile) then
                foregroundAsset = getDrawableWall(v['ForegroundTile'], v.X, v.Y)
            end
            if isTileWall(v.GroundTile) then
                backgroundAsset = getDrawableWall(v['GroundTile'], v.X, v.Y)
            end

            if isTileWater(v.ForegroundTile) then
                foregroundAsset = getDrawableWater(v['ForegroundTile'], v.X, v.Y)
            end
            
            if isTileWater(v.GroundTile) then
                backgroundAsset = getDrawableWater(v['GroundTile'], v.X, v.Y)
            end

            if not worldImg[foregroundAsset] then
                if love.filesystem.getInfo(foregroundAsset) then
                    worldImg[foregroundAsset] = love.graphics.newImage(foregroundAsset)
                else
                    worldImg[foregroundAsset] = love.graphics.newImage("assets/error.png") 
                end
            end

            if lightGivers[foregroundAsset] and not lightSource[v.X .. "," .. v.Y] then
                lightSource[v.X .. "," .. v.Y] = true
                Luven.addNormalLight(16 + v.X * 32, 16 + v.Y * 32, {1, 0.5, 0}, lightGivers[foregroundAsset])
            end

            if v.Collision then
                if foregroundAsset == "assets/world/objects/Mountain.png" then
                    treeMap[v.X .. "," .. v.Y] = true
                end
                blockMap[v.X .. "," .. v.Y] = true
            end

            love.graphics.draw(worldImg[backgroundAsset], (v.X+math.abs(lowestX)) * 32, (v.Y+math.abs(lowestY)) * 32)  
            
            love.graphics.setColor(0,0,0,0.5)
           -- if isTileWall(v.ForegroundTile) then -- draw shadow
                --love.graphics.rectangle("fill", (v.X+math.abs(lowestX)) * 32 , (v.Y+math.abs(lowestY)) * 32 + 32, 32, 16)
                
            --end
            -- if v.Collision then
            --     love.graphics.draw(worldImg[foregroundAsset],(v.X+math.abs(lowestX)) * 32, (v.Y+math.abs(lowestY)) * 32 + 60, 0, 1, -1)
            -- end
            
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(worldImg[foregroundAsset], (v.X+math.abs(lowestX)) * 32, (v.Y+math.abs(lowestY)) * 32)
        -- love.graphics.print(v.X .. "," ..v.Y.."\n"..of, v.X*32, v.Y*32)
            -- local cx,cy = love.mouse.getPosition()

            -- if  cx > v.X*32 and cx < v.X*32+32 and cy > v.Y*32+32 and cy < v.Y*32+32  then
            --     love.graphics.rectangle("fill", v.X*32, v.Y*32, 32, 32)
            -- end
        end
    love.graphics.setCanvas()
end

function drawWorld()
    for x = player.x - (love.graphics.getWidth()/2)/32, player.x + (love.graphics.getWidth()/2)/32 do
        for y = player.y - (love.graphics.getHeight()/2)/32, player.y + (love.graphics.getHeight()/2)/32 do
            -- if isTileLit(x, y) then
            --     if not wasTileLit(x, y) then
            --         love.graphics.setColor(1 - oldLightAlpha, 1 - oldLightAlpha, 1 - oldLightAlpha) -- light up a tile
            --     else
            --         love.graphics.setColor(1, 1, 1)
            --     end
            -- elseif wasTileLit(x, y) and oldLightAlpha > 0.2 then
            --     love.graphics.setColor(oldLightAlpha, oldLightAlpha, oldLightAlpha)
            -- else
            --     love.graphics.setColor(0, 0, 0, 0)
            -- end
            love.graphics.setColor(1,1,1,1)
            love.graphics.draw(groundImg, x * 32, y * 32)
        end
    end
    --   drawDummy()
    love.graphics.setColor(1,1,1,1)
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(worldCanvas, lowestX*32, lowestY*32)
    love.graphics.setBlendMode("alpha")
end

function isTileWall(tileName)
    local r = explode(tileName, " ")
    local res = false
    for i, v in ipairs(r) do
        if v == "Wall.png" then
            res = true
        end
    end
    return res
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

    for i, v in ipairs(world) do
        if isTileWall(v.ForegroundTile) or isTileWall(v.GroundTile) then
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
end

function isTileWater(tileName)
    local res = false
    if string.find(tileName, "Water.png", 1) then
        res = true
    end
    -- print(res)
    return res
end

function getDrawableWater(tileName, x, y)
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

    for i, v in ipairs(world) do
        if isTileWater(v.ForegroundTile) or isTileWater(v.GroundTile) then
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
end
