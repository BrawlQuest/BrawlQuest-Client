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
        swing = love.audio.newSource("assets/sfx/player/actions/swing.ogg", "static"),
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
        fieldnames = {
            ["wep"] = "Weapons",
            ["Shields"] = "Shields",
            ["arm_head"] = "Head Armour",
            ["arm_legs"] = "Leg Armour",
            ["arm_chest"] = "Chest Armour",
            ["spell"] = "Spells",
        },
        openField = {},
        overOpenField = 0,
        changed = false,
        changeCount = 0,
    }

    b = {}
    print(api.url .. "/crafts")
    c, h = http.request{url = api.url.."/crafts", method="GET", source=ltn12.source.string(body), sink=ltn12.sink.table(b)}

   -- if b ~= nil and b[1] ~= nil then
   print(json:encode(b))
   print(#b)

   crafting.catalogue = lunajson.decode(table.concat(b))
        for i, v in ipairs(crafting.catalogue) do
            crafting.itemCount = crafting.itemCount + 1
            if crafting.recipes[v.item.type] then
                crafting.recipes[v.item.type][#crafting.recipes[v.item.type] + 1] = copy(v)
            else
                crafting.recipes[v.item.type] = {copy(v),}
                crafting.fields[#crafting.fields+1] = v.item.type
            end
        end
    -- else
    --     love.window.showMessageBox("Error loading crafting catalogue", "Post this on Discord please!\n"..lunajson.encode(b).."\n")
    --     crafting.catalogue = {}
    -- end

  --  local success,msg = love.filesystem.write("recipes.txt", lunajson.encode(crafting.recipes))

    for i, v in ipairs(crafting.fields) do
        crafting.openField[i] = false
    end

    getRecipesHeight()
end


function updateCrafting(dt)
    if crafting.open then
        if crafting.isCrafting then
            if crafting.hammerDown < 0 then
                crafting.whiteout = crafting.whiteout + 20 * dt
                if sfxVolume > 0 then
                    crafting.sfx:setPitch(love.math.random(50,100)/100)
                    crafting.sfx:setRelative(true)
                    setEnvironmentEffects(crafting.sfx)
                    crafting.sfx:play()
                end
                if crafting.whiteout > 1 and crafting.selectedItem ~= null then
                    crafting.hammerDown = 1
                    crafting.isCrafting = false
                    crafting.whiteout = 1.25
                    local itemsSoFar = {}
                    for i,v in ipairs(crafting.enteredItems) do
                        itemsSoFar[#itemsSoFar+1] = {
                            ItemID = v.item.id,
                            Amount = v.amount
                        }
                    end
                    local b = {}
                    body = lunajson.encode(itemsSoFar)
                    -- print(api.url.."/craft/"..player.name.."/"..crafting.selectedItem.itemID)
                    c, h = http.request{url = api.url.."/craft/"..player.name.."/"..crafting.selectedItem.itemid, method="GET", source=ltn12.source.string(body), headers={["token"]=token,["Content-Length"]=#body}, sink=ltn12.sink.table(b)}
                    response = table.concat(b)

                    if h == 200 then
                        print(response)
                        crafting.result = json:decode(tostring(response))
                        crafting.result.alpha = 2
                        if love.system.getOS() ~= "Linux" and useSteam then 
                            steam.userStats.setAchievement('craft_achievement')
                            if crafting.result.type == "spell" then
                                steam.userStats.setAchievement('craft_spell_achievement')
                            end
                            steam.userStats.storeStats()
                        end
                    else
                        crafting.result = nil
                    end
                    enterCraftingItems(crafting.selectedItem)
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

    love.graphics.print("CRAFTING", inventory.headerFont, thisX + 16 , thisY + 14)
    love.graphics.print("RECIPES",crafting.font, thisX + 20, thisY + 10 + 40, 0, 2)
    x, y = thisX + 10, thisY + 10 + 40 + crafting.posY + 30
    w, h = 194 + 18, 56
    crafting.mouseOverField = {i = 0, j = 0}
    

    love.graphics.stencil(drawRecipesStencil, "replace", 1) -- stencils inventory
    love.graphics.setStencilTest("greater", 0) -- push

        crafting.overOpenField = 0

        for i,field in ipairs(crafting.fields) do
            local isMouse = isMouseOver(x * scale,y * scale,w * scale,36 * scale)
            if isMouse then
                love.graphics.setColor(1,0,0)
                crafting.overOpenField = i
            elseif crafting.openField[i] == true then
                love.graphics.setColor(1,1,1)
            else
                love.graphics.setColor(0,0,0,0.7)
            end

            love.graphics.rectangle("fill", x, y, w, 36, 10)
            if crafting.openField[i] == true and not isMouse then
                love.graphics.setColor(0,0,0)
            else
                love.graphics.setColor(1,1,1)
            end

            love.graphics.print(string.upper(crafting.fieldnames[field] or field), inventory.font, x + 10, y + 11, 0, 1)
            local ground
            local point
            if crafting.openField[i] then
                ground = 18 - 4
                point = 10
            else
                ground = 18 + 4
                point = -10
            end
            love.graphics.polygon("fill", x + w - 30, y + ground, x + w - 20, y + ground, x + w - 25, y + ground + point)

            y = y + 46
            if crafting.openField[i] then
                for j, v in ipairs(crafting.recipes[field]) do
                    if isMouseOver(x * scale,y * scale,w * scale,h * scale) then
                        crafting.mouseOverField = {i = i, j = j}
                        love.graphics.setColor(1,0,0,1)
                    elseif lunajson.encode(crafting.selectedField) == lunajson.encode({i = i, j = j}) then
                        love.graphics.setColor(43 / 255, 134 / 255, 0)
                    else
                        love.graphics.setColor(0,0,0,0.7)
                    end

                    love.graphics.rectangle("fill", x, y, w, h, 10)
                    local values = lunajson.decode(v.itemsString)
                    for l = 1, 4 do
                        if l == 1 then
                            if v.item ~= null then
                                love.graphics.setColor(1,1,1,1)
                                drawCraftingItem(x + 10, y + 10, v.item)
                            end
                            love.graphics.printf("=", x + 51, y + 8, 8, "center", 0, 3)
                            x = x + 10 + 8
                        else
                            l = l - 1
                            if v.itemsItem[l] ~= null then
                                local amount = 0
                                for n,m in ipairs(values) do
                                    if m.itemID == v.itemsItem[l].id then
                                        amount = m.amount
                                        break
                                    end
                                end
                                love.graphics.setColor(1,1,1,1)
                                drawCraftingItem(x + 10, y + 10, v.itemsItem[l], amount)
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
        end
    love.graphics.setStencilTest() -- pop

    x, y = thisX + 10 + w + 10, thisY + 10 + 10
    love.graphics.setColor(1,1,1)
    -- love.graphics.print("LVL:", inventory.headerFont, x, y)    
    -- y = y + 52

    love.graphics.setColor(1,1,1)
    love.graphics.setFont(crafting.font)
    love.graphics.print("ENTERED ITEMS", x + 5, y, 0 ,2 )

    y = thisY + 10 + 40 --+ 52
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
            drawCraftingItem(x + 10, y + 10, crafting.enteredItems[i].item, crafting.enteredItems[i].amount)
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
        drawCraftingItem(x + 10, y + 10, v.item, 1)
        love.graphics.print(v.item.name, x + 54, y + 22)
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
        love.graphics.draw(getImgIfNotExist(crafting.result.imgpath), x + size * 2, y + size * 2, 0, size)
    end

    love.graphics.setColor(1,1,1,crafting.whiteout)
    roundRectangle("fill",thisX,thisY,crafting.w,crafting.h, 10)
end

function drawCraftingItem(thisX, thisY, item, amount)
    love.graphics.setFont(inventory.itemFont)

    local isMouse = isMouseOver(thisX * scale, thisY * scale, 34 * scale, 34 * scale)

    if isItemUnusable(item) then
        if isMouse and item then
            selectedItem = item
            setItemTooltip(item)
        end
        love.graphics.setColor(0.2, 0.2, 0.2)
    elseif isMouse and item then
        setItemTooltip(item)
        selectedItem = item
        inventory.isMouseOverInventoryItem = true
        love.graphics.setColor(1,0,0,1)
        thisY = thisY - 2
    end
    drawItemBacking(thisX, thisY)

    love.graphics.setColor(1,1,1,1)
    if item then
        itemImg[item.imgpath] = getImgIfNotExist(item.imgpath)
        if string.sub(item.type, 1, 4) == "arm_" then
            love.graphics.setColor(1,1,1,0.5)
            love.graphics.draw(playerImg, thisX + 2, thisY + 2)
            love.graphics.setColor(1,1,1,1)
        end
        
        if inventory.usedItemThisTick then
            love.graphics.setColor(1,1,1,0.4)
        end

        if itemImg[item.imgpath]:getWidth() <= 32 and itemImg[item.imgpath]:getHeight() <= 32 then
            love.graphics.draw(itemImg[item.imgpath],
                thisX + 18 - (itemImg[item.imgpath]:getWidth() / 2),
                thisY + 18 - (itemImg[item.imgpath]:getHeight() / 2))
        else
            love.graphics.draw(itemImg[item.imgpath], thisX + 2, thisY + 2) -- Item
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
    if button == 1 and crafting.mouseOverAnvil == true and crafting.craftable and not crafting.changed then
        crafting.isCrafting = true
        crafting.whiteout = 0
        if sfxVolume > 0 then
            crafting.swing:stop()
            crafting.swing:setPitch(love.math.random(30,80)/100)
            crafting.swing:setRelative(true)
            setEnvironmentEffects(crafting.swing)
            crafting.swing:play()
        end
        checkHotbarChange()
    elseif button == 1 and crafting.overOpenField > 0 then
        crafting.openField[crafting.overOpenField] = not crafting.openField[crafting.overOpenField]
        if crafting.openField[crafting.overOpenField] == true then
            crafting.selectedField.i = crafting.overOpenField
            crafting.selectedField.j = 1
            v = crafting.recipes[crafting.fields[crafting.selectedField.i]][crafting.selectedField.j]
            crafting.selectedItem = v
            enterCraftingItems(v)
        end
        getRecipesHeight()
        writeSettings()
    elseif button == 1 and crafting.mouseOverField.i > 0 then
        -- print("I need to enter items!")
        crafting.selectedField = copy(crafting.mouseOverField)
        local v = crafting.recipes[crafting.fields[crafting.selectedField.i]][crafting.selectedField.j]
        crafting.selectedItem = v
        enterCraftingItems(v)
    end
end

local keyCount = 0

function checkCraftingKeyPressed(key)
    local v = null
    if crafting.fields[crafting.selectedField.i] and crafting.recipes[crafting.fields[crafting.selectedField.i]] then
        v = crafting.recipes[crafting.fields[crafting.selectedField.i]][crafting.selectedField.j]
    end

    if keyCount == 0 and (key == "up" or key == "down") then
        keyCount = 1
        if crafting.selectedField.i == 0 then
            crafting.selectedField = {i = 1, j = 1}
                if crafting.recipes[crafting.fields[crafting.selectedField.i]] then
                v = crafting.recipes[crafting.fields[crafting.selectedField.i]][crafting.selectedField.j]
                crafting.selectedItem = v
                enterCraftingItems(v)
                end
        end
        for i, v in ipairs(crafting.fields) do
            crafting.openField[i] = true
        end
        getRecipesHeight()
    elseif key == "up" and v then
        crafting.selectedField.j = crafting.selectedField.j - 1
        if crafting.selectedField.j < 1 then
            crafting.selectedField.i = crafting.selectedField.i - 1
            if crafting.selectedField.i < 1 then
                crafting.selectedField.i = #crafting.fields
                crafting.posY = 0
            end
            crafting.selectedField.j = #crafting.recipes[crafting.fields[crafting.selectedField.i]]
            crafting.posY = crafting.posY + 46
            if crafting.selectedField.i == #crafting.fields then
                crafting.posY = crafting.recipesHeight - 66
            end
            crafting.openField[crafting.selectedField.i] = true
            getRecipesHeight()
        end
        v = crafting.recipes[crafting.fields[crafting.selectedField.i]][crafting.selectedField.j]
        crafting.selectedItem = v
        enterCraftingItems(v)
        crafting.posY = crafting.posY + 66
    elseif key == "down" and v then
        crafting.selectedField.j = crafting.selectedField.j + 1
        if crafting.selectedField.j > #crafting.recipes[crafting.fields[crafting.selectedField.i]] then
            crafting.selectedField.i = crafting.selectedField.i + 1
            if crafting.selectedField.i > #crafting.fields then
                crafting.selectedField.i = 1
                
            end
            crafting.selectedField.j = 1
            crafting.posY = crafting.posY - 46
            if crafting.selectedField.i == 1 then
                crafting.posY = 66
            end
            crafting.openField[crafting.selectedField.i] = true
            getRecipesHeight()
        end
        v = crafting.recipes[crafting.fields[crafting.selectedField.i]][crafting.selectedField.j]
        crafting.selectedItem = v
        enterCraftingItems(v)
        crafting.posY = crafting.posY - 66
    elseif key == "return" and crafting.craftable and not crafting.changed then
        crafting.isCrafting = true
        crafting.whiteout = 0
        if sfxVolume > 0 then
            crafting.swing:stop()
            crafting.swing:setPitch(love.math.random(30,80)/100)
            crafting.swing:setRelative(true)
            setEnvironmentEffects(crafting.swing)
            crafting.swing:play()
        end
        crafting.changed = true
        enterCraftingItems(crafting.recipes[crafting.fields[crafting.selectedField.i]][crafting.selectedField.j])
        checkHotbarChange()
    elseif key == keybinds.INTERACT or checkMoveOrAttack(key, "move") then
        crafting.open = false
        if love.system.getOS() ~= "Linux" and useSteam then 
            steam.friends.setRichPresence("steam_display", "#StatusAdventuring")
            steam.friends.setRichPresence("location", zoneTitle.title)
        end
        crafting.enteredItems = {}
        crafting.craftableItems = {}
        crafting.craftable = false
        crafting.selectedField = {i = 0, j = 0}
    end
end

function enterCraftingItems(v)
    local craft = {}
    crafting.enteredItems = {}
    local required = v.items
    for j = 1, #v.itemsItem do
        local amount = required[j].amount
        -- print(v.itemsItem[j].name .. " " .. amount)
        local invAmount = getItemAmount(v.itemsItem[j])

        if invAmount >= amount then
            crafting.enteredItems[j] = {
                item = v.itemsItem[j],
                amount = amount,
                random = {X = math.random()*100, Y = math.random()*100},
            }
            craft[#craft+1] = true
        elseif invAmount < 1 then
            craft[#craft+1] = false
        else
            crafting.enteredItems[j] = {
                item = v.itemsItem[j],
                amount = invAmount,
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

function getRecipesHeight()
    local height = 0
    for i,v in ipairs(crafting.openField) do
        if v then
            height = height + #crafting.recipes[crafting.fields[i]]
        end
    end
    crafting.recipesHeight = (height * -66) + (46 * -#crafting.fields) + crafting.h - 60 - 20
end