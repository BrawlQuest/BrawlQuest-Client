--[[
    Leaves will fly past the screen when certain tiles are visible.
    Each world tile creates a radius for these leaves to be drawn.
]]
leaves = {}

leafImg = {}

function initLeaves()
    leafImg["assets/world/objects/Tree.png"] = love.graphics.newImage("assets/leaves/Tree.png")
end

function addLeaf(x,y)
    
        leaves[#leaves+1] = {
            x = x,
            y = y,
            r = love.math.random(0,100)/100,
            rs = love.math.random(0,300)/100,
            xv = love.math.random(-50,-10),
            bx = x,
            by = y,
            alpha = 0,
            type = "assets/world/objects/Tree.png",
        }
 
end

function updateLeaves(dt)
    for i,v in ipairs(leaves) do
        if distanceToPoint(player.dx, player.dy, v.bx, v.by) < 256 then
            v.x = v.x - v.xv*dt
            v.r = v.r + v.rs*dt
            v.alpha = v.alpha - love.math.random(0,300)/100*dt
            if v.alpha < 0 and love.math.random(1,1000) == 1 then
                v.x = v.bx
                v.y = v.by
                v.alpha = 5
            end
        end
    end
end

function drawLeaves()
    for i,v in ipairs(leaves) do
        love.graphics.setColor(1,1,1,v.alpha)
        love.graphics.draw(leafImg[v.type], v.x, v.y, v.r)
    end
end

