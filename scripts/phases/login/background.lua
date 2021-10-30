--[[
    This is for the background effects on the login screen
]]
clouds = {}
loginGrass = {}
loginMountains = {}
loginTrees = {}
loginPlayerX = 0

-- halloween related
flashAlpha = 0
flashSfx = love.audio.newSource("assets/sfx/weather/lightning_b.ogg", "static")

function initLoginBackground() 
    clouds = {}
    loginGrass = {}
    loginTrees = {}
    loginMountains = {}
    cloudImg = love.graphics.newImage("assets/ui/login/cloud.png")
    mountainImg = love.graphics.newImage("assets/ui/login/mountain.png")
    loginTreeImg = love.graphics.newImage("assets/ui/login/tree.png")
    groundImg = love.graphics.newImage("assets/world/grounds/grass.png")
    monsterImgs ={
        love.graphics.newImage("assets/ui/login/monsters/1.png"),
        love.graphics.newImage("assets/ui/login/monsters/2.png"),
        love.graphics.newImage("assets/ui/login/monsters/3.png"),
        love.graphics.newImage("assets/ui/login/monsters/4.png"),
        love.graphics.newImage("assets/ui/login/monsters/5.png"),
        love.graphics.newImage("assets/ui/login/monsters/6.png"),
        love.graphics.newImage("assets/ui/login/monsters/7.png"),
        love.graphics.newImage("assets/ui/login/monsters/8.png")
    }
    --love.graphics.setBackgroundColor(0.137,0.537,1)
    love.graphics.setBackgroundColor(0.3,0.05,0.5)
  
    for i=1,85 do
        clouds[#clouds+1] = {
            x=love.math.random(-love.graphics.getWidth(),love.graphics.getWidth()),
            y=love.math.random(1,love.graphics.getHeight()),
            speed=love.math.random(4,8)
        }
    end
    for i = 0,10 do
        loginTrees[i] = {
            x=i*(love.graphics.getWidth()/9),
            y=love.math.random(-80,-110)
        }
    end
    for i = 0,(love.graphics.getWidth()/32)+1 do
        loginGrass[#loginGrass+1] = {
            x=i*32,
            y=love.graphics.getHeight()-32
        }
        loginGrass[#loginGrass+1] = {
            x=i*32,
            y=love.graphics.getHeight()-64
        }
    end
    for i = 0,(love.graphics.getWidth()/115)+2 do
        loginMountains[#loginMountains+1] = {
            x = i*115,
            y=love.graphics.getHeight()-180
        }
    end

    randoMon1 = love.math.random(1,#monsterImgs)
    randoMon2 = love.math.random(1,#monsterImgs)
    randoMonAlpha = 0
    randoMonAlphaV = 0.02
end

function drawLoginBackground() 
    -- love.graphics.setColor(1,1,1,randoMonAlpha)
    -- love.graphics.draw(monsterImgs[randoMon1],love.graphics.getWidth()/2-512,love.graphics.getHeight()-360)
    -- love.graphics.draw(monsterImgs[randoMon2],love.graphics.getWidth()/2+256,love.graphics.getHeight()-360)
    love.graphics.setColor(0.2,0.1,0.4,1)
    for i,v in pairs(clouds) do
        love.graphics.draw(cloudImg, v.x, v.y)
    end
    love.graphics.setColor(0.2,0.2,0.2,1)
    for i,v in pairs(loginMountains) do
        love.graphics.draw(mountainImg, v.x, v.y)
    end

    love.graphics.setColor(0.2,0.1,0.4)
    for i,v in pairs(loginGrass) do
        love.graphics.draw(groundImg,v.x,v.y)
    end
   
    for i=0,10  do
        love.graphics.draw(loginTreeImg,loginTrees[i].x,love.graphics.getHeight()+loginTrees[i].y)
    end
    love.graphics.draw(playerImg,loginPlayerX,love.graphics.getHeight()-32)
    love.graphics.setColor(1,1,1,flashAlpha*0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1,1,1,1)
    
end

function updateLoginBackground(dt) 
    for i,v in pairs(clouds) do
        v.x = v.x - v.speed*dt
        if v.x < -cloudImg:getWidth() then
            v.x = love.graphics.getWidth()+cloudImg:getWidth()
        end
    end
    for i,v in pairs(loginTrees) do
        v.x = v.x - 32*dt
        if v.x <= -64 then
            v.x = love.graphics.getWidth()+64
        end
    end
    for i,v in pairs(loginGrass) do
        v.x = v.x - 32*dt
        if v.x <= -32 then
            v.x = love.graphics.getWidth()
        end
    end
    for i, v in pairs(loginMountains) do
        v.x = v.x - 8*dt
        if v.x <= -128 then
            v.x = love.graphics.getWidth()+115
        end
    end

    randoMonAlpha = randoMonAlpha + randoMonAlphaV*dt
    if randoMonAlpha > 0.1 then
        randoMonAlphaV = -0.02
    elseif randoMonAlpha < 0 then
        randoMon1 = love.math.random(1,#monsterImgs)
        randoMon2 = love.math.random(1,#monsterImgs)
        randoMonAlphaV = 0.02
    end

    loginPlayerX = loginPlayerX + 32*dt
    if loginPlayerX > love.graphics.getWidth() then
        loginPlayerX = -love.math.random(64,128)
    end

    if love.math.random(1,500) == 1 then
        flashAlpha = 2
        flashSfx:setVolume(sfxVolume)
        flashSfx:play()
    end

    flashAlpha = flashAlpha - 1*dt
end