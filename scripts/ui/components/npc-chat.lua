npcChatBackground = {"Grass", "Tree"}

showNPCChatBackground = false



-- bartenderNPCChat = {
--     name = "Bartender Fred",
--     img = "assets/npc/Bartender.png",
--     reputation = 1.0,
--     conversation = {{
--         title = "So you're the fella the King's Guard sent then, aye? About time...",
--         options = {{"What's the issue?", 2}, {"Cut the attitude. I'm here to help.", 3, -0.2}}
--     }, {
--         title = "My patrons have been complaining about a foul smell in the corner of my beer garden.",
--         options = {{"How long has this been going on for?", 4}, {"Are you sure that isn't just other patrons?", 5, 0.2}}
--     }, {
--         title = "I've been serving this town for 23 years. I'll take whatever attitude I want towards you lazy peons.",
--         options = {{"You won't be getting any help from me, then.", 1}, {"Okay, okay, I'm sorry. What's the issue?", 2}}
--     }, {
--         title = "A few days now. Our garden backs off onto a forest and we'd investigate it ourselves but the spiders there are getting real viscious looking.",
--         options = {{"Spiders?", 6}, {"I'm on the case", 1}}
--     }, {
--         title = "Hah! It could well be.",
--         options = {{"I'm on the case", 1}, {"How long ago did people notice the smell?", 4}}
--     }, {
--         title = "Spiders. Big ones, too.",
--         options = {{"Does the King's Guard know?", 7}, {"How big can a spider really be?", 8},
--                    {"Big man like yourself... I'm surprised you haven't just gone and squished em'.", 9, -0.2}}
--     }, {
--         title = "Er, well, no. News like that isn't great for business and as you know every monster report is made public knowledge.",
--         options = {{"With good reason! You're endagering the entire town!", 10, -0.1},
--                    {"Right... so these spiders. How big are they?", 8}}
--     }, {
--         title = "THEY'RE BIG! We aren't talking about no cup and paper throw away insects here.",
--         options = {{"Technically spiders are arachnids, not insects.", 11, -0.2},
--                    {"I see. I guess I'll grab a sword and take a look, then.", 1}}
--     }, {
--         title = "BIG MAN? How dare you. My wife cooks delicious pies, what am I meant to do? 'Big man'. Good grief.",
--         options = {{"He said, belly jiggling.", 11, -0.3},
--                    {"I'm sure she does. So these spiders are pretty big then?", 8}}
--     }, {
--         title = "A TOWN THAT I HELPED BUILD! You younguns can barely even hope to understand the history of this place.",
--         options = {{"Fair comment, really. So these spiders are rather large then?", 8, 0.1},
--                    {"Oh, please. You contribute nothing but booze. I bet you couldn't even begin to explain how to build a house.",
--                     11, -0.3}}
--     }, {
--         title = "And now you insult my intelligence. Great. You know what: nevermind, I'll deal with it myself.",
--         options = {{"Righto.", 1}}
--     }, {
--         title = "The King's Guard really are letting anyone be an adventurer now, aren't they? Manners notwithstanding.",
--         {
--             options = {{"Listen, fatty, just tell me how big those spiders are.", 8}}
--         }
--     }}}

-- mortusNPCChat = {
--     img = "assets/npc/Mortus.png",
--     reputation = 10.0,
--     conversation = {{
--         title = "Hey rookie. How can I help?",
--         options = {{"Heard any rumours?", 2}, {"Why do the targets yell at me?", 3}}
--     }, {
--         title = "Rumours? How cliché. Bartender Fred has been asking after someone from the King's Guard for a few days now. You could check that out?",
--         options = {{"King's Guard? But I'm not King's Guard.", 4}, {"Alright. Anything to tell about him?", 5}}
--     }, {
--         title = "They say that the souls of those who could've been saved if only they spent more time practicing their swordsmanship haunt those wooden structures.",
--         options = {{"Er... do you believe that?", 6}}
--     }, {
--         title = "Yeah, but he won't know that. The King's Guard are focused on the bandit raids right now. We can't be dealing with some boozy publican.",
--         options = {{"Boozey, is he?", 5}}
--     }, {
--         title = "Sort of. He has a fairly nasty temper and is especially sensitive about his weight.",
--         options = {{"Don't mention the beer gut. Got it.", 1}}
--     }, {
--         title = "Nah. The truth is that we cast some spells on them to make them yell like a real monster would. Strikes fear into the hearts of gullible rookies.",
--         options = {{"Who are you calling gullible?", 7}, {"Oh, haha, er, yeah, of course...", 1}},
--     }, {
--         title = "Chill out, rookie. You can't say it didn't make you jump the first time you heard it.",
--         options = {{"As a matter of fact it didn't!", 8, -0.1}, {"Alright, fair enough, you got me.", 1, 0.1},
--                    {"Meh.", 1}}
--     }, {
--         title = "Listen. If you want to get ahead here you've got to at least try and get on with me.",
--         options = {{"Well maybe I don't want to get along with you.", 9, -100},
--                    {"My apologies. I WAS scared the first time. I'm just trying to be tough.", 1, 0.1}}
--     },
-- {
--     title = "I guess not everyone can be succesful. Stay out of my way, kid.",
--     options = {}
-- }}
-- }


