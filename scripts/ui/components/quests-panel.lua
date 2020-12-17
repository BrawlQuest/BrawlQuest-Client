function initQuestsPanel()
   
    questsPanel = {
        open = false,
        amount = 0,
        opacity = 0,
        questGiver = "Mortus the Wise",
        titleFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 12),
        commentFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 10),
        titles = {"Tracking", "Backlog", "Completed",},
        spacing = 40,
        titleSpacing = 12,
        fieldSpacing = 10,
        boxSpacing = 8,
        images = {
            love.graphics.newImage("assets/ui/hud/quest-hub/action-circles/1.png"),
            love.graphics.newImage("assets/ui/hud/quest-hub/action-circles/2.png"),
            love.graphics.newImage("assets/ui/hud/quest-hub/action-circles/3.png"),
        },
        boxBgWidth = 274,
        boxTextWidth = 230,
    }
end


function drawQuestsPanel(thisX, thisY)
    love.graphics.setColor(1,1,1,questsPanel.opacity)
    love.graphics.setFont(inventory.headerFont)
    love.graphics.print("Quests", thisX + 8, thisY)
    love.graphics.setFont(inventory.font)
    thisX, thisY = thisX, thisY + 40
    for i = 1, #questsPanel.titles do
        if #quests[i] ~= null then
            love.graphics.rectangle("fill", thisX + 19, thisY, questsPanel.boxBgWidth, 2)
            thisY = thisY + 6
            love.graphics.setFont(inventory.font)
            love.graphics.print(questsPanel.titles[i], thisX + 38, thisY)
            drawQuestsPanelField(thisX, thisY + questsPanel.titleSpacing, i)
            -- love.graphics.rectangle("fill", thisX + 200, thisY, 40, getQuestsPanelFieldHeight(i))
            thisY = thisY + getQuestsPanelFieldHeight(i) + questsPanel.fieldSpacing
        end
    end
end

function drawQuestsPanelField(thisX, thisY, i)
    for j = 1, #quests[i] do 
        drawQuestsPanelQuestBox(thisX + 19, thisY, i, j)
        thisY = thisY + getQuestsPanelBoxHeight(i, j) + questsPanel.boxSpacing
    end
end


function getQuestsPanelFieldHeight(i)
    local thisY = 0
    for j = 1, #quests[i] do 
        thisY = thisY + getQuestsPanelBoxHeight(i, j) + questsPanel.boxSpacing
    end
    return thisY + questsPanel.titleSpacing
    -- return ((getQuestsPanelBoxHeight(i) + questsPanel.boxSpacing) * #quests[i]) + questsPanel.titleSpacing
end

function getQuestsPanelBoxHeight(i, j)
    return getTextHeight(
        quests[i][j].title, questsPanel.boxTextWidth, questsPanel.titleFont
    ) + 8 + getTextHeight(
        quests[i][j].task, questsPanel.boxTextWidth, questsPanel.commentFont
    ) + 10 + (12 * 2)
end

function drawQuestsPanelQuestBox(thisX, thisY, i, j)
    love.graphics.setColor(0,0,0,0.75 * questsPanel.opacity)
    drawQuestsPanelQuestBoxBg(thisX, thisY + 10, questsPanel.boxBgWidth, getQuestsPanelBoxHeight(i, j) - 10)
    love.graphics.setColor(1,1,1,questsPanel.opacity)
    love.graphics.draw(questsPanel.images[1], thisX - 10, thisY)
    -- love.graphics.draw(questsPanel.images[3], thisX + questsPanel.boxBgWidth - 15, thisY)

    thisX, thisY = thisX + 20 + ((234 / 2)-(questsPanel.boxTextWidth / 2)), thisY + 10 + 12 
    love.graphics.setFont(questsPanel.titleFont)
    love.graphics.printf(quests[i][j].title, thisX, thisY, questsPanel.boxTextWidth, "center")
    thisY = thisY + getTextHeight(quests[i][j].title, questsPanel.boxTextWidth, questsPanel.titleFont) + 8
    love.graphics.setFont(questsPanel.commentFont)
    love.graphics.printf("- " .. quests[i][j].task, thisX, thisY, questsPanel.boxTextWidth, "left")
    -- love.graphics.rectangle("fill", thisX + 100, thisY, 40, getQuestsPanelBoxHeight(i, j))
end

function drawQuestsPanelQuestBoxBg(thisX, thisY, width, height)
    love.graphics.rectangle("fill", thisX, thisY+chatCorner:getWidth(), width, height-(chatCorner:getHeight()*2))
    for i = 0, 1 do 
		love.graphics.draw(chatCorner, thisX+((i*width)), thisY, math.rad(0+(i*90)))
		love.graphics.draw(chatCorner, thisX+((i*width)), thisY+(height-(chatCorner:getHeight()*2))+(chatCorner:getHeight()*2), math.rad(-90-(i*90)))
		love.graphics.rectangle("fill", thisX+chatCorner:getWidth(), thisY+(i*((height-(chatCorner:getHeight()*2))+chatCorner:getHeight())), width-(chatCorner:getHeight()*2), chatCorner:getHeight()) -- background rectangle
    end
end