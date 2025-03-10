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
        velY = 0,
        posY = 0,
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
    end

    quests[1][1] = {
        title = "Welcome to BrawlQuest",
        comment = "Questing isn't in yet, but press Q to see some nifty goals to get you started.",
        giver =   "Drunk Man",
        profilePic = "assets/npc/Drunk Man.png",
        task = "Hover over this text",
        requiredAmount = 1,
        currentAmount = 1,
    }
    quests[2][1] = {
        title = "Start Fightin'",
        comment = "Head West from Squall's End to fight some monsters and try to get to Level 3!",
        giver =   "Drunk Man",
        profilePic = "assets/npc/Drunk Man.png",
        task = "Reach Level 3",
        requiredAmount = 3,
        currentAmount = 1,
    }
    quests[2][2] = {
        title = "Gear Up!",
        comment = "Speak to the Blacksmith in Squall's End and craft some Leather gear. Spiders drop string and Wolves drop Pelts.",
        giver =   "Drunk Man",
        profilePic = "assets/npc/Drunk Man.png",
        task = "Craft Leather Armour",
        requiredAmount = 1,
        currentAmount = 0,
    }
    quests[2][3] = {
        title = "A Noble Steed",
        comment = "Head deep into the forest to the West and find Carus who will tell you how to earn your first Mount. You might need to recruit others to help you with this one!",
        giver =   "Drunk Man",
        profilePic = "assets/npc/Drunk Man.png",
        task = "Get a Horse",
        requiredAmount = 1,
        currentAmount = 0,
    }
end

function updateQuestHub(dt)
    if isMouseOver((uiX - 468) * scale, (uiY - 102) * scale, 468 * scale, 102 * scale) and #quests[1] > 0 then -- Opens Comment
        panelMovement(dt, questHub,  1, "commentAmount")
    else
        panelMovement(dt, questHub, -1, "commentAmount")
    end

    if questHub.commentAmount > 0 and quests[1][questHub.selectedQuest] then
        local textHeight = getTextHeight(quests[1][questHub.selectedQuest].comment, 127, questHub.nameFont) -- questHub.images.npcTalkBG:getHeight()
        questHub.commentOpen = true 
        questHub.commentOpacity = cerp(0, 1, questHub.commentAmount)
        questHub.velY = questHub.velY - questHub.velY * math.min( dt * 15, 1 ) 
        questHub.posY = questHub.posY + questHub.velY * dt
        if questHub.posY > 0 then
            questHub.posY = 0
        elseif questHub.posY < -textHeight then
            questHub.posY = -textHeight
        end
    else questHub.commentOpen = false end

    if #quests[1] > 0 then
        panelMovement(dt, questHub, 1)
    else
        panelMovement(dt, questHub, -1)
    end

    if questHub.amount > 0 then questHub.open = true
        questHub.opacity = cerp(0, 1, questHub.amount)
    else questHub.open = false end

    local fieldHeight = getFullQuestsPanelFieldHeight()
    
    if questsPanel.forceOpen and not isTypingInChat then
        panelMovement(dt, questsPanel, 1)
        if fieldHeight * scale > (cerp((uiY/1.25) - 55,((uiY/1.25) - 106 - 14 - 55), questHub.amount)) * scale then
            posYQuest = posYQuest + velYQuest * dt
            local questsFieldHeight = 0 - fieldHeight + (cerp((uiY/1.25) - 55, ((uiY/1.25) - 106 - 14 - 55), questHub.amount))
            if posYQuest > 0 then
                posYQuest = 0
            elseif posYQuest < questsFieldHeight then
                posYQuest = questsFieldHeight
            end
        else posYQuest = 0
        end
    elseif not isTypingInChat and openQuestsOnHover and not crafting.open then
        if isMouseOver(((uiX/1) - 313) * scale, 
        ((uiY) + 55 - (uiY/1.25)) * scale,
        (313) * scale,
        (cerp((uiY/1.25) - 55 ,((uiY/1.25) - 106 - 14 - 55), questHub.amount)) * scale) then -- Opens Quests Panel
            panelMovement(dt, questsPanel, 1)
            if fieldHeight * scale > (cerp((uiY/1.25) - 55,((uiY/1.25) - 106 - 14 - 55), questHub.amount)) * scale then
                posYQuest = posYQuest + velYQuest * dt
                if posYQuest > 0 then posYQuest = 0
                elseif posYQuest < 0 - fieldHeight + (cerp((uiY/1.25) - 55, ((uiY/1.25) - 106 - 14 - 55), questHub.amount)) then
                    posYQuest = 0 - fieldHeight + (cerp((uiY/1.25) - 55, ((uiY/1.25) - 106 - 14 - 55), questHub.amount))
                end
            else posYQuest = 0
            end
        elseif not questsPanel.forceOpen then
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
    local x,y = thisX - 313 + 6, thisY - 106 - 14 - 15 - cerp(0, ((uiY/1.25) - 102), questsPanel.amount)
    if questHub.amount > 0 then
        love.graphics.draw(chatCorner, x, y, 0, 0.5)
        love.graphics.draw(chatCorner, x + 301, y, 0, -0.5, 0.5)
        love.graphics.rectangle("fill",x + 7, y, 301 - 14, 7)
        love.graphics.rectangle("fill",x, y + 7, 301, 8)
    end

    love.graphics.setColor(1,1,1,1 * questHub.opacity)
    thisX, thisY = thisX - 73, thisY - cerp(0, 100, questHub.amount)
    if #quests[1] > 0 then
        drawQuestHubProifle(thisX, thisY)
        if questHub.commentOpen then
            drawQuestHubNPCTalk(thisX - 150, thisY)
        end
    end
    drawQuestHubMeters(thisX - cerp(222 + 10, 371 + 10, questHub.commentAmount), thisY + 2)