-- blacksmithChat = {
--     img = "assets/npc/Blacksmith.png",
--     reputation = 1.0,
--     conversation = {
--         {
--             title = "King's Guard making you craft your own tools now, are they? Or are you here to pay my last invoice?",
--             options = {
--                 {
--                     "I'm not King's Guard.",
--                     2,
--                 },
--                 {
--                     "King's Guard owe you money?",
--                     3,
--                 },
--             },
--         },
--         {
--             title = "Ah, well that's a shame. How can I help you, then?",
--                 options = {
--                     {
--                         "I'm interested in learning about blacksmithing.",
--                         4,
--                     },
--                     {
--                         "Bartender Fred is worried about some nasty smells.",
--                         5,
--                     }
--                 }
--         },
--         {
--             title = "When do they not? I bless them for their protection against the horrors outside of our wall but they sure aren't great at paying for the things they order.",
--                 options = {
--                     {"How much are you down?",
--                     6,},
--                     {
--                         "Well, sorry to say that I'm no Kings Guard.",
--                         2,
--                     }
--                 }
--         },
--         {
--             title = "Well then! That's great to hear. Well, given my fiscal situation with the King's Guard you're going to need to gather your own supplies. Bring me some stone and wood and I'll teach you to craft.",
--             options = {
--               {  "Stone and wood? Got it.",1}
--             }
--         },
--         {
--             title = "Smells? Hah! He isn't complaining about my ovens, that's for sure. Fred loves them. I should know: I was his best man. Sorry pal, but you're in the wrong place if you're investigating the stench of his beer garden.",
--             options = {
--                { "Ah. Sorry.",1}
--             }
--         },
--         {
--             title = "Years of work, now. Years.",
--             options = {
--                 {"Sorry to hear it. Is there any way I can help?",7},
--                 {"Sad to hear it, pal.",7}
--             }
--         },
--         {
--             title = "It wouldn't be quite so hard if I had more apprentices to teach up. It'd lessen the burden significantly, that's for sure.",
--             options = {
--                 {
--                     "Apprentices? I'd be open to learning about blacksmithing!",4
--                 },
--                 {
--                     "That makes sense. Sad to say I don't know anyone interested in weapon forging.",8,
--                 }
--             }
--         },
--         {
--             title = "Aye, no worries pal. If you ever do... you know who to come to.",
--                 options = {
--                     {
--                         "Got it.",1
--                     }
--                 }
--         }
--     }
-- }
npcChat = blacksmithChat
currentConversationStage = 1
currentConversationTitle = {}
currentConversationOptions = {}

