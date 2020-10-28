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
"" -- character name (used on creation)
}

characters = {}

loginPhase = "login" -- login / character / creation

editingField = 1

function initLogin()
    loginEntryImage = love.graphics.newImage("assets/ui/login/login.png")
    charactersEntryImage = love.graphics.newImage("assets/ui/login/characterbackground.png")
    charactersButtonImage = love.graphics.newImage("assets/ui/login/characterwidget.png")
    blankPanelImage = love.graphics.newImage("assets/ui/login/emptylogin.png")
    buttonImage = love.graphics.newImage("assets/ui/login/button.png")
    textFieldImage = love.graphics.newImage("assets/ui/login/textbox.png")
    basePanelImage = love.graphics.newImage("assets/ui/login/character base panel.png")
    
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

    love.graphics.setFont(smallTextFont)
    love.graphics.print("BrawlQuest " .. version ..
    "\nFresh Play LTD 2016-2020\n\nGraphics by David E. Gervais\nMusic by Joseph Pearce\n\nMade with LÖVE", 10, 10)
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

function checkLoginKeyPressed(key)
    if loginPhase == "login" then
        checkLoginKeyPressedPhaseLogin(key)
    elseif loginPhase == "creation" then
        checkLoginKeyPressedPhaseCreation(key)
    elseif loginPhase == "characters" then
        checkLoginKeyPressedPhaseCharacters(key)
    
    end
end

function checkLoginTextinput(key)
    if loginPhase == "login" then
        checkLoginTextinputPhaseLogin(key)
    elseif loginPhase == "creation" then
        checkLoginTextinputPhaseCreation(key)
    end
end