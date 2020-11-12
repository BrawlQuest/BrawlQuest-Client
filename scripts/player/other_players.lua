--[[
    This script is for managing other player's actions.
    It could probably be named better. Any ideas, Matt?
]]

function drawOtherPlayer(v,i)
    -- TODO: we need to extract player armour somewhere here, but as we aren't loading in assets yet this hasn't been done
    local thisPlayer = players[i] -- v is playerDrawable
    if thisPlayer then
        if not itemImg[thisPlayer.Weapon.ImgPath] then
            if love.filesystem.getInfo(thisPlayer.Weapon.ImgPath) then
                itemImg[thisPlayer.Weapon.ImgPath] = love.graphics.newImage(thisPlayer.Weapon.ImgPath)
            else
                itemImg[thisPlayer.Weapon.ImgPath] = love.graphics.newImage("assets/error.png")
            end
        end
  
        drawItemIfExists(thisPlayer.Shield.ImgPath, v.X,v.Y)
   
        love.graphics.draw(itemImg[thisPlayer.Weapon.ImgPath] , v.X-(itemImg[thisPlayer.Weapon.ImgPath]:getWidth()-32), v.Y-(itemImg[thisPlayer.Weapon.ImgPath]:getHeight()-32))
        
        love.graphics.draw(playerImg, v.X, v.Y)

        if thisPlayer.HeadArmourID ~= 0 then
            drawItemIfExists(thisPlayer.HeadArmour.ImgPath,v.X,v.Y)
        end
        if thisPlayer.ChestArmourID ~= 0 then
            drawItemIfExists(thisPlayer.ChestArmour.ImgPath,v.X,v.Y)
        end
        if thisPlayer.LegArmourID ~= 0 then
            drawItemIfExists(thisPlayer.LegArmour.ImgPath,v.X,v.Y)
        end

        if thisPlayer.IsShield then
            drawItemIfExists(thisPlayer.Shield.ImgPath, v.X, v.Y)
        end
        

        love.graphics.setFont(smallTextFont)
        local nameWidth = smallTextFont:getWidth(v.Name)

        love.graphics.setColor(0,0,0,0.6)
        love.graphics.rectangle("fill", (v.X+16)-(nameWidth/2), v.Y-12, nameWidth + 4, 12)
        love.graphics.setColor(1,1,1)
        love.graphics.print(v.Name, (v.X+16)-(nameWidth/2)+2, v.Y-10)

        if thisPlayer ~= nil and thisPlayer.AX then
            diffX = thisPlayer.AX - thisPlayer.X
            diffY = thisPlayer.AY - thisPlayer.Y
            if arrowImg[diffX] ~= nil and arrowImg[diffX][diffY] ~= nil then
                love.graphics.draw(arrowImg[diffX][diffY], v.X-32, v.Y-32)
            end
        end
        love.graphics.setColor(1,1,1)
    end
end

function updateOtherPlayers(dt)
    for i, v in pairs(players) do
        if playersDrawable[i] == nil then
            print("Setting drawable")
            playersDrawable[i] = {
                ['Name'] = v.Name,
                ['X'] = v.X*32,
                ['Y'] = v.X*32,
                ['AX'] = 0,
                ['AY'] = 0
            }
        end
        

        if distanceToPoint(playersDrawable[i].X, playersDrawable[i].Y, v.X*32, v.Y*32) > 64 then
            playersDrawable[i].X = v.X*32
            playersDrawable[i].Y = v.Y*32
        end
        if distanceToPoint(playersDrawable[i].X, playersDrawable[i].Y, v.X*32, v.Y*32) > 1 then
            if playersDrawable[i].X-1 > v.X*32 then
                playersDrawable[i].X =  playersDrawable[i].X  - 64*dt
            elseif playersDrawable[i].X+1 < v.X*32 then
                playersDrawable[i].X = playersDrawable[i].X + 64*dt
            end

            if playersDrawable[i].Y-1 > v.Y*32 then
                playersDrawable[i].Y = playersDrawable[i].Y - 64*dt
            elseif playersDrawable[i].Y+1 < v.Y*32 then
                playersDrawable[i].Y = playersDrawable[i].Y + 64*dt
            end
        end
    end
end

function tickOtherPlayers()
    for i, v in pairs(players) do
        if  playersDrawable[i] then
            if v['Name'] ~= playersDrawable[i]['Name'] then
                playersDrawable[i] = v
            end
            if v.AX ~= 0 then
                if v.AX < v.X then
                playersDrawable[i].X = playersDrawable[i].X - 16
                    
                elseif v.AX > v.X then
                    playersDrawable[i].X = playersDrawable[i].X + 16
                end
            end

            if v.AY ~= 0 then
                if v.AY < v.Y then
                    playersDrawable[i].Y = playersDrawable[i].Y - 16
                elseif v.AY > v.Y then
                    playersDrawable[i].Y = playersDrawable[i].Y + 16
                end
            end
        end
    end
end