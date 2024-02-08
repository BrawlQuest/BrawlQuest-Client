buddies = {}

function updateBuddy(dt, pl)
    if buddies[pl.name] ~= null then
        local v = buddies[pl.name]
        local speed = {}
        speed.x = difference(v.x, pl.x+16) * dt
        speed.y = difference(v.y, pl.y+16) * dt
        if distanceToPoint(v.x,v.y,pl.x+16,pl.y+16) > 18 then
            if v.x > pl.x+16 then
                v.x = v.x - speed.x
                v.previousDirection = "left"
            elseif v.x < pl.x+16 then
                v.x = v.x + speed.x
                v.previousDirection = "right"
            end
            if v.y > pl.y+16 then
                v.y = v.y - speed.y
            elseif v.y < pl.y+16 then
                v.y = v.y + speed.y
            end    
        end
        buddies[pl.name] = v
    end
end

function drawBuddy(pl)

    if pl and pl.name and pl.buddy ~= "None" then
      
        local rotation = 1
        local offsetX = 0
      
        if buddies[pl.name] and buddies[pl.name].img == pl.buddy then
            
            local v = buddies[pl.name]
            if v.previousDirection and v.previousDirection == "left" then
                rotation = -1
                offsetX = 8
            end
            if v.img then
  
             local img = getImgIfNotExist(v.img)
          
                love.graphics.draw(img, v.x+offsetX, v.y, 0, rotation, 1, 0, 0)
            end
        else
            buddies[pl.name] = {
                X = pl.x*32,
                Y = pl.y*32,
                img = pl.buddy,
                previousDirection = "left"
            }
        end
    end
end