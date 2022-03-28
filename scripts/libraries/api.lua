--[[
    API
    This file can handle all interactions between the game and the API.
    It was created specifically for the scripting capabilities of a research project undertaken by Thomas Lock as part of his undergraduate Computer Science study, 2018/19.
    v1.0
]] local http = require("socket.http")
local json = require("scripts.libraries.json")

UID = ""
token = ""

selectedServer = 1

servers = {{
    name = "Swordbreak (UK)",
    url = "https://swordbreak.brawlquest.com"
}, {
    name = "Test Server (UK)",
    url = "http://dev.brawlquest.com"
}, {
    name = "Local",
    url = "http://localhost"
}}

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

local thread
local getThread
local playerDataChannel = love.thread.getChannel('data')
local getPlayerDataThread = love.thread.newThread([[
    local http = require("socket.http")
    local json = require("scripts.libraries.json")
    local ltn12 = require("ltn12")

    while true do
      action, body, token = love.thread.getChannel('action'):demand(), love.thread.getChannel('body'):demand(), love.thread.getChannel('token'):demand()
   --   if action and body and token then
      -- print("Calling http://167.172.62.97:8080"..action.." with "..body)
        local b = {}
        c, h = http.request{url = "]] .. api.url ..
                                                      [["..action, method="POST", source=ltn12.source.string(body), headers={["Content-Type"] = "application/json",["Content-Length"]=string.len(body),["token"]=token}, sink=ltn12.sink.table(b)}
        love.thread.getChannel( 'players' ):push( table.concat(b) )
    --  end
    end
  ]])

function getPlayerData(request, body, token)
    if not getPlayerDataThread:isRunning() then
        getPlayerDataThread:start()
    end

    local error = getPlayerDataThread:getError()
    print(error)
    love.thread.getChannel('action'):push(request)
    love.thread.getChannel('body'):push(body)
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
