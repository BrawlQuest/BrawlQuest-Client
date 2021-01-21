local Bresenham = require "..scripts.libraries.bresenham"

function initWorldMask()
    worldMask = {
        backroundColor = {0,0,0,0.7},
        gridSize = 32,
        range = 20,
        current = {x = 0, y = 0,},
        previous = {x = 0, y = 0,},
        flipFlop = 2,
        flipFlopAmount = 1,
    }
    worldMaskTables = {{}, {}, }
end

function updateWorldMask(dt)

    if worldMask.flipFlop == 1 then
        worldMask.flipFlopAmount = worldMask.flipFlopAmount + 2 * dt
        if worldMask.flipFlopAmount > 1 then worldMask.flipFlopAmount = 1 end
    end

    if worldMask.flipFlop == 2 then 
        worldMask.flipFlopAmount = worldMask.flipFlopAmount - 2 * dt
        if worldMask.flipFlopAmount < 0 then worldMask.flipFlopAmount = 0 end
    end

    print(worldMask.flipFlop .. ", " .. worldMask.flipFlopAmount)

    worldMask.current = {x = player.x, y = player.y,}
    if (worldMask.current.x ~= worldMask.previous.x) or (worldMask.current.y ~= worldMask.previous.y) then -- or worldScaleSmooting
        worldMask.previous = copy(worldMask.current)

        if worldMask.flipFlop == 1 then 
            worldMask.flipFlop = 2 
            print("true")
        elseif worldMask.flipFlop == 2 then 
            worldMask.flipFlop = 1 
        end

        worldMaskTables[worldMask.flipFlop] = {}
        local thisWorldScale = worldScale - ((worldScale * settPan.opacityCERP) * 0.2)
        local gridSize = worldMask.gridSize
        local gridScale = 32 / gridSize
        local cloudScale = 1 / thisWorldScale
        local width  = math.floor(((love.graphics.getWidth()  * cloudScale)/2) / gridSize) + 2 + (thisWorldScale)
        local height = math.floor(((love.graphics.getHeight() * cloudScale)/2) / gridSize) + 2 + (thisWorldScale)
        local range = worldMask.range * gridSize

        for x = (player.x * gridScale) - width, (player.x * gridScale) + width do      
            for y = (player.y * gridScale) - height, (player.y * gridScale) + height do
                local detected = false            
                local distance = distanceToPoint(player.dx, player.dy, x * gridSize, y * gridSize)
                if distance <= range then 
                    local success, counter = Bresenham.line( player.x, player.y, math.round(x), math.round(y), function (x,y) 

                        if worldLookup[x] and worldLookup[x][y] and worldLookup[x][y].Collision ~= null then
                            local output = true
                            if not detected then
                                if worldLookup[x][y].Collision then --checks if a colliosion is reached
                                    detected = true
                                    output = true   -- defers the output to later
                                end
                            elseif detected then -- checks if there are multiple collisions in a row
                                if not worldLookup[x][y].Collision then 
                                    output = false -- if the collisons end, then break,
                                else
                                    output = true 
                                end
                            end
                            return output
                        else
                            return true -- if there is no tile, just count it as blank.
                        end
                    end)
                    if success then
                        worldMaskTables[worldMask.flipFlop][#worldMaskTables[worldMask.flipFlop] + 1] = {x = x, y = y, visable = true, intensity = 1 - ((range * 0.3) / distance),}
                    else
                        worldMaskTables[worldMask.flipFlop][#worldMaskTables[worldMask.flipFlop] + 1] = {x = x, y = y, visable = false, intensity = 1 - ((range * 0.3) / distance),}
                    end         
                end
            end
        end 
    end



end

function drawWorldMask()
    local thisWorldScale = worldScale - ((worldScale * settPan.opacityCERP) * 0.2)
    local gridSize = worldMask.gridSize
    local gridScale = 32 / gridSize
    local cloudScale = 1 / thisWorldScale
    local width  = math.floor(((love.graphics.getWidth()  * cloudScale)/2) / gridSize) + 2 + (thisWorldScale)
    local height = math.floor(((love.graphics.getHeight() * cloudScale)/2) / gridSize) + 2 + (thisWorldScale)
    local range = worldMask.range * gridSize

    for x = (player.x * gridScale) - width, (player.x * gridScale) + width do      
        for y = (player.y * gridScale) - height, (player.y * gridScale) + height do
            local distance = distanceToPoint(player.dx, player.dy, x * gridSize, y * gridSize)
            if distance > range then 
                love.graphics.setColor(unpack(worldMask.backroundColor))
                love.graphics.rectangle("fill", math.round(x) * gridSize, math.round(y) * gridSize, gridSize, gridSize)
            end
        end
    end


    thisFlipFlopAmount = lerp(0,1,worldMask.flipFlopAmount)

    for i,v in ipairs(worldMaskTables[1]) do
        if v.visable then 
            love.graphics.setColor(0,0,0, v.intensity * thisFlipFlopAmount)
        else
            love.graphics.setColor(0,0,0,0.7 * thisFlipFlopAmount)
        end
        love.graphics.rectangle("fill", math.round(v.x) * gridSize, math.round(v.y) * gridSize, gridSize, gridSize)
    end

    for i,v in ipairs(worldMaskTables[2]) do
        if v.visable then 
            love.graphics.setColor(0,0,0, v.intensity * ((-1 * thisFlipFlopAmount) + 1))
        else
            love.graphics.setColor(0,0,0,0.7 * ((-1 * thisFlipFlopAmount) + 1))
        end
        love.graphics.rectangle("fill", math.round(v.x) * gridSize, math.round(v.y) * gridSize, gridSize, gridSize)
    end
end