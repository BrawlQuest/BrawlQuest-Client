

function drawProfilePic(thisX, thisY, thisScale, thisRotation, v)
	-- if not v then v = me end
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

		if v == me then
			print("Yooooo")

			if v.HeadArmourID ~= 0 then
				drawItemIfExists(v.HeadArmour.ImgPath, x, y, r)
			end
			if v.ChestArmourID ~= 0 then
				drawItemIfExists(v.ChestArmour.ImgPath, x, y, r)
			end
			if v.LegArmourID ~= 0 then
				drawItemIfExists(v.LegArmour.ImgPath, x, y, r)
			end

			-- if v.HeadArmourID ~= 0 then
			-- 	drawItemIfExists(v.HeadArmour.ImgPath, x, y, ad.previousDirection)
			-- end
			-- if v.ChestArmourID ~= 0 then
			-- 	drawItemIfExists(v.ChestArmour.ImgPath, x, y, ad.previousDirection)
			-- end

		end
		
		-- for j,v in ipairs(players) do
		-- 	print(json:encode_pretty(v) .. ",,, " .. v)
		-- 	if v.Name == v then
		-- 		print("trueee")
		-- 		love.graphics.rectangle("fill", thisX, thisY, 100, 100)
		-- 		drawItemIfExists(v.ChestArmour.ImgPath, thisX, thisY, r)
		-- 	end
		-- end

	love.graphics.pop()
end

--[[{
"AX":-2,
"AY":1,
"Buddy":"None",
"ChestArmour":{"Desc":"It hangs a bit loose, but it's good for being about the town.","ID":3,"ImgPath":"assets/player/gear/custom/green shirt.png","Name":"Green Shirt","Type":"arm_chest","Val":"0","Worth":1},
"ChestArmourID":3,
"HP":115,
"HeadArmour":{"Desc":"An error has ocurred. Run!!!","ID":0,"ImgPath":"assets/error.png","Name":"Error","Type":"Error","Val":"Error","Worth":0},
"HeadArmourID":0,
"ID":14,
"INT":1,
"IsShield":false,
"LVL":1,
"LastUpdate":1611588815,
"LegArmour":{"Desc":"Smart casual, for sure.","ID":2,"ImgPath":"assets/player/gear/custom/brown trousers.png","Name":"Brown Trousers","Type":"arm_legs","Val":"0","Worth":1},
"LegArmourID":2,
"Mana":100,
"Mount":"None",
"Name":"Lord Squabulus",
"Owner":"Danjoe",
"STA":1,
"STR":1,
"Shield":{"Desc":"An error has ocurred. Run!!!","ID":0,"ImgPath":"assets/error.png","Name":"Error","Type":"Error","Val":"Error","Worth":0},
"ShieldID":0,
"Weapon":{"Desc":"A long stick with the end sharpened to be somewhat pointy.","ID":1,"ImgPath":"assets/player/gear/a0/dagger.png","Name":"Long Stick","Type":"wep","Val":"1","Worth":1},
"WeaponID":1,
"X":-2,
"XP":91,
"Y":1}]]--