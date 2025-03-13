--[[
    API
    This file can handle all interactions between the game and the API.
    It was created specifically for the scripting capabilities of a research project undertaken by Thomas Lock as part of his undergraduate Computer Science study, 2018/19.
    v1.0
]]
local http = require("socket.http")
local json = require("scripts.libraries.json")

UID = ""
token = ""

selectedServer = 1

servers = { {
    name = "EU",
    url = "http://198.244.191.157"
},
    {
        name = "Local",
        url = "http://localhost"
    } }

api = {
}

local thread
local getThread
local playerDataChannel = love.thread.getChannel('data')
local getPlayerDataThread = love.thread.newThread([[
   print("Not initialised!")
  ]])

local getInventoryDataThread = love.thread.newThread([[
   print("Not initialised!")
  ]])

function setAPI(i)
    if i then selectedServer = i end

    api = {
        url = servers[selectedServer].url,
        get = function(action)
            -- print("Calling "..api.url..action)
            b, c, h = http.request(api.url .. action)
            return json:decode(b)
        end,
        post = function(action, body)
            -- print("Calling "..api.url..action)
            b, c, h = http.request(api.url .. action, body)
            return json:decode(b)
        end

    }

    getPlayerDataThread = love.thread.newThread([[
    local http = require("socket.http")
    local json = require("scripts.libraries.json")
    local ltn12 = require("ltn12")

      action, body, token = love.thread.getChannel('action'):demand(), love.thread.getChannel('body'):demand(), love.thread.getChannel('token'):demand()
  
        local b = {}
        c, h = http.request{url = "]] .. api.url ..
        [["..action, method="POST", source=ltn12.source.string(body), headers={["Content-Type"] = "application/json",["Content-Length"]=string.len(body),["token"]=token}, sink=ltn12.sink.table(b)}
        love.thread.getChannel( 'players' ):push( table.concat(b) )
   
  ]])

    getInventoryDataThread = love.thread.newThread([[
    local http = require("socket.http")
    local json = require("scripts.libraries.json")
    local ltn12 = require("ltn12")

  
      playerid, body, token = love.thread.getChannel('playerid'):demand(), love.thread.getChannel('body'):demand(), love.thread.getChannel('token'):demand()

      local b = {}
      c, h = http.request{url = "]] .. api.url ..
        [[/inventory/"..playerid, method="GET", headers={["Content-Type"] = "application/json",["token"]=token},  sink=ltn12.sink.table(b)}
      love.thread.getChannel( 'inventory' ):push( table.concat(b) )

    ]])
end

function getPlayerData(request, body, token)
    if not getPlayerDataThread:isRunning() then
        getPlayerDataThread:start()
    end

    local error = getPlayerDataThread:getError()
    -- print(error)
    love.thread.getChannel('action'):push(request)
    love.thread.getChannel('body'):push(body)
    love.thread.getChannel('token'):push(token)
end

function getPlayerInventory(playerid, token)
    if not getInventoryDataThread:isRunning() then
        getInventoryDataThread:start()
    end

    local error = getInventoryDataThread:getError()
    print(playerid)
    love.thread.getChannel('playerid'):push(playerid)
    love.thread.getChannel('token'):push(token)
end

function apiGET(request)
    getThread = love.thread.newThread([[
    local http = require("socket.http")
    local json = require("scripts.libraries.json")
    local ltn12 = require("ltn12")

    action,url,token = ...
    c, h = http.request{url = url..action, headers={["token"]=token}}
  ]])
    getThread:start(request, api.url, token)
end

function apiGETThreadless(request)
    print("Calling " .. api.url .. request)
    local b = {}
    c, h = http.request{url=api.url .. request, headers={["token"]=token}, sink=ltn12.sink.table(b)}
   
    return table.concat(b)
end