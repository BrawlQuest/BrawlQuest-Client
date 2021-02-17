
--[[
    This script is for managing other player's actions.
    It could probably be named better. Any ideas, Matt?
]]
function drawCharacter(v, x, y, ad)
    if ad then
        love.graphics.setColor(1,1,1)
        if not itemImg[v.Weapon.ImgPath] then
            if love.filesystem.getInfo(v.Weapon.ImgPath) then
                itemImg[v.Weapon.ImgPath] = love.graphics.newImage(v.Weapon.ImgPath)
            else
                itemImg[v.Weapon.ImgPath] = love.graphics.newImage("assets/error.png")
            end
        end

        if v.ShieldID ~= 0 and not string.find(v.Mount.Name, "boat") then -- we don't want to draw the player if they're in a boat
            drawItemIfExists(v.Shield.ImgPath, x, y, ad.previousDirection)
        end

        local rotation = 1
        local offsetX = 0
        local mountOffsetX = 0
        if ad and ad.previousDirection and ad.previousDirection == "left" then
            rotation = -1
            offsetX = 32
            if v.Mount.Name ~= "" then
                mountOffsetX = getImgIfNotExist("assets/player/mounts/"..string.lower(v.Mount.Name).."/back.png"):getWidth()-8
            end
            if not string.find(v.Mount.Name, "boat") then
                love.graphics.draw(itemImg[v.Weapon.ImgPath], x + (itemImg[v.Weapon.ImgPath]:getWidth() - 32) + 32,
                    y - (itemImg[v.Weapon.ImgPath]:getHeight() - 32), player.wobble, rotation, 1, 0, 0)
            end
        elseif ad and ad.previousDirection and ad.previousDirection == "right" then
            if not string.find(v.Mount.Name, "boat") then
            love.graphics.draw(itemImg[v.Weapon.ImgPath], x - (itemImg[v.Weapon.ImgPath]:getWidth() - 32),
                y - (itemImg[v.Weapon.ImgPath]:getHeight() - 32), player.wobble, rotation, 1, 0, 0)
            end
        end

        if v.Mount.Name ~= "" then
            if  string.find(v.Mount.Name, "boat") then -- there is no offset for boats as the player isn't drawn
                love.graphics.draw(getImgIfNotExist("assets/player/mounts/"..string.lower(v.Mount.Name).."/back.png"), x  + mountOffsetX, y, 0, rotation, 1, 0, 0)
            else
                love.graphics.draw(getImgIfNotExist("assets/player/mounts/"..string.lower(v.Mount.Name).."/back.png"), x + 6 + mountOffsetX, y + 9, 0, rotation, 1, 0, 0)
            end
        end
        
        if not string.find(v.Mount.Name, "boat") then
            drawBuddy(v)
            if v.RedAlpha ~= null then
                love.graphics.setColor(1, 1-v.RedAlpha, 1-v.RedAlpha)
            end
            -- print(v.RedAlpha)
            -- if v.Color ~= null then love.graphics.setColor(unpack(v.Color)) end
            love.graphics.draw(playerImg, x + offsetX, y, player.wobble, rotation, 1, 0, 0)
            love.graphics.setColor(1,1,1)

            if v.LegArmourID ~= 0 then
                drawItemIfExists(v.LegArmour.ImgPath, x, y, ad.previousDirection)
            end
            if v.ChestArmourID ~= 0 then
                drawItemIfExists(v.ChestArmour.ImgPath, x, y, ad.previousDirection)
            end
            if v.HeadArmourID ~= 0 then
                drawItemIfExists(v.HeadArmour.ImgPath, x, y, ad.previousDirection)
            end
            if v.Mount.Name ~= "" then
                love.graphics.draw(getImgIfNotExist("assets/player/mounts/"..string.lower(v.Mount.Name).."/fore.png"), x + 6 + mountOffsetX, y + 9, 0, rotation, 1, 0, 0)
            end

            if v.IsShield and v.ShieldID ~= 0 then
                drawItemIfExists(v.Shield.ImgPath, x, y, ad.previousDirection)
            end
        end

        -- local w, h = 64, 46
        -- love.graphics.setColor(0,0,0,0.8)
        -- roundRectangle("fill", x + 42, y - 16 - h, w, h, 5, {true, true, false, false})
        -- love.graphics.setColor(1,1,1)
        -- love.graphics.line(x + 32, y, x + 42, y - 16, x + 42 + w, y - 16)
    end
