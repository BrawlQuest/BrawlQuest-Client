--[[
    This file contains all of the functions that would be used by the player 
    as a means of controlling the character.
]]

player = {
    x = 15,
    dx = 15*32,
    dy = 15*32,
    y = 15,
    hp = 100,
    dhp = 100,
    mhp = 100,
    atk = 6,
    target = {
        x = 0,
        y = 0,
        active = false
    },
    xp = 0
}

function updateCharacter(dt)
   checkTargeting()
   movePlayer(dt)
    if player.dhp > player.hp then
        player.dhp = player.dhp - 32*dt
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
            stepSound:setPitch(love.math.random(90,200)/100)
            love.audio.play(stepSound)
        elseif love.keyboard.isDown("s") then
            player.y = player.y + 1
            calculateLighting(player.x-lightRange,player.y-lightRange,player.x+lightRange,player.y+lightRange)
            stepSound:setPitch(love.math.random(90,200)/100)
            love.audio.play(stepSound)
        end
        if love.keyboard.isDown("a") then
            player.x = player.x - 1
            calculateLighting(player.x-lightRange,player.y-lightRange,player.x+lightRange,player.y+lightRange)
            stepSound:setPitch(love.math.random(90,200)/100)
            love.audio.play(stepSound)
        elseif love.keyboard.isDown("d") then
            player.x = player.x + 1
            calculateLighting(player.x-lightRange,player.y-lightRange,player.x+lightRange,player.y+lightRange)
            stepSound:setPitch(love.math.random(90,200)/100)
            love.audio.play(stepSound)
        end
        if  blockMap[player.x..","..player.y] ~= nil then
            player.x = original[1]
            player.y = original[2]
        else
            blockMap[player.x..","..player.y] = true
        end
    else -- movement smoothing
        if difference(player.x*32, player.dx) > 1 then
            if player.dx > player.x*32 then
                player.dx = player.dx - 64*dt
            else
                player.dx = player.dx + 64*dt
            end
        else
            player.dx = player.x*32
        end

        if difference(player.y*32, player.dy) > 1 then
            if player.dy > player.y*32 then
                player.dy = player.dy - 64*dt
            else
                player.dy = player.dy + 64*dt
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
end