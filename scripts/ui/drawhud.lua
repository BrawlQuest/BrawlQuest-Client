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
        drawProfile()
    love.graphics.pop()

    love.graphics.print("BrawlQuest\nEnemies in aggro: "..enemiesInAggro)

end