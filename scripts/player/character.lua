--[[
    This file contains all of the functions that would be used by the player 
    as a means of controlling the character.
]]

player = {
    x = -15,
    dx = 15*32,
    dy = 15*32,
    y = -15,
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
    xp = 0,
    isMounted = false,
    name = "",
    isMounting = false,
    mount = {
        x = -100,
        y = -100,
        stepSndPlay = 0.3,
    },
}

newInventoryItems = {}
me = {}


function drawItemIfExists(path,x,y)
    local rotation = 1
    local offsetX = 0
    if player.previousDirection == "left" then
        rotation = -1
        offsetX = 32
    end
    if not itemImg[path] then
        if love.filesystem.getInfo(path) then
            itemImg[path] = love.graphics.newImage(path)
        else
            itemImg[path] = love.graphics.newImage("assets/error.png")
        end
    end
    love.graphics.draw(itemImg[path],x+offsetX,y, 0, rotation, 1, 0, 0)
end

function drawPlayer()
    if me and me.Weapon then
        if not itemImg[me.Weapon.ImgPath] then
            if love.filesystem.getInfo(me.Weapon.ImgPath) then
                itemImg[me.Weapon.ImgPath] = love.graphics.newImage(me.Weapon.ImgPath)
            else
                itemImg[me.Weapon.ImgPath] = love.graphics.newImage("assets/error.png")
            end
        end
      
            drawItemIfExists(me.Shield.ImgPath, player.dx,player.dy)
     
        local rotation = 1
        local offsetX = 0
        if player.previousDirection == "left" then
            rotation = -1
            offsetX = 32
            love.graphics.draw(itemImg[me.Weapon.ImgPath] , player.dx+(itemImg[me.Weapon.ImgPath]:getWidth()-32)+32, player.dy-(itemImg[me.Weapon.ImgPath]:getHeight()-32), 0, rotation, 1, 0, 0)
        else
            love.graphics.draw(itemImg[me.Weapon.ImgPath] , player.dx-(itemImg[me.Weapon.ImgPath]:getWidth()-32), player.dy-(itemImg[me.Weapon.ImgPath]:getHeight()-32), 0, rotation, 1, 0, 0)
        end

        if player.isMounted then
            love.graphics.draw(horseImg, player.dx+6, player.dy+9)
        end
        love.graphics.draw(playerImg, player.dx+offsetX, player.dy, 0, rotation, 1, 0, 0)


        if me.HeadArmourID ~= 0 then
            drawItemIfExists(me.HeadArmour.ImgPath,player.dx,player.dy)
        end
        if me.ChestArmourID ~= 0 then
            drawItemIfExists(me.ChestArmour.ImgPath,player.dx,player.dy)
        end
        if me.LegArmourID ~= 0 then
            drawItemIfExists(me.LegArmour.ImgPath,player.dx,player.dy)
        end

        
        if love.keyboard.isDown("lshift") then
            drawItemIfExists(me.Shield.ImgPath, player.dx,player.dy)
        end
       

        if player.isMounted then
            love.graphics.draw(horseForeImg, player.dx+6, player.dy+9)
        end
        if player.isMounting then
            love.graphics.draw(horseImg, player.mount.x, player.mount.y)
        end
        if player.target.active then
            diffX = player.target.x - player.x
            diffY = player.target.y - player.y
            if arrowImg[diffX] ~= nil and arrowImg[diffX][diffY] ~= nil then
                love.graphics.setColor(1,1,1,1-nextTick)
                love.graphics.draw(arrowImg[diffX][diffY], player.dx-32, player.dy-32)
            end
        end
        if player.target.active and (me.AX ~= me.X or me.AY ~= me.Y) then
            diffX = me.AX - me.X
            diffY = me.AY - me.Y
            if arrowImg[diffX] ~= nil and arrowImg[diffX][diffY] ~= nil then
                love.graphics.setColor(1,1,1,1)
            --    love.graphics.draw(arrowImg[diffX][diffY], (me.X*32)-32, (me.Y*32)-32)
            end
        end
    end
