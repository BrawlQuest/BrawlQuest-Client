--[[
    The "login" phase of login is for entering a UID and password
]]

function drawLoginPhase()
    loginImageX, loginImageY = math.floor(love.graphics.getWidth() / 2 - (loginEntryImage:getWidth() / 2)),
    math.floor(love.graphics.getHeight() / 2 - (loginEntryImage:getHeight() / 2))
    love.graphics.draw(loginEntryImage, loginImageX, loginImageY)

    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(textFont)
    if isMouseOver(loginImageX + 50, loginImageY + 265, 288, 44) then
        love.graphics.setColor(0.6, 0.6, 0.6)
    end
    if editingField == 1 then
        love.graphics.printf(textfields[1] .. "|", loginImageX + 50, loginImageY + 265, 262, "center")
    else
        love.graphics.printf(textfields[1], loginImageX + 50, loginImageY + 265, 262, "center")
    end
    love.graphics.setColor(0, 0, 0)
    if isMouseOver(loginImageX + 50, loginImageY + 335, 288, 44) then
        love.graphics.setColor(0.6, 0.6, 0.6)
    end

    if editingField == 2 then
        love.graphics.printf(textfields[3] .. "|", loginImageX + 50, loginImageY + 335, 262, "center")
    else
        love.graphics.printf(textfields[3], loginImageX + 50, loginImageY + 335, 262, "center")
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(headerFont)
    if isMouseOver(loginImageX + 36, loginImageY + 380, 288, 44) then
        love.graphics.setColor(0.8, 0.8, 0.8)
    end
    love.graphics.printf("ENTER WORLD", loginImageX + 50, loginImageY + 390, 262, "center")
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Username", loginImageX + 50, loginImageY + 230, 262, "center")
    love.graphics.printf("Password", loginImageX + 50, loginImageY + 300, 262, "center")
end

function checkClickLoginPhaseLogin(x,y)
    if isMouseOver(loginImageX + 50, loginImageY + 265, 288, 44) and editingField ~= 1 then
        editingField = 1
    elseif isMouseOver(loginImageX + 50, loginImageY + 335, 288, 44) and editingField ~= 2 then
        editingField = 2
    end
end

function checkLoginKeyPressedPhaseLogin(key)
    if key == "backspace" then
        textfields[editingField] = string.sub(textfields[editingField], 1, string.len(textfields[editingField]) - 1)
        if editingField == 2 then
            textfields[3] = string.sub(textfields[3], 1, string.len(textfields[3]) - 1)
        end
    elseif key == "tab" or key == "return" then
        if editingField == 1 then
            editingField = 2
        elseif editingField == 2 and key == "return" then
            login()
        end
    end
end

function checkLoginTextinputPhaseLogin(key)
    textfields[editingField] = textfields[editingField] .. key
    if editingField == 2 then
        textfields[3] = textfields[3] .. "*"
    end
end