function initCharacterSelection()
    bqLogo = love.graphics.newImage("assets/logo.png")
     
    cs = { -- character selection
        initialCharacter = {Name = "", Color = {love.math.random() ,love.math.random() ,love.math.random() }},
        colors = {"RED", "GREEN", "BLUE",},
        colorI = {{1,0,0,1}, {0,1,0,1}, {0,0,1,1},},
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

function updateCharacterSelection(dt)
    -- print(json:encode_pretty(characters))
    if cs.selectedCharacter > 0 then
        panelMovement(dt, cs, 1, "dualAmount", 3)
    else
        panelMovement(dt, cs, -1, "dualAmount", 3)
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

    love.graphics.setColor(1,1,1)
    local scale = 4.1
    love.graphics.draw(bqLogo, x - (bqLogo:getWidth() * 0.5) * scale, y - cs.h * 0.5 + 20 - (bqLogo:getHeight() * 0.5) * scale, 0, scale)

    love.graphics.stencil(drawCharacterSelectionStencil, "replace", 1) -- stencils inventory
    love.graphics.setStencilTest("greater", 0) -- push

        if cs.selectedCharacter > 0 then
            drawCharacterCreator()
        end
        local thisX, thisY = x - cs.w * 0.5 + cs.p, y - cs.h * 0.5 + cs.p + 120
        for i,v in ipairs(characters) do
            drawCharacterSelector(thisX, thisY, i, v.Name)
        end
        if #characters < 3 then drawCharacterSelector(thisX, thisY, math.clamp(1, #characters + 1,3), "NEW CHARACTER") end

    love.graphics.setStencilTest() -- pop
end

function drawCharacterCreator() 
    love.graphics.setColor(1,1,1, cs.dualCERP)
    local v = characters[cs.selectedCharacter] or cs.initialCharacter
    -- print(json:encode_pretty(v))
    local x, y = math.floor(love.graphics.getWidth() * 0.5), math.floor(love.graphics.getHeight() * 0.5 + 20)
    local thisX, thisY = x + cs.p, y - cs.h * 0.5 + cs.p
    love.graphics.line(x, y - cs.h * 0.5 + 20, x, y + cs.h * 0.5 - 20)
    love.graphics.print("CHARACTER NAME", thisX + 5, thisY)

    if cs.isTyping then 
        love.graphics.setColor(1,1,1,cs.dualCERP)
    elseif isMouseOver(thisX, thisY + 25, cs.cw, cs.font:getHeight() + cs.s * 2) and not characters[cs.selectedCharacter].Name then
        love.graphics.setColor(43 / 255, 134 / 255, cs.dualCERP)
        cs.overName = true
    else
        love.graphics.setColor(0,0,0,0.5 * cs.dualCERP)
    end

    roundRectangle("fill", thisX, thisY + 25, cs.cw, cs.font:getHeight() + cs.s * 2, 10)

    local text = ""
    if cs.isTyping then 
        love.graphics.setColor(0,0,0, cs.dualCERP)
        text = cs.nameText .. "|"
    else
        love.graphics.setColor(1,1,1, cs.dualCERP)
        text = cs.nameText
    end
    love.graphics.print(text, thisX + cs.s, thisY + 25 + cs.s + 2)

    love.graphics.setColor(1,1,1,cs.dualCERP)
    love.graphics.print("CHARACTER COLOUR", thisX + 5, thisY + 80)
    love.graphics.setColor(0,0,0,0.5 * cs.dualCERP)
    local w, h = cs.cw * 0.5, 105  -- cs.p * 0.5
    thisX, thisY =  thisX, thisY + h
    roundRectangle("fill", thisX, thisY, 100, 100, 10)
    thisX, thisY =  thisX + 100 + cs.p * 0.5, thisY
    roundRectangle("fill", thisX, thisY, cs.cw - 100 - cs.p * 0.5, 100, 10)

    love.graphics.setColor(v.Color[1], v.Color[2], v.Color[3], cs.dualCERP)
    roundRectangle("fill", thisX + cs.s, thisY + cs.s, cs.cw - 100 - cs.p * 0.5 - cs.s * 2, 100 - cs.s * 2, 5)
    love.graphics.setColor(1,1,1,cs.dualCERP)
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

    if characters[cs.selectedCharacter] and characters[cs.selectedCharacter].Name ~= null then
        text = "ENTER WORLD"
    else
        text = "CREATE CHARACTER"
    end
    love.graphics.printf(text, thisX + cs.s, thisY + 25 - cs.font:getHeight() * 0.5, cs.cw - cs.s * 2, "center")
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

function getSelectedCharacter()
    cs.isTyping = false
    local v = {}
    local style = {track = "line", knob = "rectangle", width = 18,}
    -- local x = 775 + cs.cw * 0.56
    local width = cs.cw - 110
    local w, h = cs.cw, 120

    local x = math.floor(love.graphics.getWidth() * 0.5) + cs.p + cs.s + 4 + cs.cw * 0.56
    local y = math.floor(love.graphics.getHeight() * 0.5 + 20) + cs.h * 0.5 - cs.p - 50 - cs.s - h + cs.s + 4

    if characters[cs.selectedCharacter] and characters[cs.selectedCharacter].Name ~= null then
        v = characters[cs.selectedCharacter]
        cs.nameText = v.Name 
        for i, slider in ipairs(cs.slider) do
            cs.slider[i] = newSlider(x, y + 5 + 38 * (i - 1), width, v.Color[i], 0.2, 1, function (sv) v.Color[i] = sv end, style)
        end
    else -- if a character is not in the current position
        v = cs.initialCharacter
        cs.isTyping = true
        -- TODO: add a way of creating a new character with the api
        cs.nameText = ""
        for i, slider in ipairs(cs.slider) do
            cs.slider[i] = newSlider(x, y + 5 + 38 * (i - 1), width, v.Color[i], 0.2, 1, function (sv) v.Color[i] = sv end, style)
        end
    end
end

function checkCharacterSelectorMousePressed()
    if cs.selectedCharacter > 0 then
        if cs.overName then
            cs.isTyping = true
        end
        if cs.overExit then
            loginOrCreate()
        end
    end
    if cs.selectableI > 0 then
        cs.selectedCharacter = cs.selectableI
        getSelectedCharacter()
    end
end

function loginOrCreate()
    if characters[cs.selectedCharacter] and characters[cs.selectedCharacter].Name then
        transitionToPhaseGame()
    else
        if cs.nameText ~= "" then
            characters[cs.selectedCharacter] = {}
            characters[cs.selectedCharacter].Name = cs.nameText
            characters[cs.selectedCharacter].Color = copy(cs.initialCharacter.Color)
            r, h = http.request {
                url = api.url.."/user/"..UID.."/".. characters[cs.selectedCharacter].Name,
                method = "POST",
                headers = {
                    ['token'] = token
                },
            }
            transitionToPhaseGame()
        end
    end
end

function checkCharacterSelectorKeyPressed(key)
    if cs.isTyping == true then
        if key == "backspace" then
            cs.nameText = string.sub(cs.nameText, 1, string.len(cs.nameText) - 1)
        elseif key == "return" then
            cs.isTyping = false
        elseif key == "escape" and cs.selectedCharacter ~= 1 then
            cs.selectedCharacter = 1
            cs.isTyping = false
        end
    else
        
        if key == "up" then
            cs.selectedCharacter = math.clamp(1, cs.selectedCharacter - 1, 3)
            getSelectedCharacter()
        elseif key == "down" then
            cs.selectedCharacter = math.clamp(1, cs.selectedCharacter + 1, 3)
            getSelectedCharacter()
        end

        if key == "escape" then
            -- loginPhase = "login"
            -- textfields[1] = ""
            -- textfields[2] = ""
            -- textfields[3] = ""
            -- editingField = 1
            if cs.selectedCharacter > 0 then
                cs.selectedCharacter = 0
            else
                love.event.quit()          
            end 
        end

        if key == "return" then
            loginOrCreate()
        end
    end
end

function drawCharacterSelectionStencil()
    local x = love.graphics.getWidth() * 0.5 - cerp(0, cs.w * 0.5, cs.dualAmount) - cs.w * 0.5 + cs.p
    local y = love.graphics.getHeight() * 0.5 + 20 - cs.h * 0.5 + cs.p
    local w = cs.w * cerp(1, 2, cs.dualAmount) - cs.p * 2
    local h = cs.h  - cs.p * 2
    roundRectangle("fill", x, y, w, h, 10)
end

function checkCharacterSelectorKeyInput(key)
    if key ~= "return" and cs.isTyping then
        cs.nameText = cs.nameText .. key
    end
end

function transitionToPhaseGame()
    -- print(json:encode_pretty(characters[cs.selectedCharacter]))
    me.Color = copy(characters[cs.selectedCharacter].Color)
    username = characters[cs.selectedCharacter]["Name"]
    local b = {}
    c, h = http.request{url = api.url.."/players/"..username, method="GET", source=ltn12.source.string(body), headers={["token"]=token}, sink=ltn12.sink.table(b)}
    local response = json:decode(b[1])
    player.x = response['Me']['X']
    player.y = response['Me']['Y']
    player.dx = player.x*32
    player.dy = player.y*32
    player.cx = player.x*32
    player.cy = player.y*32
    totalCoverAlpha = 2
    local b = {}
    c, h = http.request{url = api.url.."/world", method="GET", source=ltn12.source.string(body), headers={["token"]=token}, sink=ltn12.sink.table(b)}
    world = json:decode(b[1])

    love.audio.play(awakeSfx)
    love.graphics.setBackgroundColor(0, 0, 0)
    phase = "game"
    love.audio.stop( titleMusic )

    createWorld()
    openTutorial(1)
    if musicVolume > 0 then
        checkMusic()
    end
end