end

    function updateCharacter(dt)
    checkTargeting()
    if not isWorldEditWindowOpen then movePlayer(dt) end
        if player.dhp > player.hp then
            player.dhp = player.dhp - 32*dt
        elseif player.dhp < player.hp then
            player.dhp = player.dhp + 32*dt
        end

        if difference(player.dhp, player.hp) < 0.2 then
            player.dhp = player.hp
        end

        if player.isMounting then
            player.mount.stepSndPlay = player.mount.stepSndPlay - 1*dt
            if player.mount.stepSndPlay < 0 then
                stepSfx:stop()
                stepSfx:setPitch(love.math.random(50,200)/100)
                stepSfx:setVolume(0.4)
                stepSfx:play()
                player.mount.stepSndPlay = 0.2
            end

            if player.mount.x > player.dx+8 then
                player.mount.x = player.mount.x - 150*dt
            elseif player.mount.x < player.dx-8 then
                player.mount.x = player.mount.x + 150*dt
            end

            if player.mount.y > player.dy+8 then
                player.mount.y = player.mount.y - 150*dt
            elseif player.mount.y < player.dy-8 then
                player.mount.y = player.mount.y + 150*dt
            end

            if distanceToPoint(player.mount.x, player.mount.y, player.dx, player.dy) < 16 then
                love.audio.play(horseMountSfx[love.math.random(1,#horseMountSfx)])
                player.isMounted = true
                player.isMounting = false
            end
        end
end

function movePlayer(dt)
    local lightRange = 6

    if player.x*32 == player.dx and player.y*32 == player.dy then -- movement smoothing has finished
        local original = {
            player.x,
            player.y
        }
        if love.keyboard.isDown(keybinds.UP) then
            original[2] = original[2] - 1
        elseif love.keyboard.isDown(keybinds.DOWN) then
            original[2] = original[2] + 1
        end
        if love.keyboard.isDown(keybinds.LEFT) then
            original[1] = original[1]- 1
            player.previousDirection = "left"
        elseif love.keyboard.isDown(keybinds.RIGHT) then
            original[1] = original[1] + 1
            player.previousDirection = "right"
        end
        if (original[1] ~= player.x or original[2] ~= player.y) and not blockMap[original[1]..","..original[2]] then
            player.x = original[1]
            player.y = original[2]
            calculateLighting(player.x-lightRange,player.y-lightRange,player.x+lightRange,player.y+lightRange)
            stepSfx:stop()
            stepSfx:setPitch(love.math.random(90,200)/100)
            love.audio.play(stepSfx)
        end
        
    else -- movement smoothing
        local speed = 64
             
        if player.isMounted then
            speed = 128
        end
        if difference(player.x*32, player.dx) > 1 then
      
            if player.dx > player.x*32 then
                player.dx = player.dx - speed*dt
            else
                player.dx = player.dx + speed*dt
            end
        else
            player.dx = player.x*32
        end

        if difference(player.y*32, player.dy) > 1 then
            if player.dy > player.y*32 then
                player.dy = player.dy - speed*dt
            else
                player.dy = player.dy + speed*dt
            end
        else
            player.dy = player.y*32
        end


        if distanceToPoint(player.x*32,player.y*32,player.dx,player.dy) < 1 then -- snap to final position
            player.dx = player.x*32
            player.dy = player.y*32
        end
    end
end


function checkTargeting() -- Check which keys are down and place the player target accordingly
    player.target.x = player.x
    player.target.y = player.y
    local wasActive = player.target.active
    player.target.active = false

    if love.keyboard.isDown(keybinds.ATTACK_UP) then
        player.target.active = true
        player.target.y = player.y - 1
    elseif love.keyboard.isDown(keybinds.ATTACK_DOWN) then
        player.target.active = true
        player.target.y = player.y + 1
    end

    if love.keyboard.isDown(keybinds.ATTACK_LEFT) then
        player.target.active = true
        player.target.x = player.x - 1
    elseif love.keyboard.isDown(keybinds.ATTACK_RIGHT) then
        player.target.active = true
        player.target.x = player.x + 1
    end

    if not wasActive and player.target.active then
        -- newly active, trigger a send to make things feel a tad more responsive
        nextUpdate = 0
    end

    if player.target.active and player.isMounted then
        beginMounting()
    end
end

function beginMounting()
    if player.isMounted or player.isMounting then
        love.audio.play(horseMountSfx[love.math.random(1,#horseMountSfx)])
        player.isMounted = false
        player.isMounting = false
    else
        love.audio.play(whistleSfx[love.math.random(1,#whistleSfx)])
        player.isMounting = true
        if love.math.random(1,2) == 1 then
            player.mount.x = player.dx+love.graphics.getWidth()/2
        else
            player.mount.x = player.dx-love.graphics.getWidth()/2
        end
        if love.math.random(1,2) == 1 then
            player.mount.y = player.dy+love.graphics.getHeight()/2
        else
            player.mount.y = player.dy-love.graphics.getHeight()/2
        end
    end
end

function updateInventory(response)
    newInventoryItems = {}
    for i,v in ipairs(response['Inventory']) do
        local newItem = true
        v = copy(v)
        for o,k in ipairs(inventoryAlpha) do
            if k.Item.Name == v.Item.Name then--and v.Inventory.Amount == k.Inventory.Amount then
                print("You have "..k.Inventory.Amount.." of this item, and the server says you now have "..v.Inventory.Amount)
                    v.Inventory.Amount = v.Inventory.Amount - k.Inventory.Amount
                    print("That's a change of "..v.Inventory.Amount.." of it.")
                    if v.Inventory.Amount <= 0 then
                        newItem = false
                    end
            end
        end
        if newItem then
            table.insert(newInventoryItems, v)
        end
    end
end