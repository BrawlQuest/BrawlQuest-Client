enemies = {}
enemyImg = {}

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

function newEnemyData(data) -- called when nearby data is returned
    enemiesInAggro = 0

    for i, v in ipairs(data) do
        local id = v.ID
        local enemy = enemies[v.ID]

        if not enemy then
            print("Created new enemy with ID " .. v.ID)
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

            end
            enemy.HP = v.HP
            enemy.red = 1

            enemyHitSfx:setPitch(love.math.random(50, 100) / 100)
            love.audio.play(enemyHitSfx)
            boneSpurt(enemy.dx + 16, enemy.dy + 16, 4, 48, 1, 1, 1)
        end

        if enemy.IsAggro == false and v.IsAggro then
            enemy.aggroAlpha = 2
            enemy.IsAggro = true
            local aggroSfx = aggroSfxs[love.math.random(1, #aggroSfxs)]
            aggroSfx:setPitch(love.math.random(80, 150) / 100)
            --   aggroSfx:setPosition(v.x-player.x,v.y-player.y)
            love.audio.play(aggroSfx)
        end

        enemy.Target = v.Target
        enemy.X = v.X
        enemy.Y = v.Y

        enemy.IsAggro = v.IsAggro
        if v.IsAggro then
            if v.HP > 0 then enemiesInAggro = enemiesInAggro + 1 end
            --  if v.TargetName == player.name then -- TODO: fix v.TargetName on the API so this can work properly
            --  boneSpurt(player.dx+16,player.dy+16,v.Enemy.ATK,48,1,0,0)
            local attackSfx = attackSfxs[love.math.random(1, #attackSfxs)]
            attackSfx:setPitch(love.math.random(50, 100) / 100)
            love.audio.play(attackSfx)
            if player.isMounted or player.isMounting then
                beginMounting()
            end
            --  end
        end
    end
end

function drawEnemies()
    for i, v in pairs(enemies) do
        if v.HP > 0 then
            if isTileLit(v.X, v.Y) then
                love.graphics.setColor(1, 1 - v.red, 1 - v.red)
                love.graphics.draw(enemyImg[v.Enemy.Name], v.dx, v.dy)
                love.graphics.setColor(1, 0, 0)
                love.graphics.rectangle("fill", v.dx, v.dy - 6, (v.dhp / v.mhp) * 32, 6)
                love.graphics.setColor(1, 1, 1, v.aggroAlpha)
                love.graphics.draw(alertImg, v.dx + 8, v.dy - 16)
                love.graphics.setColor(1, 1, 1)
                -- love.graphics.setFont(smallTextFont)
          --      love.graphics.printf(tostring(v.IsAggro), v.dx, v.dy-6, 32, "center")
            end

         if distanceToPoint(v.dx,v.dy,player.dx,player.dy) < (v.Enemy.Range+1)*32 then
            love.graphics.setColor(1, 0, 0)
            love.graphics.line(v.dx + 16, v.dy + 16, player.dx + 16, player.dy + 16)
            love.graphics.setColor(1, 1, 1, 1)
         end
        elseif not v.hasBurst then
            burstLoot(v.dx + 16, v.dy + 16, math.abs(v.Enemy.HP / 3), "xp")
            enemyHitSfx:setPitch(love.math.random(50, 100) / 100)
            love.audio.play(enemyHitSfx)

            love.audio.play(deathSfxs[love.math.random(1, #deathSfxs)])
            boneSpurt(v.dx + 16, v.dy + 16, 48, 72, 0.8, 0.8, 1)
            v.hasBurst = true
        end
    end
end

function updateEnemies(dt)
    for i, v in pairs(enemies) do
        smoothMovement(v, dt)
        if v.dhp > v.HP then
            v.dhp = v.dhp - 1 * dt
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
        if v.dx > v.X * 32 + 3 then
            v.dx = v.dx - v.speed * dt
        elseif v.dx < v.X * 32 - 3 then
            v.dx = v.dx + v.speed * dt
        end

        if v.dy > v.Y * 32 + 3 then
            v.dy = v.dy - v.speed * dt
        elseif v.dy < v.Y * 32 - 3 then
            v.dy = v.dy + v.speed * dt
        end
    else
        v.dx = v.X * 32 -- preventing blurring from fractional pixels
        v.dy = v.Y * 32
    end
end

function tickEnemies()
    for i, v in ipairs(enemies) do
        local enemy = v
        enemy.speed = distanceToPoint(enemy.dx, enemy.dy, v.X * 32, v.Y * 32)
        --if tostring(enemy.IsAggro) == "true" then enemy.atkAlpha = 1 end
    end
end