--[[
    drawStandardButton(x,y,w,h,{
        text = {static = text},
        textPos = "center",
        bgColor = {off = {0,0,0,bgAlpha}, on = {1,0,0,bgAlpha}},
        fgColor = {off = {1,1,1,1}, on = {1,1,1,1}},
        action = {on = function()  end, off = function()  end,},
        disabled = false,
        select = function() return false end,
        scale = 1,
        other = function()  end,
    })
]]

function drawStandardButton(x,y,w,h,t)
    local isMouse
    if t.disabled then isMouse = not t.disabled else isMouse = isMouseOver(x * scale, y * scale, w * scale, h * scale) end
    local text
    if isMouse or (t.select and t.select()) then buttonToggleActions(t, "on", {1,0,0,1}) y = y - 4 else buttonToggleActions(t, "off", {0,0,0,0.8}) end
    love.graphics.rectangle("fill", x, y, w, h, 10)
    if isMouse or (t.select and t.select()) then if t.fgColor then love.graphics.setColor(unpack(t.fgColor.on)) else love.graphics.setColor(1,1,1) end
    else if t.fgColor then love.graphics.setColor(unpack(t.fgColor.off)) else love.graphics.setColor(1,1,1, 1 - 0.5 * boolToInt(t.disabled)) end end
    love.graphics.rectangle("line", x, y, w, h, 10)
    local textScale = t.scale or 3
    if t.text.static then text = t.text.static end
    if text then love.graphics.printf(text, x + 10, y + h/2 - getTextHeight(text, w - 20, t.font or font, textScale) * (t.textMod or 0.5), (w - 20) / textScale, t.textPos or "center", 0, textScale) end
    if t.other then t.other() end
end

function buttonToggleActions(t, key, color)
    if t.bgColor then love.graphics.setColor(unpack(t.bgColor[key])) else love.graphics.setColor(unpack(color)) end
    if t.action and t.action[key] then t.action[key]() end
    if t.text[key] then text = t.text[key] else text = false end
end