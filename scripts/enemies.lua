enemies = {}
enemyImg = {}
enemyCollisions = {}
enemyCollisionsPrevious = {[0] = {}, [1] = {},} 
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

            if enemy.HP <= 0 then
                enemy.hasBurst = true
            else
                enemy.hasBurst = false
            end

            if enemyImg[enemy.Enemy.Name] == null then
                enemyImg[enemy.Enemy.Name] = love.graphics.newImage(enemy.Enemy.Image)
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
                    for i,v in pairs(enemySounds[enemy.Enemy.Name]) do
                     --   print("Adding "..i.." sounds from " .. "assets/sfx/monsters/" .. enemy.Enemy.Name .. "/" .. i)
                        local files = recursiveEnumerate("assets/sfx/monsters/" .. enemy.Enemy.Name .. "/" .. i, {})
                        for k, file in ipairs(files) do
                       --     print("Found "..file)
                            enemySounds[enemy.Enemy.Name][i][#enemySounds[enemy.Enemy.Name][i]+1] = love.audio.newSource(file, "static")
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
        end

        if enemy.HP ~= v.HP then
            if (me.AX ~= me.X or me.AY ~= me.Y) and (me.AX == enemy.X and me.AY == enemy.Y) then
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
            addFloat(enemy.X*32,enemy.Y*32,enemy.HP - v.HP,{1,0,0})
            enemy.HP = v.HP
            enemy.red = 1

            enemyHitSfx:setPitch(love.math.random(50, 100) / 100)
            love.audio.play(enemyHitSfx)
            boneSpurt(enemy.dx + 16, enemy.dy + 16, 4, 20, 1, 1, 1)
        end

        if enemy.IsAggro == false and v.IsAggro then
            enemy.aggroAlpha = 2
            enemy.IsAggro = true
            local aggroSfx = enemySounds[v.Enemy.Name].aggro[love.math.random(1, #enemySounds[v.Enemy.Name].aggro)]
            aggroSfx:setPitch(love.math.random(80, 150) / 100)
            --   aggroSfx:setPosition(v.x-player.x,v.y-player.y)
            love.audio.play(aggroSfx)
        end

        enemy.Target = v.Target
        enemy.X = v.X
        enemy.Y = v.Y

        if enemy.HP > 0 then
            if enemyCollisions[v.X] == null then enemyCollisions[v.X] = {} end
            enemyCollisions[v.X][v.Y] = true
        end

        enemy.IsAggro = v.IsAggro
        if v.IsAggro then
            if v.HP > 0 then enemiesInAggro = enemiesInAggro + 1 end
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

function drawEnemies()
    for i, v in pairs(enemies) do
        if v.HP > 0 then

            local rotation = 1
            local offsetX = 0
            if v and v.previousDirection and v.previousDirection == "left" then
                rotation = -1
                offsetX = 32
            end

            love.graphics.setColor(1, 1 - v.red, 1 - v.red)
            love.graphics.draw(enemyImg[v.Enemy.Name], v.dx + offsetX, v.dy, 0, rotation, 1, 0, 0)
            if distanceToPoint(v.dx, v.dy, player.dx, player.dy) < 256 then
                if v.Enemy.CanMove then
                    love.graphics.setColor(1, 0, 0, 1 - (distanceToPoint(v.dx, v.dy, player.dx, player.dy)/256))
                    love.graphics.rectangle("fill", v.dx, v.dy - 6, (v.dhp / v.mhp) * 32, 6)
                else
                    love.graphics.setColor(1,0,0)
                    love.graphics.rectangle("fill", v.dx, v.dy - 2, (v.dhp / v.mhp) * 32, 2)
                end
            end
            love.graphics.setColor(1, 1, 1, v.aggroAlpha)
            love.graphics.draw(alertImg, v.dx + 8, v.dy - 16)
            love.graphics.setColor(1, 1, 1)

         if distanceToPoint(v.dx,v.dy,player.dx,player.dy) < (v.Enemy.Range+1)*32 and v.Target == me.id then
            love.graphics.setColor(1, 0, 0)
            love.graphics.line(v.dx + 16, v.dy + 16, player.dx + 16, player.dy + 16)
            love.graphics.setColor(1, 1, 1, 1)
         end
        elseif not v.hasBurst then
            burstLoot(v.dx + 16, v.dy + 16, math.abs(v.Enemy.HP / 3), "xp")

            love.audio.play(enemySounds[v.Enemy.Name].death[love.math.random(1, #enemySounds[v.Enemy.Name].death)])
            boneSpurt(v.dx + 16, v.dy + 16, 10, 25, 1, 1, 1)
            v.hasBurst = true
        end
    end
end

function updateEnemies(dt)
    for i, v in pairs(enemies) do
        smoothMovement(v, dt)
        if v.dhp > v.HP then
            v.dhp = v.dhp - difference(v.dhp,v.HP) * dt
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
    if enemyCollisionsI == 0 then enemyCollisionsI = 1 else enemyCollisionsI = 0 end
end
