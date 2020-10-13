function initDummyData() 
    print("YOU'RE INITIALISING DUMMY DATA.")

    lootSound = love.audio.newSource("assets/sfx/loot.mp3", "static")
    lootImg = love.graphics.newImage("assets/player/gear/weapons/axe02.png")
    playerImg = love.graphics.newImage("assets/player/base.png")
    horseImg = love.graphics.newImage("assets/player/mounts/horse/back.png")
    horseForeImg = love.graphics.newImage("assets/player/mounts/horse/fore.png")
    swordImg = love.graphics.newImage("assets/player/gear/weapons/sword02.png")
    armour = {
        love.graphics.newImage("assets/player/gear/armour/legend/head.png"),
        love.graphics.newImage("assets/player/gear/armour/guardian/chest.png"),
        love.graphics.newImage("assets/player/gear/armour/iron/legs.png")
    }
    groundImg = love.graphics.newImage("assets/world/grounds/grass/grass05.png")
    treeImg = love.graphics.newImage("assets/world/objects/tree.png")
    targetImg = love.graphics.newImage("assets/ui/target.png")
    xpImg = love.graphics.newImage("assets/ui/xp.png")

    enemyDieSfx = love.audio.newSource("assets/sfx/skeleton.wav", "static")
    whistleSfx = {
        love.audio.newSource("assets/sfx/player/actions/whistle/1.ogg", "static"),
        love.audio.newSource("assets/sfx/player/actions/whistle/2.ogg", "static"),
        love.audio.newSource("assets/sfx/player/actions/whistle/3.ogg", "static"),
        love.audio.newSource("assets/sfx/player/actions/whistle/4.ogg", "static")
    }
    horseMountSfx = {
        love.audio.newSource("assets/sfx/monsters/horse/mount/1.mp3", "static"),
        love.audio.newSource("assets/sfx/monsters/horse/mount/2.mp3", "static")
    }

    arrowImg = {}
    arrowImg[-1]  = {
            [0]=love.graphics.newImage("assets/ui/target/W_Arrow_1.png"),
            [-1] = love.graphics.newImage("assets/ui/target/NW_Arrow_1.png"),
            [1]=love.graphics.newImage("assets/ui/target/SW_Arrow_1.png")
        }
        arrowImg[0] = 
        {
            [-1] = love.graphics.newImage("assets/ui/target/N_Arrow_1.png"),
            [1] = love.graphics.newImage("assets/ui/target/S_arrow_1.png")
        }
        arrowImg[1] = {
            [0] = love.graphics.newImage("assets/ui/target/E_Arrow_1.png"),
            [-1] = love.graphics.newImage("assets/ui/target/NE_Arrow_1.png"),
            [1] = love.graphics.newImage("assets/ui/target/SE_Arrow_1.png")
        }
        
    loadDummyEnemies()

    for i = 1, 70 do
        trees[i] = {
            x = love.math.random(0,love.graphics.getWidth()/32),
            y = love.math.random(0,love.graphics.getHeight()/32)
        }
        blockMap[trees[#trees].x..","..trees[#trees].y] = true
        treeMap[trees[#trees].x..","..trees[#trees].y] = true
    end

    initLighting()

    font = love.graphics.newFont(10)
    love.graphics.setFont(font)
end

function drawDummy()
    for x=-30,love.graphics.getWidth()/32 do
        for y = -30,love.graphics.getHeight()/32 do
            if isTileLit(x,y) then
                if not wasTileLit(x,y) then
                    love.graphics.setColor(1-oldLightAlpha,1-oldLightAlpha,1-oldLightAlpha) -- light up a tile
                else
                    love.graphics.setColor(1,1,1)
                end
            elseif wasTileLit(x,y) and oldLightAlpha > 0.2 then
                love.graphics.setColor(oldLightAlpha, oldLightAlpha, oldLightAlpha)
            else
                love.graphics.setColor(0.2,0.2,0.2)
            end
            love.graphics.draw(groundImg, x*32, y*32)
        end
    end
    
    for i,v in ipairs(trees) do
        if isTileLit(v.x,v.y) then
            love.graphics.setColor(1,1,1)
        else
            love.graphics.setColor(0.2,0.2,0.2)
        end
        love.graphics.draw(treeImg, v.x*32, v.y*32)
    end
    
    drawLanterns()

    drawBones()

    love.graphics.setColor(1,1,1,1)

    drawDummyEnemies()
    
    love.graphics.setColor(1,1,1,1)

   

    for i,v in ipairs(playersDrawable) do
        if v.Name ~= username then
            love.graphics.draw(playerImg, v.X, v.Y)
            love.graphics.setColor(0,0,0)
            love.graphics.rectangle("fill", v.X, v.Y-12, 32, 12)
            love.graphics.setColor(1,1,1)
            love.graphics.print(v.Name, v.X, v.Y-12)
        end
    end

    drawLoot()

    love.graphics.setColor(0,0,0)
  
    love.graphics.rectangle("line", player.dx, player.dy-8, 32,6)
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("fill", player.dx, player.dy-8, (player.dhp/player.mhp)*32,6)
    love.graphics.setColor(1,1,1)

    
end