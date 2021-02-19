function initEvents()
    showEvents = true
    event = {
        amount = 0,
        hold = 1,
        release = 1,
        noiseAmount = 0,
        worldOut = 0,
        finalText = "NEW EVENT TITLE",
        text = "",
        textAmount = 0,
        alpha = 0,
    }
    eventRectangles = {}
end

function loadEventsBackground(text, amount)
    eventRectangles = {}
    for i = 1, amount do
        local rand = love.math.random(0, 1)
        local sUp
        if rand == 1 then sUp = true else sUp = false end

        eventRectangles[#eventRectangles+1] = {
            vx = love.math.random(-100, 100) * 10,
            vy = love.math.random(-100, 100) * 10,
            x = uiX * 0.5,
            y = uiY * 0.5,
            s = love.math.random() * 2,
            sUp = sUp,
            r = love.math.random(),
            g = love.math.random(),
            b = love.math.random(),
        }
    end
    event.finalText = text
    event.text = ""
    event.amount = 0
end

function updateEvents(dt)
    event.textAmount = event.textAmount + (string.len(event.finalText) * 0.7) * dt
    if event.textAmount > 1  and string.len(event.text) < string.len(event.finalText) then
        event.textAmount = 0
        -- print(string.len(event.text) + 1)
        event.text = string.sub(event.finalText, 1, string.len(event.text) + 1)
    end

    if event.amount < 1 then
        event.amount = event.amount + 0.6 * dt
        if event.amount >= 1 then
            event.amount = 1
            event.hold = 0
        end
        event.alpha = cerp(0,1,event.amount)
    elseif event.hold < 1 then
        event.hold = event.hold + 1 * dt
        if event.hold >= 1 then
            event.hold = 1
            event.release = 0
        end
    elseif event.release < 1 then
        event.release = event.release + 0.6 * dt
        if event.release >= 1 then
            event.release = 1
        end
        event.alpha = cerp(1,0,event.release)
    end

    for i,v in ipairs(eventRectangles) do
        v.s = v.s + 1 * dt
        if v.s > 2 then
            v.s = 0
        end

        v.vx = v.vx - v.vx * dt
        v.vy = v.vy - v.vy * dt

        v.x = v.x + v.vx * dt
        v.y = v.y + v.vy * dt
    end
end

function drawEvents()
    for i,v in ipairs(eventRectangles) do
        love.graphics.setColor(v.r, v.g, v.b, 0.4 * event.alpha)
        local boxScale = cerp (10, 100, v.s)
        love.graphics.rectangle("fill", v.x - boxScale / 2, v.y - boxScale / 2, boxScale, boxScale)
    end

    love.graphics.setColor(0,0,0,0.5 * event.alpha)
    love.graphics.rectangle("fill", 0, 0, uiX, uiY)

    love.graphics.setColor(1,1,1,event.alpha)
    local textScale = 8
    love.graphics.printf(event.text, npcNameFont, 0, 100, uiX / textScale, "center", 0, textScale)
end