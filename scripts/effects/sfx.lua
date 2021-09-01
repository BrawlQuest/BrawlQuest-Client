sfxr = require("scripts.libraries.sfxr")

function initSFX()

    if love.audio.isEffectsSupported() then 
        sfx = {
            genRev = {
                enabled = true,
                action = function() love.audio.setEffect("genRev", {type = "reverb", gain = 0.3, decaytime = 0.5, highgain = 0.4, decayhighratio = 0.4, roomrolloff = 0.2, airabsorption = 0,}) end },
            caveRev = {
                enabled = true,
                action = function() love.audio.setEffect("caveRev", {type = "reverb", decaytime = 3, highgain = 0.5, decayhighratio = 0.2,}) end },
            elodineRev = {
                enabled = true,
                action = function() love.audio.setEffect("elodineRev", {type = "reverb", decaytime = 2, airabsorption = 10, highgain = 0.6, density = 0.05}) end },
            -- elodineFlange = {
            --     enabled = true,
            --     action = function() love.audio.setEffect("elodineFlange", {type = "echo", damping = 0.4, delay = 0.4, feedback = 0.4, spread = 0.2,}) end },
        }
    end

    for key,v in next, sfx do v.action() end -- init sfx

    sfxRolloff = 0.3
    love.audio.setDistanceModel("exponent")

    previousSFXVolume = sfxVolume

    birds = love.audio.newSource("assets/sfx/ambient/forest/jungle.ogg", "stream")

    stepSfx = love.audio.newSource("assets/sfx/step/grass.ogg", "static")
    xpSfx = love.audio.newSource("assets/sfx/xp.ogg", "static")

    lvlSfx = love.audio.newSource("assets/sfx/player/level.ogg", "static")

    awakeSfx = love.audio.newSource("assets/sfx/player/awake.mp3", "static")
    deathSfx = love.audio.newSource("assets/sfx/player/death.mp3", "static")
    playerHitSfx = love.audio.newSource("assets/sfx/hit.ogg", "static")
    enemyHitSfx = love.audio.newSource("assets/sfx/impact_b.ogg", "static")
    critHitSfx = love.audio.newSource("assets/sfx/pit_trap_damage.ogg", "static")

    lootSfx = {
        love.audio.newSource("assets/sfx/items/loot/1.mp3", "static"),
        love.audio.newSource("assets/sfx/items/loot/2.mp3", "static"),
        love.audio.newSource("assets/sfx/items/loot/3.mp3", "static"),
    }
    shieldUpSfx = love.audio.newSource("assets/sfx/player/actions/shield.ogg", "static")
    shieldDownSfx = love.audio.newSource("assets/sfx/player/actions/shield.ogg", "static")
    shieldDownSfx:setPitch(0.5)
    
    forgingPush = love.audio.newSource("assets/ui/forging/microwave-push.ogg", "static")
    forgingPop = love.audio.newSource("assets/ui/forging/microwave-pop.ogg", "static")
    speakSound = love.audio.newSource("assets/sfx/speak.ogg", "static")

    stepSounds = {
        ["assets/world/grounds/grass.png"] = love.audio.newSource("assets/sfx/step/grass.ogg", "static"),
        ["assets/world/grounds/Stone Floor.png"] = love.audio.newSource("assets/sfx/player/step/stone.ogg", "static"),
        ["assets/world/grounds/Red Walkway.png"] = love.audio.newSource("assets/sfx/player/step/carpet.ogg", "static"),
        ["assets/world/grounds/Red Walkway Down.png"] = love.audio.newSource("assets/sfx/player/step/carpet.ogg", "static"),
        ["assets/world/grounds/Sand.png"] = love.audio.newSource("assets/sfx/player/step/snow.ogg", "static"),
        ["assets/world/doors/Armoury.png"] = love.audio.newSource("assets/sfx/player/step/door.ogg", "static"),
        ["assets/world/doors/Bar.png"] = love.audio.newSource("assets/sfx/player/step/door.ogg", "static"),
        ["assets/world/doors/Barracks.png"] = love.audio.newSource("assets/sfx/player/step/door.ogg", "static"),
        ["assets/world/doors/Church.png"] = love.audio.newSource("assets/sfx/player/step/door.ogg", "static"),
        ["assets/world/doors/Library.png"] = love.audio.newSource("assets/sfx/player/step/door.ogg", "static"),
        ["assets/world/doors/Potion.png"] = love.audio.newSource("assets/sfx/player/step/door.ogg", "static"),
        ["assets/world/doors/Residential.png"] = love.audio.newSource("assets/sfx/player/step/door.ogg", "static"),
        ["assets/world/grounds/Water.png"] = love.audio.newSource("assets/sfx/step/water.ogg", "static"),
        ["assets/world/grounds/Path.png"] = love.audio.newSource("assets/sfx/player/step/path.ogg", "static")
    }

    npcSounds = {
        ["assets/npc/Farmer.png"] = love.audio.newSource("assets/sfx/npc/farmer.ogg", "static"),
        ["assets/npc/Bartender.png"] = love.audio.newSource("assets/sfx/npc/bartender.ogg", "static"),
        ["assets/npc/Guard.png"] = love.audio.newSource("assets/sfx/npc/soldier.ogg", "static"),
        ["assets/npc/Peasant.png"] = love.audio.newSource("assets/sfx/npc/person.ogg", "static"),
        ["assets/npc/Person.png"] = love.audio.newSource("assets/sfx/npc/person.ogg", "static"),
        ["assets/npc/Drunk Man.png"] = love.audio.newSource("assets/sfx/npc/drunk man.ogg", "static"),
        ["assets/npc/Priest.png"] = love.audio.newSource("assets/sfx/npc/soldier.ogg", "static"),
    }

    staffExplode = generateNoise()
    setSFXVolumes()
