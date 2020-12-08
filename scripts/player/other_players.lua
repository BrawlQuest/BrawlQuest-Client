--[[
    This script is for managing other player's actions.
    It could probably be named better. Any ideas, Matt?
]]
function drawCharacter(v, x, y, ad)
    if ad then
        if not itemImg[v.Weapon.ImgPath] then
            if love.filesystem.getInfo(v.Weapon.ImgPath) then
                itemImg[v.Weapon.ImgPath] = love.graphics.newImage(v.Weapon.ImgPath)
            else
                itemImg[v.Weapon.ImgPath] = love.graphics.newImage("assets/error.png")
            end
        end

        if v.ShieldID ~= 0 then
            drawItemIfExists(v.Shield.ImgPath, x, y, ad.previousDirection)
        end

        local rotation = 1
        local offsetX = 0
        if ad and ad.previousDirection and ad.previousDirection == "left" then
            rotation = -1
            offsetX = 32
            love.graphics.draw(itemImg[v.Weapon.ImgPath], x + (itemImg[v.Weapon.ImgPath]:getWidth() - 32) + 32,
                y - (itemImg[v.Weapon.ImgPath]:getHeight() - 32), 0, rotation, 1, 0, 0)
        elseif ad and ad.previousDirection and ad.previousDirection == "right" then
            love.graphics.draw(itemImg[v.Weapon.ImgPath], x - (itemImg[v.Weapon.ImgPath]:getWidth() - 32),
                y - (itemImg[v.Weapon.ImgPath]:getHeight() - 32), 0, rotation, 1, 0, 0)
        end

        -- if v.isMounted then
        --     love.graphics.draw(horseImg, player.dx + 6, player.dy + 9)
        -- end
         if v.isMounted then
            love.graphics.draw(horseImg, x + 6, y + 9)
        end

        love.graphics.draw(playerImg, x + offsetX, y, 0, rotation, 1, 0, 0)

        if v.HeadArmourID ~= 0 then
            drawItemIfExists(v.HeadArmour.ImgPath, x, y, ad.previousDirection)
        end
        if v.ChestArmourID ~= 0 then
            drawItemIfExists(v.ChestArmour.ImgPath, x, y, ad.previousDirection)
        end
        if v.LegArmourID ~= 0 then
            drawItemIfExists(v.LegArmour.ImgPath, x, y, ad.previousDirection)
        end

        if v.isMounted then
            love.graphics.draw(horseForeImg, x + 6, y + 9)
        end
        -- if v.isMounting then
        --     love.graphics.draw(horseImg, player.mount.x, player.mount.y)
        -- end

        if v.IsShield and v.ShieldID ~= 0 then
            drawItemIfExists(v.Shield.ImgPath, x, y, ad.previousDirection)
        end

    end
end

