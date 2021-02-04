function initCharacterSelection()
    bqLogo = love.graphics.newImage("assets/logo.png")
     
    cs = { -- character selection
        colors = {"RED", "GREEN", "BLUE",},
        colorI = {{1,0,0,}, {0,1,0,}, {0,0,1,},},
        slider = {
            newSlider(400, 300, 300, 0.5, 0, 1, function (v) end),
            newSlider(400, 300, 300, 0.5, 0, 1, function (v) end),
            newSlider(400, 300, 300, 0.5, 0, 1, function (v) end),
        },
        overName = false,
        overExit = true,
        isTyping = false,
        nameText = "",
        selectableI = 0,
        selectedCharacter = 0,
        dualAmount = 0,
        dualCERP = 0,
        font = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 16),
        w = 350, -- width
        h = 450, -- height
        s = 10, -- spacing
        p = 28, -- padding
        ch = 84 -- content height
    }
    cs.cw = cs.w - cs.p * 2 -- content width
end

function updateCharaterSelection(dt)
    -- print(json:encode_pretty(characters))
    if cs.selectedCharacter > 0 then
        panelMovement(dt, cs, 1, "dualAmount", 2)
    else
        panelMovement(dt, cs, -1, "dualAmount", 2)
    end
    cs.dualCERP = cerp(0, 1, cs.dualAmount)

    for i, v in ipairs(cs.slider) do
        v:update()
    end
end

function drawCharacterSelection()
    cs.selectableI = 0
    cs.overName = false
    love.graphics.setFont(cs.font)

    local x, y = love.graphics.getWidth() * 0.5 - cerp(0, cs.w * 0.5, cs.dualAmount), love.graphics.getHeight() * 0.5 + 20
    love.graphics.setColor(0,0,0,0.7)
    roundRectangle("fill", x - cs.w * 0.5, y - cs.h * 0.5, cs.w * cerp(1, 2, cs.dualAmount), cs.h, 25)

    if cs.selectedCharacter > 0 then
        drawCharacterCreator()
    end

    love.graphics.setColor(1,1,1)
    local scale = 4.1
    love.graphics.draw(bqLogo, x - (bqLogo:getWidth() * 0.5) * scale, y - cs.h * 0.5 + 20 - (bqLogo:getHeight() * 0.5) * scale, 0, scale)

    local thisX, thisY = x - cs.w * 0.5 + cs.p, y - cs.h * 0.5 + cs.p + 120

    for i,v in ipairs(characters) do
        drawCharacterSelector(thisX, thisY, i, v.Name)
    end
    if #characters < 3 then drawCharacterSelector(thisX, thisY, math.clamp(1,#characters,3), "NEW CHARACTER") end
end



function drawCharacterCreator() 
    love.graphics.setColor(1,1,1, cs.dualCERP)
    local v = characters[cs.selectedCharacter]
    local x, y = math.floor(love.graphics.getWidth() * 0.5), math.floor(love.graphics.getHeight() * 0.5 + 20)
    local thisX, thisY = x + cs.p, y - cs.h * 0.5 + cs.p
    love.graphics.line(x, y - cs.h * 0.5 + 20, x, y + cs.h * 0.5 - 20)
    love.graphics.print("CHARACTER NAME", thisX + 5, thisY)

    if cs.isTyping then 
        love.graphics.setColor(1,1,1,cs.dualCERP)
    elseif isMouseOver(thisX, thisY + 25, cs.cw, cs.font:getHeight() + cs.s * 2) then
        love.graphics.setColor(43 / 255, 134 / 255, cs.dualCERP)
        cs.overName = true
    else
        love.graphics.setColor(0,0,0,0.5 * cs.dualCERP)
    end

    roundRectangle("fill", thisX, thisY + 25, cs.cw, cs.font:getHeight() + cs.s * 2, 10)

    local text = ""
    if cs.isTyping then 
        love.graphics.setColor(0,0,0, cs.dualCERP)
        text = cs.nameText
    else
        love.graphics.setColor(1,1,1, cs.dualCERP)
        text = v.Name
    end
    love.graphics.print(text, thisX + cs.s, thisY + 25 + cs.s + 2)

    love.graphics.setColor(1,1,1,cs.dualCERP)
    love.graphics.print("CHARACER COLOUR", thisX + 5, thisY + 80)
    love.graphics.setColor(0,0,0,0.5 * cs.dualCERP)
    local w, h = cs.cw * 0.5, 105  -- cs.p * 0.5
    thisX, thisY =  thisX, thisY + h
    roundRectangle("fill", thisX, thisY, 100, 100, 10)
    thisX, thisY =  thisX + 100 + cs.p * 0.5, thisY
    roundRectangle("fill", thisX, thisY, cs.cw - 100 - cs.p * 0.5, 100, 10)

    love.graphics.setColor(v.Color[1], v.Color[2], v.Color[3], cs.dualCERP)
    roundRectangle("fill", thisX + cs.s, thisY + cs.s, cs.cw - 100 - cs.p * 0.5 - cs.s * 2, 100 - cs.s * 2, 5)
    love.graphics.draw(playerImg, x + cs.p + 12, thisY + 18, 0, 2)

    love.graphics.setColor(1 - v.Color[1], 1 - v.Color[2], 1 - v.Color[3], cs.dualCERP)
    text = math.floor(v.Color[1] * 255) .. ", " .. math.floor(v.Color[2] * 255) .. ", " .. math.floor(v.Color[3] * 255)
    love.graphics.printf(text, thisX + cs.s, thisY + cs.s + 40 - cs.font:getHeight() * 0.5, cs.cw - 100 - cs.p * 0.5 - cs.s * 2, "center")

    w, h = cs.cw, 120
    thisX, thisY = x + cs.p, y + cs.h * 0.5 - cs.p - 50 - cs.s - h
    love.graphics.setColor(0,0,0,0.5 * cs.dualCERP)
    roundRectangle("fill", thisX, thisY, w, h, 10)
    love.graphics.setColor(1,1,1,cs.dualCERP)

    thisX, thisY = thisX + cs.s + 4, thisY + cs.s + 4
    for i,color in ipairs(cs.colors) do
        -- love.graphics.setColor(unpack(cs.colorI[i]))
        love.graphics.print(color, thisX, thisY)
        cs.slider[i]:draw()
        thisY = thisY + 38
    end

    w, h = cs.cw, 50
    thisX, thisY = x + cs.p, y + cs.h * 0.5 - cs.p - h

    local isMouse = isMouseOver(thisX, thisY, w, h)
    if isMouse then
        love.graphics.setColor(43 / 255, 134 / 255, cs.dualCERP)
        cs.overExit = true
    else 
        love.graphics.setColor(1,1,1, cs.dualCERP)
        cs.overExit = false
    end

    roundRectangle("fill", thisX, thisY, cs.cw, h, 10)
    if isMouse then
        love.graphics.setColor(1,1,1, cs.dualCERP)
    else love.graphics.setColor(0,0,0, cs.dualCERP)
    end

    love.graphics.printf("ENTER WORLD", thisX + cs.s, thisY + 25 - cs.font:getHeight() * 0.5, cs.cw - cs.s * 2, "center")
