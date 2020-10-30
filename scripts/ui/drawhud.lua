function drawHUD()
    if me ~= null and me.HP ~= null or me.HP ~= null then  
        love.graphics.push() -- chat and quests scaling TODO: Quests
            local i = 0.5
            love.graphics.scale(scale*i)
            drawChatPanel(uiX/i, uiY/i)
            
        love.graphics.pop()

        love.graphics.push() -- chat and quests scaling TODO: Quests
            local i = 0.75
            love.graphics.scale(scale*i)
            drawBattlebar((uiX/2)/i, uiY/i)
            drawQuestPannel(uiX/i, 0)
            --drawQuestPopUp((uiX/2)/i, (uiY/2)/i)
        love.graphics.pop()

        love.graphics.push()
            local i = 1
            love.graphics.scale(scale)
            drawToolbar()
            drawProfile(uiX/i, uiY/i)
            
        love.graphics.pop()

        love.graphics.setFont(smallTextFont)
        love.graphics.print("BrawlQuest\nEnemies in aggro: "..enemiesInAggro.."\nWidth "
        ..love.graphics.getWidth().."\nHeight "..love.graphics.getHeight().."\nuiX "
        ..uiX.."\nuiY "..uiY.." ",printWidth, 5)
    end
end 