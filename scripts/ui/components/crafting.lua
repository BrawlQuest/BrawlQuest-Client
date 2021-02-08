

function initCrafting()
    crafting = {
        open = false,
        anvil = love.graphics.newImage("assets/world/objects/Anvil.png"),
        hammer = love.graphics.newImage("assets/ui/hud/crafting/hammer.png"),
        hammerShake = 0,
        hammerDown = 1,
        hammerY = 0,
        isCrafting = false,
        sfx = love.audio.newSource("assets/sfx/player/actions/anvil.ogg", "static"),
        swing = love.audio.newSource("assets/sfx/player/actions/swing.wav", "static"),
        whiteout = 0,
        craftableItems = {
          
        },
        enteredItems = {
         
        },
        mouse = {love.graphics.newImage("assets/ui/hud/perks/BQ Mice - 1.png"), love.graphics.newImage("assets/ui/hud/perks/BQ Mice + 1.png")},
        selectableI = 0,
        percentFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 16),
    }
end

function updateCrafting(dt)
    if crafting.open then
        if crafting.isCrafting then
            if crafting.hammerDown < 0 then
                crafting.whiteout = crafting.whiteout + 20 * dt
                crafting.sfx:setPitch(love.math.random(50,100)/100)
                love.audio.play(crafting.sfx)
                if crafting.whiteout > 1 then
                    crafting.hammerDown = 1
                    crafting.isCrafting = false
                    crafting.whiteout = 1.25
                    local itemsSoFar = {}
                    for i,v in ipairs(crafting.enteredItems) do
                        itemsSoFar[#itemsSoFar+1] = {
                            ItemID = v.item.ID,
                            Amount = v.amount
                        }
                    end
                    local b = {}
                    body = json:encode(itemsSoFar)
                    c, h = http.request{url = api.url.."/craft/"..player.name, method="POST", source=ltn12.source.string(body), headers={["token"]=token,["Content-Length"]=#body}, sink=ltn12.sink.table(b)}
                    if json:decode(b[1])["success"] == null then
                        crafting.result = json:decode(b[1])
                    else
                        crafting.result = null
                    end
                  
                    crafting.enteredItems = {}
                    crafting.craftableItems = {}
                 
                end
            else
                crafting.hammerDown = crafting.hammerDown - 2 * dt
            end
        else
            crafting.whiteout = crafting.whiteout - 1 * dt
            crafting.hammerShake = crafting.hammerShake + 1 * dt
        end

        if crafting.hammerShake > 2 then
            crafting.hammerShake = 0
        end

    end
end

function drawCrafting()
    thisX, thisY = (uiX / 2) - (400 / 2), (uiY / 2) - (400 / 2)
    love.graphics.setColor(0,0,0,0.7)
    roundRectangle("fill", thisX, thisY, 400, 400, 8)
    love.graphics.setColor(1,1,1,1)
    love.graphics.stencil(drawCraftingStencil, "replace", 1) -- stencils inventory
    love.graphics.setStencilTest("greater", 0) -- push
        drawCraftingBackground(thisX, thisY)
    love.graphics.setStencilTest() -- pop
end

function drawCraftingBackground(thisX, thisY)

    if crafting.result then
       -- drawInventoryItem(thisX + 200, thisY+200, 0, crafting.result,1)
       if isMouseOver((thisX+160) * scale,(thisY+160)*scale,128*scale,128*scale) then
            setItemTooltip(crafting.result)
       end
        love.graphics.draw(getImgIfNotExist(crafting.result.ImgPath),thisX+160,thisY+160,0,4,4)
    end

    if isMouseOver((thisX+100)* scale, (thisY + 270) * scale, (crafting.anvil:getWidth()*7)*scale, (crafting.anvil:getHeight()*7)*scale) then
        love.graphics.setColor(0.6,0.6,0.6)
    end
    love.graphics.draw(crafting.anvil, thisX + 100, thisY + 270, 0, 7)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(crafting.hammer, thisX + 490, thisY + 300 - crafting.hammerY, cerp(-0.01, 0.01, crafting.hammerShake) + cerp(-0.6,0.01, crafting.hammerDown), -10)
    love.graphics.print("CRAFTING", inventory.headerFont, thisX + 10 , thisY + 7)


    love.graphics.setColor(0,0,0,0.7)
    for i = 1, 4 do
        drawItemBacking(thisX + 10, thisY + 50 + (45 * (i - 1)))
    end
    for i = 1, 9 do
        drawItemBacking(thisX + 10 + (45 * (i - 1)), thisY + 355)
    end

    love.graphics.setColor(1,1,1)
    for i,v in ipairs(crafting.craftableItems) do
        drawInventoryItem(thisX + 10, thisY + 50 + (45 * (i - 1)), 0, v.Item, 1)
        love.graphics.setFont(inventory.font)
        if v.Chance then
            love.graphics.print(v.Chance.. "%", thisX + 50 ,  thisY + 60 + (45 * (i - 1)))
        end
    end

    crafting.selectableI = 0
    for i = 1, #crafting.enteredItems do
        local dx, dy = thisX + 10 + (45 * (i - 1)), thisY + 355
        drawInventoryItem(dx, dy, 0, crafting.enteredItems[i].item, crafting.enteredItems[i].amount)
        if isMouseOver(dx, dy, inventory.images.itemBG:getWidth(), inventory.images.itemBG:getWidth()) then
            crafting.selectableI = i
        end
    end

    love.graphics.setColor(1,1,1,1)
    local w, h = 10, 296
    love.graphics.draw(crafting.mouse[2], thisX + w, thisY + h, 0, 2)
    love.graphics.draw(crafting.mouse[1], thisX + w + crafting.mouse[1]:getWidth() * 2, thisY + h, 0, 2)

    love.graphics.setColor(1,1,1,crafting.whiteout)
    love.graphics.rectangle("fill",thisX,thisY,400,400)
end

function drawCraftingButton(thisX, thisY, title)
    roundRectangle("fill", thisX, thisY, 120, 36, 5)
    love.graphics.setColor(0,0,0,1)
    love.graphics.setFont(inventory.font)
    love.graphics.printf(title, thisX, thisY + 5, 120, "center")
    love.graphics.setColor(1,1,1,1)
end

function drawCraftingStencil()
    roundRectangle("fill", (uiX / 2) - (400 / 2), (uiY / 2) - (400 / 2), 400, 400, 10)
end

function checkCraftingMousePressed(button)
    thisX, thisY = (uiX / 2) - (400 / 2), (uiY / 2) - (400 / 2)
    if button == 1 and isMouseOver((thisX+100)* scale, (thisY + 270) * scale, (crafting.anvil:getWidth()*7)*scale, (crafting.anvil:getHeight()*7)*scale) then
        crafting.isCrafting = true
        crafting.whiteout = 0
        love.audio.stop(crafting.swing)
        crafting.swing:setPitch(love.math.random(30,80)/100)
        love.audio.play(crafting.swing)
    elseif button == 2 then
        if crafting.selectableI > 0 then
            table.remove(crafting.enteredItems, crafting.selectableI)
        end
    end
end

