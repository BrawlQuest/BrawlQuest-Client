function initEvents()
    showEvents = true
    event = {
        noiseAmount = 0,
        worldOut = 0,
    }
end

function updateEvents(dt)
    if showEvents then
        event.noiseAmount = event.noiseAmount - 1 * dt
    end
end

function drawEvents()
    w, h = uiX, uiY
    local boxSize = 100
    local amount = {x = math.ceil(w / boxSize), y = math.ceil(h / boxSize)}
    local range = amount.x / 2
    w = math.ceil(w / amount.x)
    h = math.ceil(h / amount.y)
    for x = 0, amount.x do
        for y = 0, amount.y do
            local distance = distanceToPoint(w / 2, h / 2, x, y)
            local noise = math.clamp(0, love.math.noise((x + event.noiseAmount) * 0.1, (y + event.noiseAmount) * 0.1) +
                love.math.noise((x - event.noiseAmount) * 0.05, (y - event.noiseAmount) * 0.05), 1)
            -- local alpha = range / (range + difference(range, distance))
            love.graphics.setColor(
                love.math.noise((x - event.noiseAmount) * 0.05, (y - event.noiseAmount) * 0.05) + cerp(0, 0.1, event.noiseAmount),
                love.math.noise((x - event.noiseAmount) * 0.05, (y + event.noiseAmount) * 0.05) + cerp(0, 0.1, event.noiseAmount + 0.3),
                love.math.noise((x + event.noiseAmount) * 0.05, (y + event.noiseAmount) * 0.05) + cerp(0, 0.1, event.noiseAmount + 0.6),
                0.6
            )
            love.graphics.rectangle("fill", x * w, y * h, w, h)
        end
    end

    -- print("x = " .. w / 2 .. ", y = " .. h / 2)
end