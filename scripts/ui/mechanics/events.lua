function initEvents()
    showEvents = false
    event = {
        amount = 1,
        hold = 1,
        release = 1,
        finalText = "",
        text = "",
        textAmount = 0,
        alpha = 0,
    }
end

function zoneChange(text)
    if not showEvents then
        showEvents = true
        event.finalText = text
        event.text = ""
        event.amount = 0
    end
end

function updateEvents(dt)
    event.textAmount = event.textAmount + (string.len(event.finalText) * 0.7) * dt
    if event.textAmount > 1 and string.len(event.text) < string.len(event.finalText) then
        event.textAmount = 0
        event.text = string.sub(event.finalText, 1, string.len(event.text) + 1)
    end

    if event.amount < 1 then
        event.amount = event.amount + 0.7 * dt
        if event.amount >= 1 then
            event.amount = 1
            event.hold = 0
        end
        event.alpha = cerp(0,1,event.amount)
    elseif event.hold < 1 then
        event.hold = event.hold + 3 * dt
        if event.hold >= 1 then
            event.hold = 1
            event.release = 0
        end
    elseif event.release < 1 then
        event.release = event.release + 0.8 * dt
        if event.release >= 1 then
            event.release = 1
            showEvents = false
        end
        event.alpha = cerp(1,0,event.release)
    end
end

function drawAreaName()
    local alpha = 0.1
    if phase == "login" then alpha = 0.4 end
    love.graphics.setColor(0,0,0, alpha * event.alpha)
    love.graphics.rectangle("fill", 0, 0, uiX, uiY)

  love.graphics.setColor(1,1,1,event.alpha)
 -- love.graphics.setColor(1,1,1,1)
    local textScale = 8
    love.graphics.printf(event.text, npcNameFont, 0, 100, uiX / textScale, "center", 0, textScale)
end


function drawEvents()
    local x, y = player.dx + 16, player.dy + 16
end