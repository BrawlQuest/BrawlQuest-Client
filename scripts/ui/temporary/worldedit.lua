--[[
    This is a temporary file used for modifying the world.
    It should be removed before release!
]]

thisTile = {
    GroundTile = "assets/world/grounds/Grass.png",
    ForegroundTile = "assets/world/objects/Mushroom.png",
    Name = "Spooky Forest",
    Music = "*",
    Collision = true,
    Enemy = ""
}

worldFiles = {}

pendingWorldChanges = {}

isWorldEditWindowOpen = false

function initEditWorld() 
    local files = recursiveEnumerate("assets/world", {})
    print(#files)
    for k, file in ipairs(files) do
        worldFiles[#worldFiles+1] = file
         worldImg[file] = love.graphics.newImage(file)
        print(k .. ". ".. file)
    end
end

function drawEditWorldWindow()
    loginImageX, loginImageY = math.floor(love.graphics.getWidth() / 2 - (loginEntryImage:getWidth() / 2)),
    math.floor(love.graphics.getHeight() / 2 - (loginEntryImage:getHeight() / 2))
    love.graphics.draw(blankPanelImage, loginImageX, loginImageY)

    love.graphics.setFont(headerBigFont)
    love.graphics.print("Edit\nWorld", loginImageX+30, loginImageY+90)

    love.graphics.setFont(headerFont)
    love.graphics.print("Images", loginImageX+30, loginImageY+200)

   -- drawTextField(loginImageX+35,loginImageY+240,5)
    for i,v in ipairs(worldFiles) do
        love.graphics.draw(worldImg[v], loginImageX+35 + (i*32), loginImageY+240)
    end
    love.graphics.setColor(1,1,1)
    drawTextField(loginImageX+35,loginImageY+280,6)
    
    love.graphics.setColor(1,1,1)
    love.graphics.print("Name", loginImageX+30, loginImageY+310)
    drawTextField(loginImageX+35,loginImageY+330,7)
    love.graphics.setColor(1,1,1)
    love.graphics.print("Enemy", loginImageX+30, loginImageY+360)
    drawTextField(loginImageX+35,loginImageY+380,8)
    if thisTile.Collision == true then
        drawButton("TURN COLLISION OFF", loginImageX+35,loginImageY+430)
    else
        drawButton("TURN COLLISION ON", loginImageX+35,loginImageY+430)
    end
end

function checkEditWorldTextinput(key)
    textfields[editingField] = textfields[editingField] .. key
end

function checkEditWorldKeyPressed(key)
    if key == "backspace" then
        textfields[editingField] = string.sub(textfields[editingField], 1, string.len(textfields[editingField]) - 1)
    elseif key == "tab" or key == "return" then
        editingField = editingField + 1
    end
end

function checkEditWorldClick(x,y)
    if isMouseOver(loginImageX+35,loginImageY+240,288,44) then
        editingField = 5
    elseif isMouseOver(loginImageX+35,loginImageY+280,288,44) then
        editingField = 6
    elseif isMouseOver(loginImageX+35,loginImageY+330, 288, 44) then
        editingField = 7
    elseif isMouseOver(loginImageX+35,loginImageY+380, 288, 44) then
        editingField = 8
    elseif isMouseOver(loginImageX+35,loginImageY+430,288,44) then
        if thisTile.Collision then
            thisTile.Collision = false
        else
            thisTile.Collision = true
        end
    end
end