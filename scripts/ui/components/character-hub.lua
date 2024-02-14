function initCharacterHub()
    hubImages = {
        placeholder = love.graphics.newImage("assets/ui/hud/charater-hub/placeholder.png"),
        profileBG = love.graphics.newImage("assets/ui/hud/charater-hub/profile.png"),
        profileFG = love.graphics.newImage("assets/ui/hud/charater-hub/profile-fg.png"),

        statsBG = love.graphics.newImage("assets/ui/hud/charater-hub/stats.png"),
        statsFG = love.graphics.newImage("assets/ui/hud/charater-hub/stats-fg.png"),
        statCardBg = love.graphics.newImage("assets/ui/hud/charater-hub/stat-BG.png"),

        metersBG = love.graphics.newImage("assets/ui/hud/charater-hub/meters.png"),
        meterSide = love.graphics.newImage("assets/ui/hud/charater-hub/0.png"),
        meterIcons = {
            love.graphics.newImage("assets/ui/hud/charater-hub/1.png"),
            love.graphics.newImage("assets/ui/hud/charater-hub/2.png"),
            love.graphics.newImage("assets/ui/hud/charater-hub/3.png"),
        },
        meternames = {
            love.graphics.newImage("assets/ui/hud/charater-hub/HEALTH.png"),
            love.graphics.newImage("assets/ui/hud/charater-hub/MANA.png"),
            love.graphics.newImage("assets/ui/hud/charater-hub/XP.png"),
        },
    }

    showStatsPanel = false
    characterHub = {
        backgroundColor = {0,0,0,0.7},
        barColors = {{1,0,0,1}, {0,0.5,1,1}, {1,0.5,0,1}, },
        font = love.graphics.newFont("assets/ui/fonts/C&C Red Alert [INET].ttf", 13),
        nameFont = love.graphics.newFont("assets/ui/fonts/C&C Red Alert [INET].ttf", 13),
        forceOpen = false,
        amount = 0,
        flashy = 0,
        flashyCERP = 0,
        flash = false,
        selectedPerk = 0,
    }

    perks = {
        stats = {0,0,0,0},
        bonus = {0,0,0,},
        delay = 0,
        change = false,
        tick = 0,
        changeAmount = 0,
    }

    armourHub = {
        titles = {
            {name = "Head Armour", v = "headarmour"},
            {name = "Chest Armour", v = "chestarmour"},
            {name = "Leg Armour", v = "legarmour"},
        },
    }

    armourTypes = {"headarmour", "chestarmour", "legarmour",}
end

function updateCharacterHub(dt)
    if characterHub.forceOpen then
        panelMovement(dt, characterHub, 1)
    else
        if isMouseOver(0 * scale, (uiY - 97) * scale, 468 * scale, 97 * scale) then
            panelMovement(dt, characterHub, 1)
        else
            panelMovement(dt, characterHub, -1)
        end
    end
    if player.cp > 0 then
        local i = 0
        -- if inventory.open or inventory.forceOpen then i = 2 end
        characterHub.flashy = characterHub.flashy + 8 * dt
        if characterHub.flashy >= 2 then 
            characterHub.flashy = i 
            characterHub.flash = not characterHub.flash
        end
        characterHub.flashyCERP  = 0
    else
        characterHub.flashy = 0
        characterHub.flashyCERP = 0
    end

    if love.mouse.isDown(1) or love.mouse.isDown(2) and characterHub.selectedPerk > -1 then
        local dir
        if love.mouse.isDown(1) then dir = 1 else dir = -1 end
        if perks.delay < 1 then
            perks.delay = perks.delay + 4 * dt
            if perks.delay >= 1 then
                perks.change = true
            end
        end
        if perks.change == true then
            perks.tick = perks.tick + 20 * dt
            if perks.tick > 1 then
                perks.tick = 0
                if dir == 1 then
                    if player.cp - perks.changeAmount > 0 then
                        perks.changeAmount = perks.changeAmount + dir
                    end
                else
                    if me[perkTitles[characterHub.selectedPerk+1]] + perks.changeAmount > 1 then
                        perks.changeAmount = perks.changeAmount + dir
                    end
                end
            end
        end
    else
        perks.tick = 0
        perks.changeAmount = 0
        perks.delay = 0
        perks.change = false
    end
