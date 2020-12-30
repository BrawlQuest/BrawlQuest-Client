function initQuestsPanel()
    questsPanel = {
        open = false,
        forceOpen = false,
        amount = 0,
        opacity = 0,
        questGiver = "Mortus the Wise",
        titleFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 10),
        commentFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 8),
        titles = {"Tracking", "Backlog", "Completed",},
        spacing = 40,
        titleSpacing = 12,
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
    -- questsPanel.selectedQuest = {}
    questsPanel.hover = false
    love.graphics.setColor(1,1,1,questsPanel.opacity)
    love.graphics.setFont(inventory.headerFont)
    love.graphics.print("Quests", thisX + 20, thisY)
    
    love.graphics.stencil(drawQuestsPanelStencil, "replace", 1) -- stencils inventory
    love.graphics.setStencilTest("greater", 0) -- push

        love.graphics.setFont(inventory.font)
        thisX, thisY = thisX, thisY + 40 + posYQuest
        -- love.graphics.rectangle("fill", thisX + 40, thisY, 40, getFullQuestsPanelFieldHeight())
        for i = 1, #questsPanel.titles do
            -- if #quests[i] ~= 0 then
                love.graphics.rectangle("fill", thisX + 19, thisY, questsPanel.boxBgWidth, 2)
                thisY = thisY + 6
                love.graphics.setFont(inventory.font)
                love.graphics.print(questsPanel.titles[i], thisX + 38, thisY)
                drawQuestsPanelField(thisX, thisY + questsPanel.titleSpacing, i)
                -- love.graphics.rectangle("fill", thisX + 200, thisY, 40, getQuestsPanelFieldHeight(i))
                thisY = thisY + getQuestsPanelFieldHeight(i) + questsPanel.fieldSpacing
            -- end
        end

    love.graphics.setStencilTest() -- pop
    -- print(quests[1][questsPanel.selectedQuest[2]].currentAmount)
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

function getFullQuestsPanelFieldHeight()
    local questsFullHeight = 0
    for i = 1, #questsPanel.titles do
        -- if #quests[i] ~= 0 then
            questsFullHeight = questsFullHeight + 6 + getQuestsPanelFieldHeight(i) + questsPanel.fieldSpacing
        -- end
    end
    return questsFullHeight
end

function getQuestsPanelBoxHeight(i, j)
    local height = getTextHeight(
        quests[i][j].title, questsPanel.boxTextWidth, questsPanel.titleFont
    ) + 8 + getTextHeight(
        quests[i][j].task, questsPanel.boxTextWidth, questsPanel.commentFont
    ) + 10 + (10 * 2)

    local profileHeight = (profilePic:getHeight() * 0.5) + 20 + 10

    if height < profileHeight then return profileHeight else return height end
end

function drawQuestsPanelQuestBox(thisX, thisY, i, j)
    love.graphics.setColor(0,0,0,0.75 * questsPanel.opacity)
    drawQuestsPanelQuestBoxBg(thisX, thisY + 10, questsPanel.boxBgWidth, getQuestsPanelBoxHeight(i, j) - 10)
    drawProfilePic(thisX + 10, thisY + 10 + 10, 0.5, "right", me.Name)
    
    local isIt = isMouseOver((thisX  - 6) * scale, (thisY + 4) * scale, questsPanel.images[4]:getWidth() * scale, questsPanel.images[4]:getHeight() * scale)
    
    if i == 1 then
        if isIt then
            love.graphics.setColor(1,1,1,questsPanel.opacity)
            love.graphics.draw(questsPanel.images[4], thisX - 6, thisY + 4)
            love.graphics.setColor(0,0,0,questsPanel.opacity)
            love.graphics.draw(questsPanel.images[1], thisX - 6, thisY + 4)
        else
            love.graphics.setColor(0.75,0,0,questsPanel.opacity)
            love.graphics.draw(questsPanel.images[4], thisX - 6, thisY + 4)
            love.graphics.setColor(1,1,1,questsPanel.opacity)
            love.graphics.draw(questsPanel.images[1], thisX - 6, thisY + 4)
        end
    elseif i == 2 and #quests[1] < 4 then -- (i == 3 and quests[i][j].replayable)
        if isIt then
            love.graphics.setColor(1,1,1,questsPanel.opacity)
            love.graphics.draw(questsPanel.images[4], thisX - 6, thisY + 4)
            love.graphics.setColor(0,0,0,questsPanel.opacity)
            love.graphics.draw(questsPanel.images[2], thisX - 6, thisY + 4)
        else
            love.graphics.setColor(0,0.75,0,questsPanel.opacity)
            love.graphics.draw(questsPanel.images[4], thisX - 6, thisY + 4)
            love.graphics.setColor(1,1,1,questsPanel.opacity)
            love.graphics.draw(questsPanel.images[2], thisX - 6, thisY + 4)
        end
    end

    if isIt then
        questsPanel.selectedQuest = {i, j, quests[i][j]}
        questsPanel.hover = true
    end
    
    love.graphics.setColor(1,1,1,questsPanel.opacity)
    -- love.graphics.draw(questsPanel.images[3], thisX + questsPanel.boxBgWidth - 15, thisY)

    thisX, thisY = thisX + (profilePic:getWidth() * 0.5) + (10 * 2), thisY + 10 + 10 
    love.graphics.setFont(questsPanel.titleFont)
    love.graphics.printf(quests[i][j].title, thisX, thisY, questsPanel.boxTextWidth, "left")
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

function drawQuestsPanelStencil()
    love.graphics.rectangle(
        "fill",
        ((uiX/1) - 313), 
        ((uiY/1) + 55 - (uiY/1.25)),
        (313),
        (cerp((uiY/1.25) ,((uiY/1.25) - 106 - 14 - 55), questHub.amount)) --((uiY/1.25) - 106 - 14 - 55)
    )
    
end 

function checkQuestPanelMousePressed(button)
    if button == 1 and questsPanel.hover then
        if questsPanel.selectedQuest[1] == 1 then 
            questHub.selectedQuest = 1
            -- if quests[1][questsPanel.selectedQuest[2]].currentAmount == quests[1][questsPanel.selectedQuest[2]].requiredAmount then
            --     table.insert(quests[3], questsPanel.selectedQuest[3])
            -- else
                table.insert(quests[2], questsPanel.selectedQuest[3])
            -- end
            table.remove(quests[questsPanel.selectedQuest[1]], questsPanel.selectedQuest[2])
        elseif questsPanel.selectedQuest[1] == 2 and #quests[1] < 4 then 
            table.insert(quests[1], questsPanel.selectedQuest[3])
            table.remove(quests[questsPanel.selectedQuest[1]], questsPanel.selectedQuest[2])
        end
    elseif button == 1 and questHub.hover then
        questHub.selectedQuest = questHub.hoveredQuest
    end
end
