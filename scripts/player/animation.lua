function initAnimation()
    baseSpriteSheet = love.graphics.newImage("assets/player/animations/base-sprites.png")
    baseShadow = love.graphics.newImage("assets/player/animations/base-shadow.png")
    baseSwing = love.graphics.newImage("assets/player/animations/base-swing.png")
    baseImages = {}
    baseImages[1] = love.graphics.newQuad(0, 0, 48, 48, baseSpriteSheet:getDimensions())
    for x = 0, 3 do -- walk images
        baseImages[#baseImages+1] = love.graphics.newQuad(x * 48, 48, 48, 48, baseSpriteSheet:getDimensions())
    end
    for x = 0, 5 do -- attack images
        baseImages[10+x] = love.graphics.newQuad(math.clamp(0, x, 3) * 48, 96, 48, 48, baseSpriteSheet:getDimensions())
    end
    for x = 0, 3 do -- cast images
        baseImages[#baseImages+1] = love.graphics.newQuad(x * 48, 144, 48, 48, baseSpriteSheet:getDimensions())
    end

    swingImages = {}
    for x = 0, 2 do
        swingImages[#swingImages+1] = love.graphics.newQuad(x * 96, 0, 96, 96, baseSwing:getDimensions())
    end
    animatePlayerAttack = false
    initArmour()
end

local walkSpeed, attackSpeed = 6, 10
local idle, walkStart, walkEnd = 1, 2, 5

function animateCharacter(dt, bool)
    if nextTick > 0.3 and nextTick < 0.4 then animatePlayerAttack = player.attacking end
    
    if animatePlayerAttack then
        if player.frame < 10 then
            player.frame = 10
            player.frameAmount = 0
        end
        player.frameAmount = player.frameAmount + attackSpeed * dt
        if player.frameAmount >= 1 then
            player.frame = player.frame + 1
            if orCalc(player.frame, {10, 12, 13}) and worldLookup[player.x..","..player.y] then
                playFootstepSound(worldLookup[player.x..","..player.y], player.x, player.y, true)
            end
            if player.frame >= 16 then
                player.frame = 1
                animatePlayerAttack = false
            end
            player.frameAmount = 0
        end
    elseif me and me.Mount and not orCalc(me.Mount.Name, {"", "None",}) then player.frame = idle
    elseif bool or player.frame > walkStart then
        player.frameAmount = player.frameAmount + walkSpeed * dt
        if player.frameAmount >= 1 then
            player.frame = player.frame + 1
            if player.frame > walkEnd then player.frame = walkStart end
            if orCalc(player.frame, {walkStart, walkStart + 2}) and worldLookup[player.x..","..player.y] then
                playFootstepSound(worldLookup[player.x..","..player.y], player.x, player.y, true)
            end
            player.frameAmount = 0
            if not bool then
                player.frame = idle
                if worldLookup[player.x..","..player.y] then
                    playFootstepSound(worldLookup[player.x..","..player.y], player.x, player.y, true)
                end
            end
        end
    else
        player.frame = idle
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
        plr.frameAmount = plr.frameAmount + attackSpeed * dt
        if plr.frameAmount >= 1 then
            plr.Frame = (plr.Frame or 10) + 1
            if plr.Frame >= 16 then
                plr.Frame = 1
                plr.Attacking = false
            end
            plr.frameAmount = 0
        end
    elseif plr.Mount and not orCalc(plr.Mount.Name, {"", "None",}) then plr.Frame = idle
    elseif bool or (plr.Frame and plr.Frame > 1) then
        if not plr.frameAmount then plr.frameAmount = 0 end
        plr.frameAmount = plr.frameAmount + walkSpeed * dt
        if plr.frameAmount >= 1 then
            plr.Frame = (plr.Frame or 1) + 1
            if plr.Frame > walkEnd then plr.Frame = walkStart end
            plr.frameAmount = 0
            if orCalc(plr.Frame, {walkStart, walkStart + 2}) and worldLookup[plr.X..","..plr.Y] then
                playFootstepSound(worldLookup[plr.X..","..plr.Y], plr.X, plr.Y)
            end
            if not bool then 
                plr.Frame = idle
                if worldLookup[plr.X..","..plr.Y] then
                    playFootstepSound(worldLookup[plr.X..","..plr.Y], plr.X, plr.Y)
                end
            end
        end
    end
end

function tickAnimation()

end

function drawAnimation(v,x,y,dir)
    y = y - 3
    frame = v.Frame or 1
    local off = 0
    if frame == 1 or frame % 2 == 0 then off = 1 end
    love.graphics.draw(baseShadow, x, y + 15, 0, dir, 1)

    drawAnimatedWeapon(v,x,y,dir,frame)

    if v.IsShield and v.ShieldID ~= 0 and notBoat then drawArmourImage(x+12 - 5 * dir,y,v,ad,"Shield",dir) end
    love.graphics.draw(baseSpriteSheet, baseImages[frame], x - 16 * dir, y - 16, 0, dir, 1)

    drawAnimatedArmourImage(v, "LegArmour", x - 16 * dir, y - 16, dir, frame)
    drawAnimatedArmourImage(v, "ChestArmour", x - 16 * dir, y - 16, dir, frame)
    drawAnimatedArmourImage(v, "HeadArmour", x - 16 * dir, y - 16, dir, frame)

    love.graphics.setBlendMode("add")
    if frame >= 12 and frame <= 14 then love.graphics.draw(baseSwing, swingImages[frame - 11], x - (27 * dir), y - 27, 0, dir, 1) end
    love.graphics.setBlendMode("alpha")

    love.graphics.print(frame, x, y+34)
end

function drawAnimatedWeapon(v,x,y,dir,frame)
    if frame >= 10 then
        local wx,wy = x - (getImgIfNotExist(v.Weapon.ImgPath):getWidth() - 32) * dir, y - (getImgIfNotExist(v.Weapon.ImgPath):getHeight() - 32)
        if frame == 10 then drawAnimationWeapon(v,wx,wy - 3, dir)
        elseif frame == 11 then drawAnimationWeapon(v,wx + (24 * dir), wy - 16, dir, 45)
        elseif frame == 12 then drawAnimationWeapon(v,wx + (70 * dir), wy + 18, dir * -1, -40)
        elseif frame >= 13 then drawAnimationWeapon(v,wx + (16 * dir), wy - 3, dir) end
    else
        local off = 0
        if frame == 1 or frame % 2 == 0 then off = 1 end

        local shieldOff = 4
        if frame == 3 or frame == 5 then shieldOff = 5 elseif frame == 4 then shieldOff = 6 end
        if v.ShieldID ~= 0 then drawArmourImage(x - shieldOff * dir, y - off + 1, v, ad, "ShieldFalse", dir) end
        local wx, wy, r = x,y - off, 0
        if string.find(v.Weapon.ImgPath, "a1/special", 18) or
            string.find(v.Weapon.ImgPath, "sword", 22) or
            string.find(v.Weapon.ImgPath, "dagger", 22) then wx, wy, r = wx + 32 * dir, wy + 32, 180 end
        drawAnimationWeapon(v, wx, wy, dir, r)
    end
end

function drawAnimationWeapon(v,x,y,dir,r)
    r = (r or 0) * dir
    x,y = x - (2 * dir), y - 1
    if v["WeaponID"] ~= 0 then
        love.graphics.draw(getImgIfNotExist(v.Weapon.ImgPath), x, y, math.rad(r), dir, 1, 0, 0)
        if v.Weapon.Enchantment ~= "None" then
            love.graphics.push()
                love.graphics.stencil(function() 
                    love.graphics.setShader(alphaShader)
                    love.graphics.draw(getImgIfNotExist(v.Weapon.ImgPath), x, y, math.rad(r), dir, 1, 0, 0)
                    love.graphics.setShader()
                end)
                drawEnchantment(x - (getImgIfNotExist(v.Weapon.ImgPath):getWidth() - 32), y)
            love.graphics.pop()
        end
    end
end