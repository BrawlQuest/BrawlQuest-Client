function initAnimation()
    baseSpriteSheet = love.graphics.newImage("assets/player/base/base-animation.png")
    baseShadow = love.graphics.newImage("assets/player/base/base-shadow.png")
    baseImages = {}
    baseImages[#baseImages+1] = love.graphics.newQuad(0, 0, 32, 32, baseSpriteSheet:getDimensions())
    for x = 5, 9 do
        baseImages[#baseImages+1] = love.graphics.newQuad(x * 32, 0, 32, 32, baseSpriteSheet:getDimensions())
    end
end

function animateCharacter(dt, bool)
    if bool or player.frame > 1 then
        player.frameAmount = player.frameAmount + 8 * dt
        if player.frameAmount >= 1 then
            player.frame = player.frame + 1
            if not bool then player.frame = 1 end
            if player.frame > 5 then player.frame = 1 end
            player.frameAmount = 0
        end
    else player.frame = 1 end
end

function animateOtherPlayer(dt, bool, i)
    local plr = players[i]
    if bool or (plr.Frame and plr.Frame > 1) then
        if not plr.frameAmount then plr.frameAmount = 0 end
        plr.frameAmount = plr.frameAmount + 8 * dt
        if plr.frameAmount >= 1 then
            plr.Frame = (plr.Frame or 1) + 1
            if not bool then plr.Frame = 1 end
            if plr.Frame > 5 then plr.Frame = 1 end
            plr.frameAmount = 0
        end
    else plr.Frame = 1 end
end

function drawAnimation(v, x, y, dir)
    frame = v.Frame or 1
    love.graphics.draw(baseShadow, x, y + 11 , 0, dir, 1)
    love.graphics.draw(baseSpriteSheet, baseImages[frame], x, y - 4, 0, dir, 1)
end