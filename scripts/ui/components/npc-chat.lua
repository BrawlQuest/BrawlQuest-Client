npcChatBackground = {
    "Grass",
    "Tree"
}

showNPCChatBackground = false

npcChat = {
    name = "Bartender Fred",
    reputation = 1.0,
    conversation = {
        {
            title = "So you're the fella the King's Guard sent then, aye? About time...",
            options = {{"What's the issue?",2}, {"Cut the attitude. I'm here to help.",3,-0.2},},
        },
        {
            title = "My patrons have been complaining about a foul smell in the corner of my beer garden.",
            options = {
                {"How long has this been going on for?",4},
                {"Are you sure that isn't just other patrons?",5,0.2}
            },
        },
        {
            title = "I've been serving this town for 23 years. I'll take whatever attitude I want towards you lazy peons.",
            options = {
                {"You won't be getting any help from me, then.",1},
                {"Okay, okay, I'm sorry. What's the issue?",2}
            }
        },
        {
            title = "A few days now. Our garden backs off onto a forest and we'd investigate it ourselves but the spiders there are getting real viscious looking.",
            options = {
                {
                    "Spiders?",6
                },
                {
                    
                    "I'm on the case",1
                }
            }
        },
        {
            title = "Hah! It could well be.",
            options = {
                {"I'm on the case",1},
                {"How long ago did people notice the smell?",4}
            },
        },
        {
            title = "Spiders. Big ones, too.",
            options = {
                {"Does the King's Guard know?",7},
                {"How big can a spider really be?",8},
                {"Big man like yourself... I'm surprised you haven't just gone and squished em'.",9,-0.2}
            }
        },
        {
            title = "Er, well, no. News like that isn't great for business and as you know every monster report is made public knowledge.",
            options = {
                {
                    "With good reason! You're endagering the entire town!",10,-0.1
                },
                {
                    "Right... so these spiders. How big are they?",8
                }
            }
        },
        {
            title = "THEY'RE BIG! We aren't talking about no cup and paper throw away insects here.",
            options = {
                {
                    "Technically spiders are arachnids, not insects.",
                    11,
                    -0.2
                },
                {
                    "I see. I guess I'll grab a sword and take a look, then.",
                    1,
                }
            }
        },
        {
            title = "BIG MAN? How dare you. My wife cooks delicious pies, what am I meant to do? 'Big man'. Good grief.",
            options = {
                {"He said, belly jiggling.",
                11,
                -0.3},
                {
                    "I'm sure she does. So these spiders are pretty big then?",
                    8,
                }
            },
        },
        {
            title = "A TOWN THAT I HELPED BUILD! You younguns can barely even hope to understand the history of this place.",
            options = {
                {"Fair comment, really. So these spiders are rather large then?",8,0.1},
                    {"Oh, please. You contribute nothing but booze. I bet you couldn't even begin to explain how to build a house.",11,-0.3}
            }
        },
        {
            title = "And now you insult my intelligence. Great. You know what: nevermind, I'll deal with it myself.",
            options = {
                {
                    "Righto.",1
                }
            }
        },
        {
            title = "The King's Guard really are letting anyone be an adventurer now, aren't they? Manners notwithstanding.",
            {
                options = {
                    {
                        "Listen, fatty, just tell me how big those spiders are.",
                        8
                    }
                }
            }
        }
    }
}

currentConversationStage = 1
currentConversationTitle = {}
currentConversationOptions = {}

function createNPCChatBackground(x,y)
    npcChatBackground = {}
    local foundX = false
    local pathAhead = {}
    for i,v in pairs(world) do
        if v.X == x and v.Y == y then
            npcChatBackground[1] = v.GroundTile
        elseif v.Y == y and v.X > x then
            pathAhead[#pathAhead+1] = v
        end
    end
    table.sort(pathAhead, function(a,b) return a.X < b.X end)

    for i,v in ipairs(pathAhead) do
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

    for i,v in ipairs(npcChatBackground) do
        if not worldImg[v] then
            if love.filesystem.getInfo(v) then
                worldImg[v] = love.graphics.newImage(v)
            else
                worldImg[v] = love.graphics.newImage("assets/error.png")
            end
        end
    end
end

function drawNPCChatBackground(x,y)
    love.graphics.setColor(0.3,0.3,1)
    love.graphics.rectangle("fill",x,y,256, 256)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line",x,y,256,256)

    for i = 0, 1 do
        love.graphics.draw(worldImg[npcChatBackground[2]],x+(i*128),y+78,0,4,4)
    end

    for i = 0,3 do
        love.graphics.draw(worldImg[npcChatBackground[1]],x+(i*64),y+192,0,2,2)
    end

    love.graphics.draw(bartenderImg,x+128,y+126,0,4,4)
    love.graphics.setFont(smallTextFont)
    love.graphics.printf(npcChat.conversation[currentConversationStage].title,x+10,y+10,200,"left")
    local ty = y+125
    for i,v in pairs(npcChat.conversation[currentConversationStage].options) do
        drawDialogueOption(x+20,ty,v[1])
        ty = ty + getDialogueBoxHeight(v[1])+10
    end
    
    love.graphics.setColor(0,0.4+((npcChat.reputation/1)*0.4),0)
    love.graphics.rectangle("fill",x+128,y+100,120,smallTextFont:getHeight()+4)
    love.graphics.setColor(1,1,1)
    love.graphics.printf("Reputation: "..npcChat.reputation, x+128,y+102,120,"center")
end


function drawDialogueOption(x,y,text)
    local rHeight = getDialogueBoxHeight(text)
    if isMouseOver(x,y,133,rHeight) then
        love.graphics.setColor(0.2,0.2,0.2,1)
    else
        love.graphics.setColor(0,0,0,1)
    end
    love.graphics.rectangle("fill",x,y,133,rHeight+5)
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf(text,x+5,y+5,128,"left")
end

function getDialogueBoxHeight(text)
    local width, lines = smallTextFont:getWrap( text, 128 )
	if #lines >= 1 then
	 	return ((#lines)*(smallTextFont:getHeight()))+2
	else
		return smallTextFont:getHeight()+2
    end
end

function checkNPCChatMousePressed()
    tx,ty = love.graphics.getWidth()/2-128+20,love.graphics.getHeight()/2-128+125
   
        for i,v in pairs(npcChat.conversation[currentConversationStage].options) do     
            local rHeight = getDialogueBoxHeight(v[1])  
            if isMouseOver(tx,ty,133,rHeight+5) then
                currentConversationStage = v[2]
                if v[3] then
                    npcChat.reputation = npcChat.reputation + v[3]
                end
            end
            ty = ty + getDialogueBoxHeight(v[1])+10
        end
 
end