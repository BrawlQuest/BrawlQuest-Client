function initTargeting()
    attackKeys = {keybinds.ATTACK_UP, keybinds.ATTACK_DOWN, keybinds.ATTACK_LEFT, keybinds.ATTACK_RIGHT}
    targetActive = {
        up = false,
        down = false,
        left = false,
        right = false
    }
end

local targetHeld = false

function checkTargetingPress(key)
    -- if key == keybinds.ATTACK_UP then
    --     player.target.active = true
    --     if player.target.y == player.y - 1 then
    --         player.target.y = player.y
    --         targetActive.up = false
    --     else
    --         player.target.y = player.y - 1
    --         player.target.x = player.x
    --         targetActive.left = false
    --         targetActive.right = false
    --         targetActive.up = true
    --         targetActive.down = false
    --     end
    -- elseif key == keybinds.ATTACK_DOWN then
    --     player.target.active = true
    --     if player.target.y == player.y + 1 then
    --         player.target.y = player.y
    --         targetActive.down = false
    --     else
    --         player.target.y = player.y + 1
    --         player.target.x = player.x
    --         targetActive.left = false
    --         targetActive.right = false
    --         targetActive.up = false
    --         targetActive.down = true
    --     end
    -- end
    -- if key == keybinds.ATTACK_LEFT then
    --     player.target.active = true
    --     if player.target.x == player.x - 1 then
    --         player.target.x = player.x
    --         targetActive.left = false
    --     else
    --         player.target.x = player.x - 1
    --         player.target.y = player.y
    --         targetActive.left = true
    --         targetActive.right = false
    --         targetActive.up = false
    --         targetActive.down = false
    --     end
    -- elseif key == keybinds.ATTACK_RIGHT then
    --     player.target.active = true
    --     if player.target.x == player.x + 1 then
    --         player.target.x = player.x
    --         targetActive.right = false
    --     else
    --         player.target.x = player.x + 1
    --         player.target.y = player.y
    --         targetActive.left = false
    --         targetActive.right = true
    --         targetActive.up = false
    --         targetActive.down = false
    --     end
    -- end
end

function checkTargetingRelease(key)
  
end

function checkTargeting() -- Check which keys are down and place the player target accordingly
    local wasActive = player.target.active
    player.target = {x = player.x, y = player.y, active = false}

    if isMouseDown() then
        checkMouseTargeting()
    else
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
    end

    if not wasActive and player.target.active then
        -- newly active, trigger a send to make things feel a tad more responsive
        nextUpdate = 0
    end

    if player.target.active and player.isMounted then
        beginMounting()
    end
end