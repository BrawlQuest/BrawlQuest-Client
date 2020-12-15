buddies = {}

function updateBuddy(dt, pl)
    if buddies[pl.Name] == null then
        buddies[pl.Name] = {
            X = pl.X,
            Y = pl.Y,
            img = pl.Buddy,
            previousDirection = "left"
        }
    end

    local v = buddies[pl.Name]
    local speed = distanceToPoint(v.X,v.Y,pl.X+16,pl.Y+16)*dt
    if v.X+3 > pl.X+16 then
        v.X = v.X - speed
        v.previousDirection = "left"
    elseif v.X-3 < pl.X+16 then
        v.X = v.X + speed
        v.previousDirection = "right"
    end
    if v.Y > pl.Y+16 then
        v.Y = v.Y - speed
    elseif v.Y < pl.Y+16 then
        v.Y = v.Y + speed
    end    
    buddies[pl.Name] = v
end

function drawBuddy(pl)
    if pl then
        local rotation = 1
        local offsetX = 0
      
        if buddies[pl] ~= null then
            local v = buddies[pl]
            if v.previousDirection and v.previousDirection == "left" then
                rotation = -1
                offsetX = 8
            end
            local img = getImgIfNotExist(v.img)
            love.graphics.draw(img, v.X+offsetX, v.Y, 0, rotation, 1, 0, 0)
        end
    end
end