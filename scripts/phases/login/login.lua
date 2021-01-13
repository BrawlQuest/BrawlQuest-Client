--[[
    This file is for managing login.
]]
require 'scripts.phases.login.background'
require 'scripts.phases.login.phases.login'
require 'scripts.phases.login.phases.characters'
require 'scripts.phases.login.phases.creation'
require 'scripts.phases.login.phases.server'

textfields = {"", -- username
"", -- password
"", -- clean password (hidden)
"", -- character name (used on creation)
"assets/world/grounds/grass.png", -- background tile (world edit)
"assets/world/grounds/Mountain.png", -- foreground tile (world edit)
"Spooky Forest", -- locale name (world edit)
"" -- enemy name (world edit)
}

characters = {}

loginPhase = "login" -- login / character / creation

editingField = 1

function initLogin()

    loginText = {
        "BrawlQuest " .. version .. " " .. versionNumber,
        "Luven Interactive LTD 2020",
        "",
        "Created By:" ,
        "Thomas Lock -- Creator and Founder",
        "Dan Stubbs -- Designer and Other Stuff",
        "",
        "Graphics by David E. Gervais",
        "Music by Joseph Pearce",
        "",
        "Special thanks to ThinkSometimes for the Minty sprite",
        "Special thanks to my entire Twitch community <3",
        "",
        "Made with LÖVE",
    }

    loginEntryImage = love.graphics.newImage("assets/ui/login/login.png")
    charactersEntryImage = love.graphics.newImage("assets/ui/login/characterbackground.png")
    charactersButtonImage = love.graphics.newImage("assets/ui/login/characterwidget.png")
    blankPanelImage = love.graphics.newImage("assets/ui/login/emptylogin.png")
    buttonImage = love.graphics.newImage("assets/ui/login/button.png")
    textFieldImage = love.graphics.newImage("assets/ui/login/textbox.png")
    basePanelImage = love.graphics.newImage("assets/ui/login/character base panel.png")
    lightningSfx = love.audio.newSource("assets/sfx/weather/lightning_b.wav", "static")
    lightningSfx:setVolume(0.5)
    initLoginBackground()
end

function drawLogin()
    -- background stuff
    drawLoginBackground()

    if loginPhase == "login" then
        drawLoginPhase()
    elseif loginPhase == "characters" then
        drawCharactersPhase()
    elseif loginPhase == "creation" then
        drawCreationPhase()
    elseif loginPhase == "server" then
        drawServerPhase()
    end

    love.graphics.setColor(1,1,1)
    for i, v in ipairs(loginText) do
        love.graphics.print(v, playerNameFont, 10, 10 + ((playerNameFont:getHeight() + 2) * (i-1)), 0, 1)
    end
end

function updateLogin(dt)
    updateLoginBackground(dt)
end

function checkClickLogin(x, y)
    if loginPhase == "login" then
        checkClickLoginPhaseLogin(x,y)
    elseif loginPhase == "characters" then
        checkClickLoginPhaseCharacter(x,y)
    elseif loginPhase == "creation" then
        checkClickLoginPhaseCreation(x,y)
    elseif loginPhase == "server" then
        checkClickLoginPhaseServer(x,y)
    end
end

-- function checkLoginKeyPressed(key)
--     if loginPhase == "login" then
--         checkLoginKeyPressedPhaseLogin(key)
--     elseif loginPhase == "creation" then
--         checkLoginKeyPressedPhaseCreation(key)
--     elseif loginPhase == "characters" then
--         checkLoginKeyPressedPhaseCharacters(key)
--     end
-- end

function checkLoginTextinput(key)
    if loginPhase == "login" then
        checkLoginTextinputPhaseLogin(key)
    elseif loginPhase == "creation" then
        checkLoginTextinputPhaseCreation(key)
    end
end