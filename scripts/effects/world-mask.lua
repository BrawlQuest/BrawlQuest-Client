local Bresenham = require "..scripts.libraries.bresenham"

function initWorldMask()
    worldMask = {
        opacity = 0.6,
        gridSize = 32,
        range = 15,
        current = {x = 0, y = 0,},
        previous = {x = 0, y = 0,},
        flipFlop = 1,
        flipFlopAmount = 1,
        detected = false,
    }
    worldMaskTables = {{}, {}, }
end

function updateWorldMask(dt)

    worldMask.current = {x = math.floor((player.dx / 32) * 1), y = math.floor((player.dy / 32) * 1),}
    if (worldMask.current.x ~= worldMask.previous.x) or (worldMask.current.y ~= worldMask.previous.y) or worldScaleSmooting or isSettingsWindowOpen then
        worldMaskTables = {{},{},}
        local thisWorldScale = worldScale - ((worldScale * settPan.opacityCERP) * 0.2)
        local gridSize = worldMask.gridSize
        local gridScale = 32 / gridSize
        local cloudScale = 1 / thisWorldScale
        local width  = math.floor(((love.graphics.getWidth()  * cloudScale)/2) / gridSize) + 2 + (thisWorldScale)
        local height = math.floor(((love.graphics.getHeight() * cloudScale)/2) / gridSize) + 2 + (thisWorldScale)
        local range = worldMask.range * gridSize

        for x = ((player.x) * gridScale) - worldMask.range, (player.x * gridScale) + worldMask.range do
            for y = (player.y * gridScale) - worldMask.range, (player.y * gridScale) + worldMask.range do
                worldMask.detected = false            
                local distance = distanceToPoint(player.dx, player.dy, x * gridSize, y * gridSize)
                if distance <= range then 
                    if showShadows then
                        local success, counter = Bresenham.line(math.floor((player.dx / 32) * gridScale), math.floor((player.dy / 32) * gridScale), math.round(x), math.round(y), function (x,y) 
                            local thisX, thisY = x / gridScale, y / gridScale
                            -- local elseX, elseY = thisX - 0.5, thisY - 0.5

                            if worldLookup[thisX] and worldLookup[thisX][thisY] and worldLookup[thisX][thisY].Collision ~= null then
                                return checkIfCollision(thisX, thisY)
                            -- elseif worldLookup[thisX] and worldLookup[thisX][elseY] and worldLookup[thisX][elseY].Collision ~= null then
                            --     return checkIfCollision(thisX, elseY)
                            -- elseif worldLookup[elseX] and worldLookup[elseX][thisY] and worldLookup[elseX][thisY].Collision ~= null then
                            --     return checkIfCollision(elseX, thisY)
                            -- elseif worldLookup[elseX] and worldLookup[elseX][elseY] and worldLookup[elseX][elseY].Collision ~= null then
                            --     return checkIfCollision(elseX, elseY)
                            else
                                return true -- if there is no tile, just count it as blank.
                            end
                        end)

                        if success then
                            local intensity = range / (range + (difference(range, distance) * 4))
                            worldMaskTables[1][#worldMaskTables[1] + 1] = {x = x, y = y, visable = true, intensity = intensity}
                        else
                            worldMaskTables[1][#worldMaskTables[1] + 1] = {x = x, y = y, visable = false,}
                        end 
                    else -- if not drawing shadows
                        local intensity = range / (range + (difference(range, distance) * 4))
                        worldMaskTables[1][#worldMaskTables[1] + 1] = {x = x, y = y, visable = true, intensity = intensity}
                    end
                else
                    worldMaskTables[2][#worldMaskTables[2] + 1] = {x = x, y = y,}
                end
            end
        end
    end
end

function checkIfCollision(x,y)
    local output = true
    if not worldMask.detected then
        if worldLookup[x][y].Collision then --checks if a colliosion is reached
            worldMask.detected = true
            output = true   -- defers the output to later
        end
    elseif worldMask.detected then -- checks if there are multiple collisions in a row
        if not worldLookup[x][y].Collision then 
            output = false -- if the collisons end, then break,
        else
            output = true 
        end
    end
    return output
end

function drawWorldMask()
    -- worldMaskTables = {{},{},}
    local thisWorldScale = worldScale - ((worldScale * settPan.opacityCERP) * 0.2)
    local gridSize = worldMask.gridSize
    local gridScale = 32 / gridSize
    local cloudScale = 1 / thisWorldScale
    local width  = math.floor(((love.graphics.getWidth()  * cloudScale)/2) / gridSize) + 2 + (thisWorldScale)
    local height = math.floor(((love.graphics.getHeight() * cloudScale)/2) / gridSize) + 2 + (thisWorldScale)
    local range = worldMask.range * gridSize

    -- for x = ((player.x) * gridScale) - worldMask.range, (player.x * gridScale) + worldMask.range do
    --     for y = (player.y * gridScale) - worldMask.range, (player.y * gridScale) + worldMask.range do
    --         worldMask.detected = false            
    --         local distance = distanceToPoint(player.dx, player.dy, x * gridSize, y * gridSize)
    --         if distance <= range then 
    --             if showShadows then
    --                 local success, counter = Bresenham.line(math.floor((player.dx / 32) * gridScale), math.floor((player.dy / 32) * gridScale), math.round(x), math.round(y), function (x,y) 
    --                     local thisX, thisY = x / gridScale, y / gridScale
    --                     local elseX, elseY = thisX - 0.5, thisY - 0.5

    --                     if worldLookup[thisX] and worldLookup[thisX][thisY] and worldLookup[thisX][thisY].Collision ~= null then
    --                         return checkIfCollision(thisX, thisY)
    --                     elseif worldLookup[thisX] and worldLookup[thisX][elseY] and worldLookup[thisX][elseY].Collision ~= null then
    --                         return checkIfCollision(thisX, elseY)
    --                     elseif worldLookup[elseX] and worldLookup[elseX][thisY] and worldLookup[elseX][thisY].Collision ~= null then
    --                         return checkIfCollision(elseX, thisY)
    --                     elseif worldLookup[elseX] and worldLookup[elseX][elseY] and worldLookup[elseX][elseY].Collision ~= null then
    --                         return checkIfCollision(elseX, elseY)
    --                     else
    --                         return true -- if there is no tile, just count it as blank.
    --                     end
    --                 end)

    --                 if success then
    --                     local intensity = range / (range + (difference(range, distance) * 4))
    --                     love.graphics.setColor(0,0,0, (intensity - 0.2) * (worldMask.opacity + 0.2))
    --                     -- worldMaskTables[1][#worldMaskTables[1] + 1] = {x = x, y = y, visable = true, intensity = intensity}
    --                 else
    --                     love.graphics.setColor(0,0,0,worldMask.opacity)
    --                     -- worldMaskTables[1][#worldMaskTables[1] + 1] = {x = x, y = y, visable = false,}
    --                 end       
    --                 love.graphics.rectangle("fill", math.round(x) * gridSize, math.round(y) * gridSize, gridSize, gridSize)
    --             else -- if not drawing shadows
    --                 local intensity = range / (range + (difference(range, distance) * 4))
    --                 love.graphics.setColor(0,0,0, (intensity - 0.2) * (worldMask.opacity + 0.2))
    --                 love.graphics.rectangle("fill", math.round(x) * gridSize, math.round(y) * gridSize, gridSize, gridSize)
    --                 -- worldMaskTables[1][#worldMaskTables[1] + 1] = {x = x, y = y, visable = true, intensity = intensity}
    --             end
    --         else
    --             love.graphics.setColor(0,0,0,worldMask.opacity)
    --             -- worldMaskTables[2][#worldMaskTables[2] + 1] = {x = x, y = y,}
    --             love.graphics.rectangle("fill", math.round(x) * gridSize, math.round(y) * gridSize, gridSize, gridSize)
    --         end
    --     end
    -- end

    for i,v in ipairs(worldMaskTables[1]) do
        if v.visable then 
            love.graphics.setColor(0,0,0, (v.intensity - 0.2) * (worldMask.opacity + 0.2))
        else
            love.graphics.setColor(0,0,0,worldMask.opacity)
        end
        love.graphics.rectangle("fill", math.round(v.x) * gridSize, math.round(v.y) * gridSize, gridSize, gridSize)
    end
    love.graphics.setColor(0,0,0,worldMask.opacity)

    for i,v in ipairs(worldMaskTables[2]) do
        love.graphics.rectangle("fill", math.round(v.x) * gridSize, math.round(v.y) * gridSize, gridSize, gridSize)
    end 

    love.graphics.setColor(0,0,0,worldMask.opacity)

    width, height = ((love.graphics.getWidth() * cloudScale) * 0.5), ((love.graphics.getHeight() * cloudScale) * 0.5)
    local fourCorners = {
        {player.x * 32 - width - gridSize, player.y * 32 - height - gridSize, 100, 100,},
        {player.x * 32 + width + gridSize * 3, player.y * 32 - height - gridSize, -100, 100,},
        {player.x * 32 + width + gridSize * 3, player.y * 32 + height + gridSize * 3, -100, -100,},
        {player.x * 32 - width - gridSize * 2, player.y * 32 + height + gridSize * 3, 100, -100,},
    }

    local shadeCorners = {
        {player.x * 32 - range, player.y * 32 - range,},
        {player.x * 32 + range + gridSize, player.y * 32 - range,},
        {player.x * 32 + range + gridSize, player.y * 32 + range + gridSize,},
        {player.x * 32 - range, player.y * 32 + range + gridSize,},
    }

    love.graphics.polygon("fill", {
        fourCorners[1][1], fourCorners[1][2], 
        fourCorners[2][1], fourCorners[2][2], 
        shadeCorners[2][1], shadeCorners[2][2],
        shadeCorners[1][1], shadeCorners[1][2], 
    })

    love.graphics.polygon("fill", {
        fourCorners[3][1], fourCorners[3][2], 
        fourCorners[4][1], fourCorners[4][2], 
        shadeCorners[4][1], shadeCorners[4][2],
        shadeCorners[3][1], shadeCorners[3][2], 
    })

    love.graphics.polygon("fill", {
        fourCorners[4][1], fourCorners[4][2], 
        fourCorners[1][1], fourCorners[1][2], 
        shadeCorners[1][1], shadeCorners[1][2],
        shadeCorners[4][1], shadeCorners[4][2], 
    })

    love.graphics.polygon("fill", {
        fourCorners[2][1], fourCorners[2][2], 
        fourCorners[3][1], fourCorners[3][2], 
        shadeCorners[3][1], shadeCorners[3][2],
        shadeCorners[2][1], shadeCorners[2][2], 
    })

    love.graphics.setColor(1,1,1,1)
end