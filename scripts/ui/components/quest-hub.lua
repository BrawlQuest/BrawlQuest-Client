function initQuestHub()
    quests = {
        open = false,
        amount = 0,
        questGiver = "Mortus the Wise",
        nameFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 8),
    }

    questHub = {
        open = false,
        amount = 0,
        images = {
            npcTalkBG = love.graphics.newImage("assets/ui/hud/quest-hub/npcTalkBG.png")
        },
    }

end

function updateQuestHub(dt)
    if isMouseOver((uiX - 468) * scale, (uiY - 102) * scale, 468 * scale, 102 * scale) then
        questHub.open = true
        questHub.amount = questHub.amount + 4 * dt
        if questHub.amount > 1 then questHub.amount = 1 end
    else
        questHub.open = false
        questHub.amount = questHub.amount - 4 * dt
        if questHub.amount < 0 then questHub.amount = 0 end
    end
    -- print(questHub.amount)

    if isMouseOver((uiX - 313) * scale, (0) * scale, 313 * scale, (uiY - 97) * scale) then
        quests.open = true
        quests.amount = quests.amount + 4 * dt
        if quests.amount > 1 then quests.amount = 1 end
    else
        quests.open = false
        quests.amount = quests.amount - 4 * dt
        if quests.amount < 0 then quests.amount = 0 end
    end
    -- print(quests.amount)
end

function drawQuestHub(thisX, thisY) 
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", thisX, thisY - 102, -313, cerp(-18, 0 - ((uiY/1.25) - 102), quests.amount))
    love.graphics.rectangle("fill", thisX, thisY, cerp(-313, -468, questHub.amount), -102)
    love.graphics.setColor(1,1,1,1)

    drawQuestHubProifle(thisX, thisY)
    thisX, thisY = thisX - 223, thisY - 100
    drawQuestHubNPCTalk(thisX, thisY)
end

function drawQuestHubProifle(thisX, thisY)
    if me.Name ~= null then drawProfilePic(thisX - 73, thisY - 100, 1, "left", me.Name) end
    love.graphics.setFont(quests.nameFont)
    love.graphics.printf(quests.questGiver, thisX - 73, thisY - 35 + 6, 64, "center") 
end

function drawQuestHubNPCTalk(thisX, thisY)
    love.graphics.draw(questHub.images.npcTalkBG, thisX, thisY)
end