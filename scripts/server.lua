function serverResponse()
    local info = love.thread.getChannel('players'):pop()
    if info then
        local response = lunajson.decode(info)
        if response then

            if not isMouseDown() then -- if perks.stats[1] == 0 then
                perks.stats = {me.str, me.int, me.sta, player.cp}
            end

            if response then
              
                previousPlayers = copy(players) -- Temp
                if #players == 0 then
                    players = response['Players']
                end
                --  players = response['Players']
                -- re-order players to match previous order so we can loop properly
                local playersFound = {} -- a table to match against the players found. If a player isn't being sent then we need to remove it
                for i, v in ipairs(response['Players']) do
                    playersFound[#playersFound + 1] = v['name']
                    local foundPlayer = false -- if this isn't ever changed to true then we need to create the player
                    for k, x in ipairs(previousPlayers) do
                        if k == i and x['name'] ~= v['name'] then
                            players[i] = v
                            foundPlayer = true
                        end
                    end
                    if not foundPlayer then
                        players[i] = v -- create the player
                    end
                end
                for i, v in ipairs(players) do -- remove players we haven't found from the players table
                    if not arrayContains(playersFound, v['name']) then
                        table.remove(players, i)
                    end
                end
                if player.world == 0 then
                    npcs = response['NPC']
                end
                auras = response['Auras']
                playersOnline = ""
                playerCount = 0
                if response['OnlinePlayers'] then
                    for i, v in ipairs(response['OnlinePlayers']) do
                        playersOnline = playersOnline .. v .. "\n"
                        playerCount = playerCount + 1
                    end
                end
                if lunajson.encode(inventoryAlpha) ~= lunajson.encode(response['Inventory']) then
                    updateInventory(response)
                    inventoryAlpha = response['Inventory'] -- this is in this order for a reason dummy
                    -- this is in this order for a reason dummy
                    for i, v in ipairs(inventoryAlpha) do
                        if v.item == nil then
                            table.remove(inventoryAlpha, i)
                        end
                    end
                    table.sort(inventoryAlpha, function(a, b)
                        if not tonumber(a.item.val) then
                            a.item.val = "0"
                        end
                        if not tonumber(b.item.val) then
                            b.item.val = "1"
                        end -- these are different to prevent it going back and forth when sorting
                        return tonumber(a.item.val) < tonumber(b.item.val)
                    end)

                end
                player.cp = response['CharPoints']
                messages = {}
                -- for i = 1, #response['Chat']['Global'] do
                --     local v = response['Chat']['Global'][#response['Chat']['Global'] + 1 - i]
                --     messages[#messages + 1] = {
                --         username = v["Sender"]["name"],
                --         text = v["Message"],
                --         player = v["Sender"]
                --     }
                -- end
                usedItemThisTick = false
                setLighting(response)

                if (response['Me']) then
                    me = response['Me']
                    me.hotbar = response['Hotbar']
                    if me.hotbar then
                        for i, v in ipairs(me.hotbar) do
                            sortedHotbar[v.position] = v
                        end
                    end
                end
                if response["PlayerStructures"] then
                    structures = response["PlayerStructures"]
                    updateWorldLookup()
                end
                if perks.stats[1] == 0 then
                    perks.stats = {me.str, me.int, me.sta, player.cp}
                end
                if me.isDead and me.ishardcore == 0 then
                    love.audio.play(deathSfx)
                    c, h = http.request {
                        url = api.url .. "/revive/" .. username,
                        method = "GET",
                        headers = {
                            ["token"] = token
                        }
                    }
                elseif me.isDead and me.ishardcore == 1 then
                    deathMessage.display = true
              
                end

                if me.isDead then
                    player.x = me.x
                    player.y = me.y
                    
                    if me.ishardcore == 0 then
                        c, h = http.request {
                            url = api.url .. "/revive/" .. username,
                            method = "GET",
                            headers = {
                                ["token"] = token
                            }
                        }
                    else
                        deathMessage.display = true
                    end
                    if death.previousPosition.hp < getMaxHealth() * 0.9 then
                        death.open = true
                        totalCoverAlpha = 2
                        setEnvironmentEffects(awakeSfx)
                        awakeSfx:play()
                    else
                        player.dx = me.x * 32
                        player.dy = me.y * 32
                        player.cx = me.x * 32
                        player.cy = me.y * 32
                    end
                end
                if not death.open then
                    death.previousPosition = {
                        x = player.x,
                        y = player.y,
                        hp = player.hp
                    }
                end
                player.name = me.name
                player.buddy = me.buddy
                if player.hp > me.hp and me.hp < getMaxHealth() then
                    player.damageHUDAlphaUp = true
                    boneSpurt(player.dx + 16, player.dy + 16, player.hp - me.hp, 40, 1, 1, 1, "me")
                end
                player.hp = me.hp
                player.owedxp = me.xp - player.xp
                player.xp = me.xp
                if me and me.lvl and player.lvl ~= me.lvl then
                    if not firstLaunch then
                        if player.lvl ~= 0 then
                            openTutorial(6)
                        end
                        setEnvironmentEffects(lvlSfx)
                        lvlSfx:play()
                        perks.stats[4] = player.cp
                        addFloat("level", player.dx + 16, player.dy + 16, null, {1, 0, 0}, 10)
                    end
                    player.lvl = me.lvl
                    firstLaunch = false
                end
                player.name = me.name
                if player.world == 0 then
                    newEnemyData(response['Enemies'])
                end
                quests = {{}, {}, {}}
                for i, v in ipairs(response['MyQuests']) do
                    local trackedVar = 2
                    if v.Tracked == 1 then
                        trackedVar = 1
                    end
                    quests[v.Tracked][#quests[v.Tracked] + 1] = {
                        title = v.Quest.Title,
                        comment = v.Quest.description,
                        profilePic = v.Quest.imgpath,
                        giver = "",
                        requiredAmount = v.Quest.valueRequired,
                        currentAmount = v.Progress,
                        rawData = v
                    }
                    if v.Quest.type == "kill" then
                        quests[v.Tracked][#quests[v.Tracked]].task =
                            "Kill " .. v.Quest.valueRequired .. "x " .. v.Quest.value
                    elseif v.Quest.type == "gather" then
                        quests[v.Tracked][#quests[v.Tracked]].task =
                            "Gather " .. v.Quest.valueRequired .. "x " .. v.Quest.value
                    elseif v.Quest.type == "go" then
                        quests[v.Tracked][#quests[v.Tracked]].task = "Go to " ..
                                                                         (worldLookup[v.Quest.x .. "," .. v.Quest.y]
                                                                             .name or v.Quest.x .. ", " .. v.Quest.y)
                    end
                end
                activeConversations = response['ActiveConversations']
                if response['Tick'] ~= previousTick then
                    tick()
                    previousTick = response['Tick']
                end
                weather.type = response['Weather']

                -- if love.system.getOS() ~= "Linux" and useSteam then checkAchievementUnlocks() end
            end
        end
    end
end
