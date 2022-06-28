function initItemDrag()
    itemDrag = {
        dragging = false,
        amount = 1,
        item = null,
        alpha = 0,
        prevI = 0,
        id = 0,
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
    if hotbarI and hotbar[hotbarI] and hotbar[hotbarI].InventoryItem then -- copy from hotbar
        iD.prevI = hotbarI
        iD.item = copy(hotbar[hotbarI].InventoryItem.Item)
        iD.amount = hotbar[hotbarI].InventoryItem.Inventory.Amount
        iD.id = hotbar[hotbarI].InventoryItem.Inventory.ID
    else
        iD.prevI = 0
        iD.item = copy(selectedItem)
        iD.amount = selectedItemAmount
        iD.id = selectedItemID
    end
    iD.alpha = 0
    iD.dragging = true
    showMouse = false
end

function checkItemDragMouseReleased(button)
    local iD = itemDrag
    if iD.item and inventory.mouseOverButtonsAmount > 0 then
        iD.item = null
        iD.amount = 0
        hotbarData = {
            PlayerID=me.ID,
            InventoryItemID=iD.id,
            Position=inventory.mouseOverButtonsAmount
        }
      
        r, c, h = http.request {
            url = api.url.."/hotbar",
            method = "POST",
            source = ltn12.source.string(json:encode(hotbarData)),
            headers = {
                ["Content-Type"] = "application/json",
                ["Content-Length"] = string.len(json:encode(hotbarData)),
                ["token"] = token
            }
        }
    elseif iD.item then hotbar[iD.prevI] = {item = null, amount = 0}
    end
    iD.dragging = false
    showMouse = true
end

-- initItemDrag()
-- updateItemDrag(dt)
-- drawItemDrag(x,y)
-- checkItemDragKeyPressed(key)
-- checkItemDragMousePressed(button)