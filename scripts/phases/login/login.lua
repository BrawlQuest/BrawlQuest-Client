--[[
    This file is for managing login.
]]
require 'scripts.phases.login.background'
require 'scripts.phases.login.phases.login'
require 'scripts.phases.login.phases.characters'
require 'scripts.phases.login.phases.creation'
require 'scripts.phases.login.phases.server'
require 'scripts.phases.login.phases.character-selection'

textfields = {"", -- username
"", -- password
"", -- clean password (hidden)
"", -- character name (used on creation)
"assets/world/grounds/grass.png", -- background tile (world edit)
"assets/world/grounds/Mountain.png", -- foreground tile (world edit)
"Spooky Forest", -- locale name (world edit)
"" -- enemy name (world edit)
}

launch = {
    logo = love.graphics.newImage("assets/ui/login/new-login/Luven Logo.png"),
    font = love.graphics.newFont("assets/ui/fonts/AmaticSC-Regular.ttf", 400),
    inAmount = 0,
    inCERP = 0,
    outAmount = 0,
    outCERP = 0,
}

characters = {}

loginPhase = "prelaunch" -- login / character / creation

editingField = 1

function initLogin()

    initCharacterSelection()

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
    if loginPhase == "prelaunch" then   
        local imageScale = 0.4 * (1 / launch.inCERP)
        local width, height = love.graphics.getWidth(), love.graphics.getHeight()
        local iwidth, iheight = launch.logo:getWidth() * imageScale, launch.logo:getHeight() * imageScale
        love.graphics.setColor(1,1,1,1)
        drawLoginBackground()
        drawLoginPhase(launch.outCERP)
        love.graphics.setColor(launch.inCERP, launch.inCERP, launch.inCERP, 1 - launch.outCERP)
        love.graphics.rectangle("fill", 0, 0, width, height)
        love.graphics.setColor(1 - launch.inCERP, 1 - launch.inCERP, 1 - launch.inCERP, launch.inCERP - launch.outCERP)
        love.graphics.draw(launch.logo, width * 0.5 - iwidth * 0.5, height * 0.5 - iheight * 0.5 - 200 * imageScale, 0, imageScale)
        love.graphics.print("LUVEN INTERACTIVE", launch.font, width * 0.5 - (launch.font:getWidth("LUVEN INTERACTIVE") * imageScale) * 0.5, height * 0.5 + 300 * imageScale, 0, imageScale)
    else
        drawLoginBackground()
        if loginPhase == "login" then
            drawLoginPhase(launch.outCERP)
        elseif loginPhase == "characters" then
            drawCharacterSelection()
            -- drawCharactersPhase()
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
end

function updateLogin(dt)
    if loginPhase == "prelaunch" then
        if launch.inAmount < 1 then
            launch.inAmount = launch.inAmount + 0.22 * dt
            if launch.inAmount > 1 then
                birds:setLooping(true)
                love.audio.play(birds)
                -- love.audio.play(titleMusic)
                launch.inAmount = 1
            end
            launch.inCERP = cerp(0, 1, launch.inAmount)
        elseif launch.outAmount < 1 then
            launch.outAmount = launch.outAmount + 0.8 * dt
            -- titleMusic:setVolume(musicVolume * launch.outAmount)
            if launch.outAmount > 1 then
                loginPhase = "login"
            end
            launch.outCERP = cerp(0,1,launch.outAmount)
        end
    elseif loginPhase == "characters" then
        updateCharacterSelection(dt)
    end
    updateLoginBackground(dt)
end

function checkClickLogin(x, y)
    if loginPhase == "login" then
        checkClickLoginPhaseLogin(x,y)
    elseif loginPhase == "characters" then
        -- checkClickLoginPhaseCharacter(x,y)
    elseif loginPhase == "creation" then
        checkClickLoginPhaseCreation(x,y)
    elseif loginPhase == "server" then
        checkClickLoginPhaseServer(x,y)
    end
end

function checkLoginTextinput(key)
    if loginPhase == "login" then
        checkLoginTextinputPhaseLogin(key)
    elseif loginPhase == "characters" then
        checkCharacterSelectorKeyInput(key)
    elseif loginPhase == "creation" then
        checkLoginTextinputPhaseCreation(key)
    end
end