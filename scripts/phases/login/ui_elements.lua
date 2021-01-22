
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

function roundRectangle(type, x, y, width, height, radius, table)
    table = table or {true, true, true, true}
	--RECTANGLES
	love.graphics.rectangle(type, x + radius, y + radius, width - (radius * 2), height - radius * 2)
	love.graphics.rectangle(type, x + radius, y, width - (radius * 2), radius)
	love.graphics.rectangle(type, x + radius, y + height - radius, width - (radius * 2), radius)
	love.graphics.rectangle(type, x, y + radius, radius, height - (radius * 2))
	love.graphics.rectangle(type, x + (width - radius), y + radius, radius, height - (radius * 2))
	
    --ARCS
    if table[1] then
        love.graphics.arc(type, x + radius, y + radius, radius, math.rad(-180), math.rad(-90))
    else
        love.graphics.rectangle(type, x, y, radius, radius)
    end

    if table[2] then
        love.graphics.arc(type, x + width - radius, y + radius, radius, math.rad(-90), math.rad(0))
    else
        love.graphics.rectangle(type, x + width - radius, y, radius, radius)
    end

    if table[3] then
        love.graphics.arc(type, x + radius, y + height - radius, radius, math.rad(-180), math.rad(-270))
    else
        love.graphics.rectangle(type, x, y + height - radius, radius, radius)
    end

    if table[4] then
        love.graphics.arc(type, x + width - radius , y + height - radius, radius, math.rad(0), math.rad(90))
    else
        love.graphics.rectangle(type, x + width - radius , y + height - radius, radius, radius)
    end
end