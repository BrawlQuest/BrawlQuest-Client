local Bresenham = require "..scripts.libraries.bresenham"

function initWorldMask()
    worldMask = {
        opacity = 0.6,
        gridSize = 16,
        range = 30,
        current = {x = 0, y = 0,},
        previous = {x = 0, y = 0,},
        flipFlop = 1,
        flipFlopAmount = 1,
        detected = false,
    }
    worldMaskTables = {{}, {}, }
end

function updateWorldMask(dt)
    worldMask.current = {x = math.floor((player.dx / 32) * 4), y = math.floor((player.dy / 32) * 4),}

    if (worldMask.current.x ~= worldMask.previous.x) or (worldMask.current.y ~= worldMask.previous.y) or worldScaleSmooting or isSettingsWindowOpen then -- 
        
        worldMask.previous = copy(worldMask.current)
        worldMaskTables = {{},{},}

        local thisWorldScale = worldScale - ((worldScale * settPan.opacityCERP) * 0.2)
        local gridSize = worldMask.gridSize
        local gridScale = 32 / gridSize
        local cloudScale = 1 / thisWorldScale
        local width  = math.floor(((love.graphics.getWidth()  * cloudScale)/2) / gridSize) + 2 + (thisWorldScale)
        local height = math.floor(((love.graphics.getHeight() * cloudScale)/2) / gridSize) + 2 + (thisWorldScale)
        local range = worldMask.range * gridSize

        for x = ((player.x) * gridScale) - width, (player.x * gridScale) + width do      
            for y = (player.y * gridScale) - height, (player.y * gridScale) + height do
                worldMask.detected = false            
                local distance = distanceToPoint(player.dx, player.dy, x * gridSize, y * gridSize)
                if distance <= range then 
                    if showShadows then
                        local success, counter = Bresenham.line(math.floor((player.dx / 32) * gridScale), math.floor((player.dy / 32) * gridScale), math.round(x), math.round(y), function (x,y) 
                            local thisX, thisY = x / gridScale, y / gridScale
                            local elseX, elseY = thisX - 0.5, thisY - 0.5

                            if worldLookup[thisX] and worldLookup[thisX][thisY] and worldLookup[thisX][thisY].Collision ~= null then
                                return checkIfCollision(thisX, thisY)
                            elseif worldLookup[thisX] and worldLookup[thisX][elseY] and worldLookup[thisX][elseY].Collision ~= null then
                                return checkIfCollision(thisX, elseY)
                            elseif worldLookup[elseX] and worldLookup[elseX][thisY] and worldLookup[elseX][thisY].Collision ~= null then
                                return checkIfCollision(elseX, thisY)
                            elseif worldLookup[elseX] and worldLookup[elseX][elseY] and worldLookup[elseX][elseY].Collision ~= null then
                                return checkIfCollision(elseX, elseY)
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
    local gridSize = worldMask.gridSize
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
end