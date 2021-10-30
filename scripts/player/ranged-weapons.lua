function initRangedWeapons()
    target = {
        selected = false,
        x = 0,
        y = 0,
        amount = 0,
        shootable = true,
        counter = 0,
        paths = {origin = {x = 0, y = 0}},
        hit = {x = 0, y = 0,},
        prevHit = {x = 0, y = 0,},
    }
    throw = {
        open = false,
        amount = 0,
        speed = 2,
    }
    explosions = {}
    explImage = love.graphics.newImage("scripts/libraries/luven/lights/round.png")
    noManaSFX = love.audio.newSource("assets/sfx/player/actions/no mana.ogg", "static")
    smokeImg = love.graphics.newImage("assets/auras/Smoke.png")
    smokeImages = {}
    for x = 0, 8, 1 do
        smokeImages[#smokeImages+1] = love.graphics.newQuad(x * 16, 0, 16, 16, smokeImg:getDimensions())
    end
    smokeParticles = {}
    projectile = love.graphics.newImage("assets/player/gen/spell-projectile.png")
end

function updateRangedWeapons(dt)
    local t = target
    panelMovement(dt, target, -1, "amount", 1.5)
    if target.amount < 0 then target.selected = false end
    panelMovement(dt, throw, 1, "amount", throw.speed)
    if throw.open and throw.amount == 1 and t and t.hit and t.hit.x and t.hit.y then
        --create a weird sfx
        if staffExplode:isPlaying() then staffExplode:stop() end
        staffExplode = generateNoise()
        staffExplode:setVolume(0.2 * sfxVolume)
        staffExplode:setPosition(t.hit.x, t.hit.y)
        staffExplode:setRolloff(sfxRolloff * 0.5)
        setEnvironmentEffects(staffExplode)
        -- staffExplode:setPitch(love.math.random())
        staffExplode:play()
        addExplosion(t.hit.x, t.hit.y)
        throw.open = false
    end
    updateExplosions(dt)
end

function tickRangedWeapons()
    if target.selected and target.amount == 0 and me and me.Mana >= 5 then
        target.amount = 1
        target.selected = false
        throw.amount = 0
        throw.open = true
        target.paths = {origin = {x = player.x, y = player.y}}
        target.shootable, target.counter = Bresenham.line(player.x, player.y, target.x, target.y, function (x, y)
            if worldLookup[x..","..y] and worldLookup[x..","..y].Collision ~= null then
                local output = not worldLookup[x..","..y].Collision
                target.paths[#target.paths + 1] = {x = x, y = y,}
                if isTileWater(worldLookup[x..","..y].ForegroundTile) then output = true end
                return output
            end
        end)
        hitTarget()
    elseif me and me.Mana < 5 and target.selected then
        noManaSFX:setVolume(sfxVolume)
        noManaSFX:play()
    end
end

function drawRangedWeaponsGrid(x,y)
    local thisX, thisY = x * 32, y * 32
    if not uiOpen and holdingStaff() and isMouseOverTile(thisX, thisY) then
        love.graphics.setColor(1,1,1,0.5)
        roundRectangle("fill", thisX, thisY, 32, 32, 2)
        if love.mouse.isDown(1) and target.amount == 0 then
            target.selected = true
            target.x , target.y = x, y
        end
    end
end

function drawRangedWeaponEffects()
    if target.amount > 0 then
        local origin, paths = target.paths.origin, target.paths
        if #paths > 1 then
            local originX = player.dx + 16
            local originY = player.dy + 16
            local destX = cerp(originX, paths[#paths].x * 32 + 16, 1 - target.amount)
            local destY = cerp(originY, paths[#paths].y * 32 + 16, 1 - target.amount)
            love.graphics.setColor(1,0.5,0.5,0.9 * ((target.amount)))
            love.graphics.push()
            love.graphics.translate(destX, destY)
            love.graphics.rotate(math.angle(originX, originY, paths[#paths].x * 32 + 16, paths[#paths].y * 32 + 16))
            love.graphics.scale(1)
            love.graphics.draw(projectile, -projectile:getWidth() / 2, -projectile:getHeight() / 2)
            love.graphics.pop()
            love.graphics.setBlendMode("alpha")
        end
    end
    love.graphics.setColor(1,1,1,1)
end

function hitTarget()
    target.hit = target.paths[#target.paths] or null
    if target.hit then
        local x, y = target.hit.x, target.hit.y -- hit a target on these coordinates
        apiGET('/ranged/' .. me.ID .. "/" .. x .. "/" .. y)
    end
end

function updateExplosions(dt)
    for i,v in ipairs(explosions) do
        v.alpha = v.alpha - 2 * dt
        v.width = v.width - 1 * dt
        if v.alpha <= 0 then table.remove(explosions, i) end
    end

    for i,v in ipairs(smokeParticles) do
        v.x = v.x + v.vx * dt
        v.y = v.y + v.vy * dt
        v.vx = math.damp(dt, v.vx, 20)
        v.vy = math.damp(dt, v.vy, 20, -16)
        v.alpha = v.alpha - v.alphaRate * dt
        if v.alpha <= 0 then table.remove(smokeParticles, i) end
        v.imageAmount = v.imageAmount + v.frameRate * dt
        if v.imageAmount >= 1 then
            if v.imageNo > 1 then v.imageNo = v.imageNo - 1
            else v.imageNo = v.imageNo + 1 end
            v.imageAmount = 0
        end
    end
end

function drawExplosions()
    love.graphics.setBlendMode("add")
    for i,v in ipairs(explosions) do
        love.graphics.setColor(1,0,0,v.alpha)
        love.graphics.draw(explImage, v.x * 32 + 16 - explImage:getWidth() / (2 / v.width), v.y * 32 + 16 - explImage:getWidth() / (2 / v.width), 0, v.width)
    end

    for i,v in ipairs(smokeParticles) do
        love.graphics.setColor(1,1,1,v.alpha)
        love.graphics.draw(smokeImg, smokeImages[v.imageNo], v.x, v.y, 0, 2)
    end
    love.graphics.setBlendMode("alpha")
end

function addExplosion(x,y)
   
    explosions[#explosions+1] = {
        x = x,
        y = y,
        alpha = 1,
        width = 1,
    }

    for i = 1, 10 do
        local r = math.rad(love.math.random(0, 360))
        local speed = 32
        smokeParticles[#smokeParticles+1] = {
            vx = math.cos(r) * speed,
            vy = math.sin(r) * speed,
            x = x * 32,
            y = y * 32,
            imageNo = 8,
            imageAmount = 0,
            frameRate = love.math.random() * 2 + 1,
            alpha = 1,
            alphaRate = love.math.random() * 0.4 + 0.2,
        }
    end
end