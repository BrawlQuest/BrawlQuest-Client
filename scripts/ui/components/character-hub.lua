function loadCharacterHub()
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
        barColors = {
            {1,0,0,1},
            {0,0.5,1,1},
            {1,0.5,0,1},
        }
    }
end

function drawCharacterHub(thisX, thisY)
    if me ~= null and me.HP ~= null or me.XP ~= null then
        thisX, thisY = thisX, thisY - hubImages.profileBG:getHeight()
        drawCharacterHubProfile(thisX, thisY)
        thisX = thisX + hubImages.profileBG:getWidth()
        -- if isMouseOver(thisX * scale, thisY * scale, 100, 100) then
            drawCharacterHubStats(thisX, thisY)
            thisX = thisX + hubImages.statsBG:getWidth()
        -- end
        drawCharacterHubMeters(thisX, thisY)
    end
end

-- max health = 100 + (15 * me.STA) 
-- remember that me and me.STA might not be set
--- if (me and me.STA) then

function drawCharacterHubProfile(thisX, thisY)
    love.graphics.setColor(unpack(characterHub.backgroundColor))
    love.graphics.draw(hubImages.profileBG, thisX, thisY)
    love.graphics.setColor(1,1,1,1)
    drawProfilePic(thisX + 9, thisY + 8, 1, "right", me.Name)
    
    love.graphics.draw(hubImages.profileFG, thisX, thisY)
end

function drawCharacterHubStats(thisX, thisY)
    love.graphics.setColor(unpack(characterHub.backgroundColor))
    love.graphics.draw(hubImages.statsBG, thisX, thisY)
    
    for i = 0, 2 do
        if isMouseOver((thisX + (49 * i) + 3) * scale, (thisY + 43) * scale, hubImages.statCardBg:getWidth() * scale, hubImages.statCardBg:getHeight() * scale) then
            love.graphics.setColor(1,0,0,1)
        else
            love.graphics.setColor(1,1,1,0.70)
        end
        love.graphics.draw(hubImages.statCardBg, thisX + (49 * i) + 3, thisY + 43)
    end

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(hubImages.statsFG, thisX, thisY)
end

function drawCharacterHubMeters(thisX, thisY)
    love.graphics.setColor(unpack(characterHub.backgroundColor))
    love.graphics.draw(hubImages.metersBG, thisX, thisY)
    love.graphics.setFont(headerSmallFont)
    love.graphics.setColor(1,1,1,1)
    if me.Name ~= null then love.graphics.print(me.Name, thisX + 4, thisY) end
    thisY = thisY + 25
    love.graphics.setFont(headerTinyFont)
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
        love.graphics.print(meterLevels[i+1], thisX + 187, thisY + spacing + 4)
    end
end


function checkStatsMousePressed()

end

function getSTA(i)
    if i == 0 then return 15 * me.STA else return 0 end
end