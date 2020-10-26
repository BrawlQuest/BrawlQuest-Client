
function drawTextField(x, y, i) -- i is the editing field ID
    love.graphics.draw(textFieldImage, x, y)
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(textFont)
    if isMouseOver(x,  y, 288, 44) then
        love.graphics.setColor(0.6, 0.6, 0.6)
    end

    if editingField == i then
        love.graphics.printf(textfields[i] .. "|", x+10,y+6, 262, "center")
    else
        love.graphics.printf(textfields[i], x+10, y+6, 262, "center")
    end
    love.graphics.setColor(0, 0, 0)

    if isMouseOver(x, y, 288, 44) then
        love.graphics.setColor(0.6, 0.6, 0.6)
    end
end

function drawButton(text,x,y)
    if isMouseOver(x,y,buttonImage:getWidth(), buttonImage:getHeight()) then
        love.graphics.setColor(0.168,0.525,1)
    else
        love.graphics.setColor(1,1,1)
    end
    love.graphics.draw(buttonImage,x,y)

    if isMouseOver(x,y,buttonImage:getWidth(), buttonImage:getHeight()) then
        love.graphics.setColor(1,1,1)
    else
        love.graphics.setColor(0,0,0)
    end

    love.graphics.printf(text,x,y+5,buttonImage:getWidth(),"center")
end

function drawLargeButton(text,x,y)
    if isMouseOver(x,y,charactersButtonImage:getWidth(), charactersButtonImage:getHeight()) then
        love.graphics.setColor(0.168,0.525,1)
    else
        love.graphics.setColor(1,1,1)
    end
    love.graphics.draw(charactersButtonImage,x,y)

    if isMouseOver(x,y,charactersButtonImage:getWidth(), charactersButtonImage:getHeight()) then
        love.graphics.setColor(1,1,1)
    else
        love.graphics.setColor(0,0,0)
    end

    love.graphics.printf(text,x,y+15,charactersButtonImage:getWidth(),"center")
end