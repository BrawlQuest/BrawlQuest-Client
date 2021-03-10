enemies = {}
enemyImg = {}
enemyCollisions = {}
enemyCollisionsPrevious = {
    [0] = {},
    [1] = {}
}
enemyQuads = {}
enemyCollisionsI = 0
enemySounds = {}

attackSfxs = {love.audio.newSource("assets/sfx/monsters/skeletons/attack/1.ogg", "static"),
              love.audio.newSource("assets/sfx/monsters/skeletons/attack/2.ogg", "static"),
              love.audio.newSource("assets/sfx/monsters/skeletons/attack/3.ogg", "static"),
              love.audio.newSource("assets/sfx/monsters/skeletons/attack/4.ogg", "static")}

aggroSfxs = {love.audio.newSource("assets/sfx/monsters/skeletons/aggro/1.ogg", "static"),
             love.audio.newSource("assets/sfx/monsters/skeletons/aggro/2.ogg", "static"),
             love.audio.newSource("assets/sfx/monsters/skeletons/aggro/3.ogg", "static")}

deathSfxs = {love.audio.newSource("assets/sfx/monsters/skeletons/death/1.ogg", "static"),
             love.audio.newSource("assets/sfx/monsters/skeletons/death/2.ogg", "static"),
             love.audio.newSource("assets/sfx/monsters/skeletons/death/3.ogg", "static")}

alertImg = love.graphics.newImage("assets/ui/alert.png")

