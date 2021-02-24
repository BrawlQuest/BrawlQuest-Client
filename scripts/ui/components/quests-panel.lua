function initQuestsPanel()
    questsPanel = {
        open = false,
        forceOpen = false,
        amount = 0,
        opacity = 0,
        titleFont = love.graphics.newFont("assets/ui/fonts/C&C Red Alert [INET].ttf", 13),
        commentFont = love.graphics.newFont("assets/ui/fonts/C&C Red Alert [INET].ttf", 13),
        titles = {"TRACKING", "BACKLOG", "COMPLETED",},
        spacing = 40,
        titleSpacing = 16,
        fieldSpacing = 10,
        boxSpacing = 0,
        images = {
            love.graphics.newImage("assets/ui/hud/quest-hub/action-circles/1.png"),
            love.graphics.newImage("assets/ui/hud/quest-hub/action-circles/2.png"),
            love.graphics.newImage("assets/ui/hud/quest-hub/action-circles/3.png"),
            love.graphics.newImage("assets/ui/hud/quest-hub/action-bg.png"),
        },
        boxBgWidth = 274,
        boxTextWidth = 200,
        selectedQuest = {},
        hover = false,
    }
end


function drawQuestsPanel(thisX, thisY)
    questsPanel.hover = false
    love.graphics.setColor(1,1,1,questsPanel.opacity)
    love.graphics.print("QUESTS", inventory.headerFont, thisX + 20, thisY + 3)

    love.graphics.stencil(drawQuestsPanelStencil, "replace", 1) -- stencils inventory
    love.graphics.setStencilTest("greater", 0) -- push

        love.graphics.setFont(inventory.font)
        thisX, thisY = thisX, thisY + 40 + posYQuest
        for i = 1, #questsPanel.titles do
            if #quests[i] ~= 0 then
                love.graphics.rectangle("fill", thisX + 19, thisY, questsPanel.boxBgWidth, 2)
                thisY = thisY + 6
                love.graphics.setFont(inventory.font)
                love.graphics.print(questsPanel.titles[i], thisX + 42, thisY + 5)
                drawQuestsPanelField(thisX, thisY + questsPanel.titleSpacing, i)
                thisY = thisY + getQuestsPanelFieldHeight(i) + questsPanel.fieldSpacing
            end
        end
    love.graphics.setStencilTest() -- pop
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
end

function getFullQuestsPanelFieldHeight()
    local questsFullHeight = 0
    for i = 1, #questsPanel.titles do
        if #quests[i] ~= 0 then
            questsFullHeight = questsFullHeight + 6 + getQuestsPanelFieldHeight(i) + questsPanel.fieldSpacing
        end
    end
    return questsFullHeight
end

function getQuestsPanelBoxHeight(i, j)
    local height = getTextHeight(
        quests[i][j].title, questsPanel.boxTextWidth, questsPanel.titleFont
    ) + 20 + 16 + (10 * 2)

    local profileHeight = (profilePic:getHeight() * 0.5) + 20 + 10

    if height < profileHeight then return profileHeight else return height end
end

function drawQuestsPanelQuestBox(thisX, thisY, i, j)
    love.graphics.setColor(0,0,0,0.75 * questsPanel.opacity)
    drawQuestsPanelQuestBoxBg(thisX, thisY + 10, questsPanel.boxBgWidth, getQuestsPanelBoxHeight(i, j) - 10)
    drawNPCProfilePic(thisX + 10, thisY + 10 + 10, 0.5, "right", quests[i][j].profilePic)

    love.graphics.printf(quests[i][j].giver, questsPanel.commentFont, thisX + 10, thisY + 58, 32, "center")

    local isIt = isMouseOver((thisX  - 6) * scale, (thisY + 4) * scale, questsPanel.images[4]:getWidth() * scale, questsPanel.images[4]:getHeight() * scale)

    if i == 1 then
        if isIt then
            love.graphics.setColor(1,1,1,questsPanel.opacity)
            drawQuestAddButton(thisX, thisY)
            love.graphics.setColor(0,0,0,questsPanel.opacity)
            love.graphics.draw(questsPanel.images[1], thisX - 6, thisY + 4)
        else
            love.graphics.setColor(0.75,0,0,questsPanel.opacity)
            drawQuestAddButton(thisX, thisY)
            love.graphics.setColor(1,1,1,questsPanel.opacity)
            love.graphics.draw(questsPanel.images[1], thisX - 6, thisY + 4)
        end
    elseif i == 2 and #quests[1] < 4 then
        if isIt then
            love.graphics.setColor(1,1,1,questsPanel.opacity)
            drawQuestAddButton(thisX, thisY)
            love.graphics.setColor(0,0,0,questsPanel.opacity)
            love.graphics.draw(questsPanel.images[2], thisX - 6, thisY + 4)
        else
            love.graphics.setColor(0,0.75,0,questsPanel.opacity)
            drawQuestAddButton(thisX, thisY)
            love.graphics.setColor(1,1,1,questsPanel.opacity)
            love.graphics.draw(questsPanel.images[2], thisX - 6, thisY + 4)
        end
    end

    if isIt then
        questsPanel.selectedQuest = {i, j, quests[i][j]}
        questsPanel.hover = true
    end

    love.graphics.setColor(1,1,1,questsPanel.opacity)

    thisX, thisY = thisX + profilePic:getWidth() * 0.5 + 10 * 2, thisY + 10 + 10
    love.graphics.printf(quests[i][j].title, questsPanel.titleFont, thisX, thisY, questsPanel.boxTextWidth, "left")
    thisY = thisY + getTextHeight(quests[i][j].title, questsPanel.boxTextWidth, questsPanel.titleFont) + 8
    drawQuestsPanelMeter(thisX, thisY, i, j)
end

function drawQuestsPanelMeter(thisX, thisY, i, j)
    local width = questsPanel.boxBgWidth - (profilePic:getWidth() * 0.5 + 10 * 3)
    love.graphics.setColor(0,0,0,0.7)
    roundRectangle("fill", thisX, thisY, width, 18, 4)
    love.graphics.setColor(1,0,0,1)
    if quests[i][j].currentAmount > 0 then
        local table = {true, false, false, true}
        if quests[i][j].requiredAmount == quests[i][j].currentAmount then 
            love.graphics.setColor(0, 0.7, 0, 1) 
            table = {true, true, true, true}
        end
        roundRectangle("fill", thisX, thisY, width / quests[i][j].requiredAmount * quests[i][j].currentAmount, 18, 4, table)
    end

    love.graphics.setColor(1,1,1,1)    
    love.graphics.print(quests[i][j].task, questsPanel.commentFont, thisX + 7, thisY + 3)
    local text = quests[i][j].currentAmount .. "/" .. quests[i][j].requiredAmount
    love.graphics.print(text, questsPanel.commentFont, thisX + width - questsPanel.commentFont:getWidth(text) - 7, thisY + 3)
end

function drawQuestAddButton(thisX, thisY)
    local size = questsPanel.images[1]:getWidth()
    roundRectangle("fill", thisX - 6, thisY + 4, size, size, 4)
end

function drawQuestsPanelQuestBoxBg(thisX, thisY, width, height)
    roundRectangle("fill", thisX, thisY, width, height, 7)
end

function drawQuestsPanelStencil()
    love.graphics.rectangle(
        "fill",
        ((uiX/1) - 313),
        ((uiY/1) + 55 - (uiY/1.25)),
        (313),
        (cerp((uiY/1.25) ,((uiY/1.25) - 106 - 14 - 55), questHub.amount))
    )
end

function checkQuestPanelMousePressed(button)
    -- if button == 1 and questsPanel.hover then
    --     if questsPanel.selectedQuest[1] == 1 then
    --         questHub.selectedQuest = 1
    --         table.insert(quests[2], questsPanel.selectedQuest[3])
    --         table.remove(quests[questsPanel.selectedQuest[1]], questsPanel.selectedQuest[2])
    --     elseif questsPanel.selectedQuest[1] == 2 and #quests[1] < 4 then
    --         table.insert(quests[1], questsPanel.selectedQuest[3])
    --         table.remove(quests[questsPanel.selectedQuest[1]], questsPanel.selectedQuest[2])
    --     end
    -- elseif button == 1 and questHub.hover then
    --     questHub.selectedQuest = questHub.hoveredQuest
    -- end
end
