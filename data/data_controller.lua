require "data.base_character"

function initHardData()
    initBaseCharacterImages()
    lootSfx = love.audio.newSource("assets/sfx/loot.mp3", "static")
    shieldUpSfx = love.audio.newSource("assets/sfx/player/actions/shield.wav", "static")
    shieldDownSfx =love.audio.newSource("assets/sfx/player/actions/shield.wav", "static")
    shieldDownSfx:setPitch(0.5)

    lootImg = love.graphics.newImage("assets/ui/loot.png")

    playerImg = love.graphics.newImage("assets/player/base/base 1.png")


    targetImg = love.graphics.newImage("assets/ui/target.png")
    xpImg = love.graphics.newImage("assets/ui/xp.png")


    arrowImg = {}
    arrowImg[-1]  = {
            [0]=love.graphics.newImage("assets/ui/target/w_arrow_1.png"),
            [-1] = love.graphics.newImage("assets/ui/target/nw_arrow_1.png"),
            [1]=love.graphics.newImage("assets/ui/target/sw_arrow_1.png")
        }
        arrowImg[0] = 
        {
            [-1] = love.graphics.newImage("assets/ui/target/n_arrow_1.png"),
            [1] = love.graphics.newImage("assets/ui/target/s_arrow_1.png")
        }
        arrowImg[1] = {
            [0] = love.graphics.newImage("assets/ui/target/e_arrow_1.png"),
            [-1] = love.graphics.newImage("assets/ui/target/ne_arrow_1.png"),
            [1] = love.graphics.newImage("assets/ui/target/se_arrow_1.png")
        }
    
        initLighting()
end