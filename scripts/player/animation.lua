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
            if not bool then player.frame = 1 end
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

function drawAnimation(v, x, y, dir)
    frame = v.Frame or 1
    love.graphics.draw(baseShadow, x, y + 15 - 3, 0, dir, 1)
    love.graphics.draw(baseSpriteSheet, baseImages[frame], x, y - 3, 0, dir, 1)
    if frame >= 13 and frame <= 15 then love.graphics.draw(baseSwing, swingImages[frame - 12], x - (32 * dir), y - 3 - 32, 0, dir, 1) end
    love.graphics.print(v.AX .. "," .. v.AY, x,y + 34)
end