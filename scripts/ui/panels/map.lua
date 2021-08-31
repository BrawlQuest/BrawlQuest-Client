worldMapCanvas = love.graphics.newCanvas(2048,2048)


function initWorldMap()
    love.graphics.setCanvas(worldMapCanvas)
    for i,tile in ipairs(world) do
        local x,y = math.floor((tile.X) / chunkSize), math.floor((tile.Y) / chunkSize)
        if not worldChunks[x..","..y] then worldChunks[x..","..y] = {} end
        if player.world == 0 then worldChunks[x..","..y][#worldChunks[x..","..y] + 1] = copy(tile) end
        local fgt = tile.ForegroundTile:lower()

        if string.match(fgt, "grass") then
            love.graphics.setColor(0,1,0)
        elseif string.match(fgt, "tree") then
            love.graphics.setColor(0,0.5,0)
        elseif string.match(fgt, "wall") then
            love.graphics.setColor(0.2,0.2,0.2)
        elseif string.match(fgt, "floor") then
            love.graphics.setColor(0.5,0.5,0.5)
        elseif string.match(fgt, "water") then
            love.graphics.setColor(0,0,1)
        elseif string.match(fgt, "sand") then
            love.graphics.setColor(1,0.8,0)
        elseif string.match(fgt, "path") then
            love.graphics.setColor(1,0.7,1)
        end

        love.graphics.rectangle("fill", tile.X, tile.Y, 1, 1)
    end
    love.graphics.setCanvas()
end

function drawWorldMap()
    love.graphics.draw(worldMapCanvas, 300, 300)
end