end

function drawCharacterSelector(x, y, i, text)

    local addHeight = (cs.ch + cs.s) * (i - 1)
    local isMouse = isMouseOver(x, y + addHeight, cs.cw, cs.ch)

    if i == cs.selectedCharacter then
        love.graphics.setColor(1,1,1, 1)
    elseif isMouse then
        love.graphics.setColor(43 / 255, 134 / 255, 1)
        cs.selectableI = i
    else love.graphics.setColor(0,0,0,0.5) end

    roundRectangle("fill", x, y + addHeight, cs.cw, cs.ch, 10)

    if characters[i] ~= null then
        drawProfilePic(x + cs.s + 2, y + cs.s + addHeight, 1, "right", characters[i])
    end

    if i == cs.selectedCharacter then love.graphics.setColor(0,0,0)
    else love.graphics.setColor(1,1,1) end
    love.graphics.print(text, x + 64 + cs.s * 2, y + cs.ch * 0.5 - cs.font:getHeight() * 0.5 + addHeight)
end

function checkCharacterSelectorMousePressed()
    if cs.selectedCharacter > 0 then
        if cs.overName then
            cs.isTyping = true
        end
        if cs.overExit then
            print("I want to exit")
            transitionToPhaseGame() 
        end
    end

    if cs.selectableI > 0 then
        cs.isTyping = false
        cs.selectedCharacter = cs.selectableI
        local v = {}
        local style = {track = "line", knob = "rectangle", width = 18,}
        local x = 775 + cs.cw * 0.56
        local width = cs.cw - 110

        if characters[cs.selectedCharacter] and characters[cs.selectedCharacter].Name ~= null then
            v = characters[cs.selectedCharacter]
            cs.nameText = v.Name 
            for i, slider in ipairs(cs.slider) do
                cs.slider[i] = newSlider(x, 476 + 5 + 38 * (i - 1), width, v.Color[i], 0.2, 1, function (sv) v.Color[i] = sv end, style)
            end
        else
            characters[cs.selectedCharacter] = {}
            -- v = characters[cs.selectedCharacter]
            -- TODO: add a way of creating a new character with the api
            cs.nameText = ""
            -- v.Color = {}
            -- for i, slider in ipairs(cs.slider) do
            --     cs.slider[i] = newSlider(x, 476 + 5 + 38 * (i - 1), width, v.Color[i], 0.2, 1, function (sv) v.Color[i] = sv end, style)
            -- end
        end
        
    end
end

function checkCharacterSelectorKeyPressed(key)
    if cs.isTyping == true then
        if key == "backspace" then
            cs.nameText = string.sub(cs.nameText, 1, string.len(cs.nameText) - 1)
        end
        if key == "return" then
            cs.isTyping = false
            -- TODO: add a way of changing the name on the fly with the api
        end
    else
        if key == "return" then
            if characters[cs.selectedCharacter] ~= null then
                print("True")
                transitionToPhaseGame() 
            end
        end
    end
end

function checkCharacterSelectorKeyInput(key)
    cs.nameText = cs.nameText .. key
end