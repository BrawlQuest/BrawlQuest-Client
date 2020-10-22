--[[
    This script is for managing other player's actions.
    It could probably be named better. Any ideas, Matt?
]]

function drawOtherPlayer(v,i)
    -- TODO: we need to extract player armour somewhere here, but as we aren't loading in assets yet this hasn't been done
    local thisPlayer = players[i] -- v is playerDrawable
    love.graphics.draw(playerImg, v.X, v.Y)

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