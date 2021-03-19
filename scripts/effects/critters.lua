--[[
    Visual bugs and stuff that scurry when you run near them
]]
critters = {}

critterType = {
    ["assets/world/grounds/grass/grass08.png"] = {
        img = "assets/items/buddy/Chicken.png",
        allowed = {"Westlum", "Squall's End", "Foundation Forest"},
        chance = 100,
        name = "chicken",
        amount = 3
    },
      ["assets/world/grounds/Cave Floor.png"] = {
        img = "assets/critter/shade.png",
        allowed = {"Squall's End"},
        chance = 10,
        name = "shade",
        amount = 2
    },
    ["assets/world/grounds/Murky Grass.png"] = {
        img = "assets/critter/mystic.png",
        allowed = {"Elodine's Gift"},
        light = {0, 0, 1},
        chance = 150,
        name = "mystic",
        amount = 4
    }
    --  ["assets/world/grounds/Water.png"] = "assets/critter/fish.png",
}

function initCritters()
    -- load sfx
    for i, v in pairs(critterType) do
        if v.name and love.filesystem.getInfo("assets/sfx/critter/" .. v.name .. "/") then
            v.sounds = {
                idle = {},
                hide = {}
            }
            for a,k in pairs(v.sounds) do
                local files = recursiveEnumerate("assets/sfx/critter/" .. v.name .. "/" ..a, {})
                for x, file in ipairs(files) do
                    if explode(file, ".")[#explode(file, ".")] == "ogg" or explode(file, ".")[#explode(file, ".")] ==
                        "mp3" or explode(file, ".")[#explode(file, ".")] == "wav" then
                        v.sounds[a][#v.sounds[a] + 1] = love.audio.newSource(file, "static")
                    end
                end
            end
        end

    end
end

function addCritters(v)
    if critterType[v.GroundTile] and (v.ForegroundTile == "" or v.ForegroundTile == v.GroundTile) and
        arrayContains(critterType[v.GroundTile].allowed, v.Name) and
        love.math.random(1, critterType[v.GroundTile].chance) == 1 then
        critters[#critters + 1] = {
            x = v.X * 32,
            y = v.Y * 32,
            amount = love.math.random(1, critterType[v.GroundTile].amount),
            alpha = 2,
            critter = {},
            type = v.GroundTile

        }

        if critterType[v.GroundTile].light then
            critters[#critters].light = Luven.addNormalLight(v.X * 32 + 16, v.Y * 32 + 16, critterType[v.GroundTile].light, 2)
        end

        for i = 1, critters[#critters].amount do
            critters[#critters].critter[i] = {
                x = critters[#critters].x + love.math.random(1, 32),
                y = critters[#critters].y + love.math.random(1, 32),
                targetX = critters[#critters].x + love.math.random(1, 32),
                targetY = critters[#critters].y + love.math.random(1, 32),
                scattering = false
            }
            critters[#critters].critter[i].targetX = critters[#critters].critter[i].x
            critters[#critters].critter[i].targetY = critters[#critters].critter[i].y
        end
    end
end

function drawCritters()
    for i, v in ipairs(critters) do
        love.graphics.setColor(1, 1, 1, v.alpha)
        for k, a in pairs(v.critter) do
            love.graphics.draw(getImgIfNotExist(critterType[v.type].img), a.x, a.y)
        end
    end
end

function updateCritters(dt)
    for i, v in ipairs(critters) do
        if distanceToPoint(player.dx, player.dy, v.x, v.y) < 64 then
            v.alpha = v.alpha - 3 * dt
            if v.light then
                Luven.setLightPower(v.light, v.alpha / 2)
            end
            if v.alpha < 0 then
                v.alpha = 0
                if v.light then
                    Luven.setLightPower(v.light, 0)
                end
                for a, k in pairs(v.critter) do
                    k.x = v.x + love.math.random(1, 32)
                    k.y = v.y + love.math.random(1, 32)
                end
            end
        elseif v.alpha < 2 and distanceToPoint(player.dx, player.dy, v.x, v.y) > 256 then
            v.alpha = v.alpha + 1 * dt
         
            if v.light then
                Luven.setLightPower(v.light, v.alpha / 2)
            end
        end
        for a, k in pairs(v.critter) do
            local speed = 8 *dt
            if distanceToPoint(player.dx, player.dy, v.x, v.y) < 64 then
                if not k.scattering then
                    k.targetX = k.x + love.math.random(-128, 128)
                    k.targetY = k.y + love.math.random(-128, 128)
                    k.scattering = true
                    if critterType[v.type].sounds then
                        local hideSound = critterType[v.type].sounds.hide[love.math.random(1,#critterType[v.type].sounds.hide)]
                        hideSound:setVolume(sfxVolume)
                        hideSound:setPosition(v.x / 32, v.y / 32)
                        hideSound:play()
                    end
                
                end
                if k.scattering then
                    speed = 48 * dt
                end
            elseif distanceToPoint(player.dx, player.dy, v.x, v.y) > 256 and k.scattering then
                k.scattering = false
                k.x = v.x
                k.y = v.y
            end
            if k.x < k.targetX - 1 then
                k.x = k.x + speed
            elseif k.x > k.targetX + 1 then
                k.x = k.x - speed
            end
            if k.y < k.targetY - 1 then
                k.y = k.y + speed
            elseif k.y > k.targetY + 1 then
                k.y = k.y - speed
            end
            if not k.scattering and distanceToPoint(player.dx, player.dy, v.x, v.y) < 256 and love.math.random(1,3500) == 1 and v.alpha > 1 then
                if critterType[v.type].sounds then
                    local idleSound = critterType[v.type].sounds.idle[love.math.random(1,#critterType[v.type].sounds.idle)]
                    idleSound:setVolume(sfxVolume)
                    idleSound:setPosition(v.x / 32, v.y / 32)
                    idleSound:play()
                end
            end
            if love.math.random(1, 2500) == 1 and distanceToPoint(player.dx, player.dy, v.x, v.y) > 64 then
                k.targetX = v.x + love.math.random(0, 32- getImgIfNotExist(critterType[v.type].img):getWidth())
                k.targetY = v.y + love.math.random(0, 32 - getImgIfNotExist(critterType[v.type].img):getHeight())
                if k.targetX > v.x + 32 then
                    k.targetX = v.x + 32
                elseif k.targetX < v.x then
                    k.targetX = v.x
                end
                if k.targetY > v.y + 32 then
                    k.targetY = v.y + 32
                elseif k.targetY < v.y then
                    k.targetY = v.y
                end
            end
        end

    end
end
