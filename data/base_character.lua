baseCharacterImages = {}

function initBaseCharacterImages()
    for i=1,5 do
        baseCharacterImages[i] = love.graphics.newImage("assets/player/base/base "..i..".png")
    end
end