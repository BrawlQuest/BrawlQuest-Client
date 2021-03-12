--[[
    This file contains all of the functions that would be used by the player 
    as a means of controlling the character.
]]
player = {
    x = -15,
    dx = 15 * 32,
    dy = 15 * 32,
    y = -15,
    cx = 0,
    cy = 0,
    hp = 100,
    dhp = 100,
    mhp = 100,
    mana = 100,
    damageHUDAlpha = 0,
    atk = 1,
    target = {
        x = 0,
        y = 0,
        active = false
    },
    lvl = 0,
    xp = 0,
    owedxp = 0,
    isMounted = false,
    name = "",
    isMounting = false,
    mount = {
        x = -100,
        y = -100,
        stepSndPlay = 0.3
    },
    color = {1,0.4,0.2,1},
    walk = 0,
    cp = 0,
    distance = 0,
    direction = {x = 0, y = 0},
    wobble = 0, 
    wobbleValue = 0,
    speed = {x = 0, y = 0},
}

newInventoryItems = {}
me = {}

function drawItemIfExists(path, x, y, previousDirection, direction, imageScale, stencil)
    imageScale = imageScale or 1
    local offsetX = 0
    if not direction then
        direction = 1
        if previousDirection and previousDirection == "left" then
            direction = -1
            offsetX = 32
        end
    end

    if not itemImg[path] then
        if love.filesystem.getInfo(path).size  then
            itemImg[path] = love.graphics.newImage(path)
        else
            itemImg[path] = love.graphics.newImage("assets/error.png")
        end
    end

    if stencil then
        love.graphics.draw(itemImg[path], stencil, x + offsetX, y, 0, direction * imageScale, imageScale)
    else
        love.graphics.draw(itemImg[path], x + offsetX, y, 0, direction * imageScale, imageScale)
    end
end

