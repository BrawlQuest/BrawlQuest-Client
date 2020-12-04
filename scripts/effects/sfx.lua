function initSFX()

    previousSFXVolume = sfxVolume

    birds = love.audio.newSource("assets/sfx/ambient/forest/jungle.ogg", "stream")
    birds:setLooping(true)
    love.audio.play(birds)

    stepSfx = love.audio.newSource("assets/sfx/step/grass.mp3", "static")
    xpSfx = love.audio.newSource("assets/sfx/xp.wav", "static")
    xpSfx:setVolume(0.4*sfxVolume)

    awakeSfx = love.audio.newSource("assets/sfx/player/awake.wav", "static")
    playerHitSfx = love.audio.newSource("assets/sfx/hit.wav", "static")
    enemyHitSfx = love.audio.newSource("assets/sfx/impact_b.wav", "static")
    critHitSfx = love.audio.newSource("assets/sfx/pit_trap_damage.wav", "static")

    lootSfx = love.audio.newSource("assets/sfx/loot.mp3", "static")
    shieldUpSfx = love.audio.newSource("assets/sfx/player/actions/shield.wav", "static")
    shieldDownSfx = love.audio.newSource("assets/sfx/player/actions/shield.wav", "static")
    shieldDownSfx:setPitch(0.5)

    setSFXVolumes()
end

function updateSFX()
    if sfxSlider:getValue() ~= previousSFXVolume then
        sfxVolume = sfxSlider:getValue()
        setSFXVolumes()
        previousSFXVolume = sfxVolume
        print("SFX Volume: " .. sfxVolume)
        writeSettings()
    end
end

function setSFXVolumes()
    lootSfx:setVolume(1 * sfxVolume)
    shieldUpSfx:setVolume(0.4 * sfxVolume)
    shieldDownSfx:setVolume(0.4 * sfxVolume)
    xpSfx:setVolume(1 * sfxVolume)
    awakeSfx:setVolume(0.4 * sfxVolume)
    critHitSfx:setVolume(1 * sfxVolume)
    enemyHitSfx:setVolume(1 * sfxVolume)
    playerHitSfx:setVolume(1 * sfxVolume)
    birds:setVolume(1 * sfxVolume)
    -- horseMountSfx:setVolume(1*sfxVolume)
    stepSfx:setVolume(1 * sfxVolume)
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

