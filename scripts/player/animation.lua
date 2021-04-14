function initAnimation()
    baseSpriteSheet = love.graphics.newImage("assets/player/base/base-animation.png")
    baseShadow = love.graphics.newImage("assets/player/base/base-shadow.png")
    baseSwing = love.graphics.newImage("assets/player/base/base-swing.png")
    baseImages = {}
    baseImages[#baseImages+1] = love.graphics.newQuad(0, 0, 32, 32, baseSpriteSheet:getDimensions())
    for x = 1, 16 do
        baseImages[#baseImages+1] = love.graphics.newQuad(x * 32, 0, 32, 32, baseSpriteSheet:getDimensions())
    end
    swingImages = {}
    for x = 0, 2 do
        swingImages[#swingImages+1] = love.graphics.newQuad(x * 96, 0, 96, 96, baseSwing:getDimensions())
    end
    animatePlayerAttack = false
end

local speed = 10

function animateCharacter(dt, bool)
    if nextTick > 0.4 and nextTick < 0.5 then animatePlayerAttack = player.attacking end
    if animatePlayerAttack then
        if player.frame < 10 then
            player.frame = 10
            player.frameAmount = 0
        end
        player.frameAmount = player.frameAmount + speed * dt
        if player.frameAmount >= 1 then
            player.frame = player.frame + 1
            if player.frame >= 16 then
                player.frame = 1
                animatePlayerAttack = false
            end
            player.frameAmount = 0
        end
    elseif bool or player.frame > 1 then
        player.frameAmount = player.frameAmount + speed * dt
        if player.frameAmount >= 1 then
            player.frame = player.frame + 1
            -- if not bool then player.frame = 1 end
            if player.frame > 5 then player.frame = 1 end
            player.frameAmount = 0
        end
    end
end

function animateOtherPlayer(dt, bool, i)
    local plr = players[i]
    if plr.Attacking or (plr.Frame and plr.Frame > 10) then
        if not plr.frameAmount then plr.frameAmount = 0 end
        if plr.Frame and plr.Frame < 10 then
            plr.Frame = 10
            plr.frameAmount = 0
        end
        plr.frameAmount = plr.frameAmount + speed * dt
        if plr.frameAmount >= 1 then
            plr.Frame = (plr.Frame or 10) + 1
            if plr.Frame >= 16 then
                plr.Frame = 1
                plr.Attacking = false
            end
            plr.frameAmount = 0
        end
    elseif bool or (plr.Frame and plr.Frame > 1) then
        if not plr.frameAmount then plr.frameAmount = 0 end
        plr.frameAmount = plr.frameAmount + speed * dt
        if plr.frameAmount >= 1 then
            plr.Frame = (plr.Frame or 1) + 1
            if not bool then plr.Frame = 1 end
            if plr.Frame > 5 then plr.Frame = 1 end
            plr.frameAmount = 0
        end
    end
end

function tickAnimation()
    -- animatePlayerAttack = player.attacking
    -- player.attacking = true
    -- print("I'm Attacking")
end

function drawAnimation(v,x,y,dir)
    y = y - 3
    frame = v.Frame or 1
    love.graphics.draw(baseShadow, x, y + 15, 0, dir, 1)

    if frame > 10 then
    else drawAnimationWeapon(v,x,y,dir)
    end
    

    love.graphics.setColor(1,1,1)
    love.graphics.draw(baseSpriteSheet, baseImages[frame], x, y, 0, dir, 1)
    if frame >= 13 and frame <= 15 then love.graphics.draw(baseSwing, swingImages[frame - 12], x - (32 * dir), y - 32, 0, dir, 1) end
end

function drawAnimationWeapon(v,x,y,dir)
    x,y = x - (2 * dir), y - 1
    if v["WeaponID"] ~= 0 then
        -- if v.RedAlpha then love.graphics.setColor(1, 1-v.RedAlpha, 1-v.RedAlpha) else love.graphics.setColor(1, 1, 1) end
        love.graphics.draw(itemImg[v.Weapon.ImgPath], x, y, 0, dir, 1, 0, 0)
        if v.Weapon.Enchantment ~= "None" then
            love.graphics.push()
                love.graphics.stencil(function() 
                    love.graphics.setShader(alphaShader)
                    love.graphics.draw(itemImg[v.Weapon.ImgPath], x, y, 0, dir, 1, 0, 0)
                    love.graphics.setShader()
                end)
                drawEnchantment(x - (itemImg[v.Weapon.ImgPath]:getWidth() - 32), y)
            love.graphics.pop()
        end
    end
end