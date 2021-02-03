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

local launchColor, launchColorcerp = 0, 0
local count, countCerp = 0, 0
local luvenImage = love.graphics.newImage("assets/ui/login/new-login/Luven Logo.png")
local luvenFont = love.graphics.newFont("assets/ui/fonts/AmaticSC-Regular.ttf", 400)

characters = {}

loginPhase = "prelaunch" -- login / character / creation

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
    
    if loginPhase == "prelaunch" then   
        local imageScale = 0.4 * (1 / launchColorcerp)
        local width, height = love.graphics.getWidth(), love.graphics.getHeight()
        local iwidth, iheight = luvenImage:getWidth() * imageScale, luvenImage:getHeight() * imageScale
        love.graphics.setColor(1,1,1,1)
        drawLoginBackground()
        drawLoginPhase(countCerp)
        love.graphics.setColor(launchColorcerp, launchColorcerp, launchColorcerp, 1 - countCerp)
        love.graphics.rectangle("fill", 0, 0, width, height)
        love.graphics.setColor(1 - launchColorcerp, 1 - launchColorcerp, 1 - launchColorcerp, launchColorcerp - countCerp)
        love.graphics.draw(luvenImage, width * 0.5 - iwidth * 0.5, height * 0.5 - iheight * 0.5 - 200 * imageScale, 0, imageScale)
        love.graphics.print("LUVEN INTERACTIVE", luvenFont, width * 0.5 - (luvenFont:getWidth("LUVEN INTERACTIVE") * imageScale) * 0.5, height * 0.5 + 300 * imageScale, 0, imageScale)
    else
        drawLoginBackground()
        if loginPhase == "login" then
            drawLoginPhase(countCerp)
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
end


function updateLogin(dt)
    if loginPhase == "prelaunch" then
        if launchColor < 1 then
            launchColor = launchColor + 0.22 * dt
            if launchColor > 1 then 
                birds:setLooping(true)
                love.audio.play(birds)
                launchColor = 1
                countable = true
            end
            launchColorcerp = cerp(0, 1, launchColor)
        elseif count < 1 then
            count = count + 0.5 * dt
            if count > 1 then
                loginPhase = "login"
            end
            countCerp = cerp(0,1,count)
        end
    end
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

function checkLoginTextinput(key)
    if loginPhase == "login" then
        checkLoginTextinputPhaseLogin(key)
    elseif loginPhase == "creation" then
        checkLoginTextinputPhaseCreation(key)
    end
end