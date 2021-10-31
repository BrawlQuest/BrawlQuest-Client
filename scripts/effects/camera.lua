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
                tab = {0.4,0.2,0.4}, --time of day
            },
        },
        previousLocation = {0,0,0,},
        nextLocation = {0,0,0,},
        timeAmount = 1,
        oldTimeAmount,
        newTimeAmount,
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
        panelMovement(dt, lighting, 1, "amount", 0.5) 
        for i = 1, 3 do l.tab[i] = cerp(l.previousLocation[i], l.nextLocation[i], l.amount) end
        if l.amount == 1 then l.open = false end
        l.timeAmount = cerp(l.oldTimeAmount, l.newTimeAmount, l.amount)
        setAmbientLighting()
    end
end

function setAmbientLighting()
    local l = lighting
    local tab = {l.tab[1] + timeOfDay * l.timeAmount + 0.3, l.tab[2] + timeOfDay * l.timeAmount + 0.3, l.tab[3] + timeOfDay * l.timeAmount + 0.3}
    Luven.setAmbientLightColor(tab)
end

function setLighting(response)
    local l = lighting

   -- timeOfDay = cerp(0.1, 1, ((math.abs(response['CurrentHour']) * 60) + 0) / 720)
 --   timeOfDay = timeOfDay + 0.1
    timeOfDay = 0

    if not worldEdit.open then
        
        if worldLookup[me.X..","..me.Y] and worldLookup[me.X..","..me.Y].Name ~= "" then -- custom lighting for different zones
            local location = worldLookup[me.X..","..me.Y].Name
            if l.current ~= location and not l.open then
                lighting.next = location
                lighting.previous = l.current
                l.current = location
                lighting.previousLocation = l.tab

                lighting.amount = 0
                lighting.open = true

                if l.locations[location] then
                    local v = l.locations[location]
                    lighting.nextLocation = v.tab
                    l.newTimeAmount = v.todAmount
                else
                    lighting.nextLocation = {0,0,0}
                    l.newTimeAmount = 1
                end
                if l.locations[l.previous] then l.oldTimeAmount = l.locations[l.previous].todAmount else l.oldTimeAmount = 1 end
            end
        end
        if not lighting.open then setAmbientLighting() end
    else
        l.current = "lol"
        Luven.setAmbientLightColor({1,1,1})
    end
end