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
        meterNames = {
            love.graphics.newImage("assets/ui/hud/charater-hub/HEALTH.png"),
            love.graphics.newImage("assets/ui/hud/charater-hub/MANA.png"),
            love.graphics.newImage("assets/ui/hud/charater-hub/XP.png"),
        },
    }

    showStatsPanel = false
    characterHub = {
        backgroundColor = {0,0,0,0.7},
        barColors = {{1,0,0,1}, {0,0.5,1,1}, {1,0.5,0,1}, },
        font = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 8),
        nameFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 16),
        open = false,
        forceOpen = false,
        amount = 0,
        flashy = 0,
        flashyCERP = 0,
    }
end

function updateCharacterHub(dt)
    if characterHub.forceOpen then
        characterHub.open = true
        panelMovement(dt, characterHub, 1)
    else
        if isMouseOver(0 * scale, (uiY - 97) * scale, 468 * scale, 97 * scale) then
            characterHub.open = true
            panelMovement(dt, characterHub, 1)
        else
            characterHub.open = false
            panelMovement(dt, characterHub, -1)
        end
    end

    if player.cp > 0 then
        local i = 0
        if inventory.open or inventory.forceOpen then i = 2 end
        characterHub.flashy = characterHub.flashy + 2 * dt
        if characterHub.flashy >= 2 then characterHub.flashy = i end
        characterHub.flashyCERP  = cerp( 0,0.5, characterHub.flashy )
    else
        characterHub.flashy = 0
        characterHub.flashyCERP = 0
    end
end

function drawCharacterHub(thisX, thisY)
    if me ~= null and me.HP ~= null or me.XP ~= null then
        love.graphics.setFont(characterHub.font)
        thisX, thisY = thisX, thisY - hubImages.profileBG:getHeight()
        drawCharacterHubProfile(thisX, thisY)
        thisX = thisX + hubImages.profileBG:getWidth()
        if characterHub.amount ~= 0 then
            drawCharacterHubStats(thisX, thisY)
        end  
        thisX = thisX + cerp(0, hubImages.statsBG:getWidth(), characterHub.amount)
        drawCharacterHubMeters(thisX, thisY)
        if me.Weapon ~= null then drawBattlebarItem(thisX + 231 + 10, thisY + 97 - 10 - 60, itemImg[me.Weapon.ImgPath], "+"..me.Weapon.Val) end

        local defence = 0
        if me ~= null then
            if v.LegArmourID ~= 0 and me.LegArmour.Val ~= "Error" then
                defence = defence + me.LegArmour.Val
            end

            if v.ChestArmourID ~= 0 and me.ChestArmour.Val ~= "Error" then
                defence = defence + me.ChestArmour.Val
            end

            if v.HeadArmourID ~= 0 and me.HeadArmour.Val ~= "Error" then
                defence = defence + me.HeadArmour.Val
            end
        end
        drawBattlebarItem(thisX + 231 + 20 + 40, thisY + 97 - 10 - 60, "me", "+"..defence )
    end
end

function drawCharacterHubProfile(thisX, thisY)
    love.graphics.setColor(characterHub.flashyCERP,0,0,0.7)
    love.graphics.rectangle("fill", thisX, thisY, 82, 97)
    love.graphics.setColor(1,1,1,1)
    drawProfilePic(thisX + 9, thisY + 8, 1, "right")
    
    if player.cp > 0 then love.graphics.setColor(1,0,0,1) end
    love.graphics.draw(hubImages.profileFG, thisX, thisY)
    if player.cp > 0 then love.graphics.setColor(1,1,1,1) else love.graphics.setColor(0,0,0,1) end
    love.graphics.print(me.LVL, thisX + 56 - math.floor(characterHub.font:getWidth(me.LVL)/2), thisY + 85 - (characterHub.font:getHeight(me.LVL)/2))
end

function drawCharacterHubStats(thisX, thisY)
    love.graphics.setColor(characterHub.flashyCERP,0,0,0.7)
    love.graphics.rectangle("fill", thisX, thisY, cerp(0, 155, characterHub.amount), 97)
    love.graphics.setFont(characterHub.font)
    for i = 0, 2 do
        if isMouseOver((thisX + (49 * i) + 3) * scale, (thisY + 43) * scale, hubImages.statCardBg:getWidth() * scale, hubImages.statCardBg:getHeight() * scale) then
            love.graphics.setColor(1,0,0, cerp(0, 1, characterHub.amount))
        else
            love.graphics.setColor(1,1,1,cerp(0, 0.7, characterHub.amount))
        end
        love.graphics.draw(hubImages.statCardBg, thisX + (49 * i) + 3, thisY + 43)
    end

    love.graphics.setColor(1,1,1,cerp(0, 1, characterHub.amount))
    love.graphics.draw(hubImages.statsFG, thisX, thisY)
    
    love.graphics.setColor(0,0,0, cerp(0, 1, characterHub.amount))
    love.graphics.print(player.cp, thisX + 77 - (characterHub.font:getWidth(player.cp)/2), thisY + 28 - (characterHub.font:getHeight(player.cp)/2))
    for i = 0, 2 do
        love.graphics.print(me[perkTitles[i+1]], thisX + (49 * i) + 3 + 32 - (characterHub.font:getWidth(me[perkTitles[i+1]])/2), thisY + 43 + 42 - (characterHub.font:getHeight(me[perkTitles[i+1]])/2))
    end
