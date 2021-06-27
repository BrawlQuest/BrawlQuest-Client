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
    local foundX = false
    local pathAhead = {}
    for key,tiles in next, worldChunks do
        for i,v in ipairs(tiles) do
            if v.X == x and v.Y == y then npcChatBackground[1] = v.GroundTile
            elseif v.Y == y and v.X > x then pathAhead[#pathAhead + 1] = v end
        end
    end

    table.sort(pathAhead, function(a, b) return a.X < b.X end)

    for i, v in ipairs(pathAhead) do
        if v.Collision and not foundX then
            if string.find(v.ForegroundTile, "walls", 13) then
            else
                npcChatBackground[2] = v.ForegroundTile
                -- print(npcChatBackground[2])
                break
            end 
        end
    end

    if npcChatBackground[1] == nil then
        npcChatBackground[1] = "assets/world/grounds/grass.png"
    end
    if npcChatBackground[2] == nil then
        npcChatBackground[2] = "none"
    end

    -- for i, v in ipairs(npcChatBackground) do
    --     if not worldImg[v] then
    --         if love.filesystem.getInfo(v) then
    --             worldImg[v] = love.graphics.newImage(v)
    --         else
    --             worldImg[v] = love.graphics.newImage("assets/error.png")
    --         end
    --     end
    -- end
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
            love.graphics.draw(worldImg[npcChatBackground[2]], x + (i * 128) - chatXpos, y + 78, 0, 4, 4)
        end

        for i = -5, 5 do
            love.graphics.draw(worldImg[npcChatBackground[1]], x + (i * 64) - chatXpos, y + 192, 0, 2, 2)
        end

        if not worldImg[npcChat.ImgPath] then
            if love.filesystem.getInfo(npcChat.ImgPath) then
                worldImg[npcChat.ImgPath] = love.graphics.newImage(npcChat.ImgPath)
            else
                worldImg[npcChat.ImgPath] = love.graphics.newImage("assets/error.png")
            end
        end
        love.graphics.draw(worldImg[npcChat.ImgPath], x + 128 - (chatXpos*2), y + (254 - worldImg[npcChat.ImgPath]:getWidth()*4) + 0, 0, 4, 4)

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
                -- if npcChatSFX[string.sub(npcChat.Title,#chatWritten,#chatWritten)] then
                --    -- speakSound:stop()
                --     speakSound = npcChatSFX[string.sub(npcChat.Title,#chatWritten,#chatWritten)]
                --     speakSound:setPitch(love.math.random(20,200)/100)
                --     speakSound:setVolume(0.3*sfxVolume)
                --     npcChatSFX[string.sub(npcChat.Title,#chatWritten,#chatWritten)]:setPitch(love.math.random(20,200)/100)
                --     npcChatSFX[string.sub(npcChat.Title,#chatWritten,#chatWritten)]:play()
                --     -- speakSound:play()
                -- end
              --  speakSound:stop()
                speakSound:setPitch(love.math.random(60,100)/100)
                speakSound:setRelative(true)
                speakSound:setVolume(0.1*sfxVolume)
                setEnvironmentEffects(speakSound)
                speakSound:play()
                chatWritten = chatWritten..string.sub(npcChat.Title,#chatWritten+1,#chatWritten+1)
                if string.sub(npcChat.Title,#chatWritten,#chatWritten) == "." or string.sub(npcChat.Title,#chatWritten,#chatWritten) == "?" then
                    nextChar = 0.3
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
                c, h = http.request{url = api.url.."/conversation/"..v[2].."/"..username.."/"..currentNPC, method="GET", source=ltn12.source.string(body), headers={["token"]=token}, sink=ltn12.sink.table(b)}
                if b ~= nil then
                    npcChat = json:decode(table.concat(b))
                    local optionString = npcChat.Options
                 --   optionString = string.gsub(optionString, "'s", 's')
                    optionString = string.gsub(optionString, "'t", 't')
                    optionString = string.gsub(optionString, "'ll", 'll')
                    optionString = string.gsub(optionString, "'ve", 've')
                    optionString =  string.gsub(optionString, "'", '"')
                    npcChat.Options = json:decode(optionString)
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