--[[
    API
    This file can handle all interactions between the game and the API.
    It was created specifically for the scripting capabilities of a research project undertaken by Thomas Lock as part of his undergraduate Computer Science study, 2018/19.
    v1.0
]]
local http = require("socket.http")
local json = require("scripts.libraries.json")

api = {
    url = "http://167.172.62.97:8080",
    get = function (action)

       -- print("Calling "..api.url..action)
        b, c, h = http.request(api.url..action)
        tb = b
        b = json:decode(b)

        if b then
          return b
        else
          love.window.showMessageBox("Error", "An error occurred with this statement: " .. api.url .. action .. "\nThe server returned: " + tostring(tb))
        end
    end,
    post = function (action, body)
       -- print("Calling "..api.url..action)
        b, c, h = http.request(api.url..action, body)
    end
  
}

script = {
    code = [[]],
    time = 1,
    loaded = false,
    paused = false
}

function loadScript(url)
  if url == "" then url = "example.lua" end
  local s = love.filesystem.read( url )
    if not s then
      love.window.showMessageBox("Error", "Unable to find " .. url)
    else
      s = [[
          local http = require("socket.http")
          local json = require("libraries.json")

          api = {
              url = "http://freshplay.co.uk/b/api.php",
              get = function (action)

                  print("Calling "..api.url..action)
                  b, c, h = http.request(api.url..action)
                  return json:decode(b)

              end
          }
      ]]..s
      script.code = love.thread.newThread( s )
      script.loaded = true
      print("Loaded "..tostring(script.code))
    end
end

