--[[
    This page controls server selection
]]

--[[
    This file is for the character creation window
]]
require "scripts.phases.login.ui_elements"

local selectedSkinTone = 1

function drawServerPhase() 
    loginImageX, loginImageY = math.floor(love.graphics.getWidth() / 2 - (loginEntryImage:getWidth() / 2)),
    math.floor(love.graphics.getHeight() / 2 - (loginEntryImage:getHeight() / 2))
    love.graphics.draw(blankPanelImage, loginImageX, loginImageY)

    love.graphics.setFont(headerBigFont)
    love.graphics.print("Select\nServer", loginImageX+30, loginImageY+90)

    love.graphics.setFont(headerFont)
    for i=1,#servers do
        drawButton(servers[i].name, loginImageX+30, loginImageY+140+(i*48))
    end
end

function checkClickLoginPhaseServer(x,y)
    for i=1,#servers do
        if isMouseOver(loginImageX+30, loginImageY+140+(i*48), buttonImage:getWidth(), buttonImage:getHeight()) then
            selectedServer = i
            api.url = servers[selectedServer].url
            loginPhase = "login"
            
            writeSettings()
            loginViaSteam()
            break
        end
    end
end

