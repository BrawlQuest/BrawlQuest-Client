function initCamera()
    cameraScale = worldScale
    cameraWidth = 1
    cameraHeight = 0

    lighting = {
        open = false,
        amount = 1,
        next = "",
        current = "",
        previous = "",
        tab = {0,0,0,},
        locations = {
            ["Elodine's Gift"] = {
                open = false,
                todAmount = 0, -- controls the amount of timeOfDay added to your color
                tab = {0.2,0.1,0.2}, --time of day
            },
        },
        previousLocation = {0,0,0,},
        nextLocation = {0,0,0,},
    }
end

function updateCamera(dt)
    cameraScale = worldScale - (worldScale * settPan.opacityCERP) * 0.2 - (worldScale * event.alpha) * 0.1 + (worldScale * levelUp.cerp) * 0.3 - (worldScale * cerp(0, 1, death.amount * 2)) * 0.2 - (worldScale * enchanting.cerp) * 0.7
    Luven.camera:setScale(cameraScale * (1 - cerp(0, 1, cameraWidth) * (enchanting.cerp * 0.1)), cameraScale * (1 - cerp(0, 1, cameraHeight) * (enchanting.cerp * 0.1)))
    Luven.camera:setPosition(player.cx + 16, player.cy + 16)

    if enchanting.cerp > 0 then
        cameraWidth = cameraWidth + 0.6 * dt
        if cameraWidth > 2 then cameraWidth = 0 end

        cameraHeight = cameraHeight + 0.8 * dt
        if cameraHeight > 2 then cameraHeight = 0 end
    end

    local l = lighting
    if l.open then
        panelMovement(dt, lighting, 1, "amount", 1) 
        for i = 1, 3 do
            l.tab[i] = cerp(l.previousLocation[i], l.nextLocation[i], l.amount)
        end
        if l.amount == 1 then l.open = false end
        print(l.amount)

        local timeAmount, oldTimeAmount, newTimeAmount
        if l.locations[l.previous] then oldTimeAmount = l.locations[l.previous].todAmount else oldTimeAmount = 1 end
        if l.locations[l.next] then newTimeAmount = l.locations[l.next].todAmount else newTimeAmount = 1 end
        timeAmount = cerp(oldTimeAmount, newTimeAmount, l.amount)

        local tab = {l.tab[1] + timeOfDay * timeAmount, l.tab[2] + timeOfDay * timeAmount, l.tab[3] + timeOfDay * timeAmount}
        Luven.setAmbientLightColor(tab)
        print(json:encode_pretty(tab))
    end
end