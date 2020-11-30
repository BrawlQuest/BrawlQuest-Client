--[[
    This file contains toolbar and inventory functions. They're pretty good.
]]

function drawToolbar()
	if uiY > (769*scale) then
		toolbary = (uiY/2) - 261
	else
		toolbary = 124
	end
	
	if isMouseOver(0, toolbary*scale, inventory:getWidth()*scale, inventory:getHeight()*scale) then
		drawInventory()
		love.graphics.setColor(0,0,0,1)
		love.graphics.setFont(smallTextFont, 16)
		love.graphics.print("Search", 105, toolbary+14)
		smallTextFont:setFilter( "nearest", "nearest" )
		love.graphics.setColor(1,1,1,1)
	end

	love.graphics.draw(toolbarBg, 0, toolbary)

	
	toolbarItems = {a0sword, a0sword}

	local c = {1,2,3,4,5,6,7,8,9,0}
	
	love.graphics.setFont(circleFont)
	for b = 1, 10 do
		love.graphics.setColor(1,1,1,0.5)
		love.graphics.rectangle("fill", 11+7, ((toolbary+22)+((b-1)*49))+2, 34, 34)
		love.graphics.setColor(1,1,1,1)

		if toolbarItems[b] ~= null then
			love.graphics.draw(toolbarItems[b], top_left, 11+8, ((toolbary+22)+((b-1)*49))+3)
		end

		love.graphics.draw(toolbarItem, 11, (toolbary+22)+((b-1)*49))--Forground

		love.graphics.setColor(0,0,0,1)

		love.graphics.printf(c[b], 11, (toolbary+22)+((b-1)*49)+27, 16, "center")--text
		love.graphics.setColor(1,1,1,1)
	end
	circleFont:setFilter( "nearest", "nearest" )
	love.graphics.setFont(font)
end