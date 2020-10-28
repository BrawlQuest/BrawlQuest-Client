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
    atk = 1,
    target = {
        x = 0,
        y = 0,
        active = false
    },
    xp = 0,
    isMounted = false,
    isMounting = false,
    mount = {
        x = -100,
        y = -100,
        stepSndPlay = 0.3,
    }
}

me = {}


function drawPlayer()
    love.graphics.draw(swordImg, player.dx-(swordImg:getWidth()-32), player.dy-(swordImg:getHeight()-32))
    
    if player.isMounted then
        love.graphics.draw(horseImg, player.dx+6, player.dy+9)
    end
    love.graphics.draw(playerImg, player.dx, player.dy)
    for i, v in ipairs(armour) do
        love.graphics.draw(v, player.dx, player.dy)
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
            love.graphics.setColor(1,1,1,0.5)
            love.graphics.draw(arrowImg[diffX][diffY], player.dx-32, player.dy-32)
        end
    end
    if me.AX ~= me.X or me.AY ~= me.Y then
        diffX = me.AX - me.X
        diffY = me.AY - me.Y
        if arrowImg[diffX] ~= nil and arrowImg[diffX][diffY] ~= nil then
            love.graphics.setColor(1,1,1,1)
            love.graphics.draw(arrowImg[diffX][diffY], (me.X*32)-32, (me.Y*32)-32)
        end
    end
end

function updateCharacter(dt)
   checkTargeting()
   movePlayer(dt)
    if player.dhp > player.hp then
        player.dhp = player.dhp - 32*dt
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
        blockMap[player.x..","..player.y] = nil
        local original = {
            player.x,
            player.y
        }
        if love.keyboard.isDown("w") then
            player.y = player.y - 1
            calculateLighting(player.x-lightRange,player.y-lightRange,player.x+lightRange,player.y+lightRange)
            stepSfx:stop()
            stepSfx:setPitch(love.math.random(90,200)/100)
            love.audio.play(stepSfx)
        elseif love.keyboard.isDown("s") then
            player.y = player.y + 1
            calculateLighting(player.x-lightRange,player.y-lightRange,player.x+lightRange,player.y+lightRange)
            stepSfx:stop()
            stepSfx:setPitch(love.math.random(90,200)/100)
            love.audio.play(stepSfx)
        end
        if love.keyboard.isDown("a") then
            player.x = player.x - 1
            calculateLighting(player.x-lightRange,player.y-lightRange,player.x+lightRange,player.y+lightRange)
            stepSfx:stop()
            stepSfx:setPitch(love.math.random(90,200)/100)
            love.audio.play(stepSfx)
        elseif love.keyboard.isDown("d") then
            player.x = player.x + 1
            calculateLighting(player.x-lightRange,player.y-lightRange,player.x+lightRange,player.y+lightRange)
            stepSfx:stop()
            stepSfx:setPitch(love.math.random(90,200)/100)
            love.audio.play(stepSfx)
        end
        if  blockMap[player.x..","..player.y] ~= nil then
            player.x = original[1]
            player.y = original[2]
        else
            blockMap[player.x..","..player.y] = true
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
    player.target.active = false

    if love.keyboard.isDown("up") then
        player.target.active = true
        player.target.y = player.y - 1
    elseif love.keyboard.isDown("down") then
        player.target.active = true
        player.target.y = player.y + 1
    end

    if love.keyboard.isDown("left") then
        player.target.active = true
        player.target.x = player.x - 1
    elseif love.keyboard.isDown("right") then
        player.target.active = true
        player.target.x = player.x + 1
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