end

function drawCharacterHub(thisX, thisY)
    if me ~= nil and me.hp ~= nil and me.xp ~= nil then
        love.graphics.setFont(characterHub.font)
        thisX, thisY = thisX, thisY - hubImages.profileBG:getHeight()

        if characterHub.amount > 0 then drawArmourHub(thisX + 10, thisY - 50) end

        drawCharacterHubProfile(thisX, thisY)
        thisX = thisX + hubImages.profileBG:getWidth()
        if characterHub.amount ~= 0 then
            drawCharacterHubStats(thisX, thisY)
        end  
        thisX = thisX + cerp(0, hubImages.statsBG:getWidth(), characterHub.amount)
        drawCharacterHubMeters(thisX, thisY)
        thisX, thisY = thisX + 231 + 10, thisY + 97 - 10 - 60

        if player.cp > 0 then
            drawAvailablePointsPopup(thisX, thisY)
            thisY = thisY - 70
        end

        if me.weapon ~= null then drawBattlebarItem(thisX, thisY, itemImg[me.weapon.imgpath], "+"..me.weapon.val) end

        local defence = 0
        if me ~= null then
            if me.legarmourid ~= 0 and me.legarmour.val ~= "Error" then
                defence = defence + me.legarmour.val
            end

            if me.chestarmourid ~= 0 and me.chestarmour.val ~= "Error" then
                defence = defence + me.chestarmour.val
            end

            if me.headarmour ~= nil and me.headarmourid ~= 0 and me.headarmour.val ~= "Error" then
                defence = defence + me.headarmour.val
            end
        end
        thisX = thisX + 50
        drawBattlebarItem(thisX, thisY, "me", "+"..defence )
        if oldTargeting then
            thisX = thisX + 50
            drawBattlebarItem(thisX, thisY, "hold", "HOLD")
        end
        
    end
end

function drawAvailablePointsPopup(thisX, thisY)
    if characterHub.flash then
        love.graphics.setColor(1,0,0,1)
    else
        love.graphics.setColor(0,0,0,0.7)
    end
    love.graphics.rectangle("fill", thisX, thisY, 150, 60, 5)
    love.graphics.setColor(1,1,1)
    local text
    if player.cp > 1 then text = " Points Available" else text = " Point Available" end
    love.graphics.printf(player.cp .. text, thisX, thisY + 4, 150 / 2, "center", 0, 2)
end

function drawCharacterHubProfile(thisX, thisY)
    love.graphics.setColor(characterHub.flashyCERP,0,0,0.7)
    love.graphics.rectangle("fill", thisX, thisY, 82, 97)
    love.graphics.setColor(1,1,1,1)
    drawProfilePic(thisX + 9, thisY + 8, 1, "right")
    
    if player.cp > 0 then love.graphics.setColor(1,0,0,1) end
    love.graphics.draw(hubImages.profileFG, thisX, thisY)
    if isMouseOver(thisX, thisY, 82, 97) then
        setTooltip("Character Level", "Your level increases when you kill mobs or complete quests. Level up your player to access more items and to increase your character points.")
    end
    if player.cp > 0 then love.graphics.setColor(1,1,1,1) else love.graphics.setColor(0,0,0,1) end
    love.graphics.print(tostring(me.lvl), thisX + 56 - math.floor(characterHub.font:getWidth(tostring(me.lvl))/2), thisY + 84 - (characterHub.font:getHeight(tostring(me.lvl))/2))
end

