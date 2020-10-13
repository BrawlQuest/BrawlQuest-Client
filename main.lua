require "scripts.dummy_controller"
require 'scripts.dummy.lanterns'
require "scripts.player.character"
require "scripts.dummy.enemies"
require "scripts.effects.bones"
require "scripts.effects.lighting"
require "scripts.effects.music"
require "scripts.effects.loot"
require "scripts.libraries.api"
require "scripts.libraries.utils"
Luven = require "scripts.libraries.luven.luven"
local json = require("scripts.libraries.json")
local http = require("socket.http")

trees = {} -- temp
blockMap = {}
treeMap = {}
players = {} -- other players
playersDrawable = {}
lootTest = {}
nextTick = 1
timeOutTick = 3
timeOfDay = 0
username = "Pebsie"
readyForUpdate = true


sendUpdate = false

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    loadMusic()

    birds = love.audio.newSource("assets/sfx/ambient/forest/jungle.ogg", "stream")
    birds:setLooping(true)
    love.audio.play(birds)

    stepSound = love.audio.newSource("assets/sfx/step/grass.mp3", "static")
    xpSound = love.audio.newSource("assets/sfx/xp.wav", "static")
    xpSound:setVolume(0.4)
   
    playerHitSfx = love.audio.newSource("assets/sfx/hit.wav", "static")
    enemyHitSfx = love.audio.newSource("assets/sfx/impact_b.wav", "static")
    critHitSfx = love.audio.newSource("assets/sfx/pit_trap_damage.wav", "static")

    initDummyData()

    love.graphics.setBackgroundColor(0,0.3,0)
    
end

function love.draw()
    Luven.drawBegin()

    drawDummy()

    if player.target.active then
        diffX = player.target.x - player.x
        diffY = player.target.y - player.y
        if arrowImg[diffX] ~= nil and arrowImg[diffX][diffY] ~= nil then
            love.graphics.draw(arrowImg[diffX][diffY], player.dx-32, player.dy-32)
        end
    end
 
    Luven.drawEnd()

    love.graphics.print("BrawlQuest\nEnemies in aggro: "..enemiesInAggro)
    Luven.camera:draw()

end

function love.update(dt)
    nextTick = nextTick - 1*dt
    if nextTick < 0 then
        tick()
        nextTick = 1
    end

    oldLightAlpha = oldLightAlpha - 2*dt -- update light, essentially

   
    updateDummyEnemies(dt)
    updateCharacter(dt)
    updateBones(dt)
    updateMusic(dt)
    updateLoot(dt)
    Luven.update(dt)

    if not player.target.active then
        Luven.camera:setPosition(player.dx, player.dy)
    end

    timeOfDay = timeOfDay + 0.005*dt
    if timeOfDay < 0.8 then
        Luven.setAmbientLightColor({ 0.8-timeOfDay, 0.8-timeOfDay, 1-timeOfDay })
    else 
        Luven.setAmbientLightColor({ timeOfDay-0.8, timeOfDay-0.8, timeOfDay-1 })
        if timeOfDay > 2 then
            timeOfDay = 0 
        end
    end

    for i, v in pairs(players) do
        if playersDrawable[i] == nil then
            playersDrawable[i] = {
                ['Name'] = v.Name,
                ['X'] = v.X*32,
                ['Y'] = v.X*32
            }
        end

        if distanceToPoint(playersDrawable[i].X, playersDrawable[i].Y, v.X*32, v.Y*32) > 3 then
            if playersDrawable[i].X-4 > v.X*32 then
                playersDrawable[i].X =  playersDrawable[i].X  - 64*dt
            elseif playersDrawable[i].X+4 < v.X*32 then
                playersDrawable[i].X = playersDrawable[i].X + 64*dt
            end

            if playersDrawable[i].Y-4 > v.Y*32 then
                playersDrawable[i].Y = playersDrawable[i].Y - 64*dt
            elseif playersDrawable[i].Y+4 < v.Y*32 then
                playersDrawable[i].Y = playersDrawable[i].Y + 64*dt
            end
        end
    end

    local info = love.thread.getChannel( 'players' ):pop()
    if info then
        print(info)
        players = json:decode(info)
    end
end

function tick()
   tickDummyEnemies()

   if player.target.active then
        if player.dx > player.target.x*32 then
            player.dx = player.dx - 16
        elseif player.dx < player.target.x*32 then
            player.dx = player.dx + 16
        end
        if player.dy > player.target.y*32 then
            player.dy = player.dy - 16
        elseif player.dy < player.target.y*32 then
            player.dy = player.dy + 16
        end
   end
   
   getPlayerData('/players/'..username, json:encode({
    ["Name"] = username,
    ["X"] = player.x,
    ["Y"] = player.y  
  }))

   -- get data
--    print(api.url.."/players")
  
    -- request = wapi.request({
    --     method = "GET",
    --     url = api.url.."/players"
    --   }, function (body, headers, code)
    --     players = json:decode(body)
    --     if readyForUpdate then sendPlayerToServer() end
    --   end)
    -- reqbody = json:encode({
    --     ["Name"] = username,
    --     ["X"] = player.x,
    --     ["Y"] = player.y  
    --   })
    -- headers = json:encode({
    --     ["Content-Type"] = "application/json",
    --     ["Content-Length"] = string.len(reqbody)
    -- })
    -- -- print("Body: "..reqbody..", Headers: "..headers)
    -- --   updateRequest = wapi.request({
    -- --     payload = reqbody,
    -- --     headers = headers,
    -- --     method = "POST",
    -- --     url = api.url.."/players/"..username,
    -- --   }, function (body, headers, code)
    -- --     players = json:decode(body)
    -- --   end)

--     players = api.post("/players/"..username, json:encode({
--         ["Name"] = username,
--         ["X"] = player.x,
--         ["Y"] = player.y  
--       }))
--     timeOutTick = timeOutTick - 1
--     if timeOutTick == 0 then
--    --     readyForUpdate = true
--         timeOutTick = 3
--     end
end



function love.keypressed(key)
   checkTargeting()
end

function love.resize(width, height)
    reinitLighting(width, height)
end


function sendPlayerToServer() 
    readyForUpdate = false -- prevent another update from being sent until this one is finished
    username = "Pebsie"
    print("Sending player to server...")
   

  
    -- if updateRequest == nil then
    --       request = wapi.request({
    --         payload = reqbody,
    --           headers = headers,
    --         method = "POST",
    --         url = api.url.."/players"
    --       }, function (body, headers, code)
    --         readyForUpdate = true
    --       end)
    -- else
        
        
   -- end
end
