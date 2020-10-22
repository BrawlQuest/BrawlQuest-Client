--[[
    This file is for the character creation window
]]

local selectedSkinTone = 1

function drawCreationPhase() 
    loginImageX, loginImageY = math.floor(love.graphics.getWidth() / 2 - (loginEntryImage:getWidth() / 2)),
    math.floor(love.graphics.getHeight() / 2 - (loginEntryImage:getHeight() / 2))
    love.graphics.draw(blankPanelImage, loginImageX, loginImageY)

    love.graphics.setFont(headerBigFont)
    love.graphics.print("Character\nDetails", loginImageX+30, loginImageY+90)

    love.graphics.setFont(headerFont)
    love.graphics.print("Character Name", loginImageX+30, loginImageY+200)

    drawTextField(loginImageX+35,loginImageY+240,4)

    love.graphics.setFont(headerFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print("Skin Tone", loginImageX+30, loginImageY+290)

    love.graphics.draw(basePanelImage, loginImageX+35, loginImageY+320)
    
    for i,v in ipairs(baseCharacterImages) do
        love.graphics.draw(v, loginImageX+35+(i-1)*50 + 24, loginImageY+332)
        if selectedSkinTone == i then
            love.graphics.setColor(0.168,0.525,1)
            love.graphics.rectangle("line", loginImageX+35+(i-1)*50 + 25, loginImageY+330, 36, 36)
            love.graphics.setColor(1,1,1)
        elseif isMouseOver( loginImageX+35+(i-1)*50 + 25, loginImageY+330, 36, 36) then
            love.graphics.setColor(0.168,0.525,1,0.6)
            love.graphics.rectangle("line", loginImageX+35+(i-1)*50 + 25, loginImageY+330, 36, 36)
            love.graphics.setColor(1,1,1)
        end
    end

    -- button
    local thisX, thisY = loginImageX+38, loginImageY+390
    if isMouseOver(thisX,thisY,buttonImage:getWidth(), buttonImage:getHeight()) then
        love.graphics.setColor(0.168,0.525,1)
    else
        love.graphics.setColor(1,1,1)
    end
    love.graphics.draw(buttonImage,thisX,thisY)

    if isMouseOver(thisX,thisY,buttonImage:getWidth(), buttonImage:getHeight()) then
        love.graphics.setColor(1,1,1)
    else
        love.graphics.setColor(0,0,0)
    end

    love.graphics.printf("CREATE",thisX,thisY+5,buttonImage:getWidth(),"center")
end

function checkClickLoginPhaseCreation(x,y)
    if isMouseOver(loginImageX+30,loginImageY+240,textFieldImage:getWidth(),textFieldImage:getHeight()) then
        editingField = 4
    end

    for i,v in ipairs(baseCharacterImages) do
        if isMouseOver( loginImageX+35+(i-1)*50 + 25, loginImageY+330, 36, 36) then
           selectedSkinTone = i
        end
    end

    if isMouseOver(loginImageX+38, loginImageY+390,buttonImage:getWidth(), buttonImage:getHeight()) then
        r, h = http.request {
            url = api.url.."/user/"..UID.."/"..textfields[4],
            method = "POST",
            headers = {
                ['token'] = token
            },
        }

        print(h)
        if h == 200 then
            login()
        end
    end
end

function checkLoginKeyPressedPhaseCreation(key)
    if key == "backspace" then
        textfields[4] = string.sub(textfields[4], 1, string.len(textfields[4]) - 1)
    end
end

function checkLoginTextinputPhaseCreation(key)
    textfields[4] = textfields[4] .. key
end

function drawTextField(x, y, i) -- i is the editing field ID
    love.graphics.draw(textFieldImage, x, y)
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(textFont)
    if isMouseOver(x,  y, 288, 44) then
        love.graphics.setColor(0.6, 0.6, 0.6)
    end

    if editingField == i then
        love.graphics.printf(textfields[i] .. "|", x+10,y+6, 262, "center")
    else
        love.graphics.printf(textfields[i], x+10, y+6, 262, "center")
    end
    love.graphics.setColor(0, 0, 0)

    if isMouseOver(x, y, 288, 44) then
        love.graphics.setColor(0.6, 0.6, 0.6)
    end
end