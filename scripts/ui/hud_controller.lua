require "scripts.ui.components.tooltip"
require "scripts.ui.components.floats"

isEnteringText = false
UITextFields = {
    "", -- search
    "", -- chat
}

function initHUD()
    --scaling
    uiX, uiY = 1
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

    -- scrolling
    posYInventory, velyInventory, posYChat, velyChat = 0, 0, 0, 0
    uiX = love.graphics.getWidth()/scale -- scaling options
    uiY = love.graphics.getHeight()/scale

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

    toolbarItems = {}

    a0sword = love.graphics.newImage("assets/player/gear/a0/sword.png")

    toolbarBg = love.graphics.newImage("assets/ui/hud/toolbar/toolbar-backing.png")
    toolbarItem = love.graphics.newImage("assets/ui/hud/toolbar/toolbarItem.png")
    top_left = love.graphics.newQuad(0, 0, 34, 34, a0sword:getDimensions())
    inventory = love.graphics.newImage("assets/ui/hud/inventory/inventoryBg.png")

    

    -- Inventory
    inventorySubHeaderFont = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 10)
    inventoryItemBackground = love.graphics.newImage("assets/ui/hud/inventory/inventoryItem.png")

    inventoryFields = {"weapons", "spells", "armour", "mounts", "other"}
    inventoryFieldLength = {0, 0, 0, 0, 0}
    userInventory = {}
    userInventory[1] = {}
    userInventory[2] = {}
    userInventory[3] = {}
    userInventory[4] = {}
    userInventory[5] = {}
    loadInventory()

    userInventoryFieldHeight = {}

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
        0
    }
    perkTitles = {
        "strength", "intelligence", "defense"
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

end

function updateHUD( dt )
    
    velyInventory = velyInventory - velyInventory * math.min( dt * 15, 1 )

    posYChat = posYChat + velyChat * dt
    velyChat = velyChat - velyChat * math.min( dt * 15, 1 )

    -- if posYInventory <= (getFullUserInventoryFieldHeight()*-1)+483 then
    --   --  posYInventory = (getFullUserInventoryFieldHeight()*-1)+483
    --     velyInventory = 0
    -- elseif posYInventory > 0 then
    --     posYInventory = 0
    --     velyInventory = 0
    -- else
        posYInventory = posYInventory + velyInventory * dt
    -- end

    if posYChat < 0 then
        posYChat = 0
    end

    updateTooltip(dt)
    updateFloats(dt)
    updateSliders()
    updateSFX()

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
        drawToolbar()
        drawProfile(uiX/i, uiY/i)
        drawTooltip()
    love.graphics.pop()

    if showNPCChatBackground then
        love.graphics.push()
        love.graphics.scale(scale)
            w,h = love.graphics.getDimensions()
            w = (w/scale)/2
            h = (h/scale)/2
            drawNPCChatBackground(w - (128/scale/2),h - (128/scale/2))
        love.graphics.pop()
    end  

    drawSettingsPanel(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
end 

function love.wheelmoved( dx, dy )
    if isMouseOver(0, toolbarY*scale, inventory:getWidth()*scale, inventory:getHeight()*scale) then
       velyInventory = velyInventory + dy * 512
    else 
        velyChat = velyChat + dy * 512
    end
end
