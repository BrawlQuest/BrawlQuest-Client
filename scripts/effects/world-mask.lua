local Bresenham = require "..scripts.libraries.bresenham"

function initWorldMask()
    worldMask = {
        backroundColor = {0,0,0,0.7},
        gridSize = 32,
        range = 20,
    }

    firstWorldMask = {}
    secondWorldMask = {}
end

function updateWorldMask(dt)
    -- It's gotta make a table of all visisble blocks for the draw function to draw out for it depending on the players location. 
    -- this could be done with  a couple of for loops. 
    -- essentially, all logic will be done in the update function, jyst the draw will be different

    --if there has been a change, then change. 

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
                    firstWorldMask[#firstWorldMask + 1] = {x = x, y = y, intensity = 1 - ((range * 0.3) / distance),}
                end         
            end
            love.graphics.rectangle("fill", math.round(x) * gridSize, math.round(y) * gridSize, gridSize, gridSize)
        end
    end 
    print(json:encode(firstWorldMask))
end

function drawWorldMask()
    local thisWorldScale = worldScale - ((worldScale * settPan.opacityCERP) * 0.2)
    local gridSize = worldMask.gridSize
    local gridScale = 32 / gridSize
    local cloudScale = 1 / thisWorldScale
    local width  = math.floor(((love.graphics.getWidth()  * cloudScale)/2) / gridSize) + 2 + (thisWorldScale)
    local height = math.floor(((love.graphics.getHeight() * cloudScale)/2) / gridSize) + 2 + (thisWorldScale)
    love.graphics.setBlendMode("alpha", "premultiplied")
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
                    love.graphics.setColor(0,0,0, 1 - ((range * 0.3) / distance))
                else
                    love.graphics.setColor(unpack(worldMask.backroundColor))    
                end

            else
                love.graphics.setColor(unpack(worldMask.backroundColor))                
            end
            love.graphics.rectangle("fill", math.round(x) * gridSize, math.round(y) * gridSize, gridSize, gridSize)
        end
    end 

    love.graphics.setBlendMode("alpha")
end