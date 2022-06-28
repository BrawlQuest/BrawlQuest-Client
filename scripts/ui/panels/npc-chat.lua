npcChatBackground = {"Grass", "Tree"}

showNPCChatBackground = false
npcChat = blacksmithChat
currentConversationStage = 1
currentConversationTitle = {}
currentConversationOptions = {}
activeConversations = {}
chatXpos = -64
chatOpacity = 0
nextChar = 0.1
chatWritten = ""
currentNPC = 0

npcChatSFX = {}

npcPitch = {
   ["assets/npc/Bartender.png"] = {40,80},
   ["assets/npc/Guard.png"] = {40,60},
   ["assets/npc/Blacksmith.png"] = {60,100},
   ["assets/npc/Citizen2.png"] = {40,70},
   ["assets/npc/Citizen3.png"] = {40,70},
   ["assets/npc/Dancing Man.png"] = {100,120},
   ["assets/npc/Kid.png"] = {150,180},
}

function initNPCChat()
    npcChatArg = {
        font = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 16),
        selectedOption = 0,
        hover = false,
        velY = 0,
        posY = 0,
        selectedResponse = 1,
    }
end

function createNPCChatBackground(x, y)
    npcChatBackground = {}
  
    npcChatBackground[1] = worldLookup[x..","..y].GroundTile

    local foundCollidable = false
    local currentX = x
    while not foundCollidable do
        if worldLookup[currentX..","..y] and worldLookup[currentX..","..y].Collision then
            npcChatBackground[2] = worldLookup[currentX..","..y].ForegroundTile
            foundCollidable = true
        end
        currentX = currentX + 1
    end
end

function drawNPCChatBackground(x, y)
    npcChatArg.selectedOption = 0
    npcChatArg.hover = false
    love.graphics.setColor(0.3, 0.3, 1)
    love.graphics.rectangle("fill", x, y, 256, 256)
    love.graphics.setColor(1, 1, 1)
    love.graphics.stencil(drawNPCChatStencil, "replace", 1) -- stencils inventory
    love.graphics.setStencilTest("greater", 0) -- push
        
        for i = -2, 2 do
            love.graphics.draw(getImgIfNotExist(npcChatBackground[2]), x + (i * 128) - chatXpos, y + 78, 0, 4, 4)
        end

        for i = -5, 5 do
            love.graphics.draw(getImgIfNotExist(npcChatBackground[1]), x + (i * 64) - chatXpos, y + 192, 0, 2, 2)
        end

       
        love.graphics.draw(getImgIfNotExist(npcChat.ImgPath), x + 128 - (chatXpos*2), y + (254 - worldImg[npcChat.ImgPath]:getWidth()*4) + 0, 0, 4, 4)

        love.graphics.setColor(1,1,1,chatOpacity)
        love.graphics.setFont(npcChatArg.font)
    love.graphics.setStencilTest() -- pop

    
    love.graphics.setColor(1, 1, 1)

    -- Scrolling the Text
    love.graphics.stencil(drawNPCChatTextStencil, "replace", 1) -- stencils inventory
    love.graphics.setStencilTest("greater", 0) -- push
    local height = 0
    if getTextHeight(chatWritten, 200, npcChatArg.font) > npcChatArg.font:getHeight() * 3 then
        height = npcChatArg.font:getHeight() * 1
    end
    love.graphics.printf(chatWritten, x + 10, y + 10 - scrollNPCChatText(chatWritten) , 200, "left")
    
    love.graphics.setStencilTest() -- pop
    love.graphics.rectangle("line", x, y, 256, 256)
    
    local ty = y + 100
    for i, v in pairs(npcChat.Options) do
        drawDialogueOption(x + 20 , ty + 0, v[1], i, i == npcChatArg.selectedResponse)
        ty = ty + getDialogueBoxHeight(v[1]) + 10
    end
end

function scrollNPCChatText(text)
    if getTextHeight(text, 200, npcChatArg.font) > npcChatArg.font:getHeight() * 4 then
        local height = (getTextHeight(text, 200, npcChatArg.font) - (npcChatArg.font:getHeight() * 4))
        if npcChatArg.posY < 0 then
            npcChatArg.posY = 0
            return height - 0
        elseif npcChatArg.posY > height then
            npcChatArg.posY = height
            return height
        else
            return height - npcChatArg.posY
        end
    else
        npcChatArg.posY = 0
        return 0
    end
end