function drawCharacterHubStats(thisX, thisY)
    love.graphics.setColor(characterHub.flashyCERP,0,0,0.7)
    love.graphics.rectangle("fill", thisX, thisY, cerp(0, 155, characterHub.amount), 97)
    love.graphics.setFont(characterHub.font)
    characterHub.selectedPerk = -1
    for i = 0, 2 do
        if isMouseOver((thisX + (49 * i) + 3) * scale, (thisY + 43) * scale, hubImages.statCardBg:getWidth() * scale, hubImages.statCardBg:getHeight() * scale) then
            love.graphics.setColor(1,0,0, cerp(0, 1, characterHub.amount))
            characterHub.selectedPerk = i
            setPerkTooltip(i + 1)
        else
            love.graphics.setColor(1,1,1,cerp(0, 0.7, characterHub.amount))
        end
        love.graphics.draw(hubImages.statCardBg, thisX + (49 * i) + 3, thisY + 43)
    end

    love.graphics.setColor(1,1,1,cerp(0, 1, characterHub.amount))
    love.graphics.draw(hubImages.statsFG, thisX, thisY)
    love.graphics.setColor(0,0,0, cerp(0, 1, characterHub.amount))
    love.graphics.print(perks.stats[4], thisX + 77 - (characterHub.font:getWidth(perks.stats[4])/2), thisY + 27 - (characterHub.font:getHeight(perks.stats[4])/2))
    
    for i = 0, 2 do
        local change = 0
        if characterHub.selectedPerk == i and isMouseDown() then
            change = perks.changeAmount
            perks.stats[i+1] = me[perkTitles[i+1]] + change
            perks.stats[4] = player.cp - change
        end
        local text = perks.stats[i+1]..perks.bonus[i+1]
        love.graphics.printf(text, thisX + (49 * i) + 13, thisY + 78, 36, "center")
    end
end

local enchTab = {
    STR = 1,
    INT = 2,
    STA = 3,
}

function tickCharacterHub()
    perks.bonus = {0,0,0,}
    for i,v in ipairs(armourTypes) do
        if me[v] and me[v].enchantment then
            local ench = explode(me[v].enchantment, ",")
            local tabI = enchTab[ench[1]]
            if tabI and ench[2] then perks.bonus[tabI] = perks.bonus[tabI] + ench[2] end
        end
        if me[v] and me[v].id ~= 0 and me[v].attributes then
            for j, k in ipairs(explode(me[v].attributes, ";")) do
                local atri = explode(me[v].attributes, ",")
                local tabI = enchTab[atri[1]]
                if tabI then perks.bonus[tabI] = perks.bonus[tabI] + atri[2] end
            end
        end
    end
    for i,v in ipairs(perks.bonus) do if v == 0 then perks.bonus[i] = "" else perks.bonus[i] = "+"..v end end
end

function drawCharacterHubMeters(thisX, thisY)
    love.graphics.setColor(characterHub.flashyCERP,0,0,0.7)
    roundRectangle("fill", thisX, thisY, 231, 97, cerp(0, 10, characterHub.amount), {false, true, false, false})
    love.graphics.setFont(characterHub.nameFont)
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(me.name, thisX + 6, thisY+4)
    thisX, thisY = thisX + 5, thisY + 25
    love.graphics.setFont(characterHub.font)
    local j = (100/151)
    local meterLevels = {math.clamp(0, me.hp, getMaxHealth()), me.mana, me.xp}
    local meterMaxes = {getMaxHealth(), 100, 100}
    for i = 0, 2 do
        local spacing = 23 * i
        love.graphics.setColor(unpack(characterHub.backgroundColor))
        love.graphics.rectangle("fill", thisX + 31, thisY + spacing, 151, 19)
        love.graphics.setColor(unpack(characterHub.barColors[i+1]))
        love.graphics.draw(hubImages.meterSide, thisX, thisY + spacing)
        love.graphics.draw(hubImages.meterSide, thisX + 212, thisY + 19 + spacing, math.rad(180))
       love.graphics.rectangle("fill", thisX + 31, thisY + spacing, calcProgressBar(meterLevels[i+1], meterMaxes[i+1], 151), 19)
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(hubImages.meterIcons[i+1], thisX, thisY + spacing)
        love.graphics.draw(hubImages.meternames[i+1], thisX, thisY + spacing)
        if (meterLevels[i+1] ~= nil) then
            love.graphics.print(math.floor(meterLevels[i+1]), thisX + 198 - (characterHub.font:getWidth(math.floor(meterLevels[i+1]))/2), thisY + spacing + 3)
        end
    end
