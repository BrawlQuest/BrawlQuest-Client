function drawHUD()
    
    love.graphics.push() -- chat and quests scaling TODO: Quests
        local i = 0.5
        love.graphics.scale(scale*i)
        drawChatPanel(uiX/i, uiY/i)
        love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.pop()

    love.graphics.push()
        love.graphics.scale(scale)
        drawToolbar()
        drawProfile(uiX/i, uiY/i)
        drawBattlebar(uiX/2, uiY)
    love.graphics.pop()

    love.graphics.setFont(smallTextFont)
    love.graphics.print("BrawlQuest\nEnemies in aggro: "..enemiesInAggro.."\nWidth "
    ..love.graphics.getWidth().."\nHeight "..love.graphics.getHeight().."\nuiX "
    ..uiX.."\nuiY "..uiY.." ",profileBgnd:getWidth()*scale+5, 5)

end 