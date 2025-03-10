function initPlayers()
    enchantment = love.graphics.newImage("assets/player/gen/enchantment.png")
    profileEnchantment = love.graphics.newImage("assets/player/gen/profileEnchantment.png")
    enchantmentPos = 0
    shieldFalse = love.graphics.newImage("assets/player/gen/shield false.png")
    showEnchantments = false
    playerNameAlpha = 1
end

alphaShader = love.graphics.newShader [[
    vec4 effect(vec4 colour, Image texture, vec2 texpos, vec2 scrpos)
    {
      vec4 pixel = Texel(texture, texpos) * colour;
      if (pixel.a < 0.5) discard;
      return pixel;
    }
  ]]

function drawCharacter(v, x, y, ad)
    if ad then
        local playerAlpha = getEntityAlpha(x, y)
        local notBoat = not string.find(string.lower(v.Mount.Name), "boat")
        local direction, offsetX, mountOffsetX

        -- set offsets for drawing
        if ad and ad.previousDirection and ad.previousDirection == "right" then
            direction, offsetX, mountOffsetX = 1, 0, 0
        elseif ad and ad.previousDirection and ad.previousDirection == "left" then
            direction, offsetX, mountOffsetX = -1, 32,
                getImgIfNotExist("assets/player/mounts/" .. string.lower(v.Mount.Name) .. "/back.png"):getWidth() - 11
        end

        love.graphics.setColor(1, 1, 1, playerAlpha)
        drawMount(x, y, v, ad, direction, mountOffsetX, notBoat, "/back.png", playerAlpha)

        if v.ActiveSpell and v.ActiveSpell.Name and v.ActiveSpell.Name ~= "" and v.ActiveSpell.Name ~= "None" then
            -- draw spell auras
            love.graphics.draw(getImgIfNotExist("assets/auras/full/" .. v.ActiveSpell.Name .. ".png"), x, y)
        elseif notBoat then
            love.graphics.setColor(1, 1, 1, playerAlpha)
            drawBuddy(v)
            if v.RedAlpha then love.graphics.setColor(1, 1 - v.RedAlpha, 1 - v.RedAlpha, playerAlpha) end
            if drawAnimations then
                drawAnimation(v, x + offsetX, y, direction)
            else
                if v.ShieldID ~= 0 then drawArmourImage(x + offsetX, y, v, ad, "ShieldFalse", direction, playerAlpha) end
                drawWeapon(x, y, v, ad, direction, offsetX, playerAlpha)
                if v.Invulnerability >= 0 then
                    love.graphics.setColor(1, 1, 1, 0.3 * playerAlpha)
                else
                    love.graphics.setColor(1, 1, 1, playerAlpha)
                end
                love.graphics.draw(playerImg, x + offsetX, y, 0, direction, 1, 0, 0)
                drawArmourImage(x, y, v, ad, "LegArmour", nil, playerAlpha)
                drawArmourImage(x, y, v, ad, "ChestArmour", nil, playerAlpha)
                drawArmourImage(x, y, v, ad, "HeadArmour", nil, playerAlpha)
            end
            love.graphics.setColor(1, 1, 1, playerAlpha)
            drawMount(x, y, v, ad, direction, mountOffsetX, notBoat, "/fore.png", playerAlpha)
            if not drawAnimations and v.IsShield and v.ShieldID ~= 0 and notBoat then drawArmourImage(
                x + 12 + 0 * direction, y, v, ad, "Shield", direction) end
        end
    end
end

function drawMount(x, y, v, ad, direction, mountOffsetX, notBoat, type, playerAlpha)
    if v.Mount.Name ~= "" then
        if v.RedAlpha then love.graphics.setColor(1, 1 - v.RedAlpha, 1 - v.RedAlpha, playerAlpha) else love.graphics
                .setColor(1, 1, 1, playerAlpha) end
        if notBoat then
            love.graphics.draw(getImgIfNotExist("assets/player/mounts/" .. string.lower(v.Mount.Name) .. type),
                x + 6 + mountOffsetX, y + 9, 0, direction, 1, 0, 0)
        else
            love.graphics.draw(getImgIfNotExist("assets/player/mounts/" .. string.lower(v.Mount.Name) .. "/back.png"),
                x + mountOffsetX, y, 0, direction, 1, 0, 0)
        end
        if v.Mount.Enchantment ~= "None" then
            love.graphics.push()
            love.graphics.stencil(function()
                love.graphics.setShader(alphaShader)
                if notBoat then
                    love.graphics.draw(getImgIfNotExist("assets/player/mounts/" .. string.lower(v.Mount.Name) .. type),
                        x + 6 + mountOffsetX, y + 9, 0, direction, 1, 0, 0)
                else
                    love.graphics.draw(
                    getImgIfNotExist("assets/player/mounts/" .. string.lower(v.Mount.Name) .. "/back.png"),
                        x + mountOffsetX, y, 0, direction, 1, 0, 0)
                end
                love.graphics.setShader()
            end)
            drawEnchantment(x, y)
            love.graphics.pop()
        end
    end
