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
        throw.open = false
    end
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
            local destX = cerp(originX, paths[#paths].x * 32 + 16, throw.amount)
            local destY = cerp(originY, paths[#paths].y * 32 + 16, throw.amount)
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
    print("You hit: " .. json:encode(target.hit))
    local x, y = target.hit.x, target.hit.y -- hit a target on these coordinates
    apiGET('/ranged/' .. me.ID .. "/" .. target.hit.x .. "/" .. target.hit.y)
end