--[[
    This is a temporary file used for modifying the world.
    It should be removed before release!
]]

thisTile = {
    GroundTile = "assets/world/grounds/Grass.png",
    ForegroundTile = "assets/world/objects/Mushroom.png",
    Name = "Spooky Forest",
    Music = "*",
    Collision = false,
    Enemy = ""
}

worldFiles = {}

pendingWorldChanges = {}

isWorldEditWindowOpen = false

function initEditWorld() 
    local files = recursiveEnumerate("assets/world", {})
    print(#files)
    for k, file in ipairs(files) do
        if string.find(file, "Store", 1) == nil then
            worldFiles[#worldFiles+1] = file
            -- print(k .. ". ".. file)
            worldImg[file] = love.graphics.newImage(file)
        end
    end
end

function drawEditWorldWindow()
    loginImageX, loginImageY = math.floor(love.graphics.getWidth() / 2 - (loginEntryImage:getWidth() / 2)),
    math.floor(love.graphics.getHeight() / 2 - (loginEntryImage:getHeight() / 2))
    love.graphics.draw(blankPanelImage, loginImageX, loginImageY)

    love.graphics.setFont(headerBigFont)
    love.graphics.print("Edit\nWorld", loginImageX+30, loginImageY+90)
   -- drawTextField(loginImageX+35,loginImageY+240,5)
    
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", 0, 0, 20 * (32+4) + 40, 4 * (32+4) + 40)
    love.graphics.setColor(1,1,1,1)

    love.graphics.scale(1)
    local x = 10
    local y = 10
    for i,v in ipairs(worldFiles) do
        if string.sub(v,1,25) ~= "assets/world/objects/Wall" then

            
            if textfields[6] == v then
                love.graphics.rectangle("fill",x,y,32,32)
            end

            if textfields[5] == v then
                love.graphics.setColor(1,0,0)
                love.graphics.rectangle("line",x,y,32,32)
                love.graphics.setColor(1,1,1)
            end
            love.graphics.draw(worldImg[v], x, y)
            x = x + 32 + 5
            if x > love.graphics.getHeight() then
                y = y + 32 + 5
                x = 10
            end
        end
    end 


    -- love.graphics.setColor(1,1,1)
    -- drawTextField(loginImageX+35,loginImageY+280,6)
    love.graphics.setFont(headerFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print("Name", loginImageX+30, loginImageY+180)
    drawTextField(loginImageX+35,loginImageY+210,7)
    love.graphics.setColor(1,1,1)
    love.graphics.print("Enemy", loginImageX+30, loginImageY+250)
    drawTextField(loginImageX+35,loginImageY+280,8)
    if thisTile.Collision == true then
        love.graphics.setColor(1,0,0,1)
        love.graphics.rectangle("fill", loginImageX+100, loginImageY+375, 100, 100)
        drawButton("ON COLLISIONS ARE ON", loginImageX+35,loginImageY+320)
    else
        love.graphics.setColor(0,1,0,1)
        love.graphics.rectangle("fill", loginImageX+100, loginImageY+375, 100, 100)
        drawButton("OFF COLLISIONS ARE OFF", loginImageX+35,loginImageY+320)
    end
    love.graphics.setColor(1,1,1,1)
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
    local tx = 0
    local ty = 0
    for i,v in ipairs(worldFiles) do
        if isMouseOver(tx,ty,32,32) then
            if love.mouse.isDown(1) then
                textfields[6] = v
            elseif love.mouse.isDown(2) then
                textfields[5] = v
            end
        end
        tx = tx + 32
        if tx > love.graphics.getHeight() then
            ty = ty + 32
            tx = 0
        end
    end 
    if isMouseOver(loginImageX+35,loginImageY+240,288,44) then
        editingField = 7
    elseif isMouseOver(loginImageX+35,loginImageY+280, 288, 44) then
        editingField = 8
    elseif isMouseOver(loginImageX+35,loginImageY+320,288,44) then
        if thisTile.Collision then
            thisTile.Collision = false
        else
            thisTile.Collision = true
        end
    end
end