end

function drawWeapon(x, y, v, ad, direction, offsetX, playerAlpha)
    if not itemImg[v.Weapon.ImgPath] then
        if love.filesystem.getInfo(v.Weapon.ImgPath) then
            itemImg[v.Weapon.ImgPath] = love.graphics.newImage(v.Weapon.ImgPath)
        else
            itemImg[v.Weapon.ImgPath] = love.graphics.newImage("assets/error.png")
        end
    end

    if v["WeaponID"] ~= 0 then
        if v.RedAlpha then love.graphics.setColor(1, 1 - v.RedAlpha, 1 - v.RedAlpha, playerAlpha) else love.graphics
                .setColor(1, 1, 1, playerAlpha) end
        love.graphics.draw(itemImg[v.Weapon.ImgPath],
            x - (itemImg[v.Weapon.ImgPath]:getWidth() - 32) * direction + offsetX,
            y - (itemImg[v.Weapon.ImgPath]:getHeight() - 32), 0, direction, 1, 0, 0)
        if v.Weapon.Enchantment ~= "None" then
            love.graphics.push()
            love.graphics.stencil(function()
                love.graphics.setShader(alphaShader)
                love.graphics.draw(itemImg[v.Weapon.ImgPath],
                    x - (itemImg[v.Weapon.ImgPath]:getWidth() - 32) * direction + offsetX,
                    y - (itemImg[v.Weapon.ImgPath]:getHeight() - 32), 0, direction, 1, 0, 0)
                love.graphics.setShader()
            end)
            drawEnchantment(x - (itemImg[v.Weapon.ImgPath]:getWidth() - 32) + offsetX, y)
            love.graphics.pop()
        end
    end
end

function drawArmourImage(x, y, v, ad, type, direction, playerAlpha)
    if v[type .. "ID"] ~= 0 then
        if v.RedAlpha then love.graphics.setColor(1, 1 - v.RedAlpha, 1 - v.RedAlpha, playerAlpha) else love.graphics
                .setColor(1, 1, 1, playerAlpha) end
        if v.Invulnerability >= 0 and playerAlpha then
            love.graphics.setColor(1, 1, 1, 0.3 * playerAlpha)
        end
        if type ~= "ShieldFalse" then drawItemIfExists(v[type].ImgPath, x, y, ad.previousDirection) else love.graphics
                .draw(shieldFalse, x, y, 0, direction, 1) end
        if v[type] and v[type].Enchantment ~= "None" then
            love.graphics.push()
            love.graphics.stencil(function()
                love.graphics.setShader(alphaShader)
                if type ~= "ShieldFalse" then drawItemIfExists(v[type].ImgPath, x, y, ad.previousDirection) else love
                        .graphics.draw(shieldFalse, x, y, 0, direction, 1) end
                love.graphics.setShader()
            end)
            local offset = 16
            if type == "ShieldFalse" then offset = 32 end
            drawEnchantment(x - offset, y)
            love.graphics.pop()
        end
    end
end

function drawEnchantment(x, y, noiseScale)
    noiseScale = noiseScale or 1
    love.graphics.setStencilTest("equal", 1)
    love.graphics.setColor(0.8, 0, 1, 0.6)
    love.graphics.setBlendMode("add")
    love.graphics.draw(enchantment, x + enchantmentPos - 64, y - 32, 0, noiseScale)
    love.graphics.setStencilTest("always", 0)
    love.graphics.setBlendMode("alpha")
    love.graphics.setStencilTest()
end

