function initAnimation()
    baseSpriteSheet = love.graphics.newImage("assets/player/base/base-animation.png")
    baseImages = {}
    for x = 0, 8, 1 do
        baseImages[#baseImages+1] = love.graphics.newQuad(x * 32, 0, 32, 32, baseSpriteSheet:getDimensions())
    end
end

function updateAnimation(dt)
    if isMoving then
    end
end

function drawAnimation(v, x, y, dir)
    frame = v.Frame or 1
    love.graphics.draw(baseSpriteSheet, baseImages[frame], x, y, 0, dir, 1)
end

function checkAnimationKeyPressed(key)

end

function checkAnimationMousePressed(button)

end

--[[
initAnimation()
updateAnimation(dt)
drawAnimation()
if Animation.open then updateAnimation(dt) end
if Animation.open then drawAnimation() end
elseif Animation.open then checkAnimationKeyPressed(key)
if Animation.open then checkAnimationMousePressed(button) end
]]