function updateNPCChat(dt)
    chatXpos = chatXpos + 64*dt
    if chatXpos > 0 then
        chatOpacity = chatOpacity + 2*dt
        if chatOpacity > 1 then chatOpacity = 1 end
        nextChar = nextChar - 1 *dt
        if nextChar < 0 then
            
            if npcChat and #chatWritten ~= #npcChat.Title then
                -- if not npcChatSFX[string.sub(npcChat.Title,#chatWritten,#chatWritten)] then
                --     if love.filesystem.getInfo("assets/sfx/npc/speak/"..string.lower(string.sub(npcChat.Title,#chatWritten,#chatWritten))..".ogg") then
                --         npcChatSFX[string.sub(npcChat.Title,#chatWritten,#chatWritten)] = love.audio.newSource("assets/sfx/npc/speak/"..string.lower(string.sub(npcChat.Title,#chatWritten,#chatWritten))..".ogg", "static")
                --     end
                -- end
             --   if npcChatSFX[string.sub(npcChat.Title,#chatWritten,#chatWritten)] then
                --    speakSound = npcChatSFX[string.sub(npcChat.Title,#chatWritten,#chatWritten)]
                    speakSound:setPitch(love.math.random(100,110)/100)
                    speakSound:setVolume(0.05*sfxVolume)
                    if npcPitch[npcChat.ImgPath] then
                        speakSound:setPitch(love.math.random(npcPitch[npcChat.ImgPath][1],npcPitch[npcChat.ImgPath][2])/100)
                    else
                        speakSound:setPitch(love.math.random(20,200)/100)
                    end
                   
                  
            --    end
                speakSound:stop()
                speakSound:setRelative(true)
                setEnvironmentEffects(speakSound)
                speakSound:play()
                chatWritten = chatWritten..string.sub(npcChat.Title,#chatWritten+1,#chatWritten+1)
                if string.sub(npcChat.Title,#chatWritten,#chatWritten) == "." or string.sub(npcChat.Title,#chatWritten,#chatWritten) == "?" then
                    nextChar = 0.2
                elseif string.sub(npcChat.Title,#chatWritten,#chatWritten) == "," then
                    nextChar = 0.1
                elseif string.sub(npcChat.Title,#chatWritten,#chatWritten) == "!" then
                    nextChar = 0.5
                else
                    nextChar = 0.03
            end
            else
                nextChar = 0.03
            end
        end
        chatXpos = 0
    end
end

function drawDialogueOption(x, y, text, i, selected)
    local rHeight = getDialogueBoxHeight(text)
    local isMouse = isMouseOver(x*scale, y*scale, 133*scale, rHeight*scale)
    if isMouse then
        love.graphics.setColor(0.2, 0.2, 0.2, chatOpacity)
        npcChatArg.selectedOption = i
        npcChatArg.hover = true
    elseif selected then 
        love.graphics.setColor(1,1,1, chatOpacity)
    else
        love.graphics.setColor(0, 0, 0, chatOpacity)
    end
    love.graphics.rectangle("fill", x, y, 133, rHeight + 5)
    if selected and not isMouse then
        love.graphics.setColor(0, 0, 0, chatOpacity)
    else
        love.graphics.setColor(1, 1, 1, chatOpacity)
    end
    love.graphics.printf(text, x + 5, y + 5, 128, "left")
end

function getDialogueBoxHeight(text)
    local width, lines = npcChatArg.font:getWrap(text, 128)
    if #lines >= 1 then
        return ((#lines) * (npcChatArg.font:getHeight())) + 4
    else
        return npcChatArg.font:getHeight() + 4
    end
end

function checkNPCChatMousePressed(button)
    if button == 1 and npcChatArg.hover then
        continueConversation()
    end
end

function continueConversation()
    for i, v in pairs(npcChat.Options) do
        if npcChatArg.selectedOption == i then
            currentConversationStage = v[2]
            chatWritten = ""
            if v[2] == "1" then
                showNPCChatBackground = false
                npcChat.Title = ""
            else
                local b = {}
                print(api.url.."/conversation/"..v[2].."/"..username.."/"..currentNPC)
                c, h = http.request{url = api.url.."/conversation/"..v[2].."/"..username.."/"..currentNPC, method="GET", source=ltn12.source.string(body), headers={["token"]=token}, sink=ltn12.sink.table(b)}
                if b ~= nil then
                    npcChat = json:decode(table.concat(b))
                    if npcChat then
                        local optionString = npcChat.Options
                       optionString = string.gsub(optionString, "'s", 's')
                        optionString = string.gsub(optionString, "'t", 't')
                        optionString = string.gsub(optionString, "'ll", 'll')
                        optionString = string.gsub(optionString, "'ve", 've')
                        optionString =  string.gsub(optionString, "'", '"')
                        npcChat.Options = json:decode(optionString)
                    -- else
                    --     npcChat.options = {{"Okay", "1"},}
                    end
                    --npcChat.Options = json:decode(string.gsub(npcChat.Options, "'", '"'))
                end
            end
            break
        end
    end
end

function checkNPCChatKeyPressed(key)
    if key == "up" then
        npcChatArg.selectedResponse = math.clamp(1, npcChatArg.selectedResponse - 1, #npcChat.Options)
    elseif key == "down" then
        npcChatArg.selectedResponse = math.clamp(1, npcChatArg.selectedResponse + 1, #npcChat.Options)
    elseif key == "return" then
        npcChatArg.selectedOption = npcChatArg.selectedResponse
        continueConversation()
    elseif key == "space" then
        chatWritten = npcChat.Title
    end
end

function drawNPCChatIndicator()
    if distanceToPoint(player.x,player.y,3,-6) <= 1 or distanceToPoint(player.x,player.y,4,1) <= 1 or distanceToPoint(player.x,player.y,10,-16) <= 1  then
        love.graphics.setFont(npcChatArg.font)
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill",love.graphics.getWidth()/2-npcChatArg.font:getWidth("Press E to talk")/2,love.graphics.getHeight()/2+38,smallTextFont:getWidth("Press E to talk"),smallTextFont:getHeight())
        love.graphics.setColor(1,1,1)
        love.graphics.print("Press E to talk",love.graphics.getWidth()/2-npcChatArg.font:getWidth("Press E to talk")/2,love.graphics.getHeight()/2+38)
    end
end

function drawNPCChatStencil()
    love.graphics.rectangle("fill", (uiX/2) - 128, (uiY/2) - 128, 256, 256)
end

function drawNPCChatTextStencil()
    love.graphics.rectangle("fill", (uiX/2) - 128, (uiY/2) - 128, 256, 78)
end