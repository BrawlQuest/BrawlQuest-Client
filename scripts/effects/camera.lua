function initCamera()
    camera = {
        X = player.dx,
        Y = player.dy,
        lookingDistance = {x = 32 * 1.5, y = 32},
        smoothing = true,
        lookahead = true,
    }
end

function updateCamera(dt)
    local speed = {}

    if love.keyboard.isDown(keybinds.UP) then
        player.direction.y = -1
    elseif love.keyboard.isDown(keybinds.DOWN) then
        player.direction.y = 1
    -- else
    --     player.direction.y = 0
    end

    if love.keyboard.isDown(keybinds.LEFT) then
        player.direction.x = -1
    elseif love.keyboard.isDown(keybinds.RIGHT) then
        player.direction.x = 1
    else
        player.direction.x = 0
    end

    if camera.lookahead then
        if player.target.active then
            player.cx = (player.x * 32 + (camera.lookingDistance.x * player.direction.x))
            player.cy = (player.y * 32 + (camera.lookingDistance.y * player.direction.y))
        else
            player.cx = (player.dx + (camera.lookingDistance.x * player.direction.x))
            player.cy = (player.dy + (camera.lookingDistance.y * player.direction.y))
        end
    else
        if player.target.active then
            player.cx = (player.x * 32)
            player.cy = (player.y * 32)
        else
            player.cx = (player.dx)
            player.cy = (player.dy)
        end
    end

    speed.X = difference(player.cx, camera.X) * 1
    speed.Y = difference(player.cy, camera.Y) * 1

    if camera.X > player.cx then
        camera.X = camera.X - speed.X * dt
    elseif camera.X < player.cx then
        camera.X = camera.X + speed.X * dt
    end

    if camera.Y > player.cy then
        camera.Y = camera.Y - speed.Y * dt
    elseif camera.Y < player.cy then
        camera.Y = camera.Y + speed.Y * dt
    end

    if camera.smoothing then
        Luven.camera:setPosition(camera.X + 16, camera.Y + 16)
    else
        if player.target.active then
            Luven.camera:setPosition(camera.X + 16, camera.Y + 16)
        else
            Luven.camera:setPosition(player.dx + 16, player.dy + 16)
        end
    end
end