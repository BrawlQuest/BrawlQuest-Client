local worldMapCanvas = love.graphics.newCanvas(4048,4048)
local farthestX = 0
local farthestY = 0
local leastX = 0
local leastY = 0

function initWorldMap()
    love.graphics.setCanvas(worldMapCanvas)
    
    for i,tile in ipairs(world) do
        local fgt = tile.ForegroundTile:lower()
        if string.sub(tile.Name, 1,5) == "Domin" then
            love.graphics.setColor(0,1,0)
        elseif string.match(fgt, "snowy tree") or string.match(fgt, "dead") then
            love.graphics.setColor(0.7,0.7,0.7)
        elseif string.match(fgt, "tree") then
            love.graphics.setColor(0,0.5,0)
        elseif string.match(fgt, "snow") then
            love.graphics.setColor(1,1,1)
        
        elseif string.match(fgt, "wall") or string.match(fgt, "mountain") then
            love.graphics.setColor(0.2,0.2,0.2)
        elseif string.match(fgt, "floor") then
            love.graphics.setColor(0.5,0.5,0.5)
        
        elseif string.match(fgt, "water") then
            love.graphics.setColor(0,0,1)
        elseif string.match(fgt, "sand") then
            love.graphics.setColor(1,0.8,0)
        elseif string.match(fgt, "path") or  string.match(fgt, "bridge") then
            love.graphics.setColor(1,0.7,1)
        elseif string.match(fgt, "snow") then
            love.graphics.setColor(1,1,1)
        elseif string.match(fgt, "grass") then
            love.graphics.setColor(0,1,0)
        end

        love.graphics.rectangle("fill", (tile.X*4)+400, (tile.Y*4)+400, 4, 4)

        if tile.X < farthestX then
            farthestX = tile.X

        end
        if tile.Y < farthestY then
            farthestY = tile.Y
        end
    end
    love.graphics.setCanvas()
end

function drawWorldMap(x, y)
    love.graphics.stencil(function () return love.graphics.rectangle("fill", x, y, 256,256,5) end, "replace", 1) -- stencils inventory
    love.graphics.setStencilTest("greater", 0) -- push
    love.graphics.setColor(1,1,1,0.7)
    love.graphics.draw(worldMapCanvas, x + farthestX-((player.dx/32)*4)-164, y + farthestY-((player.dy/32)*4)-145)
    -- love.graphics.setColor(1,0,0)
    -- for i, v in ipairs(enemies) do
    --     love.graphics.rectangle("fill", x + ((v.X*4)+400)+farthestX-((player.dx/32)*4)-164, y + ((v.Y*4)+400)+farthestY-((player.dy/32)*4)-145, 4, 4)
    -- end
    -- love.graphics.setColor(1,1,1)
    love.graphics.setStencilTest() -- pop
    -- for i, v in ipairs(enemies) do
    --     love.graphics.rectangle("fill", x + ((v.X*4)+400)+farthestX-((player.dx/32)*4)-164, y + ((v.Y*4)+400)+farthestY-((player.dy/32)*4)-145, 4, 4)
    -- end
    love.graphics.setColor(1,1,1)
end