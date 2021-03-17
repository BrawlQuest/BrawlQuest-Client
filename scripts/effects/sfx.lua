function initSFX()

    previousSFXVolume = sfxVolume

    birds = love.audio.newSource("assets/sfx/ambient/forest/jungle.ogg", "stream")
    -- birds:setLooping(true)
    -- love.audio.play(birds)

    stepSfx = love.audio.newSource("assets/sfx/step/grass.mp3", "static")
    xpSfx = love.audio.newSource("assets/sfx/xp.wav", "static")
    xpSfx:setVolume(0.4*sfxVolume)

    lvlSfx = love.audio.newSource("assets/sfx/player/level.mp3", "static")

    awakeSfx = love.audio.newSource("assets/sfx/player/awake.wav", "static")
    playerHitSfx = love.audio.newSource("assets/sfx/hit.wav", "static")
    enemyHitSfx = love.audio.newSource("assets/sfx/impact_b.wav", "static")
    critHitSfx = love.audio.newSource("assets/sfx/pit_trap_damage.wav", "static")

    lootSfx = love.audio.newSource("assets/sfx/loot.mp3", "static")
    shieldUpSfx = love.audio.newSource("assets/sfx/player/actions/shield.wav", "static")
    shieldDownSfx = love.audio.newSource("assets/sfx/player/actions/shield.wav", "static")
    shieldDownSfx:setPitch(0.5)

    -- forgingSfx = love.audio.newSource("assets/ui/forging/microwave.wav", "static")
    forgingPush = love.audio.newSource("assets/ui/forging/microwave-push.wav", "static")
    forgingPop = love.audio.newSource("assets/ui/forging/microwave-pop.wav", "static")

    speakSound = love.audio.newSource("assets/sfx/speak.wav", "static")

    stepSounds = {
        ["assets/world/grounds/grass.png"] = love.audio.newSource("assets/sfx/step/grass.mp3", "static"),
        ["assets/world/grounds/Stone Floor.png"] = love.audio.newSource("assets/sfx/player/step/stone.mp3", "static"),
        ["assets/world/grounds/Red Walkway.png"] = love.audio.newSource("assets/sfx/player/step/carpet.mp3", "static"),
        ["assets/world/grounds/Red Walkway Down.png"] = love.audio.newSource("assets/sfx/player/step/carpet.mp3", "static"),
        ["assets/world/grounds/Sand.png"] = love.audio.newSource("assets/sfx/player/step/snow.ogg", "static"),
        ["assets/world/doors/Armoury.png"] = love.audio.newSource("assets/sfx/player/step/door.mp3", "static"),
        ["assets/world/doors/Bar.png"] = love.audio.newSource("assets/sfx/player/step/door.mp3", "static"),
        ["assets/world/doors/Barracks.png"] = love.audio.newSource("assets/sfx/player/step/door.mp3", "static"),
        ["assets/world/doors/Church.png"] = love.audio.newSource("assets/sfx/player/step/door.mp3", "static"),
        ["assets/world/doors/Library.png"] = love.audio.newSource("assets/sfx/player/step/door.mp3", "static"),
        ["assets/world/doors/Potion.png"] = love.audio.newSource("assets/sfx/player/step/door.mp3", "static"),
        ["assets/world/doors/Residential.png"] = love.audio.newSource("assets/sfx/player/step/door.mp3", "static"),
        ["assets/world/grounds/Water.png"] = love.audio.newSource("assets/sfx/step/water.ogg", "static"),
        ["assets/world/grounds/Path.png"] = love.audio.newSource("assets/sfx/player/step/path.ogg", "static")
    }

    npcSounds = {
        ["assets/npc/Farmer.png"] = love.audio.newSource("assets/sfx/npc/farmer.mp3", "static"),
        ["assets/npc/Bartender.png"] = love.audio.newSource("assets/sfx/npc/bartender.mp3", "static"),
        ["assets/npc/Guard.png"] = love.audio.newSource("assets/sfx/npc/soldier.mp3", "static"),
        ["assets/npc/Peasant.png"] = love.audio.newSource("assets/sfx/npc/person.mp3", "static"),
        ["assets/npc/Person.png"] = love.audio.newSource("assets/sfx/npc/person.mp3", "static"),
        ["assets/npc/Drunk Man.png"] = love.audio.newSource("assets/sfx/npc/drunk man.mp3", "static"),
        ["assets/npc/Priest.png"] = love.audio.newSource("assets/sfx/npc/soldier.mp3", "static"),
    }

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
    lootSfx:setVolume(0.7 * sfxVolume)
    shieldUpSfx:setVolume(0.4 * sfxVolume)
    shieldDownSfx:setVolume(0.4 * sfxVolume)
    xpSfx:setVolume(0.5 * sfxVolume)
    awakeSfx:setVolume(0.3 * sfxVolume)
    critHitSfx:setVolume(1 * sfxVolume)
    enemyHitSfx:setVolume(1 * sfxVolume)
    playerHitSfx:setVolume(1 * sfxVolume)
    birds:setVolume(1 * sfxVolume)
    -- horseMountSfx:setVolume(1*sfxVolume)
    stepSfx:setVolume(0.5 * sfxVolume)
    forgingPush:setVolume(1 * sfxVolume)
    forgingPop:setVolume(1 * sfxVolume)
    for i = 1, #attackSfxs do
        attackSfxs[i]:setVolume(1*sfxVolume)
    end
    for i = 1, #aggroSfxs do
        aggroSfxs[i]:setVolume(1*sfxVolume)
    end
    for i = 1, #deathSfxs do
        deathSfxs[i]:setVolume(1*sfxVolume)
    end
end

function playFootstepSound(v)
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
    stepSfx:play()
end
