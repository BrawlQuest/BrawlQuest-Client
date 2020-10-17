--[[
    This file is for managing login.
]]
require 'scripts.phases.login.background'
local http = require("socket.http")
local json = require("scripts.libraries.json")

textfields = {"", -- username
"", -- password
"" -- clean password (hidden)
}

loginPhase = "login" -- login / character select

editingField = 1

function initLogin()
    loginEntryImage = love.graphics.newImage("assets/ui/login/login.png")
    initLoginBackground()
end

function drawLogin()
    -- background stuff
    drawLoginBackground()

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
    love.graphics.setFont(smallTextFont)
    love.graphics.print("BrawlQuest " .. version ..
                            "\nFresh Play LTD 2016-2020\n\nGraphics by David E. Gervais\nMusic by Joseph Pearce\n\nMade with LÖVE")
end

function updateLogin(dt)
    updateLoginBackground(dt)
end

function checkClickLogin(x, y)
    if isMouseOver(loginImageX + 50, loginImageY + 265, 288, 44) and editingField ~= 1 then
        editingField = 1
    elseif isMouseOver(loginImageX + 50, loginImageY + 335, 288, 44) and editingField ~= 2 then
        editingField = 2
    end
end

function checkLoginKeyPressed(key)
    if key == "backspace" then
        textfields[editingField] = string.sub(textfields[editingField], 1, string.len(textfields[editingField]) - 1)
        if editingField == 2 then
            textfields[3] = string.sub(textfields[3], 1, string.len(textfields[3]) - 1)
        end
    elseif key == "tab" or key == "return" then
        if editingField == 1 then editingField = 2 
        elseif editingField == 2 and key == "return" then login() end
    end
end

function checkLoginTextinput(key)

    textfields[editingField] = textfields[editingField] .. key
    if editingField == 2 then
        textfields[3] = textfields[3] .. "*"
    end

end

function login()
    b, c, h = http.request(api.url.."/login", json:encode({
        UID=textfields[1],
        Password=textfields[2],
    }))

    if c == 200 then
        b,c,h = http.request(api.url.."/user/"..textfields[1], {
            
        })
    
        r = json:encode(c)
        love.system.setClipboardText(r)
    end
end