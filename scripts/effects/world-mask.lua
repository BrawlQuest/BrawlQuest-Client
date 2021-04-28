Bresenham = require "..scripts.libraries.bresenham"

function initWorldMask()
    worldMask = {
        opacity = 0.85,
        opacity2 = 0.85,
        gridSize = 32,
        range = 11,
        current = {x = 0, y = 0,},
        previous = {x = 0, y = 0,},
        flipFlop = 1,
        flipFlopAmount = 1,
        detected = false,
    }
    worldMaskTables = {{}, {}, }
end

function checkIfCollision(x,y)
    local output = true
    if not worldMask.detected then
        if worldLookup[x..","..y].Collision then --checks if a colliosion is reached
            worldMask.detected = true
            output = true   -- defers the output to later
        end
    elseif worldMask.detected then -- checks if there are multiple collisions in a row
        if not worldLookup[x..","..y].Collision then 
            output = false -- if the collisons end, then break,
        else
            output = true 
        end
    end
    return output
end

function drawWorldMask()
    local gridSize = worldMask.gridSize
    local gridScale = 32 / gridSize
    local cloudScale = 1 / cameraScale
    local width  = math.floor(((love.graphics.getWidth()  * cloudScale)/2) / gridSize) + 2 + cameraScale
    local height = math.floor(((love.graphics.getHeight() * cloudScale)/2) / gridSize) + 2 + cameraScale
    local range = worldMask.range * gridSize
    local r = 0.4 * (player.damageHUDAlpha + levelUp.cerp)
    local g = 0.2 * (levelUp.cerp)
    
    for x = ((player.x) * gridScale) - worldMask.range, (player.x * gridScale) + worldMask.range do
        for y = (player.y * gridScale) - worldMask.range, (player.y * gridScale) + worldMask.range do
            worldMask.detected = false            
            local distance = distanceToPoint(player.cx, player.cy, x * gridSize, y * gridSize)
            if distance <= range then 
                if player.world == 0 then
                    if showShadows then
                        local success, counter = Bresenham.line(math.floor((player.cx / 32) * gridScale), math.floor((player.cy / 32) * gridScale), math.round(x), math.round(y), function (x,y) 
                            local thisX, thisY = x / gridScale, y / gridScale
                            local elseX, elseY = thisX - 0.5, thisY - 0.5
                            local show = true
                            if worldLookup[thisX..","..thisY] and worldLookup[thisX..","..thisY].Collision ~= null then
                                return checkIfCollision(thisX, thisY)
                            elseif worldLookup[thisX..","..elseY] and worldLookup[thisX..","..elseY].Collision ~= null then
                                return checkIfCollision(thisX, elseY)
                            elseif worldLookup[elseX..","..thisY] and worldLookup[elseX..","..thisY].Collision ~= null then
                                return checkIfCollision(elseX, thisY)
                            elseif worldLookup[elseX..","..elseY] and worldLookup[elseX..","..elseY].Collision ~= null then
                                return checkIfCollision(elseX, elseY)
                            else return true end -- if there is no tile, just count it as blank.
                        end)

                        if success then
                            local intensity = range / (range + difference(range, distance) * 4)
                            if intensity < 0.1 then show = false end
                            love.graphics.setColor(0,0,0, (intensity - 0.2) * (worldMask.opacity2))
                        else
                            love.graphics.setColor(0,0,0,worldMask.opacity)
                        end       
                        if show then love.graphics.rectangle("fill", math.round(x) * gridSize, math.round(y) * gridSize, gridSize, gridSize) end
                    else -- if not drawing shadows
                        local intensity = range / (range + (difference(range, distance) * 5))
                        if intensity > 0.1 then
                            love.graphics.setColor(r, g, 0, (intensity) * (worldMask.opacity2))
                            love.graphics.rectangle("fill", math.round(x) * gridSize, math.round(y) * gridSize, gridSize, gridSize)
                        end
                    end
                end
                drawRangedWeaponsGrid(x,y)
            else -- outside of the circle
                if player.world == 0 then
                    love.graphics.setColor(r, g, 0,worldMask.opacity)
                    love.graphics.rectangle("fill", math.round(x) * gridSize, math.round(y) * gridSize, gridSize, gridSize)
                end
            end
        end
    end

    if player.world == 0 then
        love.graphics.setColor(r, g, 0, worldMask.opacity)

        width, height = ((love.graphics.getWidth() * cloudScale) * 0.5), ((love.graphics.getHeight() * cloudScale) * 0.5)

        local fourCorners = {
            {player.cx - width - gridSize, player.cy - height - gridSize, 100, 100,},
            {player.cx + width + gridSize * 3, player.cy - height - gridSize, -100, 100,},
            {player.cx + width + gridSize * 3, player.cy + height + gridSize * 3, -100, -100,},
            {player.cx - width - gridSize * 2, player.cy + height + gridSize * 3, 100, -100,},
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
    end

    love.graphics.setColor(1,1,1,1)
end