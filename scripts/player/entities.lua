
--[[
    This function returns an alpha value based on the distance between the player and the given x & y co-ordinates
    Note that these are drawn x and y values and not grid-based
]]
function getEntityAlpha(x,y,distanceOverride)
    local alphaToReturn = 1
    local thisDistance = 180
    if distanceOverride then
        thisDistance = distanceOverride
    end
    if (distanceToPoint(x,y,player.dx,player.dy) >  thisDistance) then
        alphaToReturn = 1 - (distanceToPoint(x,y,player.dx,player.dy)- thisDistance) / 64
    end
    return alphaToReturn
end