function initCharacterSelection()
    bqLogo = love.graphics.newImage("assets/logo.png")
     
    crtSel = { -- character selection
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
    crtSel.cw = crtSel.w - crtSel.p * 2 -- content width
end

function updateCharaterSelection(dt)
    -- print(json:encode_pretty(characters))
    if crtSel.selectedCharacter > 0 then
        panelMovement(dt, crtSel, 1, "dualAmount", 2)
    else
        panelMovement(dt, crtSel, -1, "dualAmount", 2)
    end
    crtSel.dualCERP = cerp(0, 1, crtSel.dualAmount)
end

function drawCharacterSelection()
    crtSel.selectableI = 0
    love.graphics.setFont(crtSel.font)



    local x, y = love.graphics.getWidth() * 0.5 - cerp(0, crtSel.w * 0.5, crtSel.dualAmount), love.graphics.getHeight() * 0.5 + 20
    love.graphics.setColor(0,0,0,0.7)
    roundRectangle("fill", x - crtSel.w * 0.5, y - crtSel.h * 0.5, crtSel.w * cerp(1, 2, crtSel.dualAmount), crtSel.h, 25)

    if crtSel.selectedCharacter > 0 then
        love.graphics.setColor(1,1,1, crtSel.dualCERP)
        local x, y = love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5 + 20
        local thisX, thisY = x + crtSel.p, y - crtSel.h * 0.5 + crtSel.p
        -- love.graphics.rectangle("fill", thisX, thisY, 100, 100)
        love.graphics.print("Character Name", thisX, thisY, 0, 2)

        love.graphics.setColor(0,0,0,0.5 * crtSel.dualCERP)
        roundRectangle("fill", thisX, thisY + 30, crtSel.cw, 50, 10)
    end

    love.graphics.setColor(1,1,1)
    local scale = 4
    love.graphics.draw(bqLogo, x - (bqLogo:getWidth() * 0.5) * scale, y - crtSel.h * 0.5 + 20 - (bqLogo:getHeight() * 0.5) * scale, 0, scale)

    local thisX, thisY = x - crtSel.w * 0.5 + crtSel.p, y - crtSel.h * 0.5 + crtSel.p + 120

    for i,v in ipairs(characters) do
        drawCharacterSelector(thisX, thisY, i, v.Name)
    end
    if #characters < 3 then drawCharacterSelector(thisX, thisY, #characters, "NEW CHARACTER") end

    if crtSel.selectedCharacter > 0  then
        love.graphics.setColor(1,1,1, crtSel.dualCERP)
        love.graphics.line(x * 1.5, y - crtSel.h * 0.5 + 20, x * 1.5, y + crtSel.h * 0.5 - 20) 
        love.graphics.rectangle("fill", x * 1.5 - 1, y - crtSel.h * 0.5 + 20, 2, crtSel.h - 20)
    end
end

function drawCharacterSelector(x, y, i, text)

    local addHeight = (crtSel.ch + crtSel.s) * (i - 1)
    local isMouse = isMouseOver(x, y + addHeight, crtSel.cw, crtSel.ch)

    if i == crtSel.selectedCharacter then
        love.graphics.setColor(1,1,1, 1)
    elseif isMouse then
        love.graphics.setColor(43 / 255, 134 / 255, 1)
        crtSel.selectableI = i
    else love.graphics.setColor(0,0,0,0.5) end

    roundRectangle("fill", x, y + addHeight, crtSel.cw, crtSel.ch, 10)

    if characters[i] ~= null then
        drawProfilePic(x + crtSel.s + 2, y + crtSel.s + addHeight, 1, "right", characters[i])
    end    
    
    -- if isMouse then love.graphics.setColor(1,1,1)
    -- else love.graphics.setColor(0,0,0)end

    
    if i == crtSel.selectedCharacter then love.graphics.setColor(0,0,0)
    else love.graphics.setColor(1,1,1) end

    love.graphics.print(text, x + 64 + crtSel.s * 2, y + crtSel.ch * 0.5 - crtSel.font:getHeight() * 0.5 + addHeight)
end

function checkCharacterSelectorMousePressed()
    if crtSel.selectableI > 0 then
        crtSel.selectedCharacter = crtSel.selectableI
    end
end