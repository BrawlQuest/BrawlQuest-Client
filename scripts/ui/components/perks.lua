function drawPerks()
    love.graphics.draw(perksBg)
    love.graphics.setFont(inventorySubHeaderFont)
    love.graphics.printf("Character Perks", 70, 4, 180, "center")

    love.graphics.draw(mouseDown, 70, 40)
    love.graphics.draw(mouseUp, 70+mouseUp:getWidth(), 40)

    love.graphics.setFont(font)
end