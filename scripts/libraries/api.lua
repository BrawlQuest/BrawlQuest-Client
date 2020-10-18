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

api = {
    url = "http://167.172.62.97:8080",
    get = function (action)

       -- print("Calling "..api.url..action)
        b, c, h = http.request(api.url..action)
        return json:decode(b)
    end,
    post = function (action, body)
       -- print("Calling "..api.url..action)
        b, c, h = http.request(api.url..action, body)
        return json:decode(b)
    end
  
}

local thread

function getPlayerData(request, body)
  thread = love.thread.newThread( [[
    local http = require("socket.http")
    local json = require("scripts.libraries.json")
    local ltn12 = require("ltn12")

    action, body = ...
    print("Calling http://167.172.62.97:8080"..action.." with "..body)
    local b = {}
    c, h = http.request{url = "http://167.172.62.97:8080"..action, method="POST", source=ltn12.source.string(body), headers={["Content-Type"] = "application/json",["Content-Length"]=string.len(body),["token"]="]]..token..[["}, sink=ltn12.sink.table(b)}
    love.thread.getChannel( 'players' ):push( b[1] )
  ]] )

  thread:start(request,body)
end