end

function drawQuestHubProifle(thisX, thisY)
    if quests[1] and quests[1][questHub.selectedQuest] and quests[1][questHub.selectedQuest].profilePic and quests[1][questHub.selectedQuest].giver then
        drawNPCProfilePic(thisX, thisY, 1, "left", quests[1][questHub.selectedQuest].profilePic)
        love.graphics.setFont(questHub.nameFont)
        love.graphics.printf(quests[1][questHub.selectedQuest].giver, thisX, thisY + 64 + 6, 64, "center") 
    end
end

function drawQuestHubNPCTalk(thisX, thisY)
    if questHub.commentOpen and #quests[1] > 0 then
        love.graphics.setColor(0,0,0, questHub.commentOpacity * 0.7 )
        love.graphics.draw(questHub.images.npcTalkBG, thisX, thisY)
        love.graphics.setColor(1,1,1,questHub.commentOpacity)
        -- drawQuestHubNPCTalkStencil()
        love.graphics.stencil(drawQuestHubNPCTalkStencil, "replace", 1) -- stencils inventory
        love.graphics.setStencilTest("greater", 0) -- push
        if quests[1][questHub.selectedQuest] and quests[1][questHub.selectedQuest].comment then
            love.graphics.printf(quests[1][questHub.selectedQuest].comment, questHub.font, thisX + 8, thisY + 7 + questHub.posY, 127)
        end
        love.graphics.setStencilTest() -- pop
    end
end

function drawQuestHubNPCTalkStencil()
    love.graphics.rectangle("fill", uiX - 150 - 73, uiY - cerp(0, 100, questHub.amount), questHub.images.npcTalkBG:getWidth(), questHub.images.npcTalkBG:getHeight(), 5)
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
        love.graphics.print(quests[1][i].task, questsPanel.commentFont, thisX + 7, thisY + 3)
        local text = quests[1][i].currentAmount .. "/" .. quests[1][i].requiredAmount
        love.graphics.print(text, questsPanel.commentFont, thisX + width - questsPanel.commentFont:getWidth(text) - 7, thisY + 3)
    end
    if questHub.selectedQuest == i then
        love.graphics.draw(questHub.images.arrow, thisX - 18, thisY - 1)
    end
end

function getQuestHubTextHeight(text, width)
	local width, lines = questHub.titleFont:getWrap(text, width)
 	return ((#lines)*(questHub.titleFont:getHeight()))+2
end