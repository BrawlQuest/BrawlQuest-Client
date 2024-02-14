npcs = {}
npcsDrawable = {}
npcImg = {}

function drawNPCs()
    for i, v in pairs(npcsDrawable) do
        local distance = distanceToPoint(player.cx, player.cy, v.x, v.y)
        local range = worldMask.range * 32
        if distance <= range then
            local intensity = 1 - (range / (range + difference(range, distance) * 4) - 0.2)
            if not worldImg[v.imgpath] then
                if love.filesystem.getInfo(v.imgpath) then
                    worldImg[v.imgpath] = love.graphics.newImage(v.imgpath)
                else
                    worldImg[v.imgpath] = love.graphics.newImage("assets/error.png")
                    print("AN ERROR OCURRED. " .. v.imgpath .. " can't be found.")
                end
            end

            love.graphics.setColor(1,1,1,getEntityAlpha(v.x, v.y))
            love.graphics.draw(worldImg[v.imgpath], v.x, v.y)
            drawnamePlate(v.x + 16, v.y, v.name, intensity)
            local isQuestCompleter = false
            love.graphics.setColor(1,1,1,getEntityAlpha(v.x, v.y))
            for k,q in ipairs(quests[1]) do
                if q.rawData.Quest.ReturnNPCID == v.id and q.currentAmount == q.requiredAmount then
                    love.graphics.draw(questCompleteImg , v.x + 8, v.y - 32 + v.AlertY)
                    isQuestCompleter = true
                end
            end
            if not isQuestCompleter then
                if v.GivesItem and not v.StartsQuest then
                    love.graphics.draw(itemAlertImg, v.x + 9, v.y - 32 + v.AlertY)
                elseif v.StartsQuest and not v.GivesItem then
                    love.graphics.draw(questAlertImg, v.x + 9, v.y - 32 + v.AlertY)
                elseif v.GivesItem and v.StartsQuest then
                    love.graphics.draw(itemAlertImg, v.x + 5, v.y - 32 + v.AlertY)
                    love.graphics.draw(questAlertImg, v.x + 13, v.y - 32 + v.AlertY)
                end
            end
        end
    end
end

function updateNPCs(dt)
    for i, v in ipairs(npcs) do
        if npcsDrawable[v.id] == null then
            npcsDrawable[v.id] = copy(v)
            npcsDrawable[v.id].x = v.x * 32
            npcsDrawable[v.id].y = v.y * 32
            npcsDrawable[v.id].AlertY = 0
            npcsDrawable[v.id].AlertDir = 1
        end

        local n = npcsDrawable[v.id]

        n.AlertY = n.AlertY + n.AlertDir
        if n.AlertY > 2 then
            n.AlertDir = -1 * dt
        elseif n.AlertY < -2 then
            n.AlertDir = 1 * dt
        end

        if distanceToPoint(n.x, n.y, v.x * 32, v.y * 32) > 64 then
            n.x = v.x * 32
            n.y = v.y * 32
        end
        if distanceToPoint(n.x, n.y, v.x * 32, v.y * 32) > 1 then
            if n.x - 1 > v.x * 32 then
                n.x = n.x - 30 * dt
            elseif n.x + 1 < v.x * 32 then
                n.x = n.x + 30 * dt
            end
            if n.y - 1 > v.y * 32 then
                n.y = n.y - 30 * dt
            elseif n.y + 1 < v.y * 32 then
                n.y = n.y + 30 * dt
            end
        end
    end
end

function startConversation()
    for i, v in ipairs(npcs) do
        if distanceToPoint(player.x, player.y, v.x, v.y) <= 1 and not showNPCChatBackground and v.Conversation ~= "" then
            local isQuestCompleter = false
            for k, q in ipairs(quests[1]) do

                if q.rawData.Quest.ReturnNPCID == v.id and q.currentAmount == q.requiredAmount then
                    v.Conversation = q.rawData.Quest.EndConversation
                    isQuestCompleter = true
                end

            end

            if not isQuestCompleter then
                if activeConversations[tostring(v.id)] and activeConversations[tostring(v.id)] ~= "None" then
                    v.Conversation = activeConversations[tostring(v.id)]
                end
            end
            local b = {}
            currentNPC = v.id -- this is used to continue the conversation
            c, h = http.request {
                url = api.url .. "/conversation/" .. v.Conversation .. "/" .. username .. "/"..v.id,
                method = "GET",
                source = ltn12.source.string(body),
                headers = {
                    ["token"] = token
                },
                sink = ltn12.sink.table(b)
            }
            if b ~= nil and b[1] ~= nil then
                npcChat = lunajson.decode(table.concat(b))
                chatXpos = -64
                chatOpacity = 0
                chatWritten = ""

                if npcSounds[npcChat.imgpath] then
                    npcSounds[npcChat.imgpath]:setVolume(sfxVolume)
                    npcSounds[npcChat.imgpath]:setPosition(v.x, v.y)
                    npcSounds[npcChat.imgpath]:setRolloff(sfxRolloff)
                    setEnvironmentEffects(npcSounds[npcChat.imgpath])
                    npcSounds[npcChat.imgpath]:play()
                else
                    npcSounds["assets/npc/Person.png"]:setVolume(sfxVolume)
                    npcSounds["assets/npc/Person.png"]:setPosition(v.x, v.y)
                    npcSounds["assets/npc/Person.png"]:setRolloff(sfxRolloff)
                    setEnvironmentEffects(npcSounds["assets/npc/Person.png"])
                    npcSounds["assets/npc/Person.png"]:play()
                end

                -- print(string.gsub(string.gsub(string.gsub(npcChat.Options, "',", '",'),"['",'["'),"']",'"]'))
                local optionString = npcChat.Options
               optionString = string.gsub(optionString, "'s", 's')
                optionString = string.gsub(optionString, "'t", 't')
               optionString = string.gsub(optionString, "'", '"')
                npcChat.Options = lunajson.decode(optionString)
                createNPCChatBackground(player.x, player.y)
                showNPCChatBackground = not showNPCChatBackground
            end
        end
    end
end
