local t = {
    open = false,
    amount = 0,
    alpha = 0,
    w = 600,
    h = 400,
    tab = {
        names = {"BUY", "SELL",},
        selected = 1,
        w = 200,
        h = 40,
    },
    fields = {
        {
            title = "Armour",
            open = true,
            items = {},
        },{
            title = "Reagent",
            open = true,
            items = {},
        },
    },
    selected = "item,1,1",
    mouseOver = "",
}

local item = {
    Attributes = "None",
    Desc = "A silky piece of string",
    Enchantment = "None",
    ID = 31,
    ImgPath = "assets/items/reagent/String.png",
    Name = "String",
    Type = "reagent",
    Val = "0",
    Worth = 1,
}

local standardPlayer = {
    ChestArmour = {
      Attributes = "None",
      Desc = "A sturdy, reinforced Iron Chestplate",
      Enchantment = "None",
      ID = 39,
      ImgPath = "assets/player/gear/a2/chest.png",
      Name = "Iron Chestplate",
      Type = "arm_chest",
      Val = "18",
      Worth = 10
    },
    HeadArmour = {
      Attributes = "None",
      Desc = "A sturdy, reinforced Iron Helmet",
      Enchantment = "None",
      ID = 38,
      ImgPath = "assets/player/gear/a2/head.png",
      Name = "Iron Helmet",
      Type = "arm_head",
      Val = "12",
      Worth = 10
    },
    HeadArmourID = 38,
    ID = 2,
    Name = "Danjoe",
    Order = "Warrior Order",
    Owner = "Danjoe",
}

local ghostItem = {
    Attributes = "None",
    Desc = "These are reputation tokens that can be traded and sold.",
    Enchantment = "None",
    ID = 0,
    ImgPath = "assets/player/gear/a2/head.png",
    Name = "Mages Order Reputation",
    Type = "rep",
    Val = "12",
    Worth = 10,
}

for key, v in pairs(t.fields) do
    for i = 1, 4 do
        v.items[i] = {
            cost = {},
            amount = 255,
            type = "npc", -- "npc" "player"
            player = standardPlayer,
            name = "Lord Squabulus",
            image = "assets/npc/Guard.png",
            item = item,
        }
        for j = 1, 4 do
            v.items[i].cost[j] = {
                amount = 100,
                item = ghostItem,
            }
        end
    end
end

function t:init()

end

function t:update(dt)
    self.alpha = cerp(0,1,self.amount)
    if self.open then panelMovement(dt, self,  1, "amount", 4)
    else panelMovement(dt, self, -1, "amount", 4)
    end
end

function t:draw()
    t.mouseOver = ""
    local x,y = math.floor(uiX/2 - t.w/2) , math.floor(uiY/2 - t.h/2)
    love.graphics.setColor(0,0,0,0.8 * t.alpha)
    roundRectangle("fill", x, y, t.w, t.h, 10, {false, true, true, true})

    t:drawTab(1, x, y - t.tab.h)
    t:drawTab(2, x + t.tab.w, y - t.tab.h)

    love.graphics.setColor(1,1,1,t.alpha)
    local aw, ah, pad = 305, 36, 10
    local bw, bh = aw + 0, 56
    local ax, ay = x + pad, y + 10
    local fieldHeight = 0

    for i, field in ipairs(t.fields) do
        fieldHeight = fieldHeight + ah + pad
        if field.open then
            for j,items in ipairs(field.items) do
                fieldHeight = fieldHeight + bh + pad
            end
        end
    end

    addScroller("shopLeft", 0, fieldHeight - 10, t.h - 20, function ()
        return isMouseOver(x, y, t.w, t.h)
    end)
    local bx, by = ax, ay - scrollers.shopLeft.position

    love.graphics.stencil(function ()
        love.graphics.rectangle("fill", ax, ay, aw, t.h - 20, 10)
    end, "replace", 1) -- stencils inventory
    love.graphics.setStencilTest("greater", 0) -- push
        for i, field in ipairs(t.fields) do
            t:drawField(i,field,bx,by,aw,ah)
            by = by + ah + pad
            if field.open then
                for j,items in ipairs(field.items) do
                    t:drawItem(i,field,j,items,bx,by,bw,bh)
                    by = by + bh + pad
                end
            end
        end
    love.graphics.setStencilTest()

    local cw, ch = 266, 76
    local cx, cy = ax + aw + 10, ay
    love.graphics.setColor(0.2,0.2,0.2,0.8 * t.alpha)
    roundRectangle("fill", cx, cy, cw, ch, 10, {true, true, true, false,})
    if t.selected ~= "" then
        local e = explode(t.selected, ",")
        local v = t.fields[e[2]].items[e[3]]
        if v.type == "player" then
            drawProfilePic(cx + 6, cy + 6, 1, "right", v.player)
        else drawNPCProfilePic(cx + 6, cy + 6, 1, "right", v.image)
        end
        love.graphics.setColor(1,1,1,t.alpha)
        love.graphics.printf(v.name, inventory.font, cx + ch + 10, cy + 10, cw - (ch + 20), "left")
    end
