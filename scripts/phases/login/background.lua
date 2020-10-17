--[[
    This is for the background effects on the login screen
]]
clouds = {}
loginGrass = {}
loginMountains = {}
loginTrees = {}
loginPlayerX = 0

function initLoginBackground() 
    clouds = {}
    loginGrass = {}
    loginTrees = {}
    loginMountains = {}
    cloudImg = love.graphics.newImage("assets/ui/login/cloud.png")
    mountainImg = love.graphics.newImage("assets/ui/login/mountain.png")
    loginTreeImg = love.graphics.newImage("assets/ui/login/tree.png")
    love.graphics.setBackgroundColor(0.3,0.3,1)

    for i=1,8 do
        clouds[#clouds+1] = {
            x=love.math.random(-love.graphics.getWidth(),love.graphics.getWidth()),
            y=love.math.random(1,love.graphics.getHeight()),
            speed=love.math.random(4,16)
        }
    end
    for i = 0,10 do
        loginTrees[i] = {
            x=i*(love.graphics.getWidth()/9),
            y=love.math.random(-64,-80)
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
end

function drawLoginBackground() 
    for i,v in pairs(clouds) do
        love.graphics.draw(cloudImg, v.x, v.y)
    end
    for i,v in pairs(loginMountains) do
        love.graphics.draw(mountainImg, v.x, v.y)
    end
    for i,v in pairs(loginGrass) do
        love.graphics.draw(groundImg,v.x,v.y)
    end
    for i=0,10  do
        love.graphics.draw(loginTreeImg,loginTrees[i].x,love.graphics.getHeight()+loginTrees[i].y)
    end
    love.graphics.draw(playerImg,loginPlayerX,love.graphics.getHeight()-32)
end

function updateLoginBackground(dt) 
    for i,v in pairs(clouds) do
        v.x = v.x + v.speed*dt
        if v.x > love.graphics.getWidth()+cloudImg:getWidth() then
            v.x = -cloudImg:getWidth()
        end
    end
    for i,v in pairs(loginTrees) do
        v.x = v.x - 64*dt
        if v.x <= -64 then
            v.x = love.graphics.getWidth()+64
        end
    end
    for i,v in pairs(loginGrass) do
        v.x = v.x - 64*dt
        if v.x <= -32 then
            v.x = love.graphics.getWidth()+32
        end
    end
    for i, v in pairs(loginMountains) do
        v.x = v.x - 32*dt
        if v.x <= -128 then
            v.x = love.graphics.getWidth()+115
        end
    end

    loginPlayerX = loginPlayerX + 32*dt
    if loginPlayerX > love.graphics.getWidth() then
        loginPlayerX = -love.math.random(64,128)
    end
end