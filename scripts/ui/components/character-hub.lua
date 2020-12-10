function loadCharacterHub()
    hubImages = {
        placeholder = love.graphics.newImage("assets/ui/hud/charater-hub/placeholder.png"),
        profileBG = love.graphics.newImage("assets/ui/hud/charater-hub/profile.png"),
        statsBG = love.graphics.newImage("assets/ui/hud/charater-hub/stats.png"),
        metersBG = love.graphics.newImage("assets/ui/hud/charater-hub/meters.png"),
        profileFG = love.graphics.newImage("assets/ui/hud/charater-hub/profile-fg.png"),
        statsFG = love.graphics.newImage("assets/ui/hud/charater-hub/stats-fg.png"),
        -- metersFG = love.graphics.newImage("assets/ui/hud/charater-hub/meters-fg.png"),
    }

    showStatsPanel = false
    characterHub = {
        backgroundColor = {0,0,0,0.5},
    }
end

function drawCharacterHub(thisX, thisY)
    thisX, thisY = thisX, thisY - hubImages.profileBG:getHeight()
    drawCharacterHubProfile(thisX, thisY)
    thisX = thisX + hubImages.profileBG:getWidth()
    
    -- if isMouseOver(thisX * scale, thisY * scale, 100, 100) then
        drawCharacterHubStats(thisX, thisY)
        thisX = thisX + hubImages.statsBG:getWidth()
    -- end

    drawCharacterHubMeters(thisX, thisY)

end

function drawCharacterHubProfile(thisX, thisY)
    love.graphics.setColor(unpack(characterHub.backgroundColor))
    love.graphics.draw(hubImages.profileBG, thisX, thisY)
    love.graphics.setColor(1,1,1,1)
    drawProfilePic(thisX, thisY, 1, "right", me.Name)
    love.graphics.draw(hubImages.profileFG, thisX, thisY)
end

function drawCharacterHubStats(thisX, thisY)
    love.graphics.setColor(unpack(characterHub.backgroundColor))
    love.graphics.draw(hubImages.statsBG, thisX, thisY)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(hubImages.statsFG, thisX, thisY)
end

function drawCharacterHubMeters(thisX, thisY)
    love.graphics.setColor(unpack(characterHub.backgroundColor))
    love.graphics.draw(hubImages.metersBG, thisX, thisY)
    love.graphics.setColor(1,1,1,1)
end

function checkStatsMousePressed()

end