end

function drawCharacterHubMeters(thisX, thisY)
    love.graphics.setColor(characterHub.flashyCERP,0,0,0.7)
    roundRectangle("fill", thisX, thisY, 231, 97, cerp(0, 10, characterHub.amount), {false, true, false, false})
    love.graphics.setFont(characterHub.nameFont)
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(me.Name, thisX + 6, thisY+4)
    thisX, thisY = thisX + 5, thisY + 25
    love.graphics.setFont(characterHub.font)
    local j = (100/151)
    local meterLevels = {me.HP, me.Mana, me.XP}
    for i = 0, 2 do
        local spacing = 23 * i
        love.graphics.setColor(unpack(characterHub.backgroundColor))
        love.graphics.rectangle("fill", thisX + 31, thisY + spacing, 151, 19)
        love.graphics.setColor(unpack(characterHub.barColors[i+1]))
        love.graphics.draw(hubImages.meterSide, thisX, thisY + spacing)
        love.graphics.draw(hubImages.meterSide, thisX + 212, thisY + 19 + spacing, math.rad(180))
        love.graphics.rectangle("fill", thisX + 31, thisY + spacing, meterLevels[i+1] / ((100 + getSTA(i)) / 151), 19)
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(hubImages.meterIcons[i+1], thisX, thisY + spacing)
        love.graphics.draw(hubImages.meterNames[i+1], thisX, thisY + spacing)
        love.graphics.print(math.floor(meterLevels[i+1]), thisX + 198 - (characterHub.font:getWidth(math.floor(meterLevels[i+1]))/2), thisY + spacing + 6)
    end
end


function checkStatsMousePressed(button)
    for i = 0, 2 do
        if isMouseOver((0 + hubImages.profileBG:getWidth() + (49 * i) + 3) * scale, (uiY - hubImages.profileBG:getHeight() + 43) * scale, hubImages.statCardBg:getWidth() * scale, hubImages.statCardBg:getHeight() * scale) then
            if player.cp > 0 and button == 1 then
                apiGET("/stat/"..player.name.."/"..perkTitles[i+1])
                player.cp = player.cp - 1
                me[perkTitles[i+1]] = me[perkTitles[i+1]] + 1
            elseif button == 2 then 
                c, h = http.request{url = api.url.."/stat/"..player.name.."/"..perkTitles[i+1], method="DELETE", headers={["token"]=token}}
                player.cp = player.cp + 1
                me[perkTitles[i+1]] = me[perkTitles[i+1]] - 1
            end
        end
    end
end

function getSTA(i)
    if i == 0 then return 15 * me.STA else return 0 end
end

function drawBattlebarItem(thisX, thisY, item, stats)
    love.graphics.setColor(0,0,0,0.7)
    roundRectangle("fill", thisX, thisY, 40, 60, 5)
    love.graphics.setColor(1,1,1)
    if item == "me" then
        v = me
        love.graphics.setColor(1,1,1,1)
		-- if v.Color ~= null then love.graphics.setColor(unpack(v.Color)) end
		love.graphics.draw(playerImg, thisX + 4, thisY + 4)
		love.graphics.setColor(1,1,1,1)
		if v and v.HeadArmour then
			if v.HeadArmourID ~= 0 then
				drawItemIfExists(v.HeadArmour.ImgPath, thisX + 4, thisY + 4)
			end

			if v.ChestArmourID ~= 0 then
				drawItemIfExists(v.ChestArmour.ImgPath, thisX + 4, thisY + 4)
			end

			if v.LegArmourID ~= 0 then
				drawItemIfExists(v.LegArmour.ImgPath, thisX + 4, thisY + 4)
			end
		end
    else
        love.graphics.draw(item, thisX + 4, thisY + 4) 
    end

    love.graphics.print(stats, characterHub.nameFont, thisX+(40 / 2)-(characterHub.nameFont:getWidth(stats)/2), thisY + 42)
    love.graphics.setFont(headerFont)
end
