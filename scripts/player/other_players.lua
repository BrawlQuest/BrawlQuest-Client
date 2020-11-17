--[[
    This script is for managing other player's actions.
    It could probably be named better. Any ideas, Matt?
]]

function drawCharacter(v,x,y,ad)
    if ad then
        if not itemImg[v.Weapon.ImgPath] then
            if love.filesystem.getInfo(v.Weapon.ImgPath) then
                itemImg[v.Weapon.ImgPath] = love.graphics.newImage(v.Weapon.ImgPath)
            else
                itemImg[v.Weapon.ImgPath] = love.graphics.newImage("assets/error.png")
            end
        end

        drawItemIfExists(v.Shield.ImgPath, x,y,ad.previousDirection)

    
    local rotation = 1
    local offsetX = 0
    if ad and ad.previousDirection and ad.previousDirection == "left" then
        rotation = -1
        offsetX = 32
        love.graphics.draw(itemImg[v.Weapon.ImgPath],
            x + (itemImg[v.Weapon.ImgPath]:getWidth() - 32) + 32,
           y - (itemImg[v.Weapon.ImgPath]:getHeight() - 32), 0, rotation, 1, 0, 0)
    elseif ad and ad.previousDirection and ad.previousDirection == "right" then
        love.graphics.draw(itemImg[v.Weapon.ImgPath], x - (itemImg[v.Weapon.ImgPath]:getWidth() - 32),
           y - (itemImg[v.Weapon.ImgPath]:getHeight() - 32), 0, rotation, 1, 0, 0)
    end

    -- if v.isMounted then
    --     love.graphics.draw(horseImg, player.dx + 6, player.dy + 9)
    -- end
    love.graphics.draw(playerImg, x+offsetX, y, 0, rotation, 1, 0, 0)

   
        if v.HeadArmourID ~= 0 then
            drawItemIfExists(v.HeadArmour.ImgPath,x,y,ad.previousDirection)
        end
        if v.ChestArmourID ~= 0 then
            drawItemIfExists(v.ChestArmour.ImgPath,x,y,ad.previousDirection)
        end
        if v.LegArmourID ~= 0 then
            drawItemIfExists(v.LegArmour.ImgPath,x,y,ad.previousDirection)
        end

        if v.IsShield then
            drawItemIfExists(v.Shield.ImgPath, x, y,ad.previousDirection)
        end
    end
end

function drawOtherPlayer(v,i)
    -- TODO: we need to extract player armour somewhere here, but as we aren't loading in assets yet this hasn't been done
    local thisPlayer = players[i] -- v is playerDrawable
    if thisPlayer and v and thisPlayer.Weapon then
        if not v.previousDirection then v.previousDirection = "right" end
        drawCharacter(thisPlayer,v.X,v.Y,v)

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
                playersDrawable[i].previousDirection = "left"
            elseif playersDrawable[i].X+1 < v.X*32 then
                playersDrawable[i].X = playersDrawable[i].X + 64*dt
                playersDrawable[i].previousDirection = "right"
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