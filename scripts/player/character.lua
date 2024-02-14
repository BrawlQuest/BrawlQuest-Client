--[[
    This file contains all of the functions that would be used by the player 
    as a means of controlling the character.
]]
player = {
    world = 0,  -- 0 default
    x = -15,
    y = -15,    
    dx = 15 * 32,
    dy = 15 * 32,
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
    cp = 0,
    speed = {x = 0, y = 0},
    frameAmount = 0,
    frame = 1,
    attacking = true,
    wx = 0,
    wy = 0,
    worldPosition = "0,0",
    prevWorldPosition = "0,0",
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
        if love.filesystem.getInfo(path).size then itemImg[path] = love.graphics.newImage(path)
        else itemImg[path] = love.graphics.newImage("assets/error.png") end
    end

    if itemImg[path]:getWidth() > 32 then
        x = x - (itemImg[path]:getWidth()-32)
    end
    if itemImg[path]:getHeight() > 32 then
        y = y - (itemImg[path]:getHeight()-32)
    end

    if stencil then
        love.graphics.draw(itemImg[path], stencil, x + offsetX, y, 0, direction * imageScale, imageScale)
    else
        love.graphics.draw(itemImg[path], x + offsetX, y, 0, direction * imageScale, imageScale)
    end
end

local sparklesAmount = 0

function updateCharacter(dt)
    -- When you take damage, the screen turns red around you
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

    -- Add sparkles to the player!
    if me.mount and me.mount.name ~= "None" and me.mount.name ~= "" and me.mount.enchantment ~= "None" then
        sparklesAmount = sparklesAmount + 5 * dt
        if isMoving and sparklesAmount > 1 then
            sparklesAmount = 0
            addSparkles(player.dx + 16, player.dy + 16, 5, 30, 20)
        end
    end

    -- Updates targeting and buddies
    checkTargeting()
    if me and player.dx and player.dy and player.buddy then
        local pl = {
            X = player.dx,
            Y = player.dy,
            Buddy = player.buddy,
            name = me.name
        }
        updateBuddy(dt, pl)
    end

    movePlayer(dt)
end

function worldCollision(x, y)
    local output = false
    if worldEdit.open and versionType == "dev" then return output end
    if worldLookup[x..","..y] then
        if worldLookup[x..","..y].Collision == true then
            output = true
        end
        if me.mount and string.find(me.mount.name, "boat") and isTileType(worldLookup[x..","..y].foregroundtile, "Water") then
            output = false
        elseif me.mount and string.find(me.mount.name, "boat") and not worldLookup[x..","..y].Collision then
            output = true
        end
    end
    if enemyCollisions[x..","..y] and me and me.invulnerability < 0 then output = true end
    return output
end

isMoving = false

function setDirection(direction)
    if not player.attacking then player.previousDirection = direction end
end

function movePlayer(dt) -- a nice update function
    -- move player!
    if andCalc(true, {
            (me and not me.isDead),
            (not isMoving or (distanceToPoint(player.x * 32, player.y * 32, player.dx, player.dy) < 1)),
            not worldEdit.isTyping,
            not isTypingInChat,
            not tutorialOpen,
            not death.open,
            not forging.forging,
            news.alpha ~= 1,
            -- not player.attacking,
        }) then -- movement smoothing has finished
        local prev = {x = player.x, y = player.y}
        if love.keyboard.isDown(keybinds.UP) and love.keyboard.isDown(keybinds.LEFT) and not (worldCollision(prev.x - 1, prev.y - 1) or worldCollision(prev.x - 1, prev.y) or worldCollision(prev.x, prev.y - 1)) then
            prev.y = prev.y - 1
            prev.x = prev.x - 1
            setDirection("left")
        elseif love.keyboard.isDown(keybinds.UP) and love.keyboard.isDown(keybinds.RIGHT) and not (worldCollision(prev.x + 1, prev.y - 1) or worldCollision(prev.x + 1, prev.y) or worldCollision(prev.x, prev.y - 1)) then
            prev.y = prev.y - 1
            prev.x = prev.x + 1
            setDirection("right")
        elseif love.keyboard.isDown(keybinds.DOWN) and love.keyboard.isDown(keybinds.RIGHT) and not (worldCollision(prev.x + 1, prev.y + 1) or worldCollision(prev.x + 1, prev.y) or worldCollision(prev.x, prev.y + 1)) then
            prev.y = prev.y + 1
            prev.x = prev.x + 1
            setDirection("right")
        elseif love.keyboard.isDown(keybinds.DOWN) and love.keyboard.isDown(keybinds.LEFT) and not (worldCollision(prev.x - 1, prev.y + 1) or worldCollision(prev.x - 1, prev.y) or worldCollision(prev.x, prev.y + 1)) then
            prev.y = prev.y + 1
            prev.x = prev.x - 1
            setDirection("left")
        else
            if love.keyboard.isDown(keybinds.LEFT) and not worldCollision(prev.x - 1, prev.y) then
                prev.x = prev.x - 1
                setDirection("left")
            elseif love.keyboard.isDown(keybinds.RIGHT) and not worldCollision(prev.x + 1, prev.y) then
                prev.x = prev.x + 1
                setDirection("right")
            else
                player.speed.x = 0
            end

            if love.keyboard.isDown(keybinds.UP) and not worldCollision(prev.x, prev.y - 1) then
                prev.y = prev.y - 1
            elseif love.keyboard.isDown(keybinds.DOWN) and not worldCollision(prev.x, prev.y + 1) then
                prev.y = prev.y + 1
            else
                player.speed.y = 0
            end
        end

        if (prev.x ~= player.x or prev.y ~= player.y) then--or worldEdit.open then
            player.x = prev.x
            player.y = prev.y
            if me and me.mount and worldLookup[player.x..","..player.y] then
                playFootstepSound(worldLookup[player.x..","..player.y], player.x, player.y, true)
            end
            isMoving = true
        end
    end
    
    local distance = distanceToPoint(player.x * 32, player.y * 32, player.dx, player.dy)
    if drawAnimations then animateCharacter(dt, distance > 1) end

    -- Move player! If not dead of course!
    if distance > 1 then
        local speed = 80
        if me and me.mount and me.mount.name ~= "None" or worldEdit.open then
            speed = tonumber(me.mount.val) or 80 -- Hello Mr Hackerman! If you go faster than this the server will think you're teleporting.
            local enchant = me.mount.enchantment or false
            if enchant and enchant ~= "None" and enchant ~= "" then speed = speed + 25 end
            if worldEdit.open and versionType == "dev" then speed = 256 end
        end
        -- if worldLookup[player.x..","..player.y] and worldLookup[player.x..","..player.y].foregroundtile and worldLookup[player.x..","..player.y].groundtile and (isTileType(worldLookup[player.x..","..player.y].foregroundtile, "Path") or isTileType(worldLookup[player.x..","..player.y].groundtile, "Path")) then
        --     speed = speed * 1.4
        -- end
        if me.activespell and me.activespell.name == "Whirlwind" then
            addSparkles(player.dx + 16, player.dy + 16, 5, 30, 20)
            speed = 240
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
    else
        isMoving = false
    end
end

function updateInventory(response)
    newInventoryItems = {}
    if lunajson.encode(inventoryAlpha) ~= "[]" then
        for i, v in ipairs(response['Inventory']) do
            local newItem = true
            v = copy(v)
            for o, k in ipairs(inventoryAlpha) do
                if k.item.name == v.item.name then -- and v.inventory.amount == k.inventory.amount then
                    -- print("You have " .. k.inventory.amount .. " of this item, and the server says you now have " ..
                    --           v.inventory.amount)
                    v.inventory.amount = v.inventory.amount - k.inventory.amount
                    -- print("That's a change of " .. v.inventory.amount .. " of it.")
                    if v.inventory.amount <= 0 then
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
        -- print(k.item.name)
        if (k.item ~= nil) then
            enemyHitSfx:setPosition(player.x, player.y)
            enemyHitSfx:setRolloff(sfxRolloff)
            enemyHitSfx:setRelative(false)
            setEnvironmentEffects(enemyHitSfx)
            enemyHitSfx:play()
            burstLoot((player.x*32)-16, (player.y*32)-16, k.inventory.amount, k.item.imgpath)
        end
        newInventoryItems = {}
    end

  

    getInventory()
end

function holdingStaff()
    if me and me.weapon and string.find(me.weapon.name, "Staff") then return true
    else return false end
end