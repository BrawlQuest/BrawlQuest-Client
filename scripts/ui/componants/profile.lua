function drawProfile()
	if isMouseOver(0,0,perks:getWidth()*scale,perks:getHeight()*scale) then
		love.graphics.draw(perks)
		printWidth = (profileBgnd:getWidth()+perks:getWidth())*scale+5
	else
		printWidth = profileBgnd:getWidth()*scale+5
    end
    
	love.graphics.draw(profileBgnd)
	love.graphics.draw(profileImgBox, 7, 5)
	love.graphics.draw(level, 7, 5)
    love.graphics.draw(profileBars, 7, 51)
    
	love.graphics.setColor(1,1,1,1)

	for i = 1, 3 do
		love.graphics.rectangle("fill", 20, 80+(14*(i-1)), 42, 10) -- Backing Rectangles
	end

	love.graphics.setColor(1,0,0,1)
	love.graphics.rectangle("fill", 20, 80, 10, 10) -- Health

	love.graphics.setColor(0,0.5,1,1)
	love.graphics.rectangle("fill", 20, 94, 37, 10) -- Stamina
	
	love.graphics.setColor(1,0.5,0,1)
	love.graphics.rectangle("fill", 20, 108, 23, 10) -- XP
	
	love.graphics.setColor(1,1,1,1)
end