end

function drawPlayer(v, i)
    -- TODO: we need to extract player armour somewhere here, but as we aren't loading in assets yet this hasn't been done
    local thisPlayer
    if i == -1 then -- this player is me
        thisPlayer = copy(me)
        v.X = player.dx
        v.Y = player.dy
        v.Name = player.name
        v.previousDirection = player.previousDirection
        thisPlayer.AX = player.target.x
        thisPlayer.AY = player.target.y
        thisPlayer.IsShield = love.keyboard.isDown(keybinds.SHIELD)
        thisPlayer.Name = player.name
        thisPlayer.Buddy = player.buddy
        thisPlayer.HP = player.hp
        thisPlayer.Mana = me.Mana
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
        
        local boi = 0
        if v.previousDirection == "left" then
            boi = 11 + 3
        else
            boi = 16 + 3
        end

        drawNamePlate(v.X + boi, v.Y, v.Name, 1, thisPlayer.LVL) -- thisPlayer.LVL
        
        if thisPlayer ~= nil and thisPlayer.AX then
            local diffX
            local diffY
            if i == -1 and player.target.active then
                if targetKeys[1] then diffY = -1
                elseif targetKeys[2] then diffY = 1
                else diffY = 0 end
                if targetKeys[3] then diffX = -1
                elseif targetKeys[4] then diffX = 1
                else diffX = 0 end
            else
                diffX = thisPlayer.AX - thisPlayer.X
                diffY = thisPlayer.AY - thisPlayer.Y
            end

            drawArrowImage(diffX, diffY, v.X, v.Y)
        end
        local underCharacterBarY = v.Y+34
        if thisPlayer.HP < (100+thisPlayer.STA*15) then
            love.graphics.setColor(0.4,0,0)
            love.graphics.rectangle("fill", v.X, underCharacterBarY,32,4)
            love.graphics.setColor(0,1,0)
            love.graphics.rectangle("fill", v.X, underCharacterBarY, (thisPlayer.HP/(100+thisPlayer.STA*15))*32, 4)
            underCharacterBarY = underCharacterBarY + 5
        end
        if thisPlayer.Mana < 100 then
            love.graphics.setColor(0,0,0.4)
            love.graphics.rectangle("fill", v.X, underCharacterBarY,32,4)
            love.graphics.setColor(0,0,1)
            love.graphics.rectangle("fill", v.X, underCharacterBarY, (thisPlayer.Mana/100) * 32, 4)
            underCharacterBarY = underCharacterBarY + 10
        end
        love.graphics.setColor(1, 1, 1)
    end
end

function drawArrowImage(diffX, diffY, x, y)
    if arrowData[diffX] ~= nil and arrowData[diffX][diffY] ~= nil then
        local v = arrowData[diffX][diffY]
        local size = 32
        love.graphics.setColor(1, cerp(0.1, 0.8, attackHitAmount), 0, 1)
        love.graphics.draw(v.image,
        x + 16 + v.position.x + cerp(0, v.position.x * 0.25, attackHitAmount), 
        y + 16 + v.position.y + cerp(0, v.position.y * 0.25, attackHitAmount), 
        v.rotation, 
        cerp(1, 1.25, attackHitAmount))
    end
end