function newEnemyData(data) -- called when nearby data is returned
    enemiesInAggro = 0
    enemyCollisions = copy(enemyCollisionsPrevious[enemyCollisionsI])

    for i, v in ipairs(data) do
        local id = v.ID
        local enemy = enemies[v.ID]

        if not enemy then
            enemies[v.ID] = v
            enemy = enemies[v.ID]
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

            if enemyImg[enemy.Enemy.Name] == null then
                enemyImg[enemy.Enemy.Name] = getImgIfNotExist(enemy.Enemy.Image)
            end

            -- load enemy sounds
            if enemySounds[enemy.Enemy.Name] == null then
                enemySounds[enemy.Enemy.Name] = {
                    attack = {},
                    aggro = {},
                    death = {},
                    taunt = {}
                }
                --    print("Time to load sounds for "..enemy.Enemy.Name)
                if love.filesystem.getInfo("assets/sfx/monsters/" .. enemy.Enemy.Name .. "/") then
                    --   print("They have a SFX folder!")
                    for i, v in pairs(enemySounds[enemy.Enemy.Name]) do
                        --   print("Adding "..i.." sounds from " .. "assets/sfx/monsters/" .. enemy.Enemy.Name .. "/" .. i)
                        local files = recursiveEnumerate("assets/sfx/monsters/" .. enemy.Enemy.Name .. "/" .. i, {})
                        for k, file in ipairs(files) do
                            --     print("Found "..file)
                            if explode(file, ".")[#explode(file, ".")] == "ogg" or explode(file, ".")[#explode(file, ".")] == "mp3" or explode(file, ".")[#explode(file, ".")] ==
                                "wav" then
                                enemySounds[enemy.Enemy.Name][i][#enemySounds[enemy.Enemy.Name][i] + 1] =
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
                if love.filesystem.getInfo("assets/gore/" .. enemy.Enemy.Name .. "/") then

                    local files = recursiveEnumerate("assets/gore/" .. enemy.Enemy.Name .. "/", {})
                    for k, file in ipairs(files) do
                        bone[enemy.Enemy.Name][#bone[enemy.Enemy.Name] + 1] = love.graphics.newImage(file)
                    end
                else
                    bone[enemy.Enemy.Name] = bone.image -- set to default
                   
                end
            end

            if enemyQuads[enemy.Enemy.Name] == null then -- enemy quad for drawing target outlines

                enemyQuads[enemy.Enemy.Name] = love.graphics.newQuad(0, 0, 32, 32,
                                                   enemyImg[enemy.Enemy.Name]:getDimensions())

            end

        end

        if enemy.HP ~= v.HP then
            if enemy.HP > v.HP then
                boneSpurt(enemy.dx + 16, enemy.dy + 16, 4, 20, 1, 1, 1, "mob", v.Enemy.Name)
                if sfxVolume > 0 then
                    enemyHitSfx:setPitch(love.math.random(50, 100) / 100)
                    enemyHitSfx:setVolume(1 * sfxVolume)
                    love.audio.play(enemyHitSfx)
                    enemy.red = 1
                end
            end

            if (me.AX ~= me.X or me.AY ~= me.Y) and (me.AX == enemy.X and me.AY == enemy.Y) and not death.open then
                if player.dx > me.AX * 32 then
                    player.dx = player.dx - 16
                elseif player.dx < me.AX * 32 then
                    player.dx = player.dx + 16
                end
                if player.dy > me.AY * 32 then
                    player.dy = player.dy - 16
                elseif player.dy < me.AY * 32 then
                    player.dy = player.dy + 16
                end
                attackHitAmount = 1
            end
            addFloat("text", enemy.X * 32, enemy.Y * 32 - 18, (enemy.HP - v.HP) * -1, {1, 0, 0})
            enemy.HP = v.HP
        end

        if enemy.IsAggro == false and v.IsAggro then
            enemy.aggroAlpha = 2
            enemy.IsAggro = true
            if sfxVolume > 0 then
                local aggroSfx = enemySounds[v.Enemy.Name].aggro[love.math.random(1, #enemySounds[v.Enemy.Name].aggro)]
                aggroSfx:setPitch(love.math.random(80, 150) / 100)
                aggroSfx:setVolume(1 * sfxVolume)
                -- if aggroSfx:getChannelCount() == 1 then
                -- --   aggroSfx:setPosition(v.x-player.x,v.y-player.y)
                --     aggroSfx:setPosition(enemy.X-player.x,enemy.Y-player.y)
                -- end
                love.audio.play(aggroSfx)
            end
        end

        enemy.Target = v.Target
        enemy.TargetName = v.TargetName
        
        enemy.X = v.X
        enemy.Y = v.Y

        if enemy.HP > 0 then
            if enemyCollisions[v.X] == null then
                enemyCollisions[v.X] = {}
            end
            enemyCollisions[v.X][v.Y] = true
        end

        enemy.IsAggro = v.IsAggro

        if v.IsAggro then
            if v.HP > 0 then
                enemiesInAggro = enemiesInAggro + 1
            end
            --      if v.TargetName == player.name then -- TODO: fix v.TargetName on the API so this can work properly
            --      boneSpurt(player.dx+16,player.dy+16,v.Enemy.ATK,48,1,0,0)
            --    local attackSfx = attackSfxs[love.math.random(1, #attackSfxs)]
            --    attackSfx:setPitch(love.math.random(50, 100) / 100)
            --    love.audio.play(attackSfx)
            if player.isMounted or player.isMounting then
                beginMounting()
            end
            --  end
        end
    end

    -- print(json:encode_pretty(enemyCollisions))
    if enemyCollisionsI == 0 then
        enemyCollisionsPrevious[0] = copy(enemyCollisions)
        enemyCollisionsPrevious[1] = {}
    else
        enemyCollisionsPrevious[1] = copy(enemyCollisions)
        enemyCollisionsPrevious[0] = {}
    end

end

-- print(me.HP / (100 + (15 * me.STA)))

function drawEnemies()
    -- if me.STA then print(me.HP) end
    for i, v in pairs(enemies) do
        local distance = distanceToPoint(player.cx, player.cy, v.dx, v.dy)
        local range = worldMask.range * 32
        if distance <= range then
            if v.HP > 0 then
                local intensity = 1 - (range / (range + difference(range, distance) * 4) - 0.2)
                local rotation = 1
                local offsetX = 0
                if v and v.previousDirection and v.previousDirection == "left" then
                    rotation = -1
                    offsetX = 32
                end

                if distance <= range then
                    love.graphics.setColor(1, 1 - v.red, (1 - v.red), intensity)
                    love.graphics.draw(enemyImg[v.Enemy.Name], v.dx + offsetX, v.dy, 0, rotation, 1, 0, 0)
                end

                local enemyHealth = me.HP / v.Enemy.ATK
                local playerHealth = v.Enemy.HP / (me.Weapon.Val + (me.STR - 1) * 0.5)
                -- if versionType == "dev" then
                --     love.graphics.print("      " .. math.round(enemyHealth, 2) .. " < " .. math.round(playerHealth, 2),
                --         npcNameFont, v.dx, v.dy - 10)
                -- end

                if me.HP and v.Enemy.ATK and enemyHealth < playerHealth then
                    local distanceIntensity = 1 - (distance / 128)
                    love.graphics.setColor(1, cerp(0, 0.5, nextTick * 2), 0, intensity * distanceIntensity)
                    love.graphics.draw(skull, v.dx - 6, v.dy - 8, 0, 1)
                    -- love.graphics.draw(skull, v.dx - 6 - cerp(0, 2, nextTick * 2), v.dy - 8 - cerp(0, 2, nextTick * 2), 0, cerp(1, 1.2, nextTick * 2))
                end

                -- if distanceToPoint(v.dx, v.dy, player.dx, player.dy) < 256 then 
                if v.dhp < v.mhp or not v.Enemy.CanMove then
                    if v.Enemy.CanMove then
                        love.graphics.setColor(1, 0, 0, intensity)
                        love.graphics.rectangle("fill", v.dx, v.dy - 6, (v.dhp / v.mhp) * 32, 6)
                    else
                        love.graphics.setColor(0.2, 0.2, 1, intensity)
                        love.graphics.rectangle("fill", v.dx, v.dy - 2, (v.dhp / v.mhp) * 32, 2)
                    end
                end

                love.graphics.setColor(1, 1, 1, v.aggroAlpha * intensity)
                love.graphics.draw(alertImg, v.dx + 8, v.dy - 16)
                love.graphics.setColor(1, 1, 1, intensity)

                -- print( "\"" .. v.TargetName .. "\" \"" .. me.Name .. "\"")
                if v.TargetName == player.name and v.Enemy.CanMove then
                    if nextTick >= 1 then
                        enemies[i].linesDrawable = true
                    end
                    if enemies[i].linesDrawable == true and v.IsAggro then
                        if (v.Enemy.Range+1)*32 >= distanceToPoint(v.dx,v.dy,player.dx,player.dy) then
                            love.graphics.setColor(1, 0, 0, nextTick * intensity)
                            love.graphics.line(v.dx + 16, v.dy + 16, player.dx + 16, player.dy + 16)
                            love.graphics.setColor(1, 1, 1, intensity)
                            if v.Enemy.XP / player.lvl > 1 then
                                outlinerOnly:draw(2, enemyImg[v.Enemy.Name], enemyQuads[v.Enemy.Name], v.dx + offsetX, v.dy, 0, rotation, 1, 0, 0)
                            else
                                grayOutlinerOnly:draw(2, enemyImg[v.Enemy.Name], enemyQuads[v.Enemy.Name], v.dx + offsetX, v.dy, 0, rotation, 1, 0, 0)
                            end
                        end
                    end
                else
                    enemies[i].linesDrawable = false
                end

            elseif not v.hasBurst then
                burstLoot(v.dx + 16, v.dy + 16, player.owedxp, "xp")
                local deathSound =
                    enemySounds[v.Enemy.Name].death[love.math.random(1, #enemySounds[v.Enemy.Name].death)]
                love.audio.play(deathSound)
                deathSound:setVolume(1 * sfxVolume)
                boneSpurt(v.dx + 16, v.dy + 16, 10, 25, 1, 1, 1, "mob", v.Enemy.Name)
                v.hasBurst = true
            end
        end
    end
end

function updateEnemies(dt)
    for i, v in pairs(enemies) do
        smoothMovement(v, dt)
        if v.dhp > v.HP then
            v.dhp = v.dhp - difference(v.dhp, v.HP) * dt
        elseif v.dhp < v.HP then
            v.dhp = v.HP
        end

        if difference(v.dhp, v.HP) < 0.1 then
            v.dhp = v.HP
        end

        if v.red > 0 then
            v.red = v.red - 2 * dt
            if v.red < 0 then
                v.red = 0
            end
        end
        v.atkAlpha = v.atkAlpha - 2 * dt
        v.aggroAlpha = v.aggroAlpha - 1 * dt
    end
end

function smoothMovement(v, dt)
    if distanceToPoint(v.dx, v.dy, v.X * 32, v.Y * 32) > 3 then
        local speed = v.speed * 1
        if v.dx > v.X * 32 + 3 then
            v.previousDirection = "left"
            v.dx = v.dx - speed * dt
        elseif v.dx < v.X * 32 - 3 then
            v.previousDirection = "right"
            v.dx = v.dx + speed * dt
        end

        if v.dy > v.Y * 32 + 3 then
            v.dy = v.dy - speed * dt
        elseif v.dy < v.Y * 32 - 3 then
            v.dy = v.dy + speed * dt
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
