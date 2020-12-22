function initCamera()
    camera = {}
    camera.X = player.x*32
    camera.Y = player.y*32
end

function updateCamera(dt)
    local speed = {}

    speed.X = difference(player.dx, camera.X) * 1.1
    speed.Y = difference(player.dy, camera.Y) * 1.1

    if camera.X > player.x * 32 then
        camera.X = camera.X - speed.X * dt
    elseif camera.X < player.x * 32 then
        camera.X = camera.X + speed.X * dt
    end

    if camera.Y > player.y * 32 then
        camera.Y = camera.Y - speed.Y * dt
    elseif camera.Y < player.y * 32 then
        camera.Y = camera.Y + speed.Y * dt
    end


    Luven.camera:setPosition(camera.X + 16, camera.Y + 16)
    -- print(speed.X)
end