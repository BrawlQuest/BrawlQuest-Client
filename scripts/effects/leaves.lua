--[[
    Leaves will fly past the screen when certain tiles are visible.
    Each world tile creates a radius for these leaves to be drawn.
]]
leaves = {}

leafImg = {}

function initLeaves()
    leafImg["tree"] = {
        img = love.graphics.newImage("assets/leaves/Tree.png"),
        chance = 1000,
        xv = {-50,-10},
        yv = {0,0},
        r = {0,100}
    }
    leafImg["snowy tree"] = {
        img = love.graphics.newImage("assets/leaves/Snowy Tree.png"),
        chance = 1000,
        xv = {-50,-10},
        yv = {0,0},
        r = {0,100}
    }
    leafImg["fire"] = {
        img = love.graphics.newImage("assets/leaves/Smoke.png"),
        chance = 10,
        xv = {-10,-5},
        yv = {10,50},
        r = {0,10}
    }
    leafImg["sand"] = {
        img = love.graphics.newImage("assets/leaves/Sand.png"),
        chance = 50000,
        xv = {-32,0},
        yv = {0,0},
        r = {0,0}
    }
end

function addLeaf(x,y,type,alpha)
        if not alpha then alpha = 0 end
        leaves[#leaves+1] = {
            x = x,
            y = y,
            r = love.math.random(leafImg[type].r[1],leafImg[type].r[2])/100,
            rs = love.math.random(leafImg[type].r[1],leafImg[type].r[2]*3)/100,
            xv = love.math.random(leafImg[type].xv[1],leafImg[type].xv[2]),
            yv = love.math.random(leafImg[type].yv[1],leafImg[type].yv[2]),
            bx = x,
            by = y,
            alpha = 0,
            type = type,
        }
 
end

function updateLeaves(dt)
    for i,v in ipairs(leaves) do
        if distanceToPoint(player.dx, player.dy, v.bx, v.by) < 1024 then
            v.x = v.x - v.xv*dt
            v.y = v.y - v.yv*dt
            v.r = v.r + v.rs*dt
            v.alpha = v.alpha - love.math.random(0,300)/100*dt
            if v.alpha < 0 and love.math.random(1,leafImg[v.type].chance) == 1 then
                v.x = v.bx
                v.xv = love.math.random(leafImg[v.type].xv[1],leafImg[v.type].xv[2])
                v.yv = love.math.random(leafImg[v.type].yv[1],leafImg[v.type].yv[2])
                v.y = v.by
                v.alpha = 5
            end
        end
    end
end

function drawLeaves()
    for i,v in ipairs(leaves) do
        love.graphics.setColor(1,1,1,v.alpha)
        love.graphics.draw(leafImg[v.type].img, v.x, v.y, v.r)
    end
end

