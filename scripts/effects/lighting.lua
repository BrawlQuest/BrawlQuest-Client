-- Luven related functions

lightOverride = {
    val = 0.2,
}

function initLighting() 
    worldScale = 2
    Luven.init()
    Luven.camera:init(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    Luven.camera:setScale(worldScale)
end

function recalculateLighting()
    Luven.dispose()
   -- lightSource = {}

    Luven.init()
    for i,v in ipairs(world) do
        if lightGivers[v.ForegroundTile] then--and not lightSource[v.X .. "," .. v.Y] then
            lightSource[v.X .. "," .. v.Y] = true
            Luven.addNormalLight(16 + (v.X * 32), 16 + (v.Y * 32), lightGivers[v.ForegroundTile].color, lightGivers[v.ForegroundTile].brightness)
        end
   end
end