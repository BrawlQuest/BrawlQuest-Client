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
    smokeImg = love.graphics.newImage("assets/auras/Smoke.png")
    smokeImages = {}
    for x = 0, 8, 1 do
        smokeImages[#smokeImages+1] = love.graphics.newQuad(x * 16, 0, 16, 16, smokeImg:getDimensions())
    end
    smokeParticles = {}
end

function updateRangedWeapons(dt)
    local t = target
    panelMovement(dt, target, -1, "amount", 1.5)
    if target.amount < 0 then target.selected = false end
    panelMovement(dt, throw, 1, "amount", throw.speed)
    if throw.open and throw.amount == 1 then
        --create a weird sfx
        if staffExplode:isPlaying() then staffExplode:stop() end
        staffExplode = generateNoise()
        staffExplode:setVolume(0.2 * sfxVolume)
        staffExplode:setPosition(t.hit.x, t.hit.y)
        -- staffExplode:setPitch(love.math.random()) 
        staffExplode:play()
        addExplosion(t.hit.x, t.hit.y)
        throw.open = false
    end
    updateExplosions(dt)
end

function tickRangedWeapons()
    if target.selected and target.amount == 0 then
        target.amount = 1
        target.selected = false
        throw.amount = 0
        throw.open = true
        target.paths = {origin = {x = player.x, y = player.y}}
        target.shootable, target.counter = Bresenham.line(player.x, player.y, target.x, target.y, function (x, y)
            if worldLookup[x] and worldLookup[x][y] and worldLookup[x][y].Collision ~= null then
                target.paths[#target.paths + 1] = {x = x, y = y,}
                return not worldLookup[x][y].Collision
            end
        end)
        hitTarget()
    end
end

function drawRangedWeaponsGrid(x,y)
    local thisX, thisY = x * 32, y * 32

    if isMouseOverTile(thisX, thisY) then
        love.graphics.setColor(1,1,1,0.5)
        roundRectangle("fill", thisX, thisY, 32, 32, 2)
        if love.mouse.isDown(1) and target.amount == 0 then
            target.selected = true
            target.x , target.y = x, y
        end
    end

    if target.selected and x == target.x and y == target.y then
        local targetCerp = cerp(0, 0.6, target.amount)
        if target.shootable == true then love.graphics.setColor(0,1,0,targetCerp) else love.graphics.setColor(1,0,0,targetCerp) end
        -- love.graphics.rectangle("fill", target.x * 32, target.y * 32, 32, 32)
        -- love.graphics.setColor(1,1,1, targetCerp)
        for i,v in ipairs(target.paths) do
            if i > 2 and i < #target.paths then
                love.graphics.rectangle("fill", v.x * 32, v.y * 32, 32, 32)
                break
            end
        end
    end
end

function drawRangedWeaponEffects()
    if target.amount > 0 then 
        love.graphics.setColor(1,1,1,throw.amount + 0.2)
        love.graphics.setLineWidth( 2 + target.amount )
        local origin, paths = target.paths.origin, target.paths
        if #paths > 1 then
            local originX = player.dx + 16
            local originY = player.dy + 16
            local destX = cerp(originX, paths[#paths].x * 32 + 16, 1 - target.amount)
            local destY = cerp(originY, paths[#paths].y * 32 + 16, 1 - target.amount)
            -- local destX = paths[#paths].x * 32 + 16
            -- local destY = paths[#paths].y * 32 + 16
            -- love.graphics.line(originX, originY, destX, destY)
            love.graphics.setBlendMode("add")
            love.graphics.setColor(1,0,1,0.8 * ((1 - throw.amount) + 0.2))
            love.graphics.circle("fill", destX, destY, 10)
            love.graphics.setBlendMode("alpha")
        end
    end
    love.graphics.setColor(1,1,1,1)
end

function hitTarget()
    target.hit = target.paths[#target.paths] or null
    local x, y = target.hit.x, target.hit.y -- hit a target on these coordinates
    apiGET('/ranged/' .. me.ID .. "/" .. x .. "/" .. y)
end

function updateExplosions(dt)
    for i,v in ipairs(explosions) do
        v.alpha = v.alpha - 2 * dt
        v.width = v.width - 1 * dt
    end

    for i,v in ipairs(smokeParticles) do
        v.x = v.x + v.vx * dt
        v.y = v.y + v.vy * dt
        v.vx = math.damp(dt, v.vx, 20)
        v.vy = math.damp(dt, v.vy, 20, -16)  
    end
end

function drawExplosions()
    love.graphics.setBlendMode("add")
    for i,v in ipairs(explosions) do
        love.graphics.setColor(1,0,0,v.alpha)
        love.graphics.draw(explImage, v.x * 32 + 16 - explImage:getWidth() / (2 / v.width), v.y * 32 + 16 - explImage:getWidth() / (2 / v.width), 0, v.width)
        -- love.graphics.circle("fill", v.x * 32 + 16, v.y * 32 + 16, 64 * v.width)
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(smokeImg, smokeImages[1], v.x * 32 + 16, v.y * 32 + 16)
    end
    love.graphics.setBlendMode("alpha")

    for i,v in ipairs(smokeParticles) do
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(smokeImg, smokeImages[1], v.x, v.y)
    end

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
        }
    end
end