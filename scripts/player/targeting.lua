function initTargeting()
    attackKeys = {keybinds.ATTACK_UP, keybinds.ATTACK_DOWN, keybinds.ATTACK_LEFT, keybinds.ATTACK_RIGHT}
    targetActive = {
        up = false,
        down = false,
        left = false,
        right = false
    }

    targetHeld = false
    keys = {keybinds.ATTACK_UP, keybinds.ATTACK_DOWN, keybinds.ATTACK_LEFT, keybinds.ATTACK_RIGHT}
    heldKeys = {false, false, false, false,}
    targetKeys = {false, false, false, false,}
end

function checkTargetingPress(key)

    if targetHeld then
        for i,v in ipairs(keys) do
            if key == v then
                if heldKeys[i] == false then
                    heldKeys = {false, false, false, false,}
                    targetKeys = {false, false, false, false,}
                end
            end
        end
    end
    for i,v in ipairs(keys) do
        if key == v then
            targetKeys[i] = true
        end
    end
    print("Press " .. json:encode(targetKeys))
end

function checkTargetingRelease(key)
    if not love.keyboard.isDown("lshift") then
        targetHeld = true
        for i,v in ipairs(keys) do
            if key == v then
                targetKeys[i] = false
            end
        end
    else
        targetHeld = true
        heldKeys = copy(targetKeys)
    end
    print("Release " .. json:encode(targetKeys))
    -- checkTargeting()
end

function checkTargeting() -- Check which keys are down and place the player target accordingly
    local wasActive = player.target.active
    player.target = {x = player.x, y = player.y, active = false}

    -- if isMouseDown() then
    --     checkMouseTargeting()
    -- else
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
    -- end

    if not wasActive and player.target.active then
        -- newly active, trigger a send to make things feel a tad more responsive
        nextUpdate = 0
    end

    if player.target.active and player.isMounted then
        beginMounting()
    end
end