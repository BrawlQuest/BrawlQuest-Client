local r = 0

function drawProfilePic(thisX, thisY, thisScale, thisRotation, v)
	v = v or me
	drawProfileBackground(thisX, thisY, thisScale)

	love.graphics.push()
		i = 4 * thisScale
		love.graphics.scale(i)

		r, thisX = getProfileRotation(thisRotation, thisX, i)

		love.graphics.setColor(1,1,1,1)
		-- if v.Color ~= null then love.graphics.setColor(unpack(v.Color)) end
		love.graphics.draw(playerImg, profileImgStencil, thisX, thisY / i, 0, r, 1)
		love.graphics.setColor(1,1,1,1)

		if v and v.HeadArmour then
			if v.ChestArmourID ~= 0 then
				drawItemIfExists(v.ChestArmour.ImgPath, thisX, thisY / i, "", r, profileImgStencil, 16)
			end	
			if v.HeadArmourID ~= 0 then
				drawItemIfExists(v.HeadArmour.ImgPath, thisX, thisY / i, "", r, profileImgStencil, 16)
			end
		end
	love.graphics.pop()
end

function drawNPCProfilePic(thisX, thisY, thisScale, thisRotation, image)

	if not worldImg[image] then
		if love.filesystem.getInfo(image) then
			worldImg[image] = love.graphics.newImage(image)
		else
			worldImg[image] = love.graphics.newImage("assets/error.png")
			print("AN ERROR OCURRED. "..image.." can't be found.")
		end
	end

	drawProfileBackground(thisX, thisY, thisScale)
	love.graphics.push()
		i = 4 * thisScale
		love.graphics.scale(i)

		r, thisX = getProfileRotation(thisRotation, thisX, i)
		love.graphics.draw(worldImg[image], npcImgStencil, thisX, thisY / i, 0, r, 1)
	love.graphics.pop()
end

function drawProfileBackground(thisX, thisY, thisScale)
	love.graphics.push()
		local i = 1 * thisScale
		love.graphics.scale(i)
		love.graphics.setColor(0,0,0,0.6)
		love.graphics.draw(profilePic, thisX / i, thisY / i)
		love.graphics.setColor(1,1,1,1)
	love.graphics.pop()
end

function getProfileRotation(thisRotation, thisX, i)
	if thisRotation == "left" then
		thisX = thisX/i + (playerImg:getWidth()/2)
		r = -1
		return r, thisX
	else
		thisX = thisX/i
		r = 1
		return r, thisX
	end
end