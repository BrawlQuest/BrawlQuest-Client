function initCamera()
    -- camera = {
    --     X = player.dx,
    --     Y = player.dy,
    --     lookingDistance = {x = 32 * 2, y = 32 * 2},
    --     smoothing = false,
    --     lookahead = true,
    -- }
end

function updateCamera(dt)
    Luven.camera:setPosition(player.cx + 16, player.cy + 16)

    -- local speed = {}
    
    -- speed.X = difference(player.cx, camera.X) * 1
    -- speed.Y = difference(player.cy, camera.Y) * 1

    -- if love.keyboard.isDown(keybinds.UP) then
    --     player.direction.y = player.direction.y - 1 * dt
    --     if player.direction.y < -1 then player.direction.y = -1 end
    -- elseif love.keyboard.isDown(keybinds.DOWN) then
    --     player.direction.y = player.direction.y + 1 * dt
    --     if player.direction.y > 1 then player.direction.y = 1 end
    -- else
    --     if  player.direction.y > 0.01 then
    --         player.direction.y = player.direction.y - 1 * dt
    --     elseif player.direction.y < -0.01 then
    --         player.direction.y = player.direction.y + 1 * dt
    --     end
    -- end

    -- if love.keyboard.isDown(keybinds.LEFT) then
    --     player.direction.x = player.direction.x - 1 * dt
    --     if player.direction.x < -1 then player.direction.x = -1 end
    -- elseif love.keyboard.isDown(keybinds.RIGHT) then
    --     player.direction.x = player.direction.x + 1 * dt
    --     if player.direction.x > 1 then player.direction.x = 1 end
    -- else
    --     if  player.direction.x > 0.01 then
    --         player.direction.x = player.direction.x - 1 * dt
    --     elseif player.direction.x < -0.01 then
    --         player.direction.x = player.direction.x + 1 * dt
    --     end
    -- end

    -- -- print( player.direction.x .. " " .. player.direction.y)

    -- if camera.lookahead then
    --     if player.target.active then
    --         player.cx = (player.x * 32 + (camera.lookingDistance.x * player.direction.x))
    --         player.cy = (player.y * 32 + (camera.lookingDistance.y * player.direction.y))
    --     else
    --         player.cx = (player.dx + (camera.lookingDistance.x * player.direction.x))
    --         player.cy = (player.dy + (camera.lookingDistance.y * player.direction.y))
    --     end
    -- else
    --     if player.target.active then
    --         player.cx = (player.x * 32)
    --         player.cy = (player.y * 32)
    --     else
    --         player.cx = (player.dx)
    --         player.cy = (player.dy)
    --     end
    -- end

    -- if camera.X > player.cx then
    --     camera.X = camera.X - speed.X * dt
    -- elseif camera.X < player.cx then
    --     camera.X = camera.X + speed.X * dt
    -- end

    -- if camera.Y > player.cy then
    --     camera.Y = camera.Y - speed.Y * dt
    -- elseif camera.Y < player.cy then
    --     camera.Y = camera.Y + speed.Y * dt
    -- end

    -- if camera.smoothing then
    --     Luven.camera:setPosition(camera.X + 16, camera.Y + 16)
    -- else

        -- if player.target.active then
        --     Luven.camera:setPosition(player.x * 32 + 16, player.y * 32 + 16)
        -- else
        --     Luven.camera:setPosition(player.dx + 16, player.dy + 16)
        -- end
    -- end
end