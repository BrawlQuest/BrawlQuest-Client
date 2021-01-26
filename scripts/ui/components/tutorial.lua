tutorial = {
    {
        title = "Welcome to BrawlQuest!",
        desc = "Thanks for playing BrawlQuest in Early Access. There's still a lot of polish to be added and exciting features on their way, but as a 2 person team it means a lot that you've put your trust in the game this early.",
    },
    {
        title = "Moving & Attacking",
        desc = "Press "..keybinds.UP..", "..keybinds.LEFT..", "..keybinds.DOWN.." and "..keybinds.RIGHT.." to move, and hold "..keybinds.ATTACK_UP..", "..keybinds.ATTACK_LEFT..", "..keybinds.ATTACK_DOWN.." and "..keybinds.ATTACK_RIGHT.." to attack.",
    },
    {
        title = "Questing & NPCs",
        desc = "When standing near an NPC press "..keybinds.INTERACT.." to speak to them. Some NPCs offer quests, some just fancy a chat and others are trying to sell you things.\n\nPress E to view your active quests. You can pin a quest to your HUD by clicking the..next to the quest's name.",
    },
    {
        title = "Inventory Management",
        desc = "Press Q to open your inventory or hover the mouse over the left side of the screen. Items stack infinitely and there's no limit to how many items you can hold.\n\nPress 1 - 7 on the keyboard whilst hovering over an item to add it to your quick select bar for easy access.",
    },
    {
        title = "You've levelled up!",
        desc = "Everytime you level up you gain character points which can be spent in STR, INT or STA. Hover over your character window to spend these points.\n\nSTR increases your melee attack potential. INT increases your mana recovery rate and the effects of spells. STA increases your maximum health.\n\nYou can adjust these values at any time out of combat by right clicking on the stat you want to alter.",
    }
}

tutorialFont = {
    love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 48),
    love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 24)
}
tutorialActive = 1
tutorialOpen = false
tutorialOpacity = 0
tutorialCompleted = {}

function initTutorial()
    if love.filesystem.getInfo("tutorial.txt") then
        contents, size = love.filesystem.read("string", "tutorial.txt")
        contents = json:decode(contents)
        tutorialCompleted = contents["tutorial"]
    else
        closeTutorial(0)
    end
end

function drawTutorial()
    love.graphics.setColor(0,0,0,tutorialOpacity*0.8)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setFont(tutorialFont[1])
    love.graphics.setColor(1,1,1,tutorialOpacity)
    love.graphics.printf(tutorial[tutorialActive].title,40,love.graphics.getHeight()/3,love.graphics.getWidth()-40,"center")
    love.graphics.setFont(tutorialFont[2])
    love.graphics.printf(tutorial[tutorialActive].desc.."\n\nPress ENTER to continue",40,(love.graphics.getHeight()/3)*2,love.graphics.getWidth()-40,"center")
end

function updateTutorial(dt)
    if tutorialOpen then
        tutorialOpacity = tutorialOpacity + 0.5*dt
        if tutorialOpacity > 1 then
            tutorialOpacity = 1 
        end
    else
        tutorialOpacity = tutorialOpacity - 2*dt
        if tutorialOpacity < 0 then
            tutorialOpacity = 0 
        end
    end
end

function checkTutorialKeyPressed(key)
    if key == "return" then
        closeTutorial(tutorialActive)
    end
end

function openTutorial(i)
    if not arrayContains(tutorialCompleted, i) then
        tutorialActive = i
        tutorialOpen = true
    end
end

function closeTutorial(i)
    tutorialCompleted[#tutorialCompleted+1] = i
    success,msg = love.filesystem.write("tutorial.txt", json:encode({tutorial = tutorialCompleted}))
    tutorialOpen = false
    if i == 1 then
        tutorialOpen = true
        tutorialActive = 2
    end
end