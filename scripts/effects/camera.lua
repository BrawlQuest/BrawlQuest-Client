function initCamera()
    cameraScale = worldScale - (worldScale * settPan.opacityCERP) * 0.2 - (worldScale * event.alpha) * 0.2
end

function updateCamera(dt)
    cameraScale = worldScale - (worldScale * settPan.opacityCERP) * 0.2 - (worldScale * event.alpha) * 0.2
    Luven.camera:setScale(cameraScale)
    Luven.camera:setPosition(player.cx + 16, player.cy + 16)
end