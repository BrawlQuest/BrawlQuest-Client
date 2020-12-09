function drawProfile()
	
	if isMouseOver(0,0,perksBg:getWidth()*scale,perksBg:getHeight()*scale) then
		drawPerks()
    end
    
	love.graphics.draw(profileBackground)
	drawProfilePic(19, 5, 0.5, "right", me.Name)
	love.graphics.draw(level, 7, 5)
	love.graphics.draw(profileBars, 7, 51)
	love.graphics.setColor(1,1,1,1)

	for i = 1, 3 do
		love.graphics.rectangle("fill", 20, 80+(14*(i-1)), 42, 10) -- Backing Rectangles
	end

	local j = 2.380952380952381
	
	if me ~= null and me.HP ~= null or me.XP ~= null then
		love.graphics.setColor(0,0,0,1)
		love.graphics.setFont(circleFont)
		love.graphics.printf(me.LVL, 33, 33, 30, "center")
		love.graphics.setFont(font)
		love.graphics.setColor(1,1,1,1)
		
		love.graphics.setColor(1,0,0,1)
		love.graphics.rectangle("fill", 20, 80, me.HP / j, 10) -- Health

		love.graphics.setColor(0,0.5,1,1)
		love.graphics.rectangle("fill", 20, 94, me.Mana / j, 10) -- Mana
		
		love.graphics.setColor(1,0.5,0,1)
		love.graphics.rectangle("fill", 20, 108, me.XP / j, 10) -- XP
	end

	love.graphics.setColor(1,1,1,1)
end

function drawProfilePic(thisX, thisY, thisScale, thisRotation, tplayer)
	if not tplayer then tplayer = me end
	love.graphics.push()
		local i = 1 * thisScale
		love.graphics.scale(i)
		love.graphics.setColor(0,0,0,0.6)
		love.graphics.draw(profilePic, thisX/i, thisY/i) 
		love.graphics.setColor(1,1,1,1)
	love.graphics.pop()
	
	love.graphics.push()
		local i = 4 * thisScale
		love.graphics.scale(i)

		if thisRotation == "left" then
			thisX = thisX/i + (playerImg:getWidth()/2)
			r = -1
		else
			thisX = thisX/i
			r = 1
		end

		if itemImg[tplayer.Shield] ~= nil then
			love.graphics.draw(itemImg[tplayer.Shield.ImgPath], ShieldImgStencil, thisX, thisY/i, 0, r, 1)
		end
		
		if playerImg ~= null then
			love.graphics.draw(playerImg, profileImgStencil, thisX, thisY/i, 0, r, 1)
		end

		if itemImg[tplayer.ChestArmour] ~= nil then
			love.graphics.draw(itemImg[tplayer.ChestArmour.ImgPath], profileImgStencil, thisX, thisY/i, 0, r, 1)
		end

		if itemImg[tplayer.HeadArmour] ~= nil then
			love.graphics.draw(itemImg[tplayer.HeadArmour.ImgPath], profileImgStencil, thisX, thisY/i, 0, r, 1)
		end
	love.graphics.pop()
end