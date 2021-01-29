require "data.base_character"

function initHardData()
    initBaseCharacterImages()

    lootImg = love.graphics.newImage("assets/ui/loot.png")

    playerImg = love.graphics.newImage("assets/player/base/base 0.png")
    bartenderImg = love.graphics.newImage("assets/npc/Bartender.png")

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

        cornerArrowImage = love.graphics.newImage("assets/ui/target/corner.png")
        edgeArrowImage = love.graphics.newImage("assets/ui/target/edge.png")

        arrowData = {
            [-1] = {
                [-1] = {image = cornerArrowImage, position = {x = 0, y = 0,}, rotation = math.rad(180),},
                [0] = {image = edgeArrowImage, position = {x = 0, y = 16,}, rotation = math.rad(180)},
                [1] = {image = cornerArrowImage, position = {x = 0, y = 0,}, rotation = math.rad(90),},
            },
            [0] = {
                [-1] = {image = edgeArrowImage, position = {x = -16, y = 0,}, rotation = math.rad(-90),},
                [1] = {image = edgeArrowImage, position = {x = 16, y = 0,}, rotation = math.rad(90),},
            },
            [1] = {
                [-1] = {image = cornerArrowImage, position = {x = 0, y = 0,}, rotation = math.rad(-90),},
                [0] = {image = edgeArrowImage, position = {x = 0, y = -16,}, rotation = math.rad(0),},
                [1] = {image = cornerArrowImage, position = {x = 0, y = 0,}, rotation = math.rad(0),},
            },
        }
        
        foliageImg = {
            love.graphics.newImage("assets/world/objects/foliage/BQ Foliage-1.png"),
            love.graphics.newImage("assets/world/objects/foliage/BQ Foliage-2.png"),
            love.graphics.newImage("assets/world/objects/foliage/BQ Foliage-3.png"),
            love.graphics.newImage("assets/world/objects/foliage/BQ Foliage-4.png"),
        }

        initLighting()
end