function createNPCChatBackground(x, y)
    npcChatBackground = {}
    local foundX = false
    local pathAhead = {}
    for i, v in pairs(world) do
        if v.X == x and v.Y == y then
            npcChatBackground[1] = v.GroundTile
        elseif v.Y == y and v.X > x then
            pathAhead[#pathAhead + 1] = v
        end
    end
    table.sort(pathAhead, function(a, b)
        return a.X < b.X
    end)

    for i, v in ipairs(pathAhead) do
        if v.Collision and not foundX then
            npcChatBackground[2] = v.ForegroundTile
            break
        end
    end

    if npcChatBackground[1] == nil then
        npcChatBackground[1] = "assets/world/grounds/grass.png"
    end
    if npcChatBackground[2] == nil then
        npcChatBackground[2] = "none"
    end

    for i, v in ipairs(npcChatBackground) do
        if not worldImg[v] then
            if love.filesystem.getInfo(v) then
                worldImg[v] = love.graphics.newImage(v)
            else
                worldImg[v] = love.graphics.newImage("assets/error.png")
            end
        end
    end
end

function drawNPCChatBackground(x, y)
    love.graphics.setColor(0.3, 0.3, 1)
    love.graphics.rectangle("fill", x, y, 256, 256)
    love.graphics.setColor(1, 1, 1)

    for i = 0, 1 do
        love.graphics.draw(worldImg[npcChatBackground[2]], x + (i * 128), y + 78, 0, 4, 4)
    end

    for i = 0, 3 do
        love.graphics.draw(worldImg[npcChatBackground[1]], x + (i * 64), y + 192, 0, 2, 2)
    end

    if not worldImg[npcChat.ImgPath] then
        if love.filesystem.getInfo(npcChat.ImgPath) then
            worldImg[npcChat.ImgPath] = love.graphics.newImage(npcChat.ImgPath)
        else
            worldImg[npcChat.ImgPath] = love.graphics.newImage("assets/error.png")
        end
    end
    love.graphics.draw(worldImg[npcChat.ImgPath], x + 128, y + 126, 0, 4, 4)
    love.graphics.setFont(smallTextFont)
    love.graphics.printf(npcChat.Title, x + 10, y + 10, 200, "left")
    local ty = y + 125
    for i, v in pairs(npcChat.Options) do
        drawDialogueOption(x + 20, ty, v[1])
        ty = ty + getDialogueBoxHeight(v[1]) + 10
    end

    -- love.graphics.setColor(0, 0.4 + ((npcChat.reputation / 1) * 0.4), 0)
    -- love.graphics.rectangle("fill", x + 128, y + 100, 120, smallTextFont:getHeight() + 4)
    -- love.graphics.setColor(1, 1, 1)
    -- love.graphics.printf("Reputation: " .. npcChat.reputation, x + 128, y + 102, 120, "center")

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x, y, 256, 256)
end

function drawDialogueOption(x, y, text)
    local rHeight = getDialogueBoxHeight(text)
    if isMouseOver(x, y, 133, rHeight) then
        love.graphics.setColor(0.2, 0.2, 0.2, 1)
    else
        love.graphics.setColor(0, 0, 0, 1)
    end
    love.graphics.rectangle("fill", x, y, 133, rHeight + 5)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(text, x + 5, y + 5, 128, "left")
end

function getDialogueBoxHeight(text)
    local width, lines = smallTextFont:getWrap(text, 128)
    if #lines >= 1 then
        return ((#lines) * (smallTextFont:getHeight())) + 2
    else
        return smallTextFont:getHeight() + 2
    end
end

function checkNPCChatMousePressed()
    tx, ty = love.graphics.getWidth() / 2 - 128 + 20, love.graphics.getHeight() / 2 - 128 + 125
    local hasMovedOn = false
    for i, v in pairs(npcChat.Options) do
        if not hasMovedOn then
            local rHeight = getDialogueBoxHeight(v[1])
            if isMouseOver(tx, ty, 133, rHeight + 5) then
                currentConversationStage = v[2]
                if v[2] == "1" then
                    showNPCChatBackground = false
                else
                    local b = {}
                    c, h = http.request{url = api.url.."/conversation/"..v[2].."/"..username, method="GET", source=ltn12.source.string(body), headers={["token"]=token}, sink=ltn12.sink.table(b)}
                    npcChat = json:decode(b[1])
                    npcChat.Options = json:decode(string.gsub(npcChat.Options, "'", '"'))
                end
            end
        end
        ty = ty + getDialogueBoxHeight(v[1]) + 10
    end

end

function drawNPCChatIndicator()
    if distanceToPoint(player.x,player.y,3,-6) <= 1 or distanceToPoint(player.x,player.y,4,1) <= 1 or distanceToPoint(player.x,player.y,10,-16) <= 1  then
        love.graphics.setFont(smallTextFont)
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill",love.graphics.getWidth()/2-smallTextFont:getWidth("Press E to talk")/2,love.graphics.getHeight()/2+38,smallTextFont:getWidth("Press E to talk"),smallTextFont:getHeight())
        love.graphics.setColor(1,1,1)
        love.graphics.print("Press E to talk",love.graphics.getWidth()/2-smallTextFont:getWidth("Press E to talk")/2,love.graphics.getHeight()/2+38)
    end
end