function drawNamePlate(x,y,name, alpha, level)
    level = level or null
    love.graphics.setFont(playerNameFont)  
    alpha = alpha or 1
    if level then
        local thisX, thisY = x , y - 4
        local nameWidth, levelWidth = playerNameFont:getWidth(name) + 1, playerNameFont:getWidth(level)
        local nameHeight = playerNameFont:getHeight(name)
        local padding = 2
        local textSpace = 3
        local fullWidth = levelWidth + nameWidth + textSpace

        local dx = (thisX) - (fullWidth * 0.5) - padding - 1
        local dy = thisY - nameHeight - padding - 1
        local dw = levelWidth + padding + (textSpace)
        local dh = nameHeight + (padding * 2)
        
        love.graphics.setColor(0, 0, 0, 0.6 * alpha)
        roundRectangle("fill", dx + dw, dy, nameWidth + padding + (textSpace * 2), dh, 3, {false, true, true, false})
        love.graphics.setColor(1,0,0,alpha)
        roundRectangle("fill", dx, dy, dw + 1, dh, 3, {true, false, false, true})


        love.graphics.setColor(1, 1, 1, alpha)
        love.graphics.print(level, (thisX) - (fullWidth * 0.5), thisY - nameHeight - 2 + padding)
        love.graphics.print(name, (thisX) - (fullWidth * 0.5) + (textSpace * 2) + levelWidth, thisY - nameHeight - 2 + padding)
    else
        level = level or null
        alpha = alpha or 1
        local thisX, thisY = x , y - 4
        local nameWidth = playerNameFont:getWidth(name)
        local nameHeight = playerNameFont:getHeight(name)
        local padding = 2
        love.graphics.setColor(0, 0, 0, 0.6 * alpha)
        roundRectangle("fill", (thisX) - (nameWidth / 2) - (padding) - 2, thisY - nameHeight - 3, nameWidth + (padding * 2) + 3, nameHeight + (padding * 2), 3)
        love.graphics.setColor(1, 1, 1, alpha)
        love.graphics.print(name, (thisX) - (nameWidth * 0.5), thisY - nameHeight - 2 + padding)
    end
end

attackHitAmount = 0

function updateOtherPlayers(dt)

    if attackHitAmount > 0 then
        attackHitAmount = attackHitAmount - 2 * dt
    end

    for i, v in pairs(players) do
        if playersDrawable[i] == nil then
            -- print("Setting drawable")
            playersDrawable[i] = {
                ['Name'] = v.Name,
                ['X'] = v.X * 32,
                ['Y'] = v.X * 32,
                ['AX'] = 0,
                ['AY'] = 0,
                ['HP'] = v.HP,
                ['RedAlpha'] = 0,
                ['Mount'] = v.Mount,
                ['Color'] = v.Color,
                ['Buddy'] = v.Buddy
            }
        end
        playersDrawable[i].Mount = v.Mount
        updateBuddy(dt, playersDrawable)
        if playersDrawable[i].HP > v.HP then
            print("player Hit")
            playersDrawable[i].HP = v.HP
            playersDrawable[i].RedAlpha = 1
            love.audio.play(playerHitSfx)
        end

        if playersDrawable[i].RedAlpha then
            playersDrawable[i].RedAlpha = playersDrawable[i].RedAlpha - 1*dt
            if playersDrawable[i].RedAlpha < 0 then
                playersDrawable[i].RedAlpha = 0
            end
        end
        

        if distanceToPoint(playersDrawable[i].X, playersDrawable[i].Y, v.X * 32, v.Y * 32) > 128 then
            playersDrawable[i].X = v.X * 32
            playersDrawable[i].Y = v.Y * 32
        end
        if distanceToPoint(playersDrawable[i].X, playersDrawable[i].Y, v.X * 32, v.Y * 32) > 1 then
            local speed = 64
            if playersDrawable[i].Mount.Name ~= "None" or worldEdit.open then
                if string.find(playersDrawable[i].Mount.Name, "boat") then
                    speed = 32
                else
                    speed = 110
                end
            end
            if playersDrawable[i].X - 1 > v.X * 32 then
                playersDrawable[i].X = playersDrawable[i].X - speed * dt
                playersDrawable[i].previousDirection = "left"
            elseif playersDrawable[i].X + 1 < v.X * 32 then
                playersDrawable[i].X = playersDrawable[i].X + speed * dt
                playersDrawable[i].previousDirection = "right"
            end

            if playersDrawable[i].Y - 1 > v.Y * 32 then
                playersDrawable[i].Y = playersDrawable[i].Y - speed * dt
            elseif playersDrawable[i].Y + 1 < v.Y * 32 then
                playersDrawable[i].Y = playersDrawable[i].Y + speed * dt
            end
        end
        updateBuddy(dt, playersDrawable[i])
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
