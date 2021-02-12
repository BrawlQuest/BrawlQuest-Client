function initCrafting()
    crafting = {
        w = 600,
        h = 400,
        open = false,
        mouseOverAnvil = false,
        anvil = love.graphics.newImage("assets/world/objects/Anvil.png"),
        hammer = love.graphics.newImage("assets/ui/hud/crafting/hammer.png"),
        hammerShake = 0,
        hammerDown = 1,
        hammerY = 0,
        isCrafting = false,
        craftable = false,
        sfx = love.audio.newSource("assets/sfx/player/actions/anvil.ogg", "static"),
        swing = love.audio.newSource("assets/sfx/player/actions/swing.wav", "static"),
        whiteout = 0,
        recipes = {},
        fields = {},
        selectedField = {i = 0, j = 0},
        craftableItems = {
          
        },
        enteredItems = {
         
        },
        catalogue = {

        },
        selectedItem = {},
        mouse = {love.graphics.newImage("assets/ui/hud/perks/BQ Mice - 1.png"), love.graphics.newImage("assets/ui/hud/perks/BQ Mice + 1.png")},
        selectableI = 0,
        percentFont = love.graphics.newFont("assets/ui/fonts/BMmini.TTF", 16),
        font = love.graphics.newFont("assets/ui/fonts/C&C Red Alert [INET].ttf", 13),
        posY = 0,
        velY = 0,
        itemCount = 0,
        recipesHeight = 0,
        fieldNames = {
            ["wep"] = "Weapons", 
            ["shield"] = "Sheilds", 
            ["arm_head"] = "Head Armour", 
            ["arm_legs"] = "Leg Armour", 
            ["arm_chest"] = "Chest Armour", 
            ["spell"] = "Spells",
        },
    }

    b = {}
    c, h = http.request{url = api.url.."/crafts", method="GET", source=ltn12.source.string(body), sink=ltn12.sink.table(b)}
    if b[1] ~= null then
        crafting.catalogue = json:decode(b[1])
        for i, v in ipairs(crafting.catalogue) do
            crafting.itemCount = crafting.itemCount + 1
            if crafting.recipes[v.Item.Type] then
                crafting.recipes[v.Item.Type][#crafting.recipes[v.Item.Type] + 1] = copy(v)
            else
                crafting.recipes[v.Item.Type] = {copy(v),}
                crafting.fields[#crafting.fields+1] = v.Item.Type
            end
        end
    else
        crafting.catalogue = {}
    end

    crafting.selectedItem = crafting.recipes[crafting.fields[1]][1]
    crafting.recipesHeight = (crafting.itemCount * -66) + ((crafting.font:getHeight() * 2) * -#crafting.fields) + crafting.h - 60 - 20

    -- print(json:encode_pretty(crafting.fields))
    -- success,msg = love.filesystem.write("recipes.txt", json:encode_pretty(crafting.recipes))
end

function updateCrafting(dt)
    if crafting.open then
        if crafting.isCrafting then
            if crafting.hammerDown < 0 then
                crafting.whiteout = crafting.whiteout + 20 * dt
                crafting.sfx:setPitch(love.math.random(50,100)/100)
                love.audio.play(crafting.sfx)
                if crafting.whiteout > 1 and crafting.selectedItem ~= null then
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
                    print(api.url.."/craft/"..player.name.."/"..crafting.selectedItem.ItemID)
                    c, h = http.request{url = api.url.."/craft/"..player.name.."/"..crafting.selectedItem.ItemID, method="POST", source=ltn12.source.string(body), headers={["token"]=token,["Content-Length"]=#body}, sink=ltn12.sink.table(b)}
                    if json:decode(b[1])["success"] == null then
                        crafting.result = json:decode(b[1])
                        crafting.result.alpha = 2
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

        if crafting.result and crafting.result.alpha > 0 then
            crafting.result.alpha = crafting.result.alpha - 0.5 * dt
            if crafting.result.alpha <= 0 then crafting.result.alpha = 0 end
            crafting.result.alphaCERP = cerp(0, 1, math.clamp(0, crafting.result.alpha, 1))
        end

        crafting.velY = crafting.velY - crafting.velY * math.min( dt * 15, 1 ) 
        crafting.posY = crafting.posY + crafting.velY * dt
        if crafting.posY > 0 then
            crafting.posY = 0 
        elseif crafting.posY < crafting.recipesHeight then
            crafting.posY = crafting.recipesHeight
        end
    end
end

function drawCrafting()
    local w, h = crafting.w, crafting.h
    thisX, thisY = (uiX / 2) - (w / 2), (uiY / 2) - (h / 2)
    love.graphics.setColor(0,0,0,0.8)
    roundRectangle("fill", thisX, thisY, w, h, 10)
    love.graphics.setColor(1,1,1,1)
    -- love.graphics.stencil(drawCraftingStencil, "replace", 1) -- stencils inventory
    -- love.graphics.setStencilTest("greater", 0) -- push
        drawCraftingBackground(thisX, thisY)
    -- love.graphics.setStencilTest() -- pop
end

function drawCraftingBackground(thisX, thisY)
    local c = crafting
    local w,h = crafting.w, crafting.h
    local x, y = 0, 0

    x, y = thisX + 330, thisY + 270
    if isMouseOver(x * scale, y * scale, (crafting.anvil:getWidth()*7) * scale, (crafting.anvil:getHeight() * 7) * scale) then
        crafting.mouseOverAnvil = true
        love.graphics.setColor(1,0.5,0.5)
    else
        crafting.mouseOverAnvil = false
    end

    love.graphics.draw(crafting.anvil, thisX + 330, thisY + 270, 0, 7)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(crafting.hammer, thisX + 720, thisY + 300 - crafting.hammerY, cerp(-0.01, 0.01, crafting.hammerShake) + cerp(-0.6,0.01, crafting.hammerDown), -10)

    love.graphics.print("CRAFTING", inventory.headerFont, thisX + 10 , thisY + 14)    
    love.graphics.print("RECIPES",crafting.font, thisX + 10, thisY + 10 + 40, 0, 2)
    x, y = thisX + 10, thisY + 10 + 40 + crafting.posY + 30
    w, h = 194 + 18, 56
    crafting.mouseOverField = {i = 0, j = 0}
    

    love.graphics.stencil(drawRecipesStencil, "replace", 1) -- stencils inventory
    love.graphics.setStencilTest("greater", 0) -- push

        for i,field in ipairs(crafting.fields) do
            love.graphics.setColor(1,1,1)
            love.graphics.print(string.upper(crafting.fieldNames[field] or field), inventory.font, x + 8, y + 4, 0, 1)
            y = y + (crafting.font:getHeight() * 2)
            for j, v in ipairs(crafting.recipes[field]) do
                if isMouseOver(x * scale,y * scale,w * scale,h * scale) then
                    crafting.mouseOverField = {i = i, j = j}
                    love.graphics.setColor(1,0,0,1)
                elseif json:encode(crafting.selectedField) == json:encode({i = i, j = j}) then
                    love.graphics.setColor(43 / 255, 134 / 255, 0)
                else
                    love.graphics.setColor(0,0,0,0.7)
                end

                roundRectangle("fill", x, y, w, h, 10)
                -- local v = crafting.recipes[field][1]
                local values = json:decode(v.ItemsString)
                for l = 1, 4 do
                    if l == 1 then
                        if v.Item ~= null then
                            love.graphics.setColor(1,1,1,1)
                            drawCraftingItem(x + 10, y + 10, 0, v.Item)
                        end
                        love.graphics.printf("=", x + 51, y + 8, 8, "center", 0, 3)
                        x = x + 10 + 8
                    else
                        l = l - 1
                        if v.ItemsItem[l] ~= null then
                            local amount = 0
                            for l,m in ipairs(values) do
                                if m.ItemID == v.ItemsItem[l].ID then
                                    amount = m.Amount
                                end
                            end
                            love.graphics.setColor(1,1,1,1)
                            drawCraftingItem(x + 10, y + 10, 0, v.ItemsItem[l], amount)
                        else
                            love.graphics.setColor(0,0,0,0.7)
                            drawItemBacking(x + 10, y + 10)
                        end
                    end
                    x = x + 46
                end
                x = thisX + 10
                y = y + 66
            end
        end
    love.graphics.setStencilTest() -- pop


    x, y = thisX + 10 + w + 10, thisY + 10 + 10

    love.graphics.setColor(1,1,1)
    love.graphics.setFont(crafting.font)
    love.graphics.print("ENTERED ITEMS", x + 5, y, 0 ,2 )

    y = thisY + 10 + 40
    if crafting.craftable then
        love.graphics.setColor(0.1,1,0.1,0.7)
    else
        love.graphics.setColor(1,0,0,0.7)
    end
    roundRectangle("fill", x, y, w - 18, h, 10)
    for i = 1, 4 do
        if crafting.enteredItems[i] and crafting.enteredItems[i].item then
            if crafting.craftable then
                love.graphics.setColor(1,1,1,1)
            else
                love.graphics.setColor(0,0,0,0.7)
            end
            drawCraftingItem(x + 10, y + 10, 0, crafting.enteredItems[i].item, crafting.enteredItems[i].amount)
        else
            love.graphics.setColor(0,0,0,0.7)
            drawItemBacking(x + 10, y + 10)
        end
        x = x + 46
    end

    if crafting.selectedField.i > 0 then
        x, y = thisX + 10 + w + 10, y + h + 8
        love.graphics.setColor(1,1,1)
        love.graphics.print("CREATES", x + 5, y + 10, 0 , 2)
        y = y + 40
        local v = crafting.recipes[crafting.fields[crafting.selectedField.i]][crafting.selectedField.j]
        love.graphics.setColor(0,0,0,0.7)
        roundRectangle("fill", x, y, w - 18, h, 10)
        love.graphics.setColor(1,1,1)
        drawCraftingItem(x + 10, y + 10, 0, v.Item, 1)
        love.graphics.print(v.Item.Name, x + 54, y + 22)
    end

    if crafting.result then    
        local size = 4 * crafting.result.alphaCERP
        x, y = uiX * 0.5 - (34 * size) / 2, uiY * 0.5 - (34 * size) / 2
        w, h = (34 * size), (34 * size)
        if isMouseOver(x * scale, y * scale, (34 * size) *  scale, (34 * size) * scale) then
            setItemTooltip(crafting.result)
        end
        love.graphics.setColor(1, cerp(165 / 255, 1, crafting.result.alpha), cerp(32 / 255, 1, crafting.result.alpha), 0.8 * crafting.result.alphaCERP)
        roundRectangle("fill", x,y,w,h, 5 )
        love.graphics.setColor(1,1,1, crafting.result.alphaCERP)
        love.graphics.draw(getImgIfNotExist(crafting.result.ImgPath), x + size * 2, y + size * 2, 0, size)
    end

    love.graphics.setColor(1,1,1,crafting.whiteout)
    roundRectangle("fill",thisX,thisY,crafting.w,crafting.h, 10)
end

function drawCraftingItem(thisX, thisY, field, item, amount)
    love.graphics.setFont(inventory.itemFont)

    if isMouseOver(thisX * scale, thisY * scale, 34 * scale, 34 * scale) and item then
        setItemTooltip(item)
        selectedItem = item
        inventory.isMouseOverInventoryItem = true
        love.graphics.setColor(1,0,0,1)
        thisY = thisY - 2
    end
    drawItemBacking(thisX, thisY)

    love.graphics.setColor(1,1,1,1)
    if item then
        itemImg[item.ImgPath] = getImgIfNotExist(item.ImgPath)
        if string.sub(item.Type, 1, 4) == "arm_" then
            love.graphics.setColor(1,1,1,0.5)
            love.graphics.draw(playerImg, thisX + 2, thisY + 2)
            love.graphics.setColor(1,1,1,1)
        end
        
        if inventory.usedItemThisTick then
            love.graphics.setColor(1,1,1,0.4)
        end

        if itemImg[item.ImgPath]:getWidth() <= 32 and itemImg[item.ImgPath]:getHeight() <= 32 then
            love.graphics.draw(itemImg[item.ImgPath],
                thisX + 18 - (itemImg[item.ImgPath]:getWidth() / 2),
                thisY + 18 - (itemImg[item.ImgPath]:getHeight() / 2))
        else
            love.graphics.draw(itemImg[item.ImgPath], thisX + 2, thisY + 2) -- Item
        end
    end

    if amount and amount > 1 then
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
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(amount, thisX + 5, thisY + 4)
    end
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(crafting.font)
end

function drawCraftingButton(thisX, thisY, title)
    roundRectangle("fill", thisX, thisY, 120, 36, 5)
    love.graphics.setColor(0,0,0,1)
    love.graphics.setFont(inventory.font)
    love.graphics.printf(title, thisX, thisY + 5, 120, "center")
    love.graphics.setColor(1,1,1,1)
end

function drawCraftingStencil()
    roundRectangle("fill", ((uiX / 2) - (crafting.w / 2)) * scale, ((uiY / 2) - (crafting.h / 2)) * scale, crafting.w * scale, crafting.h * scale, 10 * scale)
end

function drawRecipesStencil()
    roundRectangle("fill", (((uiX / 2) - (crafting.w / 2)) + 10), (((uiY / 2) - (crafting.h / 2)) + 10 + 40 + 30), (194 + 18), (crafting.h - 90), 10)
end

function checkCraftingMousePressed(button)
    local c = crafting
    thisX, thisY = (uiX / 2) - (400 / 2), (uiY / 2) - (400 / 2)
    if button == 1 and crafting.mouseOverAnvil == true and crafting.craftable then
        crafting.isCrafting = true
        crafting.whiteout = 0
        love.audio.stop(crafting.swing)
        crafting.swing:setPitch(love.math.random(30,80)/100)
        love.audio.play(crafting.swing)
    elseif button == 1 and crafting.mouseOverField.i > 0 then
        print("I need to enter items!")
        local craft = {}
        crafting.selectedField = copy(crafting.mouseOverField)

        local v = crafting.recipes[crafting.fields[crafting.selectedField.i]][crafting.selectedField.j]
            
        -- print(json:encode(crafting.selectedField))
        -- print("Selected ITEM: " .. json:encode_pretty(v))

        crafting.selectedItem = v
        local required = json:decode(v.ItemsString)
        crafting.enteredItems = {}
        
        for j = 1, #v.ItemsItem do
            local amount = required[j].Amount
            print(v.ItemsItem[j].Name .. " " .. amount)
            if getItemAmount(v.ItemsItem[j]) >= amount then
                crafting.enteredItems[j] = {
                    item = v.ItemsItem[j],
                    amount = amount,
                    random = {X = math.random()*100, Y = math.random()*100},
                }
                craft[#craft+1] = true
            elseif getItemAmount(v.ItemsItem[j]) < 1 then
                craft[#craft+1] = false
            else
                crafting.enteredItems[j] = {
                    item = v.ItemsItem[j],
                    amount = getItemAmount(v.ItemsItem[j]),
                    random = {X = math.random()*100, Y = math.random()*100},
                }
                craft[#craft+1] = false
            end
        end

        crafting.craftable = true
        for int, crafty in ipairs(craft) do
            if crafty == false then
                crafting.craftable = false
            end
        end
    end
end