end


function checkStatsMousePressed(button)
    if characterHub.selectedPerk > -1 then
        if button == 1 and player.cp > 0 then
            perks.changeAmount = perks.changeAmount + 1
        elseif button == 2 and me[perkTitles[characterHub.selectedPerk + 1]] > 1 then
            perks.changeAmount = perks.changeAmount - 1
        end
    end
end

function getMaxHealth()
    return me.maxhp or 115
end

function drawBattlebarItem(thisX, thisY, item, stats)
    love.graphics.setColor(0,0,0,0.8)
    local w = 40
    if item == "hold" then 
        w = 60
        if holdAttack then love.graphics.setColor(1,0,0,1) end
    end

    love.graphics.rectangle("fill", thisX, thisY, w, 60, 5)
    love.graphics.setColor(1,1,1)
    if item == "me" then
        love.graphics.setColor(1,1,1,1)
		-- if v.Color ~= null then love.graphics.setColor(unpack(me.Color)) end
		love.graphics.draw(playerImg, thisX + 4, thisY + 4)
		love.graphics.setColor(1,1,1,1)
        for i = #armourHub.titles, 1, -1 do
            local vb = armourHub.titles[i]
            if me and me[vb.v] then drawItemIfExists(me[vb.v].imgpath, thisX + 4, thisY + 4) end
        end
    elseif item == "hold" then
        love.graphics.print(boolToString(holdAttack), characterHub.nameFont, thisX+(w / 2)-(characterHub.nameFont:getWidth(stats)/2), thisY + 16)
    elseif item then
        love.graphics.draw(item, thisX + 4, thisY + 4)
    end

    love.graphics.print(stats, characterHub.nameFont, thisX+(w / 2)-(characterHub.nameFont:getWidth(stats)/2), thisY + 42)
    love.graphics.setFont(headerFont)
end

function drawArmourHub(thisX, thisY)
    local w, h = 300, 180
    local imageScale = 6
    local alpha = cerp(0,1,characterHub.amount)
    thisX, thisY = thisX - cerp(w + 20, 0, characterHub.amount), thisY - h

    love.graphics.setColor(0,0,0,0.8 * alpha)
    love.graphics.rectangle("fill", thisX, thisY, w, h, 5)

    local x, y = thisX - 10, thisY + 30

    x, y = thisX + 10, thisY + 10
    love.graphics.setColor(1,1,1, alpha)
    love.graphics.print("Armour Stats", x, y, 0, 2)
    y = y + 30
    local bw, bh = w - 20, 36

    for i, vb in ipairs(armourHub.titles) do
        love.graphics.rectangle("fill", x, y, bh, bh, 5)
        if me and me[vb.v] then -- draw armour pieces
            drawItemIfExists(me[vb.v].imgpath, x + 2, y + 2, "left", 1, 1)
        end
        love.graphics.setColor(0,0,0,0.8 * alpha)
        local xb = x + bh + 10
        local wb = bw - bh - 10
        love.graphics.rectangle("fill", xb, y, wb, bh, 5)
        love.graphics.setColor(1, 1, 1, alpha)
        
        love.graphics.print(vb.name .. ":", xb + 10, y + 3, 0, 1)
        if me[vb.v].val ~= "Error" then
            love.graphics.printf("+" .. me[vb.v].val, xb + wb - 50, y + 3, 40, "right", 0, 1)
            love.graphics.print(me[vb.v].name, xb + 10, y + 3 + 12, 0, 1)
        end
        y = y + bh + 8
    end
end
