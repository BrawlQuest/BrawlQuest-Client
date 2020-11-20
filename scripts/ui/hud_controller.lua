require "scripts.ui.components.tooltip"
require "scripts.ui.components.floats"

isEnteringText = false
UITextFields = {
    "", -- search
    "", -- chat
}

function initHUD()
    --scaling
    scale, uiX, uiY = 1

    -- fonts
    textFont = love.graphics.newFont("assets/ui/fonts/rainyhearts.ttf", 24)

    smallTextFont = love.graphics.newFont("assets/ui/fonts/rainyhearts.ttf", 12)
    headerFont = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 18) -- TODO: get a license for this font
    headerMediumFont = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 28)
    headerBigFont = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 32) -- TODO: get a license for this font
    font = headerFont

    -- scrolling
	posyInventory, velyInventory, posyChat, velyChat = 0, 0, 0, 0

    -- mouse
	love.mouse.setVisible(false) -- make default mouse invisible
    mouseImg = love.graphics.newImage("assets/ui/mouse.png") -- load in a custom mouse image
    
    -- chatbox
    profilePic = love.graphics.newImage("assets/ui/hud/chat/profile.png")
	chatCorner = love.graphics.newImage("assets/ui/hud/chat/corner.png")
	chatHeight = 0
	playerName = "Danjoe"
	chatWidth = 200
	chatSpacing = 14

	messages = {}
	messages[1] = {username = "Danjoe", text = "Hello there you lovely people who keep me company at night just for the fun of it"}
	messages[2] = {username = "Anyone", text = "Heyyyyyyyy, Red is sus Red is sus Red is sus Red is sus Red is sus Red is sus, he's being super weird right now, so... please be kind to him"}
	messages[3] = {username = "Lord Squabulus", text = "I love a lot of thisd stuff"}
	messages[4] = {username = "Boyo", text = "I just wanna have a good time"}
    messages[5] = {username = "Danjoe", text = "I love sd stuff that has real love to\n\n\n\n\nit"}

    enteredChatText = "Hello there my dude! You've got the skills I'm looking for!"

    -- toolbar
    circleFont = love.graphics.newFont("assets/ui/fonts/rainyhearts.ttf", 16)
    smallTextFont = love.graphics.newFont("assets/ui/fonts/rainyhearts.ttf",12)

    a0sword = love.graphics.newImage("assets/player/gear/a0/sword.png")
    a1sword = love.graphics.newImage("assets/player/gear/a1/sword.png")
    a2sword = love.graphics.newImage("assets/player/gear/a2/sword.png")
    a3sword = love.graphics.newImage("assets/player/gear/a3/sword.png")
    a4sword = love.graphics.newImage("assets/player/gear/a4/sword.png")

    a0axe = love.graphics.newImage("assets/player/gear/a0/axe.png")
    a1axe = love.graphics.newImage("assets/player/gear/a1/axe.png")
    a2axe = love.graphics.newImage("assets/player/gear/a2/axe.png")
    a3axe = love.graphics.newImage("assets/player/gear/a3/axe.png")
    a4axe = love.graphics.newImage("assets/player/gear/a4/axe.png")

    toolbarBg = love.graphics.newImage("assets/ui/hud/toolbar/toolbar-backing.png")
    toolbarItem = love.graphics.newImage("assets/ui/hud/toolbar/toolbarItem.png")
    top_left = love.graphics.newQuad(0, 0, 34, 34, a0sword:getDimensions())
    inventory = love.graphics.newImage("assets/ui/hud/inventory/inventoryBg.png")

    -- Profile and Perks
    perks = love.graphics.newImage("assets/ui/hud/perks/LeftUI.png")
	level = love.graphics.newImage("assets/ui/hud/profile/Level.png")
	profileBars = love.graphics.newImage("assets/ui/hud/profile/bars.png")
    profileBgnd = love.graphics.newImage("assets/ui/hud/profile/profile-backing.png")
    sheildImg = love.graphics.newImage("assets/player/gen/sheild false.png")
    profileImgStensil = love.graphics.newQuad(12, 0, 16, 16, playerImg:getDimensions())
    sheildImgStensil = love.graphics.newQuad(12, 0, 16, 16, sheildImg:getDimensions())

    -- Battlebar
    battlebarBgnd = love.graphics.newImage("assets/ui/hud/battlebar/battlebarBg.png")
    battlebarItemBg = love.graphics.newImage("assets/ui/hud/battlebar/battlebarItem.png")

    -- Inventory
    inventorySubHeaderFont = love.graphics.newFont("assets/ui/fonts/retro_computer_personal_use.ttf", 10)
    loadInventory()

    -- Quest Pannel
    questWidth = 350
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
    uiX = love.graphics.getWidth()/scale -- scaling options
    uiY = love.graphics.getHeight()/scale
    
    velyInventory = velyInventory - velyInventory * math.min( dt * 15, 1 )

    posyChat = posyChat + velyChat * dt
    velyChat = velyChat - velyChat * math.min( dt * 15, 1 )

    if posyInventory <= (getFullUserInventoryFieldHeight()*-1)+483 then
      --  posyInventory = (getFullUserInventoryFieldHeight()*-1)+483
        velyInventory = 0
    elseif posyInventory > 0 then
        posyInventory = 0
        velyInventory = 0
    else
        posyInventory = posyInventory + velyInventory * dt
    end

    if posyChat < 0 then
        posyChat = 0
    end

    updateTooltip(dt)
    updateFloats(dt)
end

function drawHUD()
    
    love.graphics.push() -- chat and quests scaling TODO: Quests
        local i = 0.5
        love.graphics.scale(scale*i)
        drawChatPanel(uiX/i, uiY/i)
        drawQuestPannel(uiX/i, 0)
    love.graphics.pop()

    love.graphics.push() -- chat and quests scaling TODO: Quests
        local i = 0.75
        love.graphics.scale(scale*i)
        drawBattlebar((uiX/2)/i, uiY/i)
        drawQuestPopUp((uiX/2)/i, (uiY/2)/i)
    love.graphics.pop()

    love.graphics.push()
        local i = 1
        love.graphics.scale(scale)
        drawToolbar()
        drawProfile(uiX/i, uiY/i)
    love.graphics.pop()

    drawTooltip()
end 

function love.wheelmoved( dx, dy )
    if isMouseOver(0, toolbary*scale, inventory:getWidth()*scale, inventory:getHeight()*scale) then
       velyInventory = velyInventory + dy * 512
    else 
        velyChat = velyChat + dy * 512
    end
end
