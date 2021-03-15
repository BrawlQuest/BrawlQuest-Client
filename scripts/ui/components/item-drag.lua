function initItemDrag()
    itemDrag = {
        dragging = false,
        amount = 1,
        item = null,
        alpha = 0,
    }
end

function updateItemDrag(dt)
    local iD = itemDrag
    panelMovement(dt, itemDrag, 1, "alpha", 4)
end

function drawItemDrag()
    local iD = itemDrag
    local x,y = mx / scale - 16, my / scale - 16
    love.graphics.setColor(1,1,1,iD.alpha)
    drawItemBacking(x,y)
    if iD.item then drawItem(x,y,iD.item) end
    drawItemAmount(x,y,iD.amount,iD.alpha)
    love.graphics.setColor(1,1,1)
end

function checkItemDragMousePressed(button, hotbarI)
    local iD = itemDrag
    if hotbarI then
        iD.item = copy(hotbar[hotbarI].item)
        iD.amount = hotbar[hotbarI].amount
    else
        iD.item = copy(selectedItem)
        iD.amount = selectedItemAmount
    end
    iD.alpha = 0
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