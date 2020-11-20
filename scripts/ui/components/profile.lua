function drawProfile()
	if isMouseOver(0,0,perks:getWidth()*scale,perks:getHeight()*scale) then
		love.graphics.draw(perks)
		printWidth = (perks:getWidth())*scale+5
	else
		printWidth = profileBgnd:getWidth()*scale+5
    end
    
	love.graphics.draw(profileBgnd)
	drawProfilePic(19, 5, 0.5, me.Name)
	love.graphics.draw(level, 7, 5)
	love.graphics.draw(profileBars, 7, 51)

	
	love.graphics.setColor(1,1,1,1)

	for i = 1, 3 do
		love.graphics.rectangle("fill", 20, 80+(14*(i-1)), 42, 10) -- Backing Rectangles
	end

	local j = 2.380952380952381

	if me ~= null and me.HP ~= null or me.XP ~= null then
		love.graphics.setColor(1,0,0,1)
		love.graphics.rectangle("fill", 20, 80, me.HP / j, 10) -- Health

		love.graphics.setColor(0,0.5,1,1)
		love.graphics.rectangle("fill", 20, 94, me.Mana / j, 10) -- Mana
		
		love.graphics.setColor(1,0.5,0,1)
		love.graphics.rectangle("fill", 20, 108, me.XP / j, 10) -- XP
	end

	love.graphics.setColor(1,1,1,1)
end

function drawProfilePic(thisX, thisY, thisScale, thisRotation, player)
	love.graphics.push()
		local i = 1 * thisScale
        love.graphics.scale(i)
		love.graphics.draw(profilePic, thisX/i, thisY/i)
	love.graphics.pop()
	
	love.graphics.push()
		local i = 4 * thisScale
		love.graphics.scale(i)
		if thisRotation == "left" then
			love.graphics.draw(playerImg, profileImgStensil, (thisX/i)+(playerImg:getWidth()/2), thisY/i, 0, -1, 1)
		else
			love.graphics.draw(playerImg, profileImgStensil, thisX/i, thisY/i)
		end
	love.graphics.pop()
end