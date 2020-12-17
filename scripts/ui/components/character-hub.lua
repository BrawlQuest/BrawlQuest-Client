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
        backgroundColor = {0,0,0,0.5},
        barColors = {{1,0,0,1}, {0,0.5,1,1}, {1,0.5,0,1}, },
        font = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 9),
        nameFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 16),
        open = false,
        amount = 0,
    }
end

function updateCharacterHub(dt)
    if isMouseOver(0 * scale, (uiY - 97) * scale, 468 * scale, 97 * scale) then
        characterHub.open = true
        characterHub.amount = characterHub.amount + 4 * dt
        if characterHub.amount > 1 then characterHub.amount = 1 end
    else
        characterHub.open = false
        characterHub.amount = characterHub.amount - 4 * dt
        if characterHub.amount < 0 then characterHub.amount = 0 end
    end
    -- print(characterHub.amount)
end

function drawCharacterHub(thisX, thisY)
    if me ~= null and me.HP ~= null or me.XP ~= null then
        love.graphics.setFont(characterHub.font)
        thisX, thisY = thisX, thisY - hubImages.profileBG:getHeight()
        drawCharacterHubProfile(thisX, thisY)
        thisX = thisX + hubImages.profileBG:getWidth()
        if characterHub.amount ~= 0 then
            drawCharacterHubStats(thisX, thisY)
        end  
        thisX = thisX + cerp(0, hubImages.statsBG:getWidth(), characterHub.amount)
        drawCharacterHubMeters(thisX, thisY)
    end
end

-- max health = 100 + (15 * me.STA) 
-- remember that me and me.STA might not be set
--- if (me and me.STA) then

function drawCharacterHubProfile(thisX, thisY)
    love.graphics.setColor(unpack(characterHub.backgroundColor))
    -- love.graphics.draw(hubImages.profileBG, thisX, thisY)
    love.graphics.rectangle("fill", thisX, thisY, 82, 97)
    love.graphics.setColor(1,1,1,1)
    drawProfilePic(thisX + 9, thisY + 8, 1, "right", me.Name)
    
    love.graphics.draw(hubImages.profileFG, thisX, thisY)
    love.graphics.setColor(0,0,0,1)
    love.graphics.print(me.LVL, thisX + 56 - (characterHub.font:getWidth(me.LVL)/2), thisY + 85 - (characterHub.font:getHeight(me.LVL)/2))
end

function drawCharacterHubStats(thisX, thisY)
    love.graphics.setColor(unpack(characterHub.backgroundColor))
    -- love.graphics.draw(hubImages.statsBG, thisX, thisY)
    love.graphics.rectangle("fill", thisX, thisY, cerp(0, 155, characterHub.amount), 97)
    love.graphics.setFont(characterHub.font)
    -- local statNumbers = {me.STA, me.INT, me.DEF}
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
    love.graphics.print(perks.reserve, thisX + 77 - (characterHub.font:getWidth(perks.reserve)/2), thisY + 28 - (characterHub.font:getHeight(perks.reserve)/2))
    for i = 0, 2 do
        love.graphics.print(perks[i+1], thisX + (49 * i) + 3 + 32 - (characterHub.font:getWidth(perks[i+1])/2), thisY + 43 + 42 - (characterHub.font:getHeight(perks[i+1])/2))
    end
end

function drawCharacterHubMeters(thisX, thisY)
    love.graphics.setColor(unpack(characterHub.backgroundColor))
    -- love.graphics.draw(hubImages.metersBG, thisX, thisY)
    love.graphics.rectangle("fill", thisX, thisY, 231, 97)
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
        love.graphics.print(meterLevels[i+1], thisX + 198 - (characterHub.font:getWidth(meterLevels[i+1])/2), thisY + spacing + 6)
    end
end


function checkStatsMousePressed(button)
    for i = 0, 2 do
        if isMouseOver((0 + hubImages.profileBG:getWidth() + (49 * i) + 3) * scale, (uiY - hubImages.profileBG:getHeight() + 43) * scale, hubImages.statCardBg:getWidth() * scale, hubImages.statCardBg:getHeight() * scale) then
            if perks.reserve > 0 and button == 1 then
                perks[i+1] = perks[i+1] + 1
                perks.reserve = perks.reserve - 1
            elseif perks[i+1] > 0 and button == 2 then
                perks[i+1] = perks[i+1] - 1
                perks.reserve = perks.reserve + 1
            end
        end
    end
end

function getSTA(i)
    if i == 0 then return 15 * me.STA else return 0 end
end