local r = 0

function drawProfilePic(thisX, thisY, thisScale, thisRotation, v)
	v = v or me
	drawProfileBackground(thisX, thisY, thisScale)

	r = 1
	if thisRotation == "left" then r = -1 thisX = thisX + profilePic:getWidth() * thisScale end
	thisScale = 4 * thisScale
	love.graphics.setColor(1,1,1,1)
	-- if v.Color ~= null then love.graphics.setColor(unpack(v.Color)) end
	love.graphics.draw(playerImg, profileImgStencil, thisX, thisY, 0, r * thisScale, thisScale)
	love.graphics.setColor(1,1,1,1)

	if v and v.headarmour then
		if v.chestarmourID ~= 0 then
			drawProfileArmour(thisX,thisY,v.chestarmour,r,thisScale)
			-- drawItemIfExists(v.chestarmour.imgpath, thisX, thisY, "", r, thisScale, profileImgStencil)
		end	
		if v.headarmourID ~= 0 then
			drawProfileArmour(thisX,thisY,v.headarmour,r,thisScale)
			-- drawItemIfExists(v.headarmour.imgpath, thisX, thisY, "", r, thisScale, profileImgStencil)
		end
	end
end

function drawProfileArmour(x,y,item,r,thisScale)
    drawItemIfExists(item.imgpath, x, y, "", r, thisScale, profileImgStencil)
    if item.enchantment ~= "None" and item.enchantment ~= nil then
        love.graphics.push()
            love.graphics.stencil(function() 
                love.graphics.setShader(alphaShader)
                drawItemIfExists(item.imgpath, x, y, "", r, thisScale, profileImgStencil)
                love.graphics.setShader()
            end)
			love.graphics.setStencilTest("equal", 1)
			love.graphics.setColor(0.8,0,1,0.6)
			love.graphics.setBlendMode("add")
			local offset = 3
			if r == 1 then offset = 2 end
			love.graphics.draw(profileEnchantment, x + (enchantmentPos * 2 - 64 * offset), y, 0, 2)
			love.graphics.setStencilTest("always", 0)
			love.graphics.setBlendMode("alpha")
			love.graphics.setStencilTest()
        love.graphics.pop()
        love.graphics.setColor(1,1,1)
    end
end

function drawNPCProfilePic(thisX, thisY, thisScale, thisRotation, image)
	if not worldImg[image] then
		if love.filesystem.getInfo(image) then
			worldImg[image] = love.graphics.newImage(image)
		else
			worldImg[image] = love.graphics.newImage("assets/error.png")
			-- print("AN ERROR OCURRED. "..image.." can't be found.")
		end
	end
	drawProfileBackground(thisX, thisY, thisScale)
	r = 1
	if thisRotation == "left" then r = -1 thisX = thisX + profilePic:getWidth() * thisScale end
	thisScale = 4 * thisScale
	love.graphics.draw(worldImg[image], npcImgStencil, thisX, thisY, 0, r * thisScale, thisScale)
end

function drawProfileBackground(thisX, thisY, thisScale)
	love.graphics.setColor(0,0,0,0.6)
	love.graphics.draw(profilePic, thisX, thisY, 0, 1)
	love.graphics.setColor(1,1,1,1)
end