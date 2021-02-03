buddies = {}

function updateBuddy(dt, pl)
    if buddies[pl.Name] == null or buddies[pl.Name].img ~= pl.Buddy then
        buddies[pl.Name] = {
            X = pl.X,
            Y = pl.Y,
            img = pl.Buddy,
            previousDirection = "left"
        }
    end

    local v = buddies[pl.Name]
    local speed = {}
    speed.X = difference(v.X, pl.X+16) * dt
    speed.Y = difference(v.Y, pl.Y+16) * dt
    if distanceToPoint(v.X,v.Y,pl.X+16,pl.Y+16) > 18 then
        if v.X > pl.X+16 then
            v.X = v.X - speed.X
            v.previousDirection = "left"
        elseif v.X < pl.X+16 then
            v.X = v.X + speed.X
            v.previousDirection = "right"
        end
        if v.Y > pl.Y+16 then
            v.Y = v.Y - speed.Y
        elseif v.Y < pl.Y+16 then
            v.Y = v.Y + speed.Y
        end    
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
            if v.img then
             local img = getImgIfNotExist(v.img)
          
                love.graphics.draw(img, v.X+offsetX, v.Y, 0, rotation, 1, 0, 0)
            end
        end
    end
end