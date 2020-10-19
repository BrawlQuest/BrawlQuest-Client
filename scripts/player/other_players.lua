--[[
    This script is for managing other player's actions.
    It could probably be named better. Any ideas, Matt?
]]

function drawOtherPlayer(v)
    -- TODO: we need to extract player armour somewhere here, but as we aren't loading in assets yet this hasn't been done
    love.graphics.draw(playerImg, v.X, v.Y)
    
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill", v.X, v.Y-12, 32, 12)
    love.graphics.setColor(1,1,1)
    love.graphics.print(v.Name, v.X, v.Y-12)
end

function updateOtherPlayers(dt)
    for i, v in pairs(players) do
        if playersDrawable[i] == nil then
            playersDrawable[i] = {
                ['Name'] = v.Name,
                ['X'] = v.X*32,
                ['Y'] = v.X*32
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
                v.X = v.X - 24
            elseif v.AX > v.X then
                v.X = v.X + 24
            end
        end

        if v.AY ~= 0 then
            if v.AY < v.Y then
                v.Y = v.Y - 24
            elseif v.AY > v.Y then
                v.Y = v.Y + 24
            end
        end
    end
end