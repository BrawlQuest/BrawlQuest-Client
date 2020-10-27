function initHUD()
    --scaling
    scale, uiX, uiY = 1

    -- scrolling
	posyInventory = 0
    velyInventory = 0 -- The scroll velocity

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
	profileImgBox = love.graphics.newImage("assets/ui/hud/profile/Profile.png")
	profileBars = love.graphics.newImage("assets/ui/hud/profile/bars.png")
    profileBgnd = love.graphics.newImage("assets/ui/hud/profile/profile-backing.png")

    -- Battlebar
    battlebarBgnd = love.graphics.newImage("assets/ui/hud/battlebar/battlebarBg.png")
    battlebarItemBg = love.graphics.newImage("assets/ui/hud/battlebar/battlebarItem.png")
end

function updateHUD( dt )
    uiX = love.graphics.getWidth()/scale -- scaling options
    uiY = love.graphics.getHeight()/scale
    posyInventory = posyInventory + velyInventory * dt
    velyInventory = velyInventory - velyInventory * math.min( dt * 15, 1 )
    if posyInventory < 1 then
        posyInventory = 0
    elseif posyInventory > 500 then
        posyInventory = 500
    end
end

function love.wheelmoved( dx, dy )
    if isMouseOver(0, toolbary*scale, inventory:getWidth()*scale, inventory:getHeight()*scale) then
        velyInventory = velyInventory + dy * 16
    end
end