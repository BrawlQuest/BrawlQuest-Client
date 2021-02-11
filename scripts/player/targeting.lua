function initTargeting()
    attackKeys = {keybinds.ATTACK_UP, keybinds.ATTACK_DOWN, keybinds.ATTACK_LEFT, keybinds.ATTACK_RIGHT}
    targetHeld = false
    keys = {keybinds.ATTACK_UP, keybinds.ATTACK_DOWN, keybinds.ATTACK_LEFT, keybinds.ATTACK_RIGHT}
    heldKeys = {false, false, false, false,}
    targetKeys = {false, false, false, false,}
    holdAttack = true
end

function checkTargetingPress(key)
    if key == "h" then
        if holdAttack then
      --      holdAttack = false
            heldKeys = {false, false, false, false,}
            targetKeys = {false, false, false, false,}
            targetHeld = false
        else
            holdAttack = true
        end
    end

    if targetHeld then
        for i,v in ipairs(keys) do
            if key == v then 
                if heldKeys[i] == false then -- if the key pressed isn't the original
                    heldKeys = {false, false, false, false,}
                    targetKeys = {false, false, false, false,}
                    targetHeld = false
                    break
                end
            end
        end
    end

    for i,v in ipairs(keys) do
        if key == v then -- if the key pressed == a direction, set the targetKeys direction to true
            targetKeys[i] = true
            break
        end
    end
end

function checkTargetingRelease(key)
    if (love.keyboard.isDown("lshift") or love.keyboard.isDown("h")) or holdAttack then
        targetHeld = true
        for i,v in ipairs(keys) do
            if key == v then -- if shift is down, don't send a key-up notice, but store this held key to memory
                heldKeys[i] = false
                break
            end
        end
    else
        for i,v in ipairs(keys) do
            if key == v then -- if shift isn't down, act normally
                targetKeys[i] = false
                break
            end
        end
    end
end

function checkTargeting() -- Check which keys are down and place the player target accordingly
    local wasActive = player.target.active
    player.target = {x = player.x, y = player.y, active = false}

    if (love.keyboard.isDown(keybinds.UP) or love.keyboard.isDown(keybinds.DOWN) or love.keyboard.isDown(keybinds.LEFT) or love.keyboard.isDown(keybinds.RIGHT)) and not (love.keyboard.isDown(keybinds.ATTACK_DOWN) or love.keyboard.isDown(keybinds.ATTACK_LEFT) or love.keyboard.isDown(keybinds.ATTACK_RIGHT) or love.keyboard.isDown(keybinds.ATTACK_UP)) then
        heldKeys = {false, false, false, false,}
        targetKeys = {false, false, false, false,}
        targetHeld = false
    end

    if isMouseDown() then
        checkMouseTargeting()
    else
        if targetKeys[1] then
            player.target.active = true
            player.target.y = player.y - 1
        elseif targetKeys[2] then
            player.target.active = true
            player.target.y = player.y + 1
        end

        if targetKeys[3] then
            player.target.active = true
            player.target.x = player.x - 1
        elseif targetKeys[4] then
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