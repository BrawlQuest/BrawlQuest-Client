


function initWeather()
    weather = {
        type = "rain",
        x = 0,
        y = 0,
        img = {
            rain = love.graphics.newImage("assets/ui/weather/rain.png"),
            splash = love.graphics.newImage("assets/ui/weather/splash.png")
        },
        splashes = {},
        canvas = love.graphics.newCanvas(love.graphics.getWidth()*2,love.graphics.getHeight()*2),
        flash = Luven.addNormalLight(0,0,{1,1,1},1)
    }
    
    weather.canvas = love.graphics.newCanvas(love.graphics.getWidth()*2,love.graphics.getHeight()*2)
    love.graphics.setCanvas(weather.canvas)
    love.graphics.setColor(0,0,0,0.2)
    love.graphics.rectangle("fill",0,0,love.graphics.getWidth()*2,love.graphics.getHeight()*2)
    love.graphics.setColor(1,1,1,1)
    for i = 1,200 do
        local x, y =  love.math.random(1,love.graphics.getWidth()), love.math.random(1,love.graphics.getHeight())
        love.graphics.draw(weather.img.rain, x, y)
        love.graphics.draw(weather.img.rain, love.graphics.getWidth()+x, y)
        love.graphics.draw(weather.img.rain, x, y+love.graphics.getHeight())
        love.graphics.draw(weather.img.rain, love.graphics.getWidth()+x, y+love.graphics.getHeight())
    end
    love.graphics.setCanvas()
    weather.x = 0
    weather.y = 0
end

function drawWeather()
    for i,v in ipairs(weather.splashes) do
        love.graphics.setColor(1,1,1,v.alpha)
        love.graphics.draw(weather.img.splash, v.x, v.y)
    end
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(weather.canvas, player.dx+weather.x-(love.graphics.getWidth()/2)+16, player.dy+weather.y-(love.graphics.getHeight()/2)+16)
end

function updateWeather(dt)
    local speed = 512*dt
    weather.x = weather.x + speed
    weather.y = weather.y + speed
    if weather.x > 0 then
        weather.x = -love.graphics.getWidth()
    end
    if weather.y > 0 then
        weather.y = -love.graphics.getHeight()
    end

   
        weather.splashes[#weather.splashes+1] = {
            x = player.dx + love.math.random(-400,400),
            y = player.dy + love.math.random(-400,400),
            alpha = 1
        }
        
        if love.math.random(1, 500) == 1 then
            Luven.setLightPower(weather.flash,32)
            Luven.setLightPosition(weather.flash,player.dx,player.dy)
        end
        Luven.setLightPower(weather.flash,Luven.getLightPower(weather.flash)-32*dt)

    for i,v in pairs(weather.splashes) do
        v.alpha = v.alpha - 1*dt
        if v.alpha < 0 then
            table.remove(weather.splashes, i)
        end
    end
end