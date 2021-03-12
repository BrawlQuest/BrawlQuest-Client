function initTargeting()
    keyNames = {"ATTACK_UP", "ATTACK_DOWN", "ATTACK_LEFT", "ATTACK_RIGHT"}
    moveKeys = {keybinds.UP, keybinds.DOWN, keybinds.LEFT, keybinds.RIGHT}
    targetHeld = false
    keys = {keybinds.ATTACK_UP, keybinds.ATTACK_DOWN, keybinds.ATTACK_LEFT, keybinds.ATTACK_RIGHT}
    heldKeys = {false, false, false, false,}
    targetKeys = {false, false, false, false,}
    holdAttack = not oldTargeting
end

function checkAttack(key)
    local output = false
    for i,v in ipairs(keyNames) do if key == keybinds[v] then output = true break end end
    return output
end

function checkTargetingPress(key)
    if key == "h" and oldTargeting then
        if holdAttack then
            holdAttack = false
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

    local holding = false
    for i,v in ipairs(keys) do
        if love.keyboard.isDown(v) then
            holding = true
            break
        end
    end

    local moving = false
    for i,v in ipairs(moveKeys) do
        if love.keyboard.isDown(v) then
            moving = true
            break
        end
    end

    if not oldTargeting and ((moving and not isTypingInChat) and not holding) then
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