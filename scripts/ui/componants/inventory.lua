function loadInventory()
    -- Inventory
    inventoryItemBgnd = love.graphics.newImage("assets/ui/hud/inventory/inventoryItem.png")

    inventoryFields = {"weapons", "spells", "armour", "mounts", "other"}
    userInventory = {}
    userInventory[1] = {a0sword, a1sword, a2sword, a3sword, a4sword, a4sword, a4sword, a4sword, a4sword, a4sword}
    userInventory[2] = {a0sword, a1sword, a2sword, a3sword}
    userInventory[3] = {a0sword, a1sword, a2sword, a3sword, a4sword}
    userInventory[4] = {a0sword, a1sword, a2sword, a3sword, a4sword}
    userInventory[5] = {a0sword, a1sword, a2sword, a3sword, a4sword}

    userInventoryFieldHeight = {}

end

function drawInventoryFeilds(thisX, y)
    love.graphics.setFont(inventorySubHeaderFont)
    thisY = y
    for i = 0, tableLength(inventoryFields)-1 do -- Draws each inventory field
        inventoryItemField(thisX+8, thisY+0, i+1)
        thisY = thisY + getUserInventoryFieldHeight(i+1)
    end
end

function inventoryItemField(thisX, y, field) 
    --love.graphics.printf(inventoryFields[field], thisX, y, 483)
    
    love.graphics.printf(inventoryFields[field], thisX, thisY, 483)
    thisY = thisY + 18
    for i = 0, tableLength(userInventory[field])-1 do 
        if i <= 3 then 
            drawInventoryItem(thisX+((i-0)*42), thisY+0, field, i+1)
            userInventoryFieldHeight[field] = 42+15
        elseif i >= 4 and i <= 7 then
            drawInventoryItem(thisX+((i-4)*42), thisY+42, field, i+1)
        elseif i >= 8 and i <= 11 then
            drawInventoryItem(thisX+((i-8)*42), thisY+84, field, i+1)
        elseif i >= 12 and i <= 15 then
            drawInventoryItem(thisX+((i-12)*42), thisY+126, field, i+1)
        elseif i >= 16 and i <= 19 then
            drawInventoryItem(thisX+((i-16)*42), thisY+168, field, i+1)
        end
    end
end

function getUserInventoryFieldHeight(field)
    local i = tableLength(userInventory[field])-1
    local j = 2
    if i <= 3 then return j+42
    elseif i >= 4 and i <= 7 then return j+84
    elseif i >= 8 and i <= 11 then return j+126
    elseif i >= 12 and i <= 15 then return j+168
    elseif i >= 16 and i <= 19 then return j+168
    end
end

function getFullUserInventoryFieldHeight()
    local j = 0
    for i = 1, tableLength(userInventory) do
        j = j + getUserInventoryFieldHeight(i) + 18
    end
    return j
end

function drawInventoryItem(thisX, thisY, field, item)
    love.graphics.draw(inventoryItemBgnd, thisX, thisY) -- Background
    love.graphics.draw(userInventory[field][item], thisX+3, thisY+3) -- Item
end

function drawInventory()
	love.graphics.draw(inventory, 0, toolbary)
	-- love.graphics.rectangle("fill", 70, toolbary+40, 180, 483)
	
	love.graphics.stencil(drawInventoryStencil, "replace", 1) -- stencils inventory
	love.graphics.setStencilTest("greater", 0) -- push
		
        drawInventoryFeilds(70, toolbary+40+posyInventory)
        -- love.graphics.rectangle("fill", 70, toolbary+40+posyInventory, 10, getFullUserInventoryFieldHeight())

	love.graphics.setStencilTest() -- pop
end

function drawInventoryStencil()
	love.graphics.rectangle("fill", 70, toolbary+40, 180, 483)
end