enemies = {}
enemyImg = {}
enemyCollisions = {}
enemyCollisionsPrevious = {[0] = {}, [1] = {}}
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
        local id = v.instanceID
        local enemy = enemies[v.instanceID]
        if not enemy then
            enemies[v.instanceID] = v
            enemy = enemies[v.instanceID]
            enemy.dx = v.x * 32
            enemy.speed = 32
            enemy.dy = v.y * 32
            enemy.mhp = v.enemy.hp
            enemy.dhp = v.hp
            enemy.red = 0
            enemy.atkAlpha = 0
            enemy.aggroAlpha = 0
            enemy.linesDrawable = false
            if enemy.hp <= 0 then
                enemy.hasBurst = true
            else
                enemy.hasBurst = false
            end
            if not enemyImg[enemy.enemy.name] then
                enemyImg[enemy.enemy.name] = getImgIfNotExist(enemy.enemy.image)
            end

            enemy.size = enemyImg[enemy.enemy.name]:getWidth()

            if not enemySounds[enemy.enemy.name] then
                enemySounds[enemy.enemy.name] = {
                    attack = {},
                    aggro = {},
                    death = {},
                    taunt = {}
                }
                if love.filesystem.getInfo(
                    "assets/sfx/monsters/" .. enemy.enemy.name .. "/") then
                    for key, sound in pairs(enemySounds[enemy.enemy.name]) do
                        local files = recursiveEnumerate(
                                          "assets/sfx/monsters/" ..
                                              enemy.enemy.name .. "/" .. key, {})
                        for k, file in ipairs(files) do
                            if explode(file, ".")[#explode(file, ".")] == "ogg" or
                                explode(file, ".")[#explode(file, ".")] == "mp3" or
                                explode(file, ".")[#explode(file, ".")] == "wav" then
                                enemySounds[enemy.enemy.name][key][#enemySounds[enemy.enemy
                                    .name][key] + 1] =
                                    love.audio.newSource(file, "static")
                            end
                        end
                    end
                else
                    enemySounds[enemy.enemy.name] = {
                        attack = attackSfxs,
                        aggro = aggroSfxs,
                        death = deathSfxs,
                        taunt = attackSfxs
                    }
                end
            end

            if bone[enemy.enemy.name] == null then -- load custom gore
                bone[enemy.enemy.name] = {}
                if love.filesystem.getInfo(
                    "assets/gore/" .. enemy.enemy.name .. "/") then
                    local files = recursiveEnumerate("assets/gore/" ..
                                                         enemy.enemy.name .. "/",
                                                     {})
                    for k, file in ipairs(files) do
                        bone[enemy.enemy.name][#bone[enemy.enemy.name] + 1] =
                            love.graphics.newImage(file)
                    end
                else
                    bone[enemy.enemy.name] = bone.image -- set to default
                end
            end

            if not enemyQuads[enemy.enemy.name] then -- enemy quad for drawing target outlines
                enemyQuads[enemy.enemy.name] =
                    love.graphics.newQuad(0, 0, enemy.size, enemy.size,
                                          enemyImg[enemy.enemy.name]:getDimensions())
            end

        end

        if enemy.hp ~= v.hp then
            if enemy.hp > v.hp then
                local thisHitSfx = enemyHitSfx
                thisHitSfx:stop()
                if (enemy.enemy.name == "Fish") then
                    thisHitSfx = splashSfx
                else
                    boneSpurt(enemy.dx + 16, enemy.dy + 16, 4, 20, 1, 1, 1,
                              "mob", v.enemy.name)

                end
                thisHitSfx:setPitch(love.math.random(50, 100) / 100)
                thisHitSfx:setVolume(0.5 * sfxVolume)
                thisHitSfx:setPosition(v.x, v.y)
                thisHitSfx:setRolloff(sfxRolloff)
                setEnvironmentEffects(thisHitSfx)
                thisHitSfx:play()
                enemy.red = 1
            end

            -- find whether you are attacking an enemy
            local attackingEnemy = false
            if enemy.size <= 32 and (me.ax == enemy.x and me.ay == enemy.y) then
                attackingEnemy = true
            elseif enemy.size > 32 and
                (me.ax == enemy.x and me.ay == enemy.y or me.ax == enemy.x + 1 and
                    me.ay == enemy.y or me.ax == enemy.x and me.ay == enemy.y +
                    1 or me.ax == enemy.x + 1 and me.ay == enemy.y + 1) then
                attackingEnemy = true
            end

            -- move the player to hit an enemy
            if (me.ax ~= me.x or me.ay ~= me.y) and attackingEnemy and
                not death.open then
                if player.dx > me.ax * 32 then
                    player.dx = player.dx - 16
                elseif player.dx < me.ax * 32 then
                    player.dx = player.dx + 16
                end
                if player.dy > me.ay * 32 then
                    player.dy = player.dy - 16
                elseif player.dy < me.ay * 32 then
                    player.dy = player.dy + 16
                end
                attackHitAmount = 1
            end

            -- Add offset to floats
            local offset = 0
            if enemy.size > 32 then offset = 16 end

            addFloat("text", enemy.x * 32 + offset, enemy.y * 32 - 18,
                     (enemy.hp - v.hp) * -1, {1, 0, 0})
            enemy.hp = v.hp
        end

        if enemy.isAggro == false and v.isAggro then
            enemy.aggroAlpha = 2
            enemy.isAggro = true
            if sfxVolume > 0 then
                local aggroSfx = enemySounds[v.enemy.name].aggro[love.math
                                     .random(1, #enemySounds[v.enemy.name].aggro)]
                aggroSfx:setPitch(love.math.random(80, 150) / 100)
                aggroSfx:setVolume(1 * sfxVolume)
                if aggroSfx:getChannelCount() == 1 then
                    aggroSfx:setPosition(v.x, v.y)
                    aggroSfx:setRolloff(sfxRolloff)
                end
                setEnvironmentEffects(aggroSfx)
                aggroSfx:play()
            end
        end

        enemy.target = v.target
        enemy.targetname = v.targetname

        enemy.x = v.x
        enemy.y = v.y

        if enemy.hp > 0 then
            enemyCollisions[v.x .. "," .. v.y] = true -- ..","..
            enemy.updated = true
            enemy.lastUpdate = os.time(os.date("!*t"))
        end

        enemy.isAggro = v.isAggro
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
        local size = enemyImg[v.enemy.name]:getWidth()
        local halfSize = size / 2
        local enemyAlpha = getEntityAlpha(v.dx, v.dy)
        if distance <= range then
            if v.hp > 0 and v.updated and os.time(os.date("!*t")) - v.lastUpdate <
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
                    love.graphics.draw(enemyImg[v.enemy.name], v.dx + offsetX,
                                       v.dy, 0, rotation, 1, 0, 0)
                end

                local enemyHealth = me.hp / v.enemy.atk
                local playerHealth = v.enemy.hp /
                                         (me.weapon.val + (me.str - 1) * 0.5)

                if me.hp and v.enemy.atk and enemyHealth < playerHealth then
                    local distanceIntensity = 1 - (distance / 128)
                    love.graphics.setColor(1, cerp(0, 0.5, nextTick * 2), 0,
                                           intensity * distanceIntensity *
                                               enemyAlpha)
                    love.graphics.draw(skull, v.dx - 6, v.dy - 8, 0, 1)
                end

                -- show red when hit
                if v.dhp < v.mhp or not v.enemy.CanMove then
                    if v.enemy.CanMove then
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
                if v.targetname == player.name and v.enemy.CanMove then
                    if nextTick >= 1 then
                        enemies[i].linesDrawable = true
                    end
                    if enemies[i].linesDrawable == true and v.isAggro then
                        if (v.enemy.Range + 1) * 32 >= distance then
                            love.graphics.setColor(1, 0, 0,
                                                   nextTick * intensity *
                                                       enemyAlpha)
                            love.graphics.line(v.dx + halfSize, v.dy + halfSize,
                                               player.dx + 16, player.dy + 16)
                            love.graphics.setColor(1, 1, 1,
                                                   intensity * enemyAlpha)
                            if v.enemy.xP / player.lvl > 1 then
                                outlinerOnly:draw(2, enemyImg[v.enemy.name],
                                                  enemyQuads[v.enemy.name],
                                                  v.dx + offsetX, v.dy, 0,
                                                  rotation, 1)
                            else
                                grayOutlinerOnly:draw(2, enemyImg[v.enemy.name],
                                                      enemyQuads[v.enemy.name],
                                                      v.dx + offsetX, v.dy, 0,
                                                      rotation, 1)
                            end
                        end
                    end
                else
                    enemies[i].linesDrawable = false
                end
            elseif v and v.lastUpdate and os.time(os.date("!*t")) - v.lastUpdate <
                5 and not v.hasBurst then
                burstLoot(v.dx + halfSize, v.dy + halfSize, player.owedxp, "xp")
                local deathSound = enemySounds[v.enemy.name].death[love.math
                                       .random(1,
                                               #enemySounds[v.enemy.name].death)]
                deathSound:setVolume(1 * sfxVolume)
                if deathSound:getChannelCount() == 1 then
                    deathSound:setPosition(v.dx / 32, v.dy / 32)
                    deathSound:setRolloff(sfxRolloff)
                end
                setEnvironmentEffects(deathSound)
                deathSound:play()
                if love.system.getOS() ~= "Linux" and useSteam then
                    if v.enemy.name == "Fire Phoenix" then
                        steam.userStats.setAchievement(
                            'kill_phoenix_achievement')
                        steam.userStats.storeStats()
                    elseif v.enemy.name == "Entity of Frost" then
                        steam.userStats.setAchievement('kill_frost_achievement')
                        steam.userStats.storeStats()
                    end
                    if v.enemy.hp > 1000 then
                        steam.userStats.setAchievement('kill_boss_achievement')
                        steam.userStats.storeStats()
                    end
                    local success, kills = steam.userStats.getStatInt("kill")
                    steam.userStats.setStatInt("kill", kills + 1)
                end
                if v.enemy.Width and v.enemy.Height then
                    for a = 1, v.enemy.Width do
                        for k = 1, v.enemy.Height do
                            boneSpurt(v.dx + halfSize + ((a - 1) * 32),
                                      v.dy + halfSize + ((k - 1) * 32), 10, 25,
                                      1, 1, 1, "mob", v.enemy.name)
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
        v.dhp = v.dhp + (v.hp - v.dhp) * 2 * dt
        if v.red > 0 then
            v.red = v.red - 2 * dt
            if v.red < 0 then v.red = 0 end
        end
        v.atkAlpha = v.atkAlpha - 2 * dt
        v.aggroAlpha = v.aggroAlpha - 1 * dt
    end
end

function smoothMovement(v, dt)
    if distanceToPoint(v.dx, v.dy, v.x * 32, v.y * 32) > 3 then
        if v.dx > v.x * 32 + 0 then
            v.previousDirection = "left"
            v.dx = v.dx - v.speed * dt
        elseif v.dx < v.x * 32 - 0 then
            v.previousDirection = "right"
            v.dx = v.dx + v.speed * dt
        end

        if v.dy > v.y * 32 + 0 then
            v.dy = v.dy - v.speed * dt
        elseif v.dy < v.y * 32 - 0 then
            v.dy = v.dy + v.speed * dt
        end
    else
        v.dx = v.x * 32 -- preventing blurring from fractional pixels
        v.dy = v.y * 32
    end
end

function tickEnemies()
    if enemyCollisionsI == 0 then
        enemyCollisionsI = 1
    else
        enemyCollisionsI = 0
    end
end
