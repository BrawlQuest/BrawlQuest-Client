

function drawProfilePic(thisX, thisY, thisScale, thisRotation, v)

	v = v or me

	profileCount = profileCount + 1

	-- print (profileCount .. "=  " .. json:encode_pretty(v))

	love.graphics.push()
		local i = 1 * thisScale
		love.graphics.scale(i)
		love.graphics.setColor(0,0,0,0.6)
		love.graphics.draw(profilePic, thisX/i, thisY/i)
		love.graphics.setColor(1,1,1,1)
	love.graphics.pop()

	love.graphics.push()
		i = 4 * thisScale
		love.graphics.scale(i)

		if thisRotation == "left" then
			thisX = thisX/i + (playerImg:getWidth()/2)
			r = -1
		else
			thisX = thisX/i
			r = 1
		end

		love.graphics.draw(playerImg, profileImgStencil, thisX, thisY/i, 0, r, 1)

		if v and v.HeadArmour then
			if v.HeadArmourID ~= 0 then
				drawItemIfExists(v.HeadArmour.ImgPath, thisX, thisY/i, "", r, profileImgStencil, 16)
			end
			if v.ChestArmourID ~= 0 then
				drawItemIfExists(v.ChestArmour.ImgPath, thisX, thisY/i, "", r, profileImgStencil, 16)
			end
			if v.LegArmourID ~= 0 then
				drawItemIfExists(v.LegArmour.ImgPath, thisX, thisY/i, "", r, profileImgStencil, 16)
			end
		end
	love.graphics.pop()
end