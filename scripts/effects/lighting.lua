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
        if lightGivers[v.foregroundtile] then--and not lightSource[v.x .. "," .. v.y] then
            lightSource[v.x .. "," .. v.y] = true
            Luven.addNormalLight(16 + (v.x * 32), 16 + (v.y * 32), lightGivers[v.foregroundtile].color, lightGivers[v.foregroundtile].brightness)
        end
   end
end