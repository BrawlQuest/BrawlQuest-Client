function initQuestHub()
    initQuestsPanel()
    questHub = {
        open = false,
        amount = 0,
        opacity = 0,
        selectedQuest = 1,
        font = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 8),
        titleFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 14),
        nameFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 8),
        images = {
            npcTalkBG = love.graphics.newImage("assets/ui/hud/quest-hub/npcTalkBG.png"),
            barCapLeft = love.graphics.newImage("assets/ui/hud/quest-hub/barCapLeft.png"),
            barCapRight = love.graphics.newImage("assets/ui/hud/quest-hub/barCapRight.png"),
            barComplete = love.graphics.newImage("assets/ui/hud/quest-hub/1.png"),
            barUnComplete = love.graphics.newImage("assets/ui/hud/quest-hub/0.png"),
        },
    }

    
    quests = {
        -- {Tracking = {}, Backlog = {}, Completed = {},}
        {
            {
                title = "The Fall of Man and his friends, he had it bad man",
                comment = "fas poijhfoiwjff oifjwoefhi ofoefh ofofjofhoihf onfohf ofoif if oknvp poif",
                giver = "Mortus",
                task = "Get 12 Apples",
                requiredAmount = 12,
                currentAmount = 6,
                complete = false,
                -- selected = 1,
            },
            {
                title = "The Brotherhood",
                comment = "fas poijhfoiwjff oifjwoefhi ofoefh ofofjofhoihf onfohf ofoif if oknvp poif",
                giver = "Brother Dan",
                task = "Kill 4 Mobs",
                requiredAmount = 4,
                currentAmount = 4,
                complete = true,
                -- selected = 2,
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
                complete = false,
                -- selected = 1,
            },
            {
                title = "The Brotherhood",
                comment = "fas poijhfoiwjff oifjwoefhi ofoefh ofofjofhoihf onfohf ofoif if oknvp poif",
                giver = "Brother Dan",
                task = "Kill 4 Mobs",
                requiredAmount = 4,
                currentAmount = 4,
                complete = true,
                -- selected = 2,
            },
        },
        {},
    }
end

function updateQuestHub(dt)
    if isMouseOver((uiX - 468) * scale, (uiY - 102) * scale, 468 * scale, 102 * scale) then
        questHub.amount = questHub.amount + 4 * dt
        if questHub.amount > 1 then questHub.amount = 1 end
    else
        questHub.amount = questHub.amount - 4 * dt
        if questHub.amount < 0 then questHub.amount = 0 end
    end

    if questHub.amount > 0 then questHub.open = true else questHub.open = false end
    questHub.opacity = cerp(0, 1, questHub.amount)

    if isMouseOver((uiX - 313) * scale, (0) * scale, 313 * scale, (uiY - 97) * scale) then
        questsPanel.amount = questsPanel.amount + 4 * dt
        if questsPanel.amount > 1 then questsPanel.amount = 1 end
    else
        questsPanel.amount = questsPanel.amount - 4 * dt
        if questsPanel.amount < 0 then questsPanel.amount = 0 end
    end

    if questsPanel.amount > 0 then questsPanel.open = true else questsPanel.open = false end
    questsPanel.opacity = cerp(0, 1, questsPanel.amount)
end

function drawQuestHub(thisX, thisY) 
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", thisX, thisY - 106, -313, cerp(-14, 0 - ((uiY/1.25) - 102), questsPanel.amount))
    love.graphics.rectangle("fill", thisX, thisY, cerp(-313, -462, questHub.amount), -106)
    love.graphics.setColor(1,1,1,1)


    thisX, thisY = thisX - 73, thisY - 100
    drawQuestHubProifle(thisX, thisY)
    if questHub.open then
        -- thisX, thisY = thisX - 150, thisY
        drawQuestHubNPCTalk(thisX - 150, thisY)
    end
    drawQuestHubMeters(thisX - cerp(222 + 10, 371 + 10, questHub.amount), thisY + 2)

    if questsPanel.open then
        drawQuestsPanel(thisX - 313 + 73, thisY + cerp(-14, 0 - ((uiY/1.25) - 102 - 15), questsPanel.amount))
    end
end

function drawQuestHubProifle(thisX, thisY)
    if me.Name ~= null then drawProfilePic(thisX, thisY, 1, "left", me.Name) end
    love.graphics.setFont(questHub.nameFont)
    love.graphics.printf(questsPanel.questGiver, thisX, thisY + 64 + 6, 64, "center") 
end

function drawQuestHubNPCTalk(thisX, thisY)
    if questHub.open then
        love.graphics.setColor(0,0,0, questHub.opacity * 0.6 )
        love.graphics.draw(questHub.images.npcTalkBG, thisX, thisY)
        love.graphics.setColor(1,1,1,questHub.opacity)
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
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", thisX + 28, thisY, 157, 19)
    if quests[1][i] ~= null then
        if not quests[1][i].complete then
            love.graphics.setColor(1,0,0,1)
        else
            love.graphics.setColor(0,0.7,0,1)
        end
    end

    love.graphics.draw(questHub.images.barCapLeft, thisX, thisY)
    love.graphics.draw(questHub.images.barCapRight, thisX + 188, thisY)

    if quests[1][i] ~= null then
        love.graphics.rectangle("fill", thisX + 28, thisY, (157 / quests[1][i].requiredAmount) * quests[1][i].currentAmount, 19)
        love.graphics.setColor(1,1,1,1)

        if quests[1][i].complete then 
            love.graphics.draw(questHub.images.barComplete, thisX + 9, thisY + 4)
        else 
            love.graphics.draw(questHub.images.barUnComplete, thisX + 9, thisY + 4) 
        end

        love.graphics.printf(quests[1][i].task, thisX + 34, thisY + 7, 144, "left")
        love.graphics.printf(quests[1][i].currentAmount .. "/" .. quests[1][i].requiredAmount, thisX + 188, thisY + 7, 34, "center")
    end
end

function getQuestHubTextHeight(text, width)
	local width, lines = questHub.titleFont:getWrap(text, width)
 	return ((#lines)*(questHub.titleFont:getHeight()))+2
end