function drawPlayer(v, i)
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
        v.RedAlpha = 0
        v.NameAlpha = playerNameAlpha
        v.Frame = player.frame
        thisPlayer.Frame = player.frame
    else
        thisPlayer = players[i]
    end

    if thisPlayer and v and thisPlayer.Weapon then
        if not v.previousDirection then v.previousDirection = "right" end
        -- print(v.RedAlpha)
        if v.RedAlpha then love.graphics.setColor(1, 1 - v.RedAlpha, 1 - v.RedAlpha) end
        drawCharacter(thisPlayer, v.X, v.Y, v)

        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(playerNameFont)

        local boi = 0
        if v.previousDirection == "left" then
            boi = 11 + 3
        else
            boi = 16 + 3
        end

        -- local text
        -- if thisPlayer.Prestige > 1 then text = thisPlayer.Prestige .. "," .. thisPlayer.LVL else text = thisPlayer.LVL end
        local alpha
        if true then alpha = v.NameAlpha else alpha = 1 end

        drawNamePlate(v.X + boi, v.Y, thisPlayer.Name, v.NameAlpha, thisPlayer.LVL, thisPlayer.Prestige, v.IsPremium) -- thisPlayer.LVL

        if thisPlayer ~= nil and thisPlayer.AX then                                                                   -- attack players
            local diffX = 0
            local diffY = 0
            if i == -1 and player.target.active then
                if isMouseDown() and not holdingStaff() then
                    local mx, my = love.mouse.getPosition()
                    mx = player.cx - (player.cx - (mx - love.graphics.getWidth() * 0.5))
                    my = player.cy - (player.cy - (my - love.graphics.getHeight() * 0.5))
                    local range = { x = 4 * 32, y = 4 * 32 }
                    if my < -range.y then
                        diffY = -1
                    elseif my > range.y then
                        diffY = 1
                    end
                    if mx < -range.x then
                        diffX = -1
                    elseif mx > range.x then
                        diffX = 1
                    end
                elseif not orCalc(0, { player.target.x, player.target.y }) then
                    diffX = player.target.x - player.x
                    diffY = player.target.y - player.y
                else
                    if targetKeys[1] then
                        diffY = -1
                    elseif targetKeys[2] then
                        diffY = 1
                    else
                        diffY = 0
                    end
                    if targetKeys[3] then
                        diffX = -1
                    elseif targetKeys[4] then
                        diffX = 1
                    else
                        diffX = 0
                    end
                end
                drawArrowImage(diffX, diffY, v.X, v.Y)
            else
                diffX = thisPlayer.AX - thisPlayer.X
                diffY = thisPlayer.AY - thisPlayer.Y
            end
        end
        local underCharacterBarY = v.Y + 34
        local thisHealth
        if i == -1 then thisHealth = getMaxHealth() else thisHealth = thisPlayer.MaxHP end
        if thisPlayer.HP < thisHealth then
            love.graphics.setColor(0.4, 0, 0)
            love.graphics.rectangle("fill", v.X, underCharacterBarY, 32, 4)
            love.graphics.setColor(0, 1, 0)
            if i == -1 then
                love.graphics.rectangle("fill", v.X, underCharacterBarY,
                    math.clamp(0, thisPlayer.HP / thisHealth, 1) * 32, 4)
            else
                love.graphics.rectangle("fill", v.X, underCharacterBarY, (thisPlayer.HP / thisHealth) * 32, 4)
            end
            underCharacterBarY = underCharacterBarY + 5
        end
        if thisPlayer.Mana < 100 then
            love.graphics.setColor(0, 0, 0.4)
            love.graphics.rectangle("fill", v.X, underCharacterBarY, 32, 4)
            love.graphics.setColor(0, 0, 1)
            love.graphics.rectangle("fill", v.X, underCharacterBarY, (thisPlayer.Mana / 100) * 32, 4)
            underCharacterBarY = underCharacterBarY + 10
        end
        love.graphics.setColor(1, 1, 1)
    end
end

function drawArrowImage(diffX, diffY, x, y)
    if arrowData[diffX] and arrowData[diffX][diffY] then
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

