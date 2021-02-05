function initQuestHub()
    
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
        font = love.graphics.newFont("assets/ui/fonts/C&C Red Alert [INET].ttf", 13),
        titleFont = love.graphics.newFont("assets/ui/fonts/C&C Red Alert [INET].ttf", 13),
        nameFont = love.graphics.newFont("assets/ui/fonts/C&C Red Alert [INET].ttf", 13),
        images = {
            npcTalkBG = love.graphics.newImage("assets/ui/hud/quest-hub/npcTalkBG.png"),
            barCapLeft = love.graphics.newImage("assets/ui/hud/quest-hub/barCapLeft.png"),
            barCapRight = love.graphics.newImage("assets/ui/hud/quest-hub/barCapRight.png"),
            barComplete = love.graphics.newImage("assets/ui/hud/quest-hub/1.png"),
            barUnComplete = love.graphics.newImage("assets/ui/hud/quest-hub/0.png"),
            arrow = love.graphics.newImage("assets/ui/hud/quest-hub/arrow.png")
        },
    }

    initQuestsPanel()
    quests = {}

    local randomQuest = {0, love.math.random(1, 5), love.math.random(1, 2),}
    local randomGiver = {
        {"Mortus", "assets/npc/Mortus.png",},
        {"Lumberjack", "assets/npc/Lumberjack.png",},
        {"Drunk Man", "assets/npc/Drunk Man.png",},
        {"Blacksmith", "assets/npc/Blacksmith.png",},
        {"Bartender", "assets/npc/Bartender.png",},
        {"Brother Dan", "assets/npc/Priest.png",},
    }

    for i = 1, 3 do
        quests[i] = {}
        for j = 1, randomQuest[i] do
            local rand = love.math.random(1, 6)
            local max = love.math.random(1, 20)
            local min = love.math.random(0, max - 1)
            if i == 3 then min = max end
            quests[i][j] = {
                title = generateRandomTitle(),
                comment = "The long path is unclear at best",
                giver = randomGiver[rand][1],
                profilePic = randomGiver[rand][2],
                task = "Get " .. max .. " Apples",
                requiredAmount = max,
                currentAmount = min,
            }
        end
    end
end

