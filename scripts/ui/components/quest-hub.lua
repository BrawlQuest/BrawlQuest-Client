function initQuestHub()
    initQuestsPanel()
    questHub = {
        open = true,
        commentOpen = false,
        amount = 0,
        commentAmount = 0,
        opacity = 0,
        commentOpacity = 0,
        selectedQuest = 1,
        hover = false,
        hoveredQuest = 1,
        font = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 8),
        titleFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 14),
        nameFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 8),
        images = {
            npcTalkBG = love.graphics.newImage("assets/ui/hud/quest-hub/npcTalkBG.png"),
            barCapLeft = love.graphics.newImage("assets/ui/hud/quest-hub/barCapLeft.png"),
            barCapRight = love.graphics.newImage("assets/ui/hud/quest-hub/barCapRight.png"),
            barComplete = love.graphics.newImage("assets/ui/hud/quest-hub/1.png"),
            barUnComplete = love.graphics.newImage("assets/ui/hud/quest-hub/0.png"),
            arrow = love.graphics.newImage("assets/ui/hud/quest-hub/arrow.png")
        },
    }

    quests = {
        -- {Tracking = {}, Backlog = {}, Completed = {},}
        {
            
        },
        {
            {
                title = "The Fall of Man and his friends, he had it bad man",
                comment = "fas poijhfoiwjff oifjwoefhi ofoefh ofofjofhoihf onfohf ofoif if oknvp poif",
                giver = "Mortus",
                task = "Get 12 Apples",
                requiredAmount = 12,
                currentAmount = 6,
                replayable = true,
            },
            {
                title = "The Brotherhood",
                comment = "fas poijhfoiwjff oifjwoefhi ofoefh ofofjofhoihf onfohf ofoif if oknvp poif",
                giver = "Brother Dan",
                task = "Kill 4 Mobs",
                requiredAmount = 4,
                currentAmount = 4,
                replayable = false,
            },
            {
                title = "The Fall of Man",
                comment = "fas poijhfoiwjff oifjwoefhi ofoefh ofofjofhoihf onfohf ofoif if oknvp poif",
                giver = "Mortus",
                task = "Get 12 Apples",
                requiredAmount = 12,
                currentAmount = 6,
                replayable = true,
            },
            {
                title = "The people",
                comment = "fas poijhfoiwjff oifjwoefhi ofoefh ofofjofhoihf onfohf ofoif if oknvp poif",
                giver = "Brother Dan",
                task = "Kill 4 Mobs",
                requiredAmount = 4,
                currentAmount = 4,
                replayable = false,
            },
            {
                title = "Kill all the boars",
                comment = "fas poijhfoiwjff oifjwoefhi ofoefh ofofjofhoihf onfohf ofoif if oknvp poif",
                giver = "Brother Dan",
                task = "Kill 4 Mobs",
                requiredAmount = 4,
                currentAmount = 4,
                replayable = false,
            },
            {
                title = "I don't know what I'm doing",
                comment = "fas poijhfoiwjff oifjwoefhi ofoefh ofofjofhoihf onfohf ofoif if oknvp poif",
                giver = "Brother Dan",
                task = "Kill 4 Mobs",
                requiredAmount = 4,
                currentAmount = 4,
                replayable = false,
            },
        },
        {
            {
                title = "The Fall of Man",
                comment = "fas poijhfoiwjff oifjwoefhi ofoefh ofofjofhoihf onfohf ofoif if oknvp poif",
                giver = "Mortus",
                task = "Get 12 Apples",
                requiredAmount = 12,
                currentAmount = 6,
                replayable = false,
            },
            {
                title = "The Killer",
                comment = "fas poijhfoiwjff oifjwoefhi ofoefh ofofjofhoihf onfohf ofoif if oknvp poif",
                giver = "Brother Dan",
                task = "Kill 4 Mobs",
                requiredAmount = 4,
                currentAmount = 4,
                replayable = true,
            },
        },
    }
end

