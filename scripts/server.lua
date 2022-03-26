function serverResponse()
    local info = love.thread.getChannel('players'):pop()
    if info then
        local response = json:decode(info)
        if response then

            if not isMouseDown() then -- if perks.stats[1] == 0 then
                perks.stats = {me.STR, me.INT, me.STA, player.cp}
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
                    playersFound[#playersFound + 1] = v['Name']
                    local foundPlayer = false -- if this isn't ever changed to true then we need to create the player
                    for k, x in ipairs(previousPlayers) do
                        if k == i and x['Name'] ~= v['Name'] then
                            players[i] = v
                            foundPlayer = true
                        end
                    end
                    if not foundPlayer then
                        players[i] = v -- create the player
                    end
                end
                for i, v in ipairs(players) do -- remove players we haven't found from the players table
                    if not arrayContains(playersFound, v['Name']) then
                        table.remove(players, i)
                    end
                end
                if player.world == 0 then npcs = response['NPC'] end
                auras = response['Auras']
                playersOnline = ""
                playerCount = 0
                if response['OnlinePlayers'] then
                    for i, v in ipairs(response['OnlinePlayers']) do
                        playersOnline = playersOnline .. v .. "\n"
                        playerCount = playerCount + 1
                    end
                end
                if json:encode(inventoryAlpha) ~=
                    json:encode(response['Inventory']) then
                    updateInventory(response)
                    inventoryAlpha = response['Inventory'] -- this is in this order for a reason dummy
                    -- this is in this order for a reason dummy

                    table.sort(inventoryAlpha, function(a, b)
                        if not tonumber(a.Item.Val) then
                            a.Item.Val = "0"
                        end
                        if not tonumber(b.Item.Val) then
                            b.Item.Val = "1"
                        end -- these are different to prevent it going back and forth when sorting
                        return tonumber(a.Item.Val) < tonumber(b.Item.Val)
                    end)

                end
                player.cp = response['CharPoints']
                messages = {}
                for i = 1, #response['Chat']['Global'] do
                    local v =
                        response['Chat']['Global'][#response['Chat']['Global'] +
                            1 - i]
                    messages[#messages + 1] = {
                        username = v["Sender"]["Name"],
                        text = v["Message"],
                        player = v["Sender"]
                    }
                end
                usedItemThisTick = false
                setLighting(response)

                if (response['Me']) then me = response['Me'] end
                if response["PlayerStructures"] then
                    structures = response["PlayerStructures"]
                    updateWorldLookup()
                end
                if perks.stats[1] == 0 then
                    perks.stats = {me.STR, me.INT, me.STA, player.cp}
                end
                if me.IsDead == true then
                    love.audio.play(deathSfx)
                    c, h = http.request {
                        url = api.url .. "/revive/" .. username,
                        method = "GET",
                        headers = {["token"] = token}
                    }
                end

                if me.IsDead then
                    player.x = me.X
                    player.y = me.Y
                    c, h = http.request {
                        url = api.url .. "/revive/" .. username,
                        method = "GET",
                        headers = {["token"] = token}

                    }
                    if death.previousPosition.hp < getMaxHealth() * 0.9 then
                        death.open = true
                        totalCoverAlpha = 2
                        setEnvironmentEffects(awakeSfx)
                        awakeSfx:play()
                    else
                        player.dx = me.X * 32
                        player.dy = me.Y * 32
                        player.cx = me.X * 32
                        player.cy = me.Y * 32
                    end
                end
                if not death.open then
                    death.previousPosition = {
                        x = player.x,
                        y = player.y,
                        hp = player.hp
                    }
                end
                player.name = me.Name
                player.buddy = me.Buddy
                if player.hp > me.HP and me.HP < getMaxHealth() then
                    player.damageHUDAlphaUp = true
                    boneSpurt(player.dx + 16, player.dy + 16, player.hp - me.HP,
                              40, 1, 1, 1, "me")
                end
                player.hp = me.HP
                player.owedxp = me.XP - player.xp
                player.xp = me.XP
                if me and me.LVL and player.lvl ~= me.LVL then
                    if not firstLaunch then
                        if player.lvl ~= 0 then
                            openTutorial(6)
                        end
                        setEnvironmentEffects(lvlSfx)
                        lvlSfx:play()
                        perks.stats[4] = player.cp
                        addFloat("level", player.dx + 16, player.dy + 16, null,
                                 {1, 0, 0}, 10)
                    end
                    player.lvl = me.LVL
                    firstLaunch = false
                end
                player.name = me.Name
                if player.world == 0 then
                    newEnemyData(response['Enemies'])
                end
                quests = {{}, {}, {}}
                for i, v in ipairs(response['MyQuests']) do
                    local trackedVar = 2
                    if v.Tracked == 1 then trackedVar = 1 end
                    quests[v.Tracked][#quests[v.Tracked] + 1] = {
                        title = v.Quest.Title,
                        comment = v.Quest.Desc,
                        profilePic = v.Quest.ImgPath,
                        giver = "",
                        requiredAmount = v.Quest.ValueRequired,
                        currentAmount = v.Progress,
                        rawData = v
                    }
                    if v.Quest.Type == "kill" then
                        quests[v.Tracked][#quests[v.Tracked]].task = "Kill " ..
                                                                         v.Quest
                                                                             .ValueRequired ..
                                                                         "x " ..
                                                                         v.Quest
                                                                             .Value
                    elseif v.Quest.Type == "gather" then
                        quests[v.Tracked][#quests[v.Tracked]].task =
                            "Gather " .. v.Quest.ValueRequired .. "x " ..
                                v.Quest.Value
                    elseif v.Quest.Type == "go" then
                        quests[v.Tracked][#quests[v.Tracked]].task = "Go to " ..
                                                                         (worldLookup[v.Quest
                                                                             .X ..
                                                                             "," ..
                                                                             v.Quest
                                                                                 .Y]
                                                                             .Name or
                                                                             v.Quest
                                                                                 .X ..
                                                                             ", " ..
                                                                             v.Quest
                                                                                 .Y)
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
