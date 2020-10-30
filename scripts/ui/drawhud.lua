function drawHUD()
    
    -- love.graphics.push() -- chat and quests scaling TODO: Quests
    --     local i = 0.5
    --     love.graphics.scale(scale*i)
    --     drawChatPanel(uiX/i, uiY/i)
    -- love.graphics.pop()

    -- love.graphics.push() -- chat and quests scaling TODO: Quests
    --     local i = 0.75
    --     love.graphics.scale(scale*i)
    --     drawBattlebar((uiX/2)/i, uiY/i)
    -- love.graphics.pop()

    love.graphics.push()
        local i = 1
        love.graphics.scale(scale)
        -- drawToolbar()
        drawProfile(uiX/i, uiY/i)
    love.graphics.pop()

    --love.graphics.rectangle("fill", (uiX-getChatWidth()), 0, getChatWidth()*(scale*0.5), uiY)
end 