function drawNamePlate(x, y, name, alpha, level, prestige, isPremium)
    level = level or null
    love.graphics.setFont(playerNameFont)
    alpha = alpha or 1
    local playerAlpha = getEntityAlpha(x, y)
    if level then
        if prestige and prestige > 1 then
            local thisX, thisY = x, y - 4
            local nameWidth, levelWidth = playerNameFont:getWidth(name) + 1, playerNameFont:getWidth(level)
            local prestigeWidth = playerNameFont:getWidth(prestige)
            local nameHeight = playerNameFont:getHeight(name)
            local padding = { x = 3, y = 2 }
            local fullWidth = levelWidth + nameWidth + prestigeWidth + padding.x * 6
            local dx = thisX - (fullWidth * 0.5)
            local dy = thisY - nameHeight - padding.y - 1
            local dh = nameHeight + (padding.y * 2)

            if (isPremium) then
                love.graphics.setColor(1, 0.6, 0, 0.6 * alpha * playerAlpha)
            else
                love.graphics.setColor(0, 0, 0, 0.6 * alpha * playerAlpha)
            end
            roundRectangle("fill", dx, dy, fullWidth, dh, 3)
            -- love.graphics.setColor(1,1,1,1 * alpha)
            -- roundRectangle("fill", dx, dy, prestigeWidth + padding.x * 2, dh, 3, {true, false, false, true})

            love.graphics.setColor(1, 0, 0, alpha * playerAlpha)
            love.graphics.rectangle("fill", dx + (prestigeWidth + padding.x * 2), dy, levelWidth + padding.x * 2, dh)
            if (isPremium) then
                love.graphics.setColor(1, 1, 1, alpha * playerAlpha)
            else
                love.graphics.setColor(1, 0, 0, alpha * playerAlpha)
            end

            love.graphics.print(prestige, dx + padding.x + 0.5, thisY - nameHeight - 2 + padding.y)
            if (isPremium) then
                love.graphics.setColor(0, 0, 0, 0.6 * alpha * playerAlpha)
            else
                love.graphics.setColor(1, 1, 1, alpha * playerAlpha)
            end

            love.graphics.print(level, dx + padding.x + 0.5 + (prestigeWidth + padding.x * 2),
                thisY - nameHeight - 2 + padding.y)
            love.graphics.print(name, dx + padding.x * 3 + levelWidth + (prestigeWidth + padding.x * 2),
                thisY - nameHeight - 2 + padding.y)
        else
            local thisX, thisY = x, y - 4
            local nameWidth, levelWidth = playerNameFont:getWidth(name) + 1, playerNameFont:getWidth(level)
            local nameHeight = playerNameFont:getHeight(name)
            local padding = { x = 3, y = 2 }
            local fullWidth = levelWidth + nameWidth + padding.x * 4
            local dx = thisX - (fullWidth * 0.5)
            local dy = thisY - nameHeight - padding.y - 1
            local dh = nameHeight + (padding.y * 2)

            love.graphics.setColor(0, 0, 0, 0.6 * alpha * playerAlpha)
            roundRectangle("fill", dx, dy, fullWidth, dh, 3)
            love.graphics.setColor(1, 0, 0, alpha * playerAlpha)
            roundRectangle("fill", dx, dy, levelWidth + padding.x * 2, dh, 3, { true, false, false, true })

            love.graphics.setColor(1, 1, 1, alpha * playerAlpha)
            love.graphics.print(level, dx + padding.x + 0.5, thisY - nameHeight - 2 + padding.y)
            love.graphics.print(name, dx + padding.x * 3 + levelWidth, thisY - nameHeight - 2 + padding.y)
        end
    else
        level = level or null
        alpha = alpha or 1
        local thisX, thisY = x, y - 4
        local nameWidth = playerNameFont:getWidth(name)
        local nameHeight = playerNameFont:getHeight(name)
        local padding = 2
        love.graphics.setColor(0, 0, 0, 0.6 * alpha * playerAlpha)
        roundRectangle("fill", (thisX) - (nameWidth / 2) - (padding) - 2, thisY - nameHeight - 3,
            nameWidth + (padding * 2) + 3, nameHeight + (padding * 2), 3)
        love.graphics.setColor(1, 1, 1, alpha * playerAlpha)
        love.graphics.print(name, (thisX) - (nameWidth * 0.5), thisY - nameHeight - 2 + padding)
    end
end

