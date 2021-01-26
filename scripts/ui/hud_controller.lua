require "scripts.ui.components.tooltip"
require "scripts.ui.components.floats"

isEnteringText = false
UITextFields = {
    "", -- search
    "", -- chat
}

function initHUD()
    --scaling
    scale = 1
    velyWorldScale = 0
    posYWorldScale = 1
    worldScales = {8, 4, 3, 2, 1,}
    worldEditScales = {8, 4, 3, 2, 1, 0.5, 0.25, 0.125}
    selectedWorldScale = 4
    previousWorldScale = 4
    worldScaleAmount = 1
    worldScaleSmooting = false

    -- fonts
    textFont = love.graphics.newFont("assets/ui/fonts/rainyhearts.ttf", 24)

    smallTextFont = love.graphics.newFont("assets/ui/fonts/rainyhearts.ttf", 12)
    playerNameFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 8)
    npcNameFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 8)
    headerSmallFont = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 16)
    headerTinyFont = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 6)
    headerFont = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 18) -- TODO: get a license for this font
    headerMediumFont = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 28)
    headerBigFont = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 32) -- TODO: get a license for this font
    font = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 18)
   
    chatFont = love.graphics.newFont("assets/ui/fonts/C&C Red Alert [INET].ttf", 26)

    npcChatFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 16)

    -- scrolling
    posYInventory, velyInventory, posYChat, velyChat, posYQuest, velYQuest = 0, 0, 0, 0, 0, 0
    uiX, uiY = love.graphics.getWidth()/scale, love.graphics.getHeight()/scale -- scaling options

    -- mouse
	love.mouse.setVisible(false) -- make default mouse invisible
    mouseImg = love.graphics.newImage("assets/ui/mouse.png") -- load in a custom mouse image
    
    -- chatbox
    initChat()
    chatCursor = {
        on = true,
        speed = 40,
        i = 0,
    }

    -- Profile

	level = love.graphics.newImage("assets/ui/hud/profile/Level.png")
	profileBars = love.graphics.newImage("assets/ui/hud/profile/bars.png")
    profileBackground = love.graphics.newImage("assets/ui/hud/profile/profile-backing.png")
    ShieldImg = love.graphics.newImage("assets/player/gen/shield false.png")
    profileImgStencil = love.graphics.newQuad(12, 0, 16, 16, playerImg:getDimensions())
    ShieldImgStencil = love.graphics.newQuad(12, 0, 16, 16, ShieldImg:getDimensions())
    profileCount = 0

    -- Perks
    
    perksBg = love.graphics.newImage("assets/ui/hud/perks/perksBg.png")
    mouseDown = love.graphics.newImage("assets/ui/hud/perks/BQ Mice - 1.png")
    mouseUp = love.graphics.newImage("assets/ui/hud/perks/BQ Mice + 1.png")
    perksReserve = love.graphics.newImage("assets/ui/hud/perks/cp-backing.png")

    selectedPerk = 0

    perkImages = {
        love.graphics.newImage("assets/ui/hud/perks/perkType3.png"),
        love.graphics.newImage("assets/ui/hud/perks/perkType2.png"),
        love.graphics.newImage("assets/ui/hud/perks/perkType1.png")
    }

    perks = {
        total = 10,
        reserve = 10,
        0,
        0,
        0,
    }
    perkTitles = {
        "STR", "INT", "STA",
    }

    -- Battlebar
    battlebarBackground = love.graphics.newImage("assets/ui/hud/battlebar/battlebarBg.png")
    battlebarItemBg = love.graphics.newImage("assets/ui/hud/battlebar/battlebarItem.png")

    -- Quest Panel
    questWidth = 600
    questHeight = 0
    questSmallBoxTrue = love.graphics.newImage("assets/ui/hud/quests/xTrue.png")
    questSmallBoxFalse = love.graphics.newImage("assets/ui/hud/quests/xFalse.png")
    buttonBacking = love.graphics.newImage("assets/ui/hud/quests/ButtonBacking.png")
    buttonOutline = love.graphics.newImage("assets/ui/hud/quests/ButtonOutline.png")

    selectedQuest = {npcName = "Mortus", npcDialogue = "I have a quest for you", title = "The long and winding road", 
    "Create a new passport", 
    "Have lots of fun, it really is fun, like I have all the fun in the world",
    "Make a lot of money",
    "Have a great time!"}

    questPopUpWidth = 335
    questPopUpHeight = 496
    questPopUpPanelGap = 400

    initCharacterHub() 
    initToolBarInventory()
    initQuestHub()
    initNPCChat()
    initCrafting()
    initNewWorldEdit()
end

function updateHUD( dt )
    velyInventory = velyInventory - velyInventory * math.min( dt * 15, 1 )
    velyChat = velyChat - velyChat * math.min( dt * 15, 1 )

    if worldScaleSmooting then        
        worldScaleAmount = worldScaleAmount + 4 * dt
        if worldScaleAmount > 1 then 
            worldScaleAmount = 1 
            worldScaleSmooting = false
        end
    end

    if worldEdit.open then
        if difference(worldScale, worldEditScales[selectedWorldScale]) > 0 then
            worldScale = cerp(previousWorldScale, worldEditScales[selectedWorldScale], worldScaleAmount)
        end
    else
        if selectedWorldScale > #worldScales then selectedWorldScale = #worldScales end
        if difference(worldScale, worldScales[selectedWorldScale]) > 0 then
            worldScale = cerp(previousWorldScale, worldScales[selectedWorldScale], worldScaleAmount)
        end
    end

    if (getFullChatHeight() + cerp(10, 115, questHub.amount)) * scale > uiY then -- take into account spacing from the bottom
        posYChat = posYChat + velyChat * dt
        if posYChat < 0 then
            posYChat = 0
        -- elseif posYChat > uiY - getFullChatHeight() then
        --     posYChat = uiY - getFullChatHeight()
        end
    else posYChat = 0
    end

    updateTooltip(dt)
    updateFloats(dt)
    updateSliders()
    updateSFX()
    updateToolBarInventory(dt)
    updateCharacterHub(dt)
    updateQuestHub(dt)
    updateCrafting(dt)
    updateNewWorldEdit(dt)

    if isSettingsWindowOpen then
        updateSettingsPanel(dt)
    elseif settPan.opacity > 0 then
        settPan.opacity = settPan.opacity - settPan.opacitySpeed * dt
        if settPan.opacity <= 0 then settPan.opacity = 0 end
    end

    settPan.opacityCERP = cerp(0,1,settPan.opacity)

    if chatCursor.i < chatCursor.speed then
        chatCursor.i = chatCursor.i + 1
    else
        if chatCursor.on then
            chatCursor.on = false
        else
            chatCursor.on = true
        end
        chatCursor.i = 0
    end
end

function drawHUD()
    love.graphics.push()
        local i = 1
        love.graphics.scale(scale)
        if showNPCChatBackground then drawNPCChatBackground((uiX/2)/i - 128, (uiY/2)/i - 128) end
        if crafting.open then drawCrafting() end
        drawCharacterHub(0, uiY/i)
        drawToolBarInventory(0, uiY/i)
        drawQuestHub(uiX/i, uiY/i)
        if questsPanel.open then drawQuestsPanel((uiX/i) - 313, (uiY/i) + cerp(-14, 0 - ((uiY/1.25) - 15), questsPanel.amount)) end
        drawTooltip()
        drawAuraHeadings()
       
    love.graphics.pop()

    love.graphics.push() -- chat and quests scaling TODO: Quests
        local i = 0.5
        love.graphics.scale(scale*i)
        if showChat then
            drawChatPanel(uiX/i, (uiY - cerp(cerp(0, 100, questHub.amount), ((uiY/1.25)-15), questsPanel.amount)) / i)
        end
        drawZoneTitle()
    love.graphics.pop()

    love.graphics.setColor(1,1,1,1)
    
    -- drawSettingsPanel(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    if settPan.opacity > 0 then drawSettingsPanel() end
    
end 

function drawTextBelowPlayer(text)
    love.graphics.setFont(smallTextFont)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill",love.graphics.getWidth()/2-smallTextFont:getWidth(text)/2,love.graphics.getHeight()/2+38,smallTextFont:getWidth(text),smallTextFont:getHeight())
    love.graphics.setColor(1,1,1)
    love.graphics.print(text,love.graphics.getWidth()/2-smallTextFont:getWidth(text)/2,love.graphics.getHeight()/2+38)
end