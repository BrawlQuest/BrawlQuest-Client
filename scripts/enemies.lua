enemies = {}
enemyImg = {}
enemyCollisions = {}
enemyCollisionsPrevious = { [0] = {}, [1] = {} }
enemyQuads = {}
enemyCollisionsI = 0
enemySounds = {}

attackSfxs = {
    love.audio.newSource("assets/sfx/monsters/skeletons/attack/1.ogg", "static"),
    love.audio.newSource("assets/sfx/monsters/skeletons/attack/2.ogg", "static"),
    love.audio.newSource("assets/sfx/monsters/skeletons/attack/3.ogg", "static"),
    love.audio.newSource("assets/sfx/monsters/skeletons/attack/4.ogg", "static")
}

aggroSfxs = {
    love.audio.newSource("assets/sfx/monsters/skeletons/aggro/1.ogg", "static"),
    love.audio.newSource("assets/sfx/monsters/skeletons/aggro/2.ogg", "static"),
    love.audio.newSource("assets/sfx/monsters/skeletons/aggro/3.ogg", "static")
}

deathSfxs = {
    love.audio.newSource("assets/sfx/monsters/skeletons/death/1.ogg", "static"),
    love.audio.newSource("assets/sfx/monsters/skeletons/death/2.ogg", "static"),
    love.audio.newSource("assets/sfx/monsters/skeletons/death/3.ogg", "static")
}

alertImg = love.graphics.newImage("assets/ui/alert.png")

