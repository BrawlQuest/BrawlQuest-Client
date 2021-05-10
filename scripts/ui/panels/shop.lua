local t = {
    open = false,
    amount = 0,
    alpha = 0,
    w = 600,
    h = 400,
    fields = {
        {
            title = "HELLO",
            open = true,
            items = {
                {
                    price = 200,
                    item = {
                        Attributes = "None",
                        Desc = "A silky piece of string",
                        Enchantment = "None",
                        ID = 31,
                        ImgPath = "assets/items/reagent/String.png",
                        Name = "String",
                        Type = "reagent",
                        Val = "0",
                        Worth = 1,
                    },
                },
            },
        },{
            title = "IT'S GOOD",
            open = true,
            items = {},
        },{
            title = "VERY GOOD",
            open = true,
            items = {},
        },
    },

}

function t:init()

end

function t:update(dt)
    self.alpha = cerp(0,1,self.amount)
    if self.open then panelMovement(dt, self,  1, "amount", 4)
    else panelMovement(dt, self, -1, "amount", 4)
    end
end

function t:draw()
    local x,y = math.floor(uiX/2 - t.w/2) , math.floor(uiY/2 - t.h/2)
    love.graphics.setColor(0,0,0,0.4 * t.alpha)
    love.graphics.rectangle("fill", x, y, t.w, t.h, 10)
    love.graphics.setColor(1,1,1,t.alpha)
    love.graphics.print("TRADING", inventory.headerFont, x + 16 , y + 14)
    local aw, ah, pad = getPaddedSize(t.w - 20, 10, 2), 36, 10
    local bw, bh = aw + 0, 56
    local ax, ay = x + pad, y + 80
    for i, field in ipairs(t.fields) do
        t:drawField(i,field,ax,ay,aw,ah)
        ay = ay + ah + pad
        if field.open then
            for j,item in ipairs(field.items) do
                t:drawItem(i,field,j,item,ax,ay,bw,bh)
                ay = ay + bh + pad
            end
        end
    end
end

function t:drawField(i,field,ax,ay,aw,ah)
    love.graphics.setColor(0,0,0,0.8 * t.alpha)
    love.graphics.rectangle("fill",ax,ay,aw,ah,10)
    love.graphics.setColor(1,1,1,t.alpha)
    love.graphics.print(field.title, inventory.font, ax + 10, ay + 11, 0, 1)
end

function t:drawItem(i,field,j,item,x,y,w,h)
    love.graphics.setColor(1,0,1,0.4 * t.alpha)
    love.graphics.rectangle("fill",x,y,w,h,10)
    love.graphics.setColor(1,1,1,t.alpha)
    drawCraftingItem(x + 10, y + 10, item, 0)
    x = x + 56
    love.graphics.print(item.Name, inventory.font, x, y + 11, 0, 1)
    love.graphics.print(item.Name, inventory.font, x, y + 11, 0, 1)
end

function t:reveal()
    t.open = not t.open
end

function t:keypressed(key)

end

function t:mousepressed(button)

end

return t

--[[
shop:init()
shop:update(dt)
shop:draw(x,y)
shop:keypressed(key)
shop:mousepressed(button)
]]