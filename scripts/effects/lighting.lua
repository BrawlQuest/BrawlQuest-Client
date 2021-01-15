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
        return true--false
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
    if ty > player.y then
        ty = ty - 1
    elseif ty < player.y then
        ty = ty + 1
    end

    local success, counter = Bresenham.line( player.x, player.y, tx, ty, function( x, y, counter )
     --   print( string.format( 'x: %d, y: %d, steps: %d, tile: %s', x, y, counter, grid[x][y] ))
        if treeMap[x..","..y] then -- Are you here to make enemies count as light blockers? Maybe don't...
            -- We've tried it a few times and it just doesn't work!
            return false
        end
        return true
    end)

    return success
end

-- Luven related functions

function initLighting() 
    worldScale = 2
    Luven.init()
    -- Luven.setAmbientLightColor({ 0.1, 0.1, 0.1 })
    Luven.camera:init(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    Luven.camera:setScale(worldScale)
end

function reinitLighting(w,h)
    lightSource = {}
    Luven.dispose()
    initLighting()
end
