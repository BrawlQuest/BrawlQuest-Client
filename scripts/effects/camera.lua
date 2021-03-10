function initCamera()
    cameraScale = worldScale
    cameraWidth = 1
    cameraHeight = 0
end

function updateCamera(dt)
    cameraScale = worldScale - (worldScale * settPan.opacityCERP) * 0.2 - (worldScale * event.alpha) * 0.1 + (worldScale * levelUp.cerp) * 0.3 - (worldScale * cerp(0, 1, death.amount * 2)) * 0.2 - (worldScale * enchanting.cerp) * 0.9
    Luven.camera:setScale(cameraScale * (1 - cerp(0, 1, cameraWidth) * (enchanting.cerp * 0.1)), cameraScale * (1 - cerp(0, 1, cameraHeight) * (enchanting.cerp * 0.1))) 
    Luven.camera:setPosition(player.cx + 16, player.cy + 16)
    
    if enchanting.cerp > 0 then
        cameraWidth = cameraWidth + 0.6 * dt
        if cameraWidth > 2 then cameraWidth = 0 end

        cameraHeight = cameraHeight + 0.8 * dt
        if cameraHeight > 2 then cameraHeight = 0 end
    end
end