function generateRandomTitle()
    local randText = {desc = {"Great", "Ominous", "Dark", "Evil", "Hungry"}, thing = {"Woods", "Night", "Day", "Road", "Nightmare",}}
    -- local rand = 
    local text = ""
    for i = 1, love.math.random(1, 5) do
        text = text .. randText.desc[love.math.random(1, #randText.desc)] .. " "
    end
    return "The " .. text .. randText.thing[love.math.random(1, #randText.thing)]
end

function updateQuestHub(dt)
    if isMouseOver((uiX - 468) * scale, (uiY - 102) * scale, 468 * scale, 102 * scale) and #quests[1] > 0 then -- Opens Comment
        panelMovement(dt, questHub,  1, "commentAmount")
    else
        panelMovement(dt, questHub, -1, "commentAmount")
    end

    if questHub.commentAmount > 0 then 
        questHub.commentOpen = true 
        questHub.commentOpacity = cerp(0, 1, questHub.commentAmount)
    else questHub.commentOpen = false end

    if #quests[1] > 0 then
        panelMovement(dt, questHub, 1)
    else
        panelMovement(dt, questHub, -1)
    end

    if questHub.amount > 0 then questHub.open = true
        questHub.opacity = cerp(0, 1, questHub.amount) 
    else questHub.open = false end
    
    if questsPanel.forceOpen and not isTypingInChat then
        panelMovement(dt, questsPanel, 1)
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
    elseif not isTypingInChat and openUiOnHover then
        if isMouseOver(((uiX/1) - 313) * scale, 
        ((uiY) + 55 - (uiY/1.25)) * scale,
        (313) * scale,
        (cerp((uiY/1.25) - 55 ,((uiY/1.25) - 106 - 14 - 55), questHub.amount)) * scale) then -- Opens Quests Panel
            panelMovement(dt, questsPanel, 1)
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
            panelMovement(dt, questsPanel, -1)
        end
    else
        panelMovement(dt, questsPanel, -1)
    end

    if questsPanel.amount > 0 then questsPanel.open = true else questsPanel.open = false end
    questsPanel.opacity = cerp(0, 1, questsPanel.amount)
end

function drawQuestHub(thisX, thisY) 
    questHub.hover = false
    if #quests[1] > 0 then
        love.graphics.setColor(0,0,0,0.7)
    else
        love.graphics.setColor(0,0,0,0.7 * questsPanel.opacity)
    end

    roundRectangle("fill", thisX - 313, thisY - 106 - 14 - cerp(0, ((uiY/1.25) - 102), questsPanel.amount), 313, 14 + cerp(0, ((uiY/1.25) - 102), questsPanel.amount), 5 , {true, false, false, false}) -- Quests Panel Background
    roundRectangle("fill", thisX - cerp(313, 462, questHub.commentAmount), thisY - 106, cerp(313, 462, questHub.commentAmount), 106, cerp(0, 10, questHub.commentAmount), {true, false, false, false}) -- Quests Hub Background


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
    drawNPCProfilePic(thisX, thisY, 1, "left", quests[1][questHub.selectedQuest].profilePic)
    love.graphics.setFont(questHub.nameFont)
    love.graphics.printf(quests[1][questHub.selectedQuest].giver, thisX, thisY + 64 + 6, 64, "center") 
end

function drawQuestHubNPCTalk(thisX, thisY)
    if questHub.commentOpen and #quests[1] > 0 then
        love.graphics.setColor(0,0,0, questHub.commentOpacity * 0.7 )
        love.graphics.draw(questHub.images.npcTalkBG, thisX, thisY)
        love.graphics.setColor(1,1,1,questHub.commentOpacity)
        love.graphics.printf(quests[1][questHub.selectedQuest].comment, questHub.font, thisX + 8, thisY + 7, 127)
    end
end

function drawQuestHubMeters(thisX, thisY)
    for i = 1, 4 do
        drawQuestHubMetersBar(thisX + 2, thisY + (24 * (i-1)), i)
    end
end

function drawQuestHubMetersBar(thisX, thisY, i)
    
    local width = 222
    local isMouse = isMouseOver(thisX * scale, thisY * scale, width * scale, 19 * scale)
    if isMouse then love.graphics.setColor(0.1, 0.1, 0.1, 0.7 * questHub.opacity) else love.graphics.setColor(0,0,0,0.7 * questHub.opacity) end
    roundRectangle("fill", thisX, thisY, width, 19, 4)
    love.graphics.setColor(1,0,0,1)
    if quests[1][i] ~= null then
        if isMouse then
            love.graphics.setColor(0.88,0.6,0,1 *  questHub.opacity)
            questHub.hoveredQuest = i
            questHub.hover = true
        end
        if quests[1][i].currentAmount > 0 then -- draw a bar
            local table = {true, false, false, true}
            if quests[1][i].requiredAmount == quests[1][i].currentAmount then
                love.graphics.setColor(0, 0.7, 0, 1)
                table = {true, true, true, true}
            end
            roundRectangle("fill", thisX, thisY, width / quests[1][i].requiredAmount * quests[1][i].currentAmount, 19, 4, table)
        end
        love.graphics.setColor(1,1,1,1)    
        love.graphics.print(quests[1][i].task, questsPanel.commentFont, thisX + 7, thisY + 6)
        local text = quests[1][i].currentAmount .. "/" .. quests[1][i].requiredAmount
        love.graphics.print(text, questsPanel.commentFont, thisX + width - questsPanel.commentFont:getWidth(text) - 7, thisY + 6)
    end
    if questHub.selectedQuest == i then
        love.graphics.draw(questHub.images.arrow, thisX - 18, thisY - 1)
    end
end

function getQuestHubTextHeight(text, width)
	local width, lines = questHub.titleFont:getWrap(text, width)
 	return ((#lines)*(questHub.titleFont:getHeight()))+2
end