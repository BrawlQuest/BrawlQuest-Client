function initEvents()
    showEvents = true
    event = {
        amount = 0,
        noiseAmount = 0,
        worldOut = 0,
        finalText = "NEW EVENT TITLE",
        text = "",
        textAmount = 0,
    }
    eventRectangles = {}
    loadEventsBackground("NEW EVENT TITLE", 1000)
end

function loadEventsBackground(text, amount)
    for i = 1, amount do
        eventRectangles[#eventRectangles+1] = {
            dx = love.math.random(0, uiX),
            dy = love.math.random(0, uiY),
            x = uiX * 0.5,
            y = uiY * 0.5,
            s = love.math.random(),
            sUp = true,
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


    event.textAmount = event.textAmount + 10 * dt
    if event.textAmount > 1  and string.len(event.text) < string.len(event.finalText) then
        event.textAmount = 0
        print(string.len(event.text) + 1)
        event.text = string.sub(event.finalText, 1, string.len(event.text) + 1)
    end

    if event.amount < 1 then
        event.amount = event.amount + 0.5 * dt
        if event.amount >= 1 then
            event.amount = 1
        end
    end

    event.alpha = cerp(0,1,event.amount)

    for i,v in ipairs(eventRectangles) do
        v.s = v.s + 1 * dt
        if v.s > 2 then
            v.s = love.math.random()
        end
        v.x = v.dx * event.alpha
        v.y = v.dy * event.alpha
    end
end

function drawEvents()
    love.graphics.setColor(1,1,1,0.3)
    for i,v in ipairs(eventRectangles) do
        love.graphics.setColor(v.r,v.g,v.b,0.4)
        local boxScale = cerp (10, 100, v.s)
        love.graphics.rectangle("fill", v.x - boxScale / 2, v.y - boxScale / 2, boxScale, boxScale)
    end


    love.graphics.setColor(1,1,1,event.alpha)
    local textScale = 8
    love.graphics.printf(event.text, npcNameFont, 0, 100, uiX / textScale, "center", 0, textScale)
end