function updateQuestHub(dt)
    if isMouseOver((uiX - 468) * scale, (uiY - 102) * scale, 468 * scale, 102 * scale) and #quests[1] > 0 then -- Opens Comment
        questHub.commentAmount = questHub.commentAmount + 4 * dt
        if questHub.commentAmount > 1 then questHub.commentAmount = 1 end
    else
        questHub.commentAmount = questHub.commentAmount - 4 * dt
        if questHub.commentAmount < 0 then questHub.commentAmount = 0 end
    end

    if questHub.commentAmount > 0 then questHub.commentOpen = true else questHub.commentOpen = false end
    questHub.commentOpacity = cerp(0, 1, questHub.commentAmount)

    if #quests[1] > 0 then
        questHub.amount = questHub.amount + 4 * dt
        if questHub.amount > 1 then questHub.amount = 1 end
    else
        questHub.amount = questHub.amount - 4 * dt
        if questHub.amount < 0 then questHub.amount = 0 end
    end

    if questHub.amount > 0 then questHub.open = true else questHub.open = false end
    questHub.opacity = cerp(0, 1, questHub.amount)
    
    if questsPanel.forceOpen and not isTypingInChat then
        questsPanel.amount = questsPanel.amount + 4 * dt
        if questsPanel.amount > 1 then questsPanel.amount = 1 end
        velYQuest = velYQuest - velYQuest * math.min( dt * 15, 1 )
        if getFullQuestsPanelFieldHeight() * scale > (cerp((uiY/1.25) - 55,((uiY/1.25) - 106 - 14 - 55), questHub.amount)) * scale then
            posYQuest = posYQuest + velYQuest * dt
            local questsFieldHeight = 0 - getFullQuestsPanelFieldHeight() + (cerp((uiY/1.25) - 55, ((uiY/1.25) - 106 - 14 - 55), questHub.amount))
            if posYQuest > 0 then
                posYQuest = 0
            elseif posYQuest < questsFieldHeight then
                posYQuest = questsFieldHeight
            end
        else posYQuest = 0
        end
    else
        if isMouseOver(((uiX/1) - 313) * scale, 
        ((uiY) + 55 - (uiY/1.25)) * scale,
        (313) * scale,
        (cerp((uiY/1.25) - 55 ,((uiY/1.25) - 106 - 14 - 55), questHub.amount)) * scale) and not isTypingInChat then -- Opens Quests Panel
            questsPanel.amount = questsPanel.amount + 4 * dt
            if questsPanel.amount > 1 then questsPanel.amount = 1 end

            velYQuest = velYQuest - velYQuest * math.min( dt * 15, 1 )
            if getFullQuestsPanelFieldHeight() * scale > (cerp((uiY/1.25) - 55,((uiY/1.25) - 106 - 14 - 55), questHub.amount)) * scale then
                posYQuest = posYQuest + velYQuest * dt
                if posYQuest > 0 then
                    posYQuest = 0
                elseif posYQuest < 0 - getFullQuestsPanelFieldHeight() + (cerp((uiY/1.25) - 55, ((uiY/1.25) - 106 - 14 - 55), questHub.amount)) then
                    posYQuest = 0 - getFullQuestsPanelFieldHeight() + (cerp((uiY/1.25) - 55, ((uiY/1.25) - 106 - 14 - 55), questHub.amount))
                end
            else posYQuest = 0
            end
        else
            questsPanel.amount = questsPanel.amount - 4 * dt
            if questsPanel.amount < 0 then questsPanel.amount = 0 end
        end
    end

    if questsPanel.amount > 0 then questsPanel.open = true else questsPanel.open = false end
    questsPanel.opacity = cerp(0, 1, questsPanel.amount)
end