end

function t:drawTab(i, x, y)
    if i == t.tab.selected then
        love.graphics.setColor(0,0,0,0.8 * t.alpha)
    else
        love.graphics.setColor(0,0,0,0.4 * t.alpha)
    end
    roundRectangle("fill", x, y, t.tab.w, t.tab.h, 20, {false, true, false, false})
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(t.tab.names[i], inventory.font, x + 10, y + 10, 0, 1)
end

function t:drawField(i,field,x,y,w,h)
    local isMouse = isMouseOver(x * scale, y * scale, w * scale, h * scale)
    if isMouse then
        t.mouseOver = "field,"..i
        love.graphics.setColor(0.4,0.4,0.4,t.alpha)
    else
        love.graphics.setColor(0.3,0.3,0.3,0.8 * t.alpha)
    end
    love.graphics.rectangle("fill",x,y,w,h,10)
    love.graphics.setColor(1,1,1,t.alpha)
    love.graphics.print(field.title, inventory.font, x + 10, y + 11, 0, 1)
end

function t:drawItem(i,field,j,items,x,y,w,h)
    local isMouse = isMouseOver(x * scale, y * scale, w * scale, h * scale)
    if t.selected == "item,"..i..","..j then
        love.graphics.setColor(1,0,0,t.alpha)
    elseif isMouse then
        t.mouseOver = "item,"..i..","..j
        love.graphics.setColor(0.3,0.3,0.3,t.alpha)
        y = y - 1
    else
        love.graphics.setColor(0.2,0.2,0.2,0.8 * t.alpha)
    end
    love.graphics.rectangle("fill",x,y,w,h,10)
    love.graphics.setColor(1,1,1,t.alpha)
    drawCraftingItem(x + 10, y + 10, items.item, items.amount)
    love.graphics.printf("=", x + 51, y + 8, 8, "center", 0, 3)
    x = x + 65
    for k = 1, 5 do
        local item = items.cost[k]
        if item then
            drawCraftingItem(x + 10, y + 10, item.item, item.amount)
        else
            love.graphics.setColor(0,0,0,0.7)
            drawItemBacking(x + 10, y + 10)
        end
        x = x + 46
    end
end

function t:drawGhostItem(i,field,j,items,x,y,w,h)
    local isMouse = isMouseOver(x * scale, y * scale, w * scale, h * scale)
    if t.selected == "item,"..i..","..j then
        love.graphics.setColor(1,0,0,t.alpha)
    elseif isMouse then
        t.mouseOver = "item,"..i..","..j
        love.graphics.setColor(0.3,0.3,0.3,t.alpha)
        y = y - 1
    else
        love.graphics.setColor(0.2,0.2,0.2,0.8 * t.alpha)
    end
    love.graphics.rectangle("fill",x,y,w,h,10)
    love.graphics.setColor(1,1,1,t.alpha)
    drawCraftingItem(x + 10, y + 10, items.item, items.amount)
    love.graphics.printf("=", x + 51, y + 8, 8, "center", 0, 3)
    x = x + 65
    for k = 1, 5 do
        local item = items.cost[k]
        if item then
            drawCraftingItem(x + 10, y + 10, item.item, item.amount)
        else
            love.graphics.setColor(0,0,0,0.7)
            drawItemBacking(x + 10, y + 10)
        end
        x = x + 46
    end
end

function t:reveal()
    t.open = not t.open
end

function t:keypressed(key)

end

function t:mousepressed(button)
    if t.mouseOver ~= "" then
        local e = explode(t.mouseOver)
        if e[1] == "item" then t.selected = t.mouseOver
        elseif e[1] == "field" then t.fields[e[2]].open = not t.fields[e[2]].open
        end
    end
end

return t

--[[
shop:init()
shop:update(dt)
shop:draw(x,y)
shop:keypressed(key)
shop:mousepressed(button)
]]