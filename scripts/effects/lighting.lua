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

function reinitLighting(w,h)
    lightSource = {}
    Luven.dispose()
    initLighting()
end
