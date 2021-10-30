
--[[
    This function returns an alpha value based on the distance between the player and the given x & y co-ordinates
    Note that these are drawn x and y values and not grid-based
]]
function getEntityAlpha(x,y)
    local alphaToReturn = 1
    if (distanceToPoint(x,y,player.dx,player.dy) > 180) then
        alphaToReturn = 1 - (distanceToPoint(x,y,player.dx,player.dy)-180) / 64
    end
    return alphaToReturn
end