tutorial = {
    {
        title = "Welcome to BrawlQuest!",
        desc = "Thanks for playing BrawlQuest in Early Access. There's still a lot of polish to be added and exciting features on their way, but as a 2 person team it means a lot that you've put your trust in the game this early.",
    },
    {
        title = "Moving & Attacking",
        desc = "Press "..keybinds.UP..", "..keybinds.LEFT..", "..keybinds.DOWN.." and "..keybinds.RIGHT.." to move, and "..keybinds.ATTACK_UP..", "..keybinds.ATTACK_LEFT..", "..keybinds.ATTACK_DOWN.." and "..keybinds.ATTACK_RIGHT.." to attack.",
    },
    {
        title = "What is there to do?",
        desc = "BrawlQuest is all about existing in our world and just vibing. If you walk in any direction you're sure to find something to do or a challenge to overcome, and that's the whole point.\n\nAs a beginner we suggest finding a friend or two and fighting monsters in the forest to the West of the spawn town."
    },
    {
        title = "READ THIS: Beta Advice",
        desc = "You're playing a Beta version of the game. It's really important that you let us know how you feel about it and report any problems you encounter.\n\nThere are forums to do this on the Steam Community Hub. Please go there and let us know what you like, hate and when things break.\n\nThere will be a new update every few days!"
    },
    {
        title = "Questing & NPCs",
        desc = "When standing near an NPC press "..keybinds.INTERACT.." to speak to them. Some NPCs offer quests, some just fancy a chat and others are trying to sell you things.\n\n",
    },
    {
        title = "Inventory Management",
        desc = "Press "..keybinds.INVENTORY.." to open your inventory or hover the mouse over the left side of the screen. Items stack infinitely and there's no limit to how many items you can hold.\n\nPress 1 - 7 on the keyboard whilst hovering over an item to add it to your quick select bar for easy access.",
    },
    {
        title = "You've levelled up!",
        desc = "Everytime you level up you gain character points which can be spent in STR, INT or STA. Hover over your character window to spend these points.\n\nSTR increases your melee attack potential. INT increases your mana recovery rate and the effects of spells. STA increases your maximum health.\n\nYou can adjust these values at any time out of combat by right clicking on the stat you want to alter.",
    },
    {
        title = "Death",
        desc = "When you die you will re-awaken at the nearest graveyard. At Level 10 you will lose a level everytime you die so BE CAREFUL!"
    },
    {
        title = "Crafting",
        desc = "We aren't explicit about crafting recipes. This is intentional.\n\nExperiment with throwing different reagents into the system and pressing down on that hammer. You never know: you might be the first to uncover a crafting recipe!"
    },
    {
        title = "Attacking",
        desc = "Remember to press "..keybinds.ATTACK_UP..", "..keybinds.ATTACK_LEFT..", "..keybinds.ATTACK_DOWN.." and "..keybinds.ATTACK_RIGHT.." to attack.",
    },
    {
        title = "Welcome to Foundation Forest!",
        desc = "You can place down Wall, Floor and Furniture objects in Foundation Forest. There ISN'T currently a way of destroying walls, so if you get stuck press ESC -> Respawn!"
    }
}

tutorialFont = {
    love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 48),
    love.graphics.newFont("assets/ui/fonts/rainyhearts.ttf", 24)
}
tutorialActive = 1
tutorialOpen = false
tutorialOpacity = 0
pressEnterOpacity = 0
pressEnterGoUp = true
tutorialCompleted = {}
tutorialQuickTriggers = { -- these are reduce by 1 every second, and trigger a tutorial if they hit 0 while active
 
}

function initTutorial()
    if love.filesystem.getInfo("tutorial.txt") then
        local contents, size = love.filesystem.read("string", "tutorial.txt")
        contents = json:decode(contents)
        tutorialCompleted = contents["tutorial"]
    else
        closeTutorial(0)
    end
end

function drawTutorial()
    love.graphics.setColor(0,0,0,tutorialOpacity*0.8)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setFont(enchanting.font)
    love.graphics.setColor(1,1,1,tutorialOpacity)
    local w, h = love.graphics.getWidth() - 200, 10
    local x, y = 100, love.graphics.getHeight()/2 - getTextHeight(tutorial[tutorialActive].title, w, enchanting.font, h) / 1.5 - getTextHeight(tutorial[tutorialActive].desc, w, enchanting.font, 3) / 2
    love.graphics.printf(tutorial[tutorialActive].title, x, y, w / h, "center", 0, h)
    y = y + getTextHeight(tutorial[tutorialActive].title, w, enchanting.font, h) + 20
    love.graphics.printf(tutorial[tutorialActive].desc, x, y, w / 3, "center", 0, 3)
    love.graphics.setColor(1,0,0,pressEnterOpacity*tutorialOpacity)
    y = y + getTextHeight(tutorial[tutorialActive].desc, w, enchanting.font, 3) + 20
    love.graphics.printf("Press ENTER to continue", x, y, w / 3,"center", 0, 3)
end

function updateTutorial(dt)
    if tutorialOpen then
        if pressEnterGoUp then
            pressEnterOpacity = pressEnterOpacity + 2*dt
            if pressEnterOpacity > 2 then
                pressEnterGoUp = false
            end
        else
            pressEnterOpacity = pressEnterOpacity - 2*dt
            if pressEnterOpacity < 0 then
                pressEnterGoUp = true
            end
        end
                
        tutorialOpacity = tutorialOpacity + 2*dt
        if tutorialOpacity > 1 then
            tutorialOpacity = 1 
        end
    else
        tutorialOpacity = tutorialOpacity - 2*dt
        if tutorialOpacity < 0 then tutorialOpacity = 0 end
    end

    for i, v in pairs(tutorialQuickTriggers) do
        if v.active then
            v.duration = v.duration - 1*dt
            if v.duration < 0 then
                --tutorialOpen = true
                openTutorial(v.trigger)
                
                v.active = false
            end
        end
        tutorialQuickTriggers[i] = v
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
    elseif i == 2 then
        tutorialOpen = true
        tutorialActive = 3
    elseif i == 3 then
        tutorialOpen = true
        tutorialActive = 4
    end
end