function updateCharacter(dt)
    if player.damageHUDAlphaUp then
        player.damageHUDAlpha = player.damageHUDAlpha + 3*dt
        if player.damageHUDAlpha > 1 then
            player.damageHUDAlpha = 1
            player.damageHUDAlphaUp = false
        end
    end
    if player.damageHUDAlpha > 0 then
        player.damageHUDAlpha = player.damageHUDAlpha - 0.35*dt
        if player.damageHUDAlpha < 0 then player.damageHUDAlpha = 0 end
    end
    
    checkTargeting()
    if me and player.dx and player.dy and player.buddy then
        local pl = {
            X = player.dx,
            Y = player.dy,
            Buddy = player.buddy,
            Name = me.Name
        }
        updateBuddy(dt, pl)
    end

    movePlayer(dt)

    if player.isMounting then
        player.mount.stepSndPlay = player.mount.stepSndPlay - 1 * dt
        if player.mount.stepSndPlay < 0 then
            player.mount.stepSndPlay = 0.2
        end

        if player.mount.x > player.dx + 8 then
            player.mount.x = player.mount.x - 150 * dt
        elseif player.mount.x < player.dx - 8 then
            player.mount.x = player.mount.x + 150 * dt
        end

        if player.mount.y > player.dy + 8 then
            player.mount.y = player.mount.y - 150 * dt
        elseif player.mount.y < player.dy - 8 then
            player.mount.y = player.mount.y + 150 * dt
        end

        if distanceToPoint(player.mount.x, player.mount.y, player.dx, player.dy) < 16 then
            love.audio.play(horseMountSfx[love.math.random(1, #horseMountSfx)])
            player.isMounted = true
            player.isMounting = false
        end
    end
end

function worldCollison(x, y)
    local output = false
    if worldEdit.open and versionType == "dev" then return output end
    if worldLookup[x] and worldLookup[x][y] then
        if worldLookup[x][y].Collision == true then
            output = true
        end
        if me.Mount and string.find(me.Mount.Name, "boat") and isTileType(worldLookup[x][y].ForegroundTile, "Water") then
            output = false
        elseif me.Mount and string.find(me.Mount.Name, "boat") and not worldLookup[x][y].Collision then
            output = true
        end
    end
     if enemyCollisions[x] and enemyCollisions[x][y] == true then
        output = true
    end
    return output
end

isMoving = false
movementStarted = 1 -- the max time it'll ever take to cross a tile. This should fix rubberbanding.

function movePlayer(dt)
    if (me and not me.IsDead) and (not isMoving or (distanceToPoint(player.x * 32, player.y * 32, player.dx, player.dy) < 1 and not isTypingInChat and not worldEdit.isTyping and not tutorialOpen)) then -- movement smoothing has finished
        local prev = {x = player.x, y = player.y}
        if love.keyboard.isDown(keybinds.UP) and love.keyboard.isDown(keybinds.LEFT) and not (worldCollison(prev.x - 1, prev.y - 1) or worldCollison(prev.x - 1, prev.y) or worldCollison(prev.x, prev.y - 1)) then
            prev.y = prev.y - 1
            prev.x = prev.x - 1
            player.previousDirection = "left"
        elseif love.keyboard.isDown(keybinds.UP) and love.keyboard.isDown(keybinds.RIGHT) and not (worldCollison(prev.x + 1, prev.y - 1) or worldCollison(prev.x + 1, prev.y) or worldCollison(prev.x, prev.y - 1)) then
            prev.y = prev.y - 1
            prev.x = prev.x + 1
            player.previousDirection = "right"
        elseif love.keyboard.isDown(keybinds.DOWN) and love.keyboard.isDown(keybinds.RIGHT) and not (worldCollison(prev.x + 1, prev.y + 1) or worldCollison(prev.x + 1, prev.y) or worldCollison(prev.x, prev.y + 1)) then
            prev.y = prev.y + 1
            prev.x = prev.x + 1
            player.previousDirection = "right"
        elseif love.keyboard.isDown(keybinds.DOWN) and love.keyboard.isDown(keybinds.LEFT) and not (worldCollison(prev.x - 1, prev.y + 1) or worldCollison(prev.x - 1, prev.y) or worldCollison(prev.x, prev.y + 1)) then
            prev.y = prev.y + 1
            prev.x = prev.x - 1
            player.previousDirection = "left"
        else
            if love.keyboard.isDown(keybinds.LEFT) and not worldCollison(prev.x - 1, prev.y) then
                prev.x = prev.x - 1
                player.previousDirection = "left"
            elseif love.keyboard.isDown(keybinds.RIGHT) and not worldCollison(prev.x + 1, prev.y) then
                prev.x = prev.x + 1
                player.previousDirection = "right"
            else
                player.speed.x = 0
            end

            if love.keyboard.isDown(keybinds.UP) and not worldCollison(prev.x, prev.y - 1) then
                prev.y = prev.y - 1
            elseif love.keyboard.isDown(keybinds.DOWN) and not worldCollison(prev.x, prev.y + 1) then
                prev.y = prev.y + 1
            else
                player.speed.y = 0
            end
        end

        if (prev.x ~= player.x or prev.y ~= player.y) or worldEdit.open then
            player.x = prev.x
            player.y = prev.y
            if worldLookup[player.x]then
                playFootstepSound(worldLookup[player.x][player.y])
            end
            isMoving = true
        end
    end
    
    if distanceToPoint(player.x * 32, player.y * 32, player.dx, player.dy) > 1 then
        local speed = 64
        if me and me.Mount and me.Mount.Name ~= "None" or worldEdit.open then
            speed = tonumber(me.Mount.Val) or 64 -- Hello Mr Hackerman! If you go faster than this the server will think you're teleporting.
            local enchant = me.Mount.Enchantment or false
            if enchant and enchant ~= "None" and enchant ~= "" then
                speed = speed + 25
            end
            if worldEdit.open and versionType == "dev" then
                speed = 256
            end
        end
        if worldLookup[player.x] and worldLookup[player.x][player.y] and (isTileType(worldLookup[player.x][player.y].ForegroundTile, "Path") or isTileType(worldLookup[player.x][player.y].GroundTile, "Path")) then
            speed = speed * 1.4
        end

        if not death.open then
            local x,y = player.x * 32, player.y * 32
            if player.dx > x then
                player.dx = player.dx - speed * dt
                if player.dx <= x then player.dx = x end
            elseif player.dx < x then
                player.dx = player.dx + speed * dt
                if player.dx >= x then player.dx = x end
            end

            if player.cx > x then
                player.cx = player.cx - speed * dt
                if player.cx <= x then player.cx = x end
            elseif player.cx < x then
                player.cx = player.cx + speed * dt
                if player.cx >= x then player.dx = x end
            end

            if player.dy > y then
                player.dy = player.dy - speed * dt
                if player.dy <= y then player.dy = y end
            elseif player.dy < y then
                player.dy = player.dy + speed * dt
                if player.dy >= y then player.dy = y end
            end

            if player.cy > y then
                player.cy = player.cy - speed * dt
                if player.cy <= y then player.cy = y end
            elseif player.cy < y then
                player.cy = player.cy + speed * dt
                if player.cy >= y then player.dy = y end
            end
        end
        if distanceToPoint(player.x * 32, player.y * 32, player.dx, player.dy) < 1  then
            isMoving = false
        end
    end
end

function beginMounting()
    if player.isMounted or player.isMounting then
     --   love.audio.play(horseMountSfx[love.math.random(1, #horseMountSfx)])
        player.isMounted = false
        player.isMounting = false
    else
       -- love.audio.play(whistleSfx[love.math.random(1, #whistleSfx)])
        player.isMounting = true
        if love.math.random(1, 2) == 1 then
            player.mount.x = player.dx + love.graphics.getWidth() / 2
        else
            player.mount.x = player.dx - love.graphics.getWidth() / 2
        end
        if love.math.random(1, 2) == 1 then
            player.mount.y = player.dy + love.graphics.getHeight() / 2
        else
            player.mount.y = player.dy - love.graphics.getHeight() / 2
        end
    end
end

function updateInventory(response)
    newInventoryItems = {}
    if json:encode(inventoryAlpha) ~= "[]" then
        for i, v in ipairs(response['Inventory']) do
            local newItem = true
            v = copy(v)
            for o, k in ipairs(inventoryAlpha) do
                if k.Item.Name == v.Item.Name then -- and v.Inventory.Amount == k.Inventory.Amount then
                    -- print("You have " .. k.Inventory.Amount .. " of this item, and the server says you now have " ..
                    --           v.Inventory.Amount)
                    v.Inventory.Amount = v.Inventory.Amount - k.Inventory.Amount
                    -- print("That's a change of " .. v.Inventory.Amount .. " of it.")
                    if v.Inventory.Amount <= 0 then
                        newItem = false
                    end
                end
            end
            if newItem then
                table.insert(newInventoryItems, v)
                openTutorial(6)
            end
        end
    end

    for i,k in ipairs(newInventoryItems) do
        -- print(k.Item.Name)
        love.audio.play(enemyHitSfx)
        burstLoot((player.x*32)-16, (player.y*32)-16, k.Inventory.Amount, k.Item.ImgPath)
        newInventoryItems = {}
    end
    getInventory()
end
