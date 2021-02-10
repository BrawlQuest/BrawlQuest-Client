function initTargeting()
    keys = {keybinds.ATTACK_UP, keybinds.ATTACK_DOWN, keybinds.ATTACK_LEFT, keybinds.ATTACK_RIGHT}
    targetKeys = {
        {v = false, key = keys[1]},
        {v = false, key = keys[2]},
        {v = false, key = keys[3]},
        {v = false, key = keys[4]},
    }
end

local targetHeld = false

function checkTargetingPress(key)
    for i,v in ipairs(keys) do
        if key == v then
            targetKeys[i].v = true
        end
    end

    if not targetHeld and key == "lshift" then
        targetKeys = {
            {v = false, key = keys[1]},
            {v = false, key = keys[2]},
            {v = false, key = keys[3]},
            {v = false, key = keys[4]},
        }
    end

    -- print(json:encode(targetKeys))
    -- checkTargeting()
end

function checkTargetingRelease(key)
    if not love.keyboard.isDown("lshift") then
        targetHeld = true
        for i,v in ipairs(keys) do
            if key == v then
                targetKeys[i].v = false
            end
        end
    else
        if key == "lshift" then
            targetKeys = {
                {v = false, key = keys[1]},
                {v = false, key = keys[2]},
                {v = false, key = keys[3]},
                {v = false, key = keys[4]},
            }
        end
    end
    -- print(json:encode(targetKeys))
    -- checkTargeting()
end

function checkTargeting() -- Check which keys are down and place the player target accordingly
    local wasActive = player.target.active
    player.target = {x = player.x, y = player.y, active = false}

    -- if isMouseDown() then
    --     checkMouseTargeting()
    -- else
        player.target.active = false
        for i, v in ipairs(targetKeys) do
            if v.v == true then
                player.target.active = true
            end
        end

        if targetKeys[1].v then
            player.target.y = player.y - 1
        elseif targetKeys[2].v then
            player.target.y = player.y + 1
        end

        if targetKeys[3].v then
            player.target.x = player.x - 1
        elseif targetKeys[4].v then
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