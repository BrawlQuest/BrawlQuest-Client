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
        "Created By" ,
        "Thomas Lock & Danjoe Stubbs",
        "Original music by JoeyFunWithMusic\nAdditional music by Eric Matyas (Some Dreamy Place, Ocean Game Title, Left Behind, Dreamlands, Their Sacred Place)",
        "",
        "Graphics by David E. Gervais,used here under a CC license. pousse.rapiere.free.fr/tome/",
        "",
        "Special thanks to ThinkSometimes for the Minty sprite",
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
    lightningSfx = love.audio.newSource("assets/sfx/weather/lightning_b.ogg", "static")
    lightningSfx:setVolume(0.5)
    initLoginBackground()
    loadingAmount = 0
    loadingText = "Connecting to Servers "
    loginAttempts = 1
    circleAmount = 0
    loadingDots = "\n"
    dotTick = 0
    dotAmount = 0
end

function drawLogin()
    if loginPhase == "prelaunch" then   
        local imageScale = 0.4 * (1 / launch.inCERP)
        local width, height = love.graphics.getWidth(), love.graphics.getHeight()
        local iwidth, iheight = launch.logo:getWidth() * imageScale, launch.logo:getHeight() * imageScale
        love.graphics.setColor(1,1,1,1)
        drawLoginBackground()
        love.graphics.setColor(1,1,1,launch.outCERP)
        love.graphics.draw(bqLogo, (love.graphics.getWidth() / 2) - ((bqLogo:getWidth() * logoScale) * 0.5), (love.graphics.getHeight() / 2) - ((bqLogo:getHeight() * logoScale) * 0.5) - 100, 0, logoScale)
        love.graphics.printf(loadingText .. loadingDots, chatFont, 0, love.graphics.getHeight() * 0.5 + 70, love.graphics.getWidth() / 1, "center", 0, 1)
        for i, v in ipairs(loginText) do
            love.graphics.print(v, playerNameFont, 10, 10 + ((playerNameFont:getHeight() + 2) * (i-1)), 0, 1)
        end
        love.graphics.setColor(launch.inCERP, launch.inCERP, launch.inCERP, 1 - launch.outCERP)
        love.graphics.rectangle("fill", 0, 0, width, height)
        love.graphics.setColor(1 - launch.inCERP, 1 - launch.inCERP, 1 - launch.inCERP, launch.inCERP - launch.outCERP)
        love.graphics.draw(launch.logo, width * 0.5 - iwidth * 0.5, height * 0.5 - iheight * 0.5 - 200 * imageScale, 0, imageScale)
        love.graphics.print("LUVEN INTERACTIVE", launch.font, width * 0.5 - (launch.font:getWidth("LUVEN INTERACTIVE") * imageScale) * 0.5, height * 0.5 + 300 * imageScale, 0, imageScale)
    elseif loginPhase == "dev" then
        love.graphics.setColor(1,1,1,1)
        drawLoginBackground()
        love.graphics.draw(bqLogo, (love.graphics.getWidth() / 2) - ((bqLogo:getWidth() * logoScale) * 0.5), (love.graphics.getHeight() / 2) - ((bqLogo:getHeight() * logoScale) * 0.5) - 100, 0, logoScale)
        love.graphics.printf("Welcome to Dev Mode!\nPress LEFT or \"A\" to Login with Steam ID\nPress RIGHT or \"D\" to Login with anything else\nOtherwise you can quick login like before\n" .. loadingDots, chatFont, 0, love.graphics.getHeight() * 0.5 + 70, love.graphics.getWidth() / 1, "center", 0, 1)
    else
        drawLoginBackground()
        if loginPhase == "login" then
            drawLoginPhase(launch.outCERP)
            -- drawAreaName()
        elseif loginPhase == "loading" then
            love.graphics.setColor(1,1,1,launch.outCERP)
            love.graphics.draw(bqLogo, (love.graphics.getWidth() / 2) - ((bqLogo:getWidth() * logoScale) * 0.5), (love.graphics.getHeight() / 2) - ((bqLogo:getHeight() * logoScale) * 0.5) - 100, 0, logoScale)
            love.graphics.printf(loadingText .. loadingDots, chatFont, 0, love.graphics.getHeight() * 0.5 + 70, love.graphics.getWidth() / 1, "center", 0, 1)
        elseif loginPhase == "characters" then
            drawCharacterSelection()
        elseif loginPhase == "creation" then
            drawCreationPhase()
        elseif loginPhase == "server" then
            drawServerPhase()
        end

        love.graphics.setColor(1,1,1)
        for i, v in ipairs(loginText) do
            love.graphics.print(v, playerNameFont, 10, 10 + ((playerNameFont:getHeight() + 2) * (i-1)), 0, 1)
        end
        drawAreaName()
    end
end

function updateLogin(dt)
    if loginPhase == "prelaunch" then
        if launch.inAmount < 1 then
            launch.inAmount = launch.inAmount + 0.22 * dt
            if launch.inAmount > 1 then
                birds:setLooping(true)
                birds:setVolume(0.1 * sfxVolume)
                birds:play()
                launch.inAmount = 1
            end
            launch.inCERP = cerp(0, 1, launch.inAmount)
        elseif launch.outAmount < 1 then
            launch.outAmount = launch.outAmount + 0.8 * dt
            if launch.outAmount > 1 then
                loginPhase = "loading"
                loginViaSteam()
            end
            launch.outCERP = cerp(0,1,launch.outAmount)
        end
    elseif loginPhase == "loading" then
        loadingAmount = loadingAmount + 0.2 * dt
        if loadingAmount >= 1 then
            loginAttempts = loginAttempts + 1
            loadingText = "Login Failed: Attempt: " .. loginAttempts .. "\n Check Your Internet Connection\n Reattempting Login "
            loginViaSteam()
            loadingAmount = 0
        end
    elseif loginPhase == "characters" then
        updateCharacterSelection(dt)
    end
    updateLoginBackground(dt)
    updateEvents(dt)

    dotTick = dotTick + 2.5 * dt
    if dotTick >= 1 then
        dotTick = 0
        dotAmount = dotAmount + 1
        loadingDots = loadingDots .. "."
        if dotAmount > 3 then
            dotAmount = 0
            loadingDots = "\n"
        end
    end
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

function checkLoginTextInput(key)
    if loginPhase == "login" and key ~= " " then
        checkLoginTextinputPhaseLogin(key)
    elseif loginPhase == "characters" then
        checkCharacterSelectorKeyInput(key)
    elseif loginPhase == "creation" then
        checkLoginTextinputPhaseCreation(key)
    end
end

function loginViaSteam(skipDev)
    if skipDev or (versionType ~= "dev" and love.system.getOS() ~= "Linux")  then
        local originalID = steam.user.getSteamID()
        local str = tostring(originalID)
        print("Logging in as "..str)
        if str ~= "nil" then
            textfields[1] = str
            textfields[2] = str
            textfields[3] = str
            login()
        else
            print("Can't connect to server")
            loginPhase = "login"
        end
    else
        loginPhase = "dev"
    end
end