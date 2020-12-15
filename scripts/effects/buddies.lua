buddies = {}

function updatePlayerBuddy(dt, player)
    if buddies[player.Name] == null then
        buddies[player.Name] = {
            X = player.X,
            Y = player.Y,
            img = player.Buddy
        }
    end

    local v = buddies[player.Name]
    local speed = distanceToPoint(v.X,player.X)*dt
    if v.X > player.X then
        v.X = v.X - speed
    elseif v.X < player.X then
        v.X = v.X + speed
    end
    if v.Y > player.Y then
        v.Y = v.Y - speed
    elseif v.Y < player.Y then
        v.Y = v.Y + speed
    end    
    buddies[player.Name] = v
end

function drawBuddy(player)
    if player and player.Buddy and player.Buddy ~= null then
        local v = buddies[player.Name]
        local img = getImgIfNotexist(v.img)
        love.graphics.draw(img, v.X, v.Y)
    end
end