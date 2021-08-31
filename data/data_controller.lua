require "data.base_character"

function initHardData()
    initBaseCharacterImages()

    lootImg = love.graphics.newImage("assets/ui/loot.png")

    damageHUDImg = love.graphics.newImage("assets/ui/damage.png")
    playerImg = love.graphics.newImage("assets/player/base/base 1.png")
    bartenderImg = love.graphics.newImage("assets/npc/Bartender.png")

    targetImg = love.graphics.newImage("assets/ui/target.png")
    xpImg = love.graphics.newImage("assets/ui/xp.png")
    questAlertImg = love.graphics.newImage("assets/ui/alert.png")
    questCompleteImg = love.graphics.newImage("assets/ui/complete.png")
    itemAlertImg = love.graphics.newImage("assets/ui/alert-item.png")

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
    initBones()

    world = {}
    worldImg = {}
    lightGivers = {
        ["assets/world/objects/lantern.png"] = {
            brightness = 0.8,
            color = {1, 0.5, 0},
        },
        ["assets/world/objects/Mushroom.png"]  = {
            brightness = 0.8,
            color = {1, 0.6, 0},
        },
        ["assets/world/objects/Pumpkin0.png"] = {
            brightness = 1,
            color = {1, 0.5, 0},
        },
        ["assets/world/objects/Pumpkin1.png"] = {
            brightness = 1,
            color = {1, 0.5, 0},
        },
        ["assets/world/objects/Pumpkin2.png"] = {
            brightness = 1,
            color = {1, 0.5, 0},
        },
        ["assets/world/objects/Lamp.png"]  = {
            brightness = 2,
            color = {1, 0.5, 0},
        },
        ["assets/world/objects/Furnace.png"] = {
            brightness = 1,
            color = {1, 0.2, 0},
        },
        ["assets/world/objects/Campfire.png"] = {
            brightness = 0.7,
            color = {1, 0.2, 0},
        },
        ["assets/world/objects/Ice Torch.png"] = {
            brightness = 1,
            color = {0,0.5,1},
        },
        ["assets/world/grounds/Lava.png"] = {
            brightness = 2,
            color = {1, 0.5, 0},
        },
        ["assets/world/objects/Portal.png"] = {
            brightness = 3,
            color ={0.6,0,0.4}
        },
        ["assets/world/objects/Mould Mushroom.png"] = {
            brightness = 0.7,
            color ={1,0,0.8}
        },
        ["assets/world/objects/Standing Light.png"] = {
            brightness = 1,
            color ={1,0.3,0.1}
        },
    }
end