attackHitAmount = 0
local sparklesAmount = 0

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
                ['Buddy'] = v.Buddy,
                ['NameAlpha'] = 1,
            }
        end

        if playersDrawable[i].Mount.Name ~= v.Mount.Name then
            playSoundIfExists("assets/sfx/items/" .. v.Mount.Name .. ".ogg", (playersDrawable[i].X + 16) / 32,
                (playersDrawable[i].Y + 16) / 32)
        end
        playersDrawable[i].Mount = v.Mount
        updateBuddy(dt, playersDrawable)
        if playersDrawable[i].HP > v.HP then
            playSoundIfExists("assets/sfx/hit.ogg", (playersDrawable[i].X + 16) / 32, (playersDrawable[i].Y + 16) / 32)
            playersDrawable[i].HP = v.HP
            playersDrawable[i].RedAlpha = 1
            boneSpurt(playersDrawable[i].X + 16, playersDrawable[i].Y + 16, 10, 25, 1, 1, 1)
        end

        if playersDrawable[i].RedAlpha then
            if playersDrawable[i].RedAlpha > 0 then
                playersDrawable[i].RedAlpha = playersDrawable[i].RedAlpha - 1 * dt
                if playersDrawable[i].RedAlpha < 0 then
                    playersDrawable[i].RedAlpha = 0
                end
            end
        end

        local distance = distanceToPoint(playersDrawable[i].X, playersDrawable[i].Y, v.X * 32, v.Y * 32)
        setNamePlateAlpha(v, i)

        if distance > 128 then
            playersDrawable[i].X = v.X * 32
            playersDrawable[i].Y = v.Y * 32
        end

        if drawAnimations then animateOtherPlayer(dt, distance > 3, i) end

        if distance > 1 then
            -- set the speed of movement for the player
            local speed = 64
            if playersDrawable[i].Mount.Name ~= "None" or worldEdit.open then
                speed = tonumber(playersDrawable[i].Mount.Val) or 64
                local enchant = playersDrawable[i].Mount.Enchantment or false
                if enchant and enchant ~= "None" and enchant ~= "" then
                    speed = speed + 25
                end
            end
            if worldLookup[v.X .. "," .. v.Y] and (isTileType(worldLookup[v.X .. "," .. v.Y].ForegroundTile, "Path") or isTileType(worldLookup[v.X .. "," .. v.Y].GroundTile, "Path")) then
                speed = speed * 1.4
            end

            -- want some sparkles?
            local iWantSparkles = false

            -- move player
            if playersDrawable[i].X - 1 > v.X * 32 then
                playersDrawable[i].X = playersDrawable[i].X - speed * dt
                iWantSparkles = true
            elseif playersDrawable[i].X + 1 < v.X * 32 then
                playersDrawable[i].X = playersDrawable[i].X + speed * dt
                iWantSparkles = true
            end

            if playersDrawable[i].Y - 1 > v.Y * 32 then
                playersDrawable[i].Y = playersDrawable[i].Y - speed * dt
                iWantSparkles = true
            elseif playersDrawable[i].Y + 1 < v.Y * 32 then
                playersDrawable[i].Y = playersDrawable[i].Y + speed * dt
                iWantSparkles = true
            end

            if v.Mount and v.Mount.Name ~= "None" and v.Mount.Name ~= "" and v.Mount.Enchantment ~= "None" then
                sparklesAmount = sparklesAmount + 5 * dt
                if iWantSparkles and sparklesAmount > 1 then
                    sparklesAmount = 0
                    addSparkles(playersDrawable[i].X + 16, playersDrawable[i].Y + 16, 5, 30, 20)
                end
            end
        end
        updateBuddy(dt, playersDrawable[i])
        -- updateRangedWeapons(dt, playersDrawable[i])

        -- set all players animation frame
        if not v.Frame then
            if previousPlayers and previousPlayers[i] and previousPlayers[i].Frame then
                v.Frame = previousPlayers[i].Frame
            else
                v.Frame = 1
            end
        end

        -- set attacking, mainly for animations
        if (v.X ~= v.AX or v.Y ~= v.AY) and nextTick > 0.3 and nextTick < 0.4 then v.Attacking = true end
    end
end

function tickOtherPlayers()
    for i, v in pairs(players) do
        if playersDrawable[i] then
            local plr = playersDrawable[i]
            if v['Name'] ~= plr['Name'] then
                plr = v
                setNamePlateAlpha(v, i)
            end
            v.Name = plr.Name

            -- sets the animation position X and Y
            if v.AX ~= 0 then
                if v.AX < v.X then
                    plr.X = plr.X - 16
                    plr.previousDirection = "left"
                elseif v.AX > v.X then
                    plr.X = plr.X + 16
                    plr.previousDirection = "right"
                end
            end

            if v.AY ~= 0 then
                if v.AY < v.Y then
                    plr.Y = plr.Y - 16
                elseif v.AY > v.Y then
                    plr.Y = plr.Y + 16
                end
            end


            -- sets the direction of other players
            if previousPlayers and previousPlayers[i] then
                if v.X < previousPlayers[i].X then
                    playersDrawable[i].previousDirection = "left"
                elseif v.X > previousPlayers[i].X then
                    playersDrawable[i].previousDirection = "right"
                end
            end
        end
    end
end

-- sets the opacity of the name plate based on how close you are to other players
function setNamePlateAlpha(v, i)
    local distance = distanceToPoint(v.X * 32, v.Y * 32, player.dx, player.dy)
    if distance < 128 then
        playersDrawable[i].NameAlpha = distance / 128
        playerNameAlpha = distance / 128
    else
        playersDrawable[i].NameAlpha = 1
        playerNameAlpha = 1
    end
end
