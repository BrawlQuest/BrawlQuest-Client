--[[
    This file is for managing login.
]]
require 'scripts.phases.login.background'
require 'scripts.phases.login.phases.login'
require 'scripts.phases.login.phases.characters'
local http = require("socket.http")
local json = require("scripts.libraries.json")
local ltn12 = require("ltn12")

textfields = {"", -- username
"", -- password
"" -- clean password (hidden)
}

characters = {}

loginPhase = "login" -- login / character select

editingField = 1

function initLogin()
    loginEntryImage = love.graphics.newImage("assets/ui/login/login.png")
    charactersEntryImage = love.graphics.newImage("assets/ui/login/character.png")
    buttonImage = love.graphics.newImage("assets/ui/login/button.png")
    initLoginBackground()
end

function drawLogin()
    -- background stuff
    drawLoginBackground()

    if loginPhase == "login" then
        drawLoginPhase()
    elseif loginPhase == "characters" then
        drawCharactersPhase()
    end

    love.graphics.setFont(smallTextFont)
    love.graphics.print("BrawlQuest " .. version ..
                            "\nFresh Play LTD 2016-2020\n\nGraphics by David E. Gervais\nMusic by Joseph Pearce\n\nMade with LÖVE")
end

function updateLogin(dt)
    updateLoginBackground(dt)
end

function checkClickLogin(x, y)
    if loginPhase == "login" then
        checkClickLoginPhaseLogin(x,y)
    elseif loginPhase == "characters" then
        checkClickLoginPhaseCharacter(x,y)
    end
end

function checkLoginKeyPressed(key)
    if loginPhase == "login" then
        checkLoginKeyPressedPhaseLogin(key)
    end
end

function checkLoginTextinput(key)

    if loginPhase == "login" then
        checkLoginTextinputPhaseLogin(key)
    end

end

function login()
    b, c, h = http.request(api.url .. "/login", json:encode({
        UID = textfields[1],
        Password = textfields[2]
    }))

    if c == 200 then
        b = json:decode(b)
        UID = textfields[1]
        token = b['token']
        r, h = http.request {
            url = api.url .. "/user/" .. textfields[1],
            headers = {
                ['token'] = b['token']
            },
            sink = ltn12.sink.table(characters)
        }

       if c == 200 then
            characters = json:decode(characters[1])
            loginPhase = "characters"
       end
    end
end