function drawPlayer(v, i)
    -- TODO: we need to extract player armour somewhere here, but as we aren't loading in assets yet this hasn't been done
    local thisPlayer
    if i == -1 then -- this player is me
        thisPlayer = me
        v.X = player.dx
        v.Y = player.dy
        v.previousDirection = player.previousDirection
        thisPlayer.AX = player.target.x
        thisPlayer.AY = player.target.y
        thisPlayer.IsShield = love.keyboard.isDown(keybinds.SHIELD)
    else
        thisPlayer = players[i]
    end
    if thisPlayer and v and thisPlayer.Weapon then
        if not v.previousDirection then
            v.previousDirection = "right"
        end
        if v.RedAlpha ~= null then
            love.graphics.setColor(1, 1-v.RedAlpha, 1-v.RedAlpha)
        end
        drawCharacter(thisPlayer, v.X, v.Y, v)

        love.graphics.setColor(1,1,1)
        love.graphics.setFont(playerNameFont)
        local nameWidth = playerNameFont:getWidth(v.Name)
        local nameHeight = playerNameFont:getHeight(v.Name)
        local padding = 1

        if v.previousDirection == "left" then
            boi = 10
        else
            boi = 16
        end

        love.graphics.setColor(0, 0, 0, 0.6)
        love.graphics.rectangle("fill", (v.X + boi) - (nameWidth / 2), v.Y - nameHeight - 3, nameWidth + ((padding+2)*2), nameHeight + (padding*2))
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(v.Name, (v.X + boi) - (nameWidth / 2) + (padding+2), v.Y - nameHeight - 3 + padding)
        
        if thisPlayer ~= nil and thisPlayer.AX then
            local diffX
            local diffY
            if i == -1 and (love.keyboard.isDown(keybinds.ATTACK_UP) or love.keyboard.isDown(keybinds.ATTACK_DOWN) or love.keyboard.isDown(keybinds.ATTACK_LEFT) or love.keyboard.isDown(keybinds.ATTACK_RIGHT)) then
                diffX = player.target.x - player.x
                diffY = player.target.y - player.y
            else
                diffX = thisPlayer.AX - thisPlayer.X
                diffY = thisPlayer.AY - thisPlayer.Y
            end
            if arrowImg[diffX] ~= nil and arrowImg[diffX][diffY] ~= nil then
                love.graphics.setColor(1, 1, 1, 1 - nextTick)
                love.graphics.draw(arrowImg[diffX][diffY], v.X - 32, v.Y - 32)
            end
        end
        love.graphics.setColor(1, 1, 1)
    end
end

function drawNamePlate(x,y,name)
    love.graphics.setFont(playerNameFont)
    local nameWidth = playerNameFont:getWidth(name)
    local nameHeight = playerNameFont:getHeight(name)
    padding = 1
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", (x) - (nameWidth / 2),y- nameHeight - 3, nameWidth + ((padding+2)*2), nameHeight + (padding*2))
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(name, (x) - (nameWidth / 2) + (padding+2), y - nameHeight - 3 + padding)
    
end

function updateOtherPlayers(dt)
    for i, v in pairs(players) do
        if playersDrawable[i] == nil then
            print("Setting drawable")
            playersDrawable[i] = {
                ['Name'] = v.Name,
                ['X'] = v.X * 32,
                ['Y'] = v.X * 32,
                ['AX'] = 0,
                ['AY'] = 0,
                ['HP'] = v.HP,
                ['RedAlpha'] = 0
            }
        end

        if playersDrawable[i].HP > v.HP then
            playersDrawable[i].HP = v.HP
            playersDrawable[i].RedAlpha = 1
            love.audio.play(playerHitSfx)
        end

        playersDrawable[i].RedAlpha = playersDrawable[i].RedAlpha - 1*dt
        if playersDrawable[i].RedAlpha < 0 then
            playersDrawable[i].RedAlpha = 0
        end
        

        if distanceToPoint(playersDrawable[i].X, playersDrawable[i].Y, v.X * 32, v.Y * 32) > 64 then
            playersDrawable[i].X = v.X * 32
            playersDrawable[i].Y = v.Y * 32
        end
        if distanceToPoint(playersDrawable[i].X, playersDrawable[i].Y, v.X * 32, v.Y * 32) > 1 then
            if playersDrawable[i].X - 1 > v.X * 32 then
                playersDrawable[i].X = playersDrawable[i].X - 64 * dt
                playersDrawable[i].previousDirection = "left"
            elseif playersDrawable[i].X + 1 < v.X * 32 then
                playersDrawable[i].X = playersDrawable[i].X + 64 * dt
                playersDrawable[i].previousDirection = "right"
            end

            if playersDrawable[i].Y - 1 > v.Y * 32 then
                playersDrawable[i].Y = playersDrawable[i].Y - 64 * dt
            elseif playersDrawable[i].Y + 1 < v.Y * 32 then
                playersDrawable[i].Y = playersDrawable[i].Y + 64 * dt
            end
        end
    end
end

function tickOtherPlayers()
    for i, v in pairs(players) do
        if playersDrawable[i] then
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
