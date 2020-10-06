--[[
    This script file is used for lighting in the game.
    It might be messy and slow.
]]

local Bresenham = require "..scripts.libraries.bresenham"

lightMap = {}
oldLightMap = {}

oldLightAlpha = 1

function calculateLighting(lowerX,lowerY,upperX,upperY,lanternPass)
    oldLightMap = copy(lightMap)
    lightMap = {}
    oldLightAlpha = 0.8
    for x=lowerX,upperX do
        for y=lowerY,upperY do
            if not calculateTileLit(x,y) then
                lightMap[x..","..y] = true
            else
                lightMap[x..","..y] = "lit"
            end
        end
    end
end

function isTileLit(x,y) 
    if lightMap[x..","..y] == "lit" then
        return true
    else
        return false
    end
end

function wasTileLit(x,y) 
    if oldLightMap[x..","..y] == "lit" then
        return true
    else
        return false
    end
end

function calculateTileLit(tx,ty) 
    -- doing this prevents trees themselves from being hidden
    if tx > player.x then
        tx = tx - 1
    elseif tx < player.x then
        tx = tx + 1
    end
    if ty > player. y then
        ty = ty - 1
    elseif ty < player.x then
        ty = ty + 1
    end

    local success, counter = Bresenham.line( player.x, player.y, tx, ty, function( x, y, counter )
     --   print( string.format( 'x: %d, y: %d, steps: %d, tile: %s', x, y, counter, grid[x][y] ))
        if treeMap[x..","..y] then
            return false
        end
        return true
    end)

    return success
   
end