function newEnemyData(data) -- called when nearby data is returned
    enemyCollisions = copy(enemyCollisionsPrevious[enemyCollisionsI])
    for i, v in ipairs(enemies) do enemies[i].updated = false end
    for i, v in ipairs(data) do
        local id = v.InstanceID
        local enemy = enemies[v.InstanceID]
        if not enemy then
            enemies[v.InstanceID] = v
            enemy = enemies[v.InstanceID]
            enemy.dx = v.X * 32
            enemy.speed = 32
            enemy.dy = v.Y * 32
            enemy.mhp = v.Enemy.HP
            enemy.dhp = v.HP
            enemy.red = 0
            enemy.atkAlpha = 0
            enemy.aggroAlpha = 0
            enemy.linesDrawable = false
            if enemy.HP <= 0 then
                enemy.hasBurst = true
            else
                enemy.hasBurst = false
            end
            if not enemyImg[enemy.Enemy.Name] then
                enemyImg[enemy.Enemy.Name] = getImgIfNotExist(enemy.Enemy.Image)
            end

            enemy.size = enemyImg[enemy.Enemy.Name]:getWidth()

            if not enemySounds[enemy.Enemy.Name] then
                enemySounds[enemy.Enemy.Name] = {
                    attack = {},
                    aggro = {},
                    death = {},
                    taunt = {}
                }
                if love.filesystem.getInfo(
                        "assets/sfx/monsters/" .. enemy.Enemy.Name .. "/") then
                    for key, sound in pairs(enemySounds[enemy.Enemy.Name]) do
                        local files = recursiveEnumerate(
                            "assets/sfx/monsters/" ..
                            enemy.Enemy.Name .. "/" .. key, {})
                        for k, file in ipairs(files) do
                            if explode(file, ".")[#explode(file, ".")] == "ogg" or
                                explode(file, ".")[#explode(file, ".")] == "mp3" or
                                explode(file, ".")[#explode(file, ".")] == "wav" then
                                enemySounds[enemy.Enemy.Name][key][#enemySounds[enemy.Enemy
                                .Name][key] + 1] =
                                    love.audio.newSource(file, "static")
                            end
                        end
                    end
                else
                    enemySounds[enemy.Enemy.Name] = {
                        attack = attackSfxs,
                        aggro = aggroSfxs,
                        death = deathSfxs,
                        taunt = attackSfxs
                    }
                end
            end

            if bone[enemy.Enemy.Name] == null then -- load custom gore
                bone[enemy.Enemy.Name] = {}
                if love.filesystem.getInfo(
                        "assets/gore/" .. enemy.Enemy.Name .. "/") then
                    local files = recursiveEnumerate("assets/gore/" ..
                        enemy.Enemy.Name .. "/",
                        {})
                    for k, file in ipairs(files) do
                        bone[enemy.Enemy.Name][#bone[enemy.Enemy.Name] + 1] =
                            love.graphics.newImage(file)
                    end
                else
                    bone[enemy.Enemy.Name] = bone.image -- set to default
                end
            end

            if not enemyQuads[enemy.Enemy.Name] then -- enemy quad for drawing target outlines
                enemyQuads[enemy.Enemy.Name] =
                    love.graphics.newQuad(0, 0, enemy.size, enemy.size,
                        enemyImg[enemy.Enemy.Name]:getDimensions())
            end
        end

        if enemy.HP ~= v.HP then
            if enemy.HP > v.HP then
                local thisHitSfx = enemyHitSfx
                thisHitSfx:stop()
                if (enemy.Enemy.Name == "Fish") then
                    thisHitSfx = splashSfx
                else
                    boneSpurt(enemy.dx + 16, enemy.dy + 16, 4, 20, 1, 1, 1,
                        "mob", v.Enemy.Name)
                end
                thisHitSfx:setPitch(love.math.random(50, 100) / 100)
                thisHitSfx:setVolume(0.5 * sfxVolume)
                thisHitSfx:setPosition(v.X, v.Y)
                thisHitSfx:setRolloff(sfxRolloff)
                setEnvironmentEffects(thisHitSfx)
                thisHitSfx:play()
                enemy.red = 1
            end

            -- find whether you are attacking an enemy
            -- local attackingEnemy = false
            -- if enemy.size <= 32 and (me.AX == enemy.X and me.AY == enemy.Y) then
            --     attackingEnemy = true
            -- elseif enemy.size > 32 and
            --     (me.AX == enemy.X and me.AY == enemy.Y or me.AX == enemy.X + 1 and
            --         me.AY == enemy.Y or me.AX == enemy.X and me.AY == enemy.Y +
            --         1 or me.AX == enemy.X + 1 and me.AY == enemy.Y + 1) then
            --     attackingEnemy = true
            -- end

            -- move the player to hit an enemy
            -- if (me.AX ~= me.X or me.AY ~= me.Y) and attackingEnemy and
            --     not death.open then
            --     if player.dx > me.AX * 32 then
            --         player.dx = player.dx - 16
            --     elseif player.dx < me.AX * 32 then
            --         player.dx = player.dx + 16
            --     end
            --     if player.dy > me.AY * 32 then
            --         player.dy = player.dy - 16
            --     elseif player.dy < me.AY * 32 then
            --         player.dy = player.dy + 16
            --     end
            --     attackHitAmount = 1
            -- end

            -- Add offset to floats
            local offset = 0
            if enemy.size > 32 then offset = 16 end

            addFloat("text", enemy.X * 32 + offset, enemy.Y * 32 - 18,
                (enemy.HP - v.HP) * -1, { 1, 0, 0 })
            enemy.HP = v.HP
        end

        if enemy.IsAggro == false and v.IsAggro then
            enemy.aggroAlpha = 2
            enemy.IsAggro = true
            if sfxVolume > 0 then
                local aggroSfx = enemySounds[v.Enemy.Name].aggro[love.math
                .random(1, #enemySounds[v.Enemy.Name].aggro)]
                aggroSfx:setPitch(love.math.random(80, 150) / 100)
                aggroSfx:setVolume(1 * sfxVolume)
                if aggroSfx:getChannelCount() == 1 then
                    aggroSfx:setPosition(v.X, v.Y)
                    aggroSfx:setRolloff(sfxRolloff)
                end
                setEnvironmentEffects(aggroSfx)
                aggroSfx:play()
            end
        end

        enemy.Target = v.Target
        enemy.TargetName = v.TargetName

        enemy.X = v.X
        enemy.Y = v.Y

        if enemy.HP > 0 then
            enemyCollisions[v.X .. "," .. v.Y] = true -- ..","..
            enemy.updated = true
            enemy.lastUpdate = os.time(os.date("!*t"))
        end

        enemy.IsAggro = v.IsAggro
    end

    if enemyCollisionsI == 0 then
        enemyCollisionsPrevious[0] = copy(enemyCollisions)
        enemyCollisionsPrevious[1] = {}
    else
        enemyCollisionsPrevious[1] = copy(enemyCollisions)
        enemyCollisionsPrevious[0] = {}
    end

    for i, v in ipairs(enemies) do table.remove(enemies, i) end
end

function drawEnemies()
    for i, v in pairs(enemies) do
        local distance = distanceToPoint(player.dx, player.dy, v.dx, v.dy)
        local range = worldMask.range * 32
        local size = enemyImg[v.Enemy.Name]:getWidth()
        local halfSize = size / 2
        local enemyAlpha = getEntityAlpha(v.dx, v.dy)
        if distance <= range then
            if v.HP > 0 and v.updated and os.time(os.date("!*t")) - v.lastUpdate <
                5 then
                local intensity = 1 -
                    (range /
                        (range + difference(range, distance) *
                            4) - 0.2)
                local rotation = 1
                local offsetX = 0
                if v and v.previousDirection and v.previousDirection == "left" then
                    rotation = -1
                    offsetX = size
                end

                if distance <= range then
                    love.graphics.setColor(1, 1 - v.red, (1 - v.red),
                        intensity * enemyAlpha)
                    love.graphics.draw(enemyImg[v.Enemy.Name], v.dx + offsetX,
                        v.dy, 0, rotation, 1, 0, 0)
                end

                local enemyHealth = me.HP / v.Enemy.ATK
                local playerHealth = v.Enemy.HP /
                    (me.Weapon.Val + (me.STR - 1) * 0.5)

                if me.HP and v.Enemy.ATK and enemyHealth > playerHealth then
                    local distanceIntensity = 1 - (distance / 128)
                    love.graphics.setColor(1, cerp(0, 0.5, nextTick * 2), 0,
                        intensity * distanceIntensity *
                        enemyAlpha)
                    love.graphics.draw(skull, v.dx - 6, v.dy - 8, 0, 1)
                end

                -- show red when hit
                if v.dhp < v.mhp or not v.Enemy.CanMove then
                    if v.Enemy.CanMove then
                        love.graphics.setColor(1, 0, 0, intensity * enemyAlpha)
                        love.graphics.rectangle("fill", v.dx, v.dy - 6,
                            (v.dhp / v.mhp) * size, 6)
                    else
                        love.graphics.setColor(0.2, 0.2, 1,
                            intensity * enemyAlpha)
                        love.graphics.rectangle("fill", v.dx, v.dy - 2,
                            (v.dhp / v.mhp) * size, 2)
                    end
                end

                -- draws alert when first seen
                love.graphics.setColor(1, 1, 1, v.aggroAlpha * intensity)
                love.graphics.draw(alertImg, v.dx + 8, v.dy - 16)
                love.graphics.setColor(1, 1, 1, intensity * enemyAlpha)

                -- draw lines
                if v.TargetName == player.name and v.Enemy.CanMove and v.IsAggro then
                    if (v.Enemy.Range + 1) * 32 >= distance then
                        love.graphics.setColor(1, 0, 0,
                            nextTick * intensity *
                            enemyAlpha)
                        love.graphics.line(v.dx + halfSize, v.dy + halfSize,
                            player.dx + 16, player.dy + 16)
                        love.graphics.setColor(1, 1, 1,
                            intensity * enemyAlpha)
                        if v.Enemy.XP / player.lvl > 1 then
                            outlinerOnly:draw(2, enemyImg[v.Enemy.Name],
                                enemyQuads[v.Enemy.Name],
                                v.dx + offsetX, v.dy, 0,
                                rotation, 1)
                        else
                            grayOutlinerOnly:draw(2, enemyImg[v.Enemy.Name],
                                enemyQuads[v.Enemy.Name],
                                v.dx + offsetX, v.dy, 0,
                                rotation, 1)
                        end
                    end
                end
            elseif v and v.lastUpdate and os.time(os.date("!*t")) - v.lastUpdate <
                5 and not v.hasBurst then
                burstLoot(v.dx + halfSize, v.dy + halfSize, player.owedxp, "xp")
                local deathSound = enemySounds[v.Enemy.Name].death[love.math
                .random(1,
                    #enemySounds[v.Enemy.Name].death)]
                deathSound:setVolume(1 * sfxVolume)
                if deathSound:getChannelCount() == 1 then
                    deathSound:setPosition(v.dx / 32, v.dy / 32)
                    deathSound:setRolloff(sfxRolloff)
                end
                setEnvironmentEffects(deathSound)
                deathSound:play()
                if love.system.getOS() ~= "Linux" and useSteam then
                    if v.Enemy.Name == "Fire Phoenix" then
                        steam.userStats.setAchievement(
                            'kill_phoenix_achievement')
                        steam.userStats.storeStats()
                    elseif v.Enemy.Name == "Entity of Frost" then
                        steam.userStats.setAchievement('kill_frost_achievement')
                        steam.userStats.storeStats()
                    end
                    if v.Enemy.HP > 1000 then
                        steam.userStats.setAchievement('kill_boss_achievement')
                        steam.userStats.storeStats()
                    end
                    local success, kills = steam.userStats.getStatInt("kill")
                    steam.userStats.setStatInt("kill", kills + 1)
                end
                if v.Enemy.Width and v.Enemy.Height then
                    for a = 1, v.Enemy.Width do
                        for k = 1, v.Enemy.Height do
                            boneSpurt(v.dx + halfSize + ((a - 1) * 32),
                                v.dy + halfSize + ((k - 1) * 32), 10, 25,
                                1, 1, 1, "mob", v.Enemy.Name)
                        end
                    end
                end
                v.hasBurst = true
            end
        end
    end
end

function updateEnemies(dt)
    for i, v in pairs(enemies) do
        smoothMovement(v, dt)
        v.dhp = v.dhp + (v.HP - v.dhp) * 2 * dt
        if v.red > 0 then
            v.red = v.red - 2 * dt
            if v.red < 0 then v.red = 0 end
        end
        v.atkAlpha = v.atkAlpha - 2 * dt
        v.aggroAlpha = v.aggroAlpha - 1 * dt
    end
end

function smoothMovement(v, dt)
    if distanceToPoint(v.dx, v.dy, v.X * 32, v.Y * 32) > 3 then
        if v.dx > v.X * 32 + 0 then
            v.previousDirection = "left"
            v.dx = v.dx - v.speed * dt
        elseif v.dx < v.X * 32 - 0 then
            v.previousDirection = "right"
            v.dx = v.dx + v.speed * dt
        end

        if v.dy > v.Y * 32 + 0 then
            v.dy = v.dy - v.speed * dt
        elseif v.dy < v.Y * 32 - 0 then
            v.dy = v.dy + v.speed * dt
        end
    else
        v.dx = v.X * 32 -- preventing blurring from fractional pixels
        v.dy = v.Y * 32
    end
end

function tickEnemies()
    if enemyCollisionsI == 0 then
        enemyCollisionsI = 1
    else
        enemyCollisionsI = 0
    end
end
