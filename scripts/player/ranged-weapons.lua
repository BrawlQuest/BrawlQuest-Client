function initRangedWeapons()
    target = {
        selected = false,
        x = 0,
        y = 0,
        amount = 0,
        shootable = true,
        counter = 0,
        path = {origin = {x = 0, y = 0}},
    }
end

function updateRangedWeapons(dt)
    if target.amount > 0 then
        target.amount = target.amount - 1.1 * dt
        if target.amount < 0 then
            target.selected = false
            target.amount = 0
        end
    end
end

function tickRangedWeapons()
    if target.selected and target.amount == 0 then 
        target.amount = 1
        target.path = {origin = {x = player.x, y = player.y}}
        target.shootable, target.counter = Bresenham.line(player.x, player.y, target.x, target.y, function (x, y)
            if worldLookup[x] and worldLookup[x][y] and worldLookup[x][y].Collision ~= null then
                target.path[#target.path + 1] = {x = x, y = y,}
                return not worldLookup[x][y].Collision
            end
        end)
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
        for i,v in ipairs(target.path) do
            if i > 2 then -- and i < #target.path then
                love.graphics.rectangle("fill", v.x * 32, v.y * 32, 32, 32) 
            end
        end
    end
end

function drawRangedWeaponEffects()
    if target.amount > 0 then 
        love.graphics.setColor(1,1,1,cerp(0, 1, target.amount))
        love.graphics.setLineWidth( 2 )
        local origin, dest = target.path.origin, target.path
        love.graphics.line(origin.x * 32 + 16, origin.y * 32 + 16, dest[#dest-1].x * 32 + 16, dest[#dest-1].y * 32 + 16)
    end
    love.graphics.setColor(1,1,1,1)
end