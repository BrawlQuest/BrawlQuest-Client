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

function drawItemIfExists(path, x, y, previousDirection, rotation, stencil, width)
    local offsetX = 0
    if not rotation then
        rotaiton = 1
        if previousDirection and previousDirection == "left" then
            rotation = -1
            offsetX = 32
        end
    end

    if not itemImg[path] then
        if love.filesystem.getInfo(path) then
            itemImg[path] = love.graphics.newImage(path)
        else
            itemImg[path] = love.graphics.newImage("assets/error.png")
        end
    end

    if stencil then
        love.graphics.draw(itemImg[path], stencil, x + offsetX, y, player.wobble, rotation, 1, 0, 0)
    else
        love.graphics.draw(itemImg[path], x + offsetX, y, player.wobble, rotation, 1, 0, 0)
    end
end

function updateCharacter(dt)
    checkTargeting()
    if me and player.dx and player.dy and player.buddy then
        local pl = {
            X = player.dx,
            Y = player.dy,
            Buddy = player.buddy,
            Name = player.name
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
    if worldEdit.open and (username == "Danjoe" or username == "Pebsie") then return output end
    if worldLookup[x] and worldLookup[x][y] then
        if worldLookup[x][y].Collision == true then
            output = true
        end
        if me.Mount and string.find(me.Mount, "boat") and isTileType(worldLookup[x][y].ForegroundTile, "Water") then
            output = false
        elseif string.find(me.Mount, "boat") and not worldLookup[x][y].Collision then
            output = true
        end
    end
     if enemyCollisions[x] and enemyCollisions[x][y] == true then
        output = true
    end
    return output
end

function movePlayer(dt)
    if player.x * 32 == player.dx and player.y * 32 == player.dy and not isTypingInChat and not worldEdit.isTyping then -- movement smoothing has finished
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
        end

        -- if (prev.x ~= player.x) or (prev.y ~= player.y) then
        --     if (worldLookup[prev.x] and worldLookup[prev.x][prev.y] and not worldLookup[prev.x][prev.y].Collision) then
        --         player.x = prev.x
        --         if worldLookup[player.x]then
        --             playFootstepSound(worldLookup[player.x][player.y])
        --         end
        --     end
        --     if (worldLookup[prev.x] and worldLookup[prev.x][prev.y] and not worldLookup[prev.x][prev.y].Collision) then
        --         player.y = prev.y

        --     end
        -- end

    else -- movement smoothing
        local speed = 64

        if me.Mount ~= "None" or worldEdit.open then
            speed = 110 -- Hello Mr Hackerman! If you go faster than this the server will think you're teleporting.
        end
        if string.find(me.Mount, "boat") then
            speed = 32
        end
        if difference(player.x * 32, player.dx) > 1 then
            if player.dx > player.x * 32 then
                player.dx = player.dx - speed * dt
            else
                player.dx = player.dx + speed * dt
            end
        else
            player.dx = player.x * 32
        end

        if difference(player.x * 32, player.cx) > 1 then
            if player.cx > player.x * 32 then
                player.cx = player.cx - speed * dt
            else
                player.cx = player.cx + speed * dt
            end
        else
            player.cx = player.x * 32
        end

        if difference(player.y * 32, player.dy) > 1 then
            if player.dy > player.y * 32 then
                player.dy = player.dy - speed * dt
            else
                player.dy = player.dy + speed * dt
            end
        else
            player.dy = player.y * 32
        end

        if difference(player.y * 32, player.cy) > 1 then
            if player.cy > player.y * 32 then
                player.cy = player.cy - speed * dt
            else
                player.cy = player.cy + speed * dt
            end
        else
            player.cy = player.y * 32
        end

        -- if distanceToPoint(player.x * 32, player.y * 32, player.cx, player.cy) > 4 * 32 then -- snap to final position
        --     player.cx = player.x * 32
        --     player.cy = player.y * 32
        -- end
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
                    print("You have " .. k.Inventory.Amount .. " of this item, and the server says you now have " ..
                              v.Inventory.Amount)
                    v.Inventory.Amount = v.Inventory.Amount - k.Inventory.Amount
                    print("That's a change of " .. v.Inventory.Amount .. " of it.")
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
        print(k.Item.Name)
        love.audio.play(enemyHitSfx)
        burstLoot((player.x*32)-16, (player.y*32)-16, k.Inventory.Amount, k.Item.ImgPath)
        newInventoryItems = {}
    end
    getInventory()
end
