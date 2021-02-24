function initCamera()
    cameraScale = worldScale
end

function updateCamera(dt)
    cameraScale = worldScale - (worldScale * settPan.opacityCERP) * 0.2 - (worldScale * event.alpha) * 0.1 + (worldScale * levelUp.cerp) * 0.3 - (worldScale * cerp(0, 1, death.amount * 2)) * 0.2
    Luven.camera:setScale(cameraScale)
    Luven.camera:setPosition(player.cx + 16, player.cy + 16)
end