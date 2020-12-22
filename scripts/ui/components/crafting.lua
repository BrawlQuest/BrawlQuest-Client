function initCrafting()
    crafting = {
        open = false,
        anvil = love.graphics.newImage("assets/world/objects/Anvil.png"),
        hammer = love.graphics.newImage("assets/ui/hud/crafting/hammer.png"),
        hammerShake = 0,
        craftableItems = {
            {
                item = a0sword,
                random = {X = math.random()*100, Y = math.random()*100},
                chance = 90,
                amount = 1,
            },
            {
                item = a0sword,
                random = {X = math.random()*100, Y = math.random()*100},
                chance = 90,
                amount = 1,
            },
            {
                item = a0sword,
                random = {X = math.random()*100, Y = math.random()*100},
                chance = 90,
                amount = 1,
            },
        },
        percentFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 16),
    }
end

function updateCrafting(dt)
    if crafting.open then
        crafting.hammerShake = crafting.hammerShake + (1 * dt)
        if crafting.hammerShake > 2 then
            crafting.hammerShake = 0
        end
    end
end

function drawCrafting(thisX, thisY)
    love.graphics.setColor(0,0,0,0.5)
    roundRectangle("fill", thisX, thisY, 400, 400, 10)
    love.graphics.setColor(1,1,1,1)
    love.graphics.stencil(drawCraftingStencil, "replace", 1) -- stencils inventory
    love.graphics.setStencilTest("greater", 0) -- push
        drawCraftingBackground(thisX, thisY)
    love.graphics.setStencilTest() -- pop
end

function drawCraftingBackground(thisX, thisY)

    love.graphics.draw(crafting.anvil, thisX + 100, thisY + 270, 0, 7)
    love.graphics.draw(crafting.hammer, thisX + 470, thisY + 300, cerp(-0.01, 0.01, crafting.hammerShake), -10)

    love.graphics.setFont(inventory.headerFont)
    love.graphics.print("Crafting", thisX + 10 , thisY + 7)

    for i = 1 , #crafting.craftableItems do
        drawCraftingItem(thisX + 10, thisY + 50 + (45 * (i - 1)), crafting.craftableItems[i].item, crafting.craftableItems[i].amount, crafting.craftableItems[i].chance)
        love.graphics.draw(a0sword ,thisX + 100 + crafting.craftableItems[i].random.X, thisY + 180 + crafting.craftableItems[i].random.Y, 0, 4, 2)
    end
end

function drawCraftingItem(thisX, thisY, item, amount, chance)
    love.graphics.draw(inventory.images.itemBG, thisX, thisY)
    if item ~= null then love.graphics.draw(item, top_left, thisX + 2, thisY + 2) end
    
    love.graphics.setFont(crafting.percentFont)
    love.graphics.print(chance .. "%", thisX + 45 , thisY + 11)
    
    love.graphics.setFont(inventory.itemFont)
    if amount > 1 then
        if amount <= 9 then
            inventory.imageNumber = 1
        elseif amount > 9 and amount <= 99 then
            inventory.imageNumber = 2
        elseif amount > 99 and amount <= 999 then
            inventory.imageNumber = 3
        else
            inventory.imageNumber = 4
        end
        thisX, thisY = thisX + 39 - inventory.images.numberBg[inventory.imageNumber]:getWidth(),
            thisY + 39 - inventory.images.numberBg[inventory.imageNumber]:getHeight()
        love.graphics.draw(inventory.images.numberBg[inventory.imageNumber], thisX, thisY)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print(amount, thisX + 5, thisY + 4)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function drawCraftingStencil()
    roundRectangle("fill", (uiX / 2) - (400 / 2), (uiY / 2) - (400 / 2), 400, 400, 10)
end

