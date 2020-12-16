function initQuestsPanel()
   
    questsPanel = {
        open = false,
        amount = 0,
        opacity = 0,
        questGiver = "Mortus the Wise",
        nameFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 8),
        titles = {"Tracking", "Backlog", "Completed",},
        spacing = 10,
    }
end


function drawQuestsPanel(thisX, thisY)
    love.graphics.setColor(1,1,1,questsPanel.opacity)
    love.graphics.setFont(inventory.headerFont)
    love.graphics.print("Quests", thisX + 8, thisY)
    love.graphics.setFont(inventory.font)
    for i = 1, #questsPanel.titles do
        love.graphics.print(questsPanel.titles[i], thisX + questsPanel.spacing, thisY + 40 + (20 * (i-1)))
    end
end