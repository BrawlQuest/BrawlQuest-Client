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

    -- fonts
    textFont = love.graphics.newFont("assets/ui/fonts/rainyhearts.ttf", 24)

    smallTextFont = love.graphics.newFont("assets/ui/fonts/rainyhearts.ttf", 12)
    playerNameFont = love.graphics.newFont("assets/ui/fonts/rainyhearts.ttf", 8)
    headerSmallFont = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 16)
    headerTinyFont = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 6)
    headerFont = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 18) -- TODO: get a license for this font
    headerMediumFont = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 28)
    headerBigFont = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 32) -- TODO: get a license for this font
    font = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 18)
   
    chatFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 24)

    npcChatFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 12)

    -- scrolling
    posYInventory, velyInventory, posYChat, velyChat = 0, 0, 0, 0
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


    -- toolbar
    circleFont = love.graphics.newFont("assets/ui/fonts/rainyhearts.ttf", 16)
    smallTextFont = love.graphics.newFont("assets/ui/fonts/rainyhearts.ttf",12)
    a0sword = love.graphics.newImage("assets/player/gear/a0/sword.png")
    toolbarY = 0
    toolbarItems = {a0sword, a0sword}
    toolbarTitles = {1,2,3,4,5,6,7,8,9,0}

    

    toolbarBg = love.graphics.newImage("assets/ui/hud/toolbar/toolbar-backing.png")
    toolbarItem = love.graphics.newImage("assets/ui/hud/toolbar/toolbarItem.png")
    top_left = love.graphics.newQuad(0, 0, 34, 34, a0sword:getDimensions())
    -- inventory = love.graphics.newImage("assets/ui/hud/inventory/inventoryBg.png")

    

    -- Inventory
    inventorySubHeaderFont = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 10)
    inventoryItemBackground = love.graphics.newImage("assets/ui/hud/inventory/inventoryItem.png")

    userInventory = {}
    userInventory[1] = {}
    userInventory[2] = {}
    userInventory[3] = {}
    userInventory[4] = {}
    userInventory[5] = {}
    userInventory[6] = {}
    userInventory[7] = {}
    inventoryFieldLength = {0, 0, 0, 0, 0, 0, 0,}

    userInventoryFieldHeight = {}

    scrollInventory = {up = true, down = true,}

    -- Profile

	level = love.graphics.newImage("assets/ui/hud/profile/Level.png")
	profileBars = love.graphics.newImage("assets/ui/hud/profile/bars.png")
    profileBackground = love.graphics.newImage("assets/ui/hud/profile/profile-backing.png")
    ShieldImg = love.graphics.newImage("assets/player/gen/shield false.png")
    profileImgStencil = love.graphics.newQuad(12, 0, 16, 16, playerImg:getDimensions())
    ShieldImgStencil = love.graphics.newQuad(12, 0, 16, 16, ShieldImg:getDimensions())

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

end

function updateHUD( dt )
    
    velyInventory = velyInventory - velyInventory * math.min( dt * 15, 1 )

    posYChat = posYChat + velyChat * dt
    velyChat = velyChat - velyChat * math.min( dt * 15, 1 )

    if posYChat < 0 then
        posYChat = 0
    end

    updateTooltip(dt)
    updateFloats(dt)
    updateSliders()
    updateSFX()
    updateToolBarInventory(dt)
    updateCharacterHub(dt)

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

	-- if isMouseOver(0, toolbarY*scale, inventory:getWidth()*scale, inventory:getHeight()*scale) then
    --     inventoryOpacity = inventoryOpacity + 3*dt
    --     if inventoryOpacity > 1 then inventoryOpacity = 1 end
    -- else
    --     inventoryOpacity = inventoryOpacity - 3*dt
    --     if inventoryOpacity < 0 then inventoryOpacity = 0 end
    -- end
end

function drawHUD()
    love.graphics.push() -- chat and quests scaling TODO: Quests
        local i = 0.5
        love.graphics.scale(scale*i)
        drawChatPanel(uiX/i, uiY/i)
        -- drawQuestPanel(uiX/i, 0)
    love.graphics.pop()

    love.graphics.push() -- chat and quests scaling TODO: Quests
        local i = 0.75
        love.graphics.scale(scale*i)
        -- drawBattlebar((uiX/2)/i, uiY/i)
        drawQuestPopUp((uiX/2)/i, (uiY/2)/i)
        
    love.graphics.pop()

    love.graphics.push()
        local i = 1
        love.graphics.scale(scale)
        --drawToolbar(0, uiY - hubImages.profileBG:getHeight() - 523)
        -- drawProfile(uiX/i, uiY/i)
        
        if showNPCChatBackground then drawNPCChatBackground((uiX/2)/i - 128, (uiY/2)/i - 128) end
        drawCharacterHub(0, uiY/i)
        drawToolBarInventory(0, uiY/i)
        drawTooltip()
    love.graphics.pop()

    -- love.graphics.setColor(1,1,1,0.5*inventory.opacity)
    -- love.graphics.rectangle("fill", (0) * scale, (0 + 50) * scale, 313 * scale, (uiY - 97 - 50 - 50) * scale)
    -- love.graphics.rectangle("fill", (0) * scale, (0 + 50) * scale, 313 * scale, (0 + getFullUserInventoryFieldHeight()) * scale)
    -- love.graphics.setColor(1,1,1,1)

    drawSettingsPanel(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
end 

