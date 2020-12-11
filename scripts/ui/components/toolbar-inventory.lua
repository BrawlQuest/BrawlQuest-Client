function initToolBarInventory()
    inventory = {
        open = true,
    }
end

function updateToolBarInventory(dt)
    
end

function drawToolBarInventory(thisX, thisY)
    love.graphics.setColor(unpack(characterHub.backgroundColor))
    love.graphics.rectangle("fill", thisX + 313, thisY - 97, -313, -23)
end

function getInventoryBackgroundHeight()
    if inventory.open then
        return uiY - (97)
    else
        return 97
    end
end