function drawQuestHub(thisX, thisY) 
    questHub.hover = false
    if #quests[1] > 0 then
        love.graphics.setColor(0,0,0,0.5)
    else
        love.graphics.setColor(0,0,0,0.5 * questsPanel.opacity)
    end
    love.graphics.rectangle("fill", thisX, thisY - 106, -313, cerp(-14, 0 - ((uiY/1.25) - 102), questsPanel.amount)) -- Quests Panel Background
    love.graphics.rectangle("fill", thisX, thisY, cerp(-313, -462, questHub.commentAmount), -106) -- Quests Hub Background
    love.graphics.setColor(1,1,1,1 * questHub.opacity)


    thisX, thisY = thisX - 73, thisY - cerp(0, 100, questHub.amount)
    if #quests[1] > 0 then 
        drawQuestHubProifle(thisX, thisY)
        if questHub.commentOpen then
            -- thisX, thisY = thisX - 150, thisY
            drawQuestHubNPCTalk(thisX - 150, thisY)
        end
    end
    drawQuestHubMeters(thisX - cerp(222 + 10, 371 + 10, questHub.commentAmount), thisY + 2)
end

function drawQuestHubProifle(thisX, thisY)
    if me.Name ~= null then drawProfilePic(thisX, thisY, 1, "left", me.Name) end
    love.graphics.setFont(questHub.nameFont)
    love.graphics.printf(quests[1][questHub.selectedQuest].giver, thisX, thisY + 64 + 6, 64, "center") 
end

function drawQuestHubNPCTalk(thisX, thisY)
    if questHub.commentOpen and #quests[1] > 0 then
        love.graphics.setColor(0,0,0, questHub.commentOpacity * 0.6 )
        love.graphics.draw(questHub.images.npcTalkBG, thisX, thisY)
        love.graphics.setColor(1,1,1,questHub.commentOpacity)
        love.graphics.setFont(questHub.titleFont)
        love.graphics.printf(quests[1][questHub.selectedQuest].title , thisX + 7, thisY + 7, 127)
        love.graphics.setFont(questHub.font)
        love.graphics.printf(quests[1][questHub.selectedQuest].comment, thisX + 7, thisY + 7 + getQuestHubTextHeight(quests[1][questHub.selectedQuest].title, 127), 127)
    end
end

function drawQuestHubMeters(thisX, thisY)
    for i = 1, 4 do
        drawQuestHubMetersBar(thisX , thisY + (24 * (i-1)), i)
    end
end

function drawQuestHubMetersBar(thisX, thisY, i)
    love.graphics.setColor(0,0,0,0.5 * questHub.opacity)
    love.graphics.rectangle("fill", thisX + 28, thisY, 157, 19)
    if quests[1][i] ~= null then
        if isMouseOver(thisX * scale, thisY * scale, 214 * scale, 19 * scale) then
            love.graphics.setColor(0.88,0.6,0,1 *  questHub.opacity)
            questHub.hoveredQuest = i
            questHub.hover = true
        elseif #quests[1] > 0 then 
            if quests[1][i].requiredAmount == quests[1][i].currentAmount then
                love.graphics.setColor(0,0.7,0,1 *  questHub.opacity)
            else
                love.graphics.setColor(1,0,0,1 *  questHub.opacity)
            end
        end
    end
    love.graphics.draw(questHub.images.barCapRight, thisX + 188, thisY)
    love.graphics.draw(questHub.images.barCapLeft, thisX, thisY)
 
    if quests[1][i] ~= null and #quests[1] > 0 then 
        love.graphics.rectangle("fill", thisX + 28, thisY, (157 / quests[1][i].requiredAmount) * quests[1][i].currentAmount, 19)
        love.graphics.setColor(1,1,1,1 *  questHub.opacity)

        if quests[1][i].requiredAmount == quests[1][i].currentAmount then 
            love.graphics.draw(questHub.images.barComplete, thisX + 9, thisY + 4)
        else 
            love.graphics.draw(questHub.images.barUnComplete, thisX + 9, thisY + 4) 
        end

        love.graphics.printf(quests[1][i].task, thisX + 34, thisY + 7, 144, "left")
        love.graphics.printf(quests[1][i].currentAmount .. "/" .. quests[1][i].requiredAmount, thisX + 188, thisY + 7, 34, "center")
    end

    if questHub.selectedQuest == i then
        love.graphics.draw(questHub.images.arrow, thisX - 18, thisY - 1)
    end

end

function getQuestHubTextHeight(text, width)
	local width, lines = questHub.titleFont:getWrap(text, width)
 	return ((#lines)*(questHub.titleFont:getHeight()))+2
end