end

function updateSFX()
    if sfxSlider:getValue() ~= previousSFXVolume then
        sfxVolume = sfxSlider:getValue()
        setSFXVolumes()
        previousSFXVolume = sfxVolume
    end
end

function setSFXVolumes()
    crafting.sfx:setVolume(1 * sfxVolume)
    crafting.swing:setVolume(1 * sfxVolume)
    lvlSfx:setVolume(0.6 * sfxVolume)
    -- lootSfx:setVolume(0.5 * sfxVolume)
    deathSfx:setVolume(sfxVolume)
    shieldUpSfx:setVolume(0.4 * sfxVolume)
    shieldDownSfx:setVolume(0.4 * sfxVolume)
    xpSfx:setVolume(1 * sfxVolume)
    awakeSfx:setVolume(0.3 * sfxVolume)
    critHitSfx:setVolume(1 * sfxVolume)
    enemyHitSfx:setVolume(1 * sfxVolume)
    playerHitSfx:setVolume(1 * sfxVolume)
    birds:setVolume(0.1 * sfxVolume)
    -- horseMountSfx:setVolume(1*sfxVolume)
    forgingPush:setVolume(1 * sfxVolume)
    forgingPop:setVolume(1 * sfxVolume)
    for i = 1, #attackSfxs do attackSfxs[i]:setVolume(1*sfxVolume) end
    for i = 1, #aggroSfxs do aggroSfxs[i]:setVolume(1*sfxVolume) end
    for i = 1, #deathSfxs do deathSfxs[i]:setVolume(1*sfxVolume) end
end

function playFootstepSound(v, x, y, relative)

    stepSfx:stop()
    if v and stepSounds[v.GroundTile] then
        stepSfx = stepSounds[v.GroundTile]
    elseif v and stepSounds[v.ForegroundTile] then
        stepSfx = stepSounds[v.ForegroundTile]
    else
        stepSfx = stepSounds["assets/world/grounds/grass.png"]
    end
    stepSfx:setPitch(love.math.random(85,200)/100)
    stepSfx:setVolume(0.5 * sfxVolume)
    stepSfx:setRelative(false)
    -- stepSfx:setPosition(x, y)
    if relative then stepSfx:setPosition(0, 0) stepSfx:setRelative(true)
    else stepSfx:setRelative(false) stepSfx:setPosition(x, y) end
    if x == player.x and y == player.y then stepSfx:setRelative(true)
    else stepSfx:setRelative(false)  print(x..","..y) end
    
    setEnvironmentEffects(stepSfx)
    stepSfx:play()
end

function generateNoise(tab)
    if not tab then 
        local sound = sfxr.newSound({
            BITDEPTH = 16,
            SAMPLERATE = 44100,
        })
        sound:randomExplosion()
        local soundData = sound:generateSoundData()
        return love.audio.newSource(soundData, "stream")
    end
    -- source:play()
end

local tileName = "Squall's End"

function setEnvironmentEffects(sound)
    local x,y = 0,0
    setEffect(sound, "genRev", true)
    if worldLookup[player.x..","..player.y] then
        -- print(worldLookup[player.x..","..player.y].Name)
        if not orCalc(worldLookup[player.x..","..player.y].Name, {"", "Spooky Forest",}) then tileName = worldLookup[player.x..","..player.y].Name end
        setEffect(sound, "caveRev", orCalc(tileName, {"Shieldbreak Mine", "Shieldbreak", "The Permafrost Mines"}))
        setEffect(sound, "elodineRev", orCalc(tileName, {"Elodine's Gift",}))
    end
end

function setEffect(sound, effect, bool)
    if love.audio.isEffectsSupported() then
        if bool then
            if sfx[effect] then
                if sfx[effect].enabled == false then
                    sfx[effect].enabled = true
                    sfx[effect].action()
                end
                sound:setEffect(effect)
            end
        else sfx[effect].enabled = love.audio.setEffect(effect, false) end
    end
end