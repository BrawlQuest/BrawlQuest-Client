function initItemDrag()
    itemDrag = {
        dragging = false,
        amount = 1,
        item = null,
    }
end

function updateItemDrag(dt)
    local iD = itemDrag
end

function drawItemDrag()
    local iD = itemDrag
    local x,y = mx / scale, my / scale
    drawItemBacking(x,y)
    love.graphics.setColor(1,1,1,1)
    if iD.item then drawItem(x,y,iD.item) end
    drawItemAmount(x,y,iD.amount)
    love.graphics.setColor(1,1,1)
end

function checkItemDragMousePressed(button)
    local iD = itemDrag
    iD.item = copy(selectedItem)
    iD.amount = selectedItemAmount
    iD.dragging = true
end

function checkItemDragMouseReleased(button)
    local iD = itemDrag
    if iD.item and inventory.mouseOverButtonsAmount > 0 then
        hotbar[inventory.mouseOverButtonsAmount] = {item = iD.item, amount = iD.amount}
        hotbarChanged = true
        writeSettings()
        iD.item = null
        iD.amount = 0
    end
    iD.dragging = false
end

-- initItemDrag()
-- updateItemDrag(dt)
-- drawItemDrag(x,y)
-- checkItemDragKeyPressed(key)
-- checkItemDragMousePressed(button)