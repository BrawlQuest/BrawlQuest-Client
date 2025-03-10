--[[
    The "login" phase of login is for entering a UID and password
]]

logoScale = 5
loginPhaseAlpha = 0

function drawLoginPhase(countCerp)

    loginImageX, loginImageY = math.floor(love.graphics.getWidth() / 2 - (loginEntryImage:getWidth() / 2)),
    math.floor(love.graphics.getHeight() / 2 - (loginEntryImage:getHeight() / 2))

    love.graphics.setColor(0,0,0,0.7 * countCerp)
    roundRectangle("fill", loginImageX, loginImageY + 220, loginEntryImage:getWidth(), loginEntryImage:getHeight() - 220, 20)

    love.graphics.setColor(1,1,1, countCerp)
    love.graphics.draw(loginEntryImage, loginImageX, loginImageY)

    love.graphics.draw(bqLogo, (love.graphics.getWidth() / 2) - ((bqLogo:getWidth() * logoScale) * 0.5), loginImageY - 90, 0, logoScale)

    love.graphics.setColor(0, 0, 0, countCerp)
    love.graphics.setFont(textFont)
    if isMouseOver(loginImageX + 50, loginImageY + 265, 288, 44) then
        love.graphics.setColor(0.6, 0.6, 0.6, countCerp)
    end
    if editingField == 1 then
        love.graphics.printf(textfields[1] .. "|", loginImageX + 50, loginImageY + 265, 262, "center")
    else
        love.graphics.printf(textfields[1], loginImageX + 50, loginImageY + 265, 262, "center")
    end
    love.graphics.setColor(0, 0, 0, countCerp)
    if isMouseOver(loginImageX + 50, loginImageY + 335, 288, 44) then
        love.graphics.setColor(0.6, 0.6, 0.6, countCerp)
    end

    if editingField == 2 then
        love.graphics.printf(textfields[3] .. "|", loginImageX + 50, loginImageY + 335, 262, "center")
    else
        love.graphics.printf(textfields[3], loginImageX + 50, loginImageY + 335, 262, "center")
    end

    love.graphics.setColor(1, 1, 1, countCerp)
    love.graphics.setFont(headerFont)
    if isMouseOver(loginImageX + 36, loginImageY + 380, 288, 44) then
        love.graphics.setColor(0.8, 0.8, 0.8, countCerp)
    end
    love.graphics.printf("LOGIN / REGISTER", loginImageX + 50, loginImageY + 390, 262, "center")
    love.graphics.setColor(1, 1, 1, countCerp)
    love.graphics.printf("Username", loginImageX + 50, loginImageY + 230, 262, "center")
    love.graphics.printf("Password", loginImageX + 50, loginImageY + 300, 262, "center")

    love.graphics.setFont(smallTextFont)
    if isMouseOver(loginImageX + 50, loginImageY + 460, 262, 30) then
        love.graphics.setColor(0.8,0.8,0.8, countCerp)
    else
        love.graphics.setColor(1,1,1, countCerp)
    end
    love.graphics.printf("Server: "..servers[selectedServer].name.."\nClick to change", loginImageX + 50, loginImageY+460, 262, "center")
end

function checkClickLoginPhaseLogin(x,y)
    if loginImageX and loginImageY then
        if isMouseOver(loginImageX + 50, loginImageY + 265, 288, 44) and editingField ~= 1 then
            editingField = 1
        elseif isMouseOver(loginImageX + 50, loginImageY + 335, 288, 44) and editingField ~= 2 then
            editingField = 2
        elseif isMouseOver(loginImageX + 36, loginImageY + 380, 288, 44) then
            login()
        elseif isMouseOver(loginImageX + 50, loginImageY + 460, 262, 30) then
            loginPhase = "server"
        end
    end
end

function checkLoginKeyPressedPhasePrelaunch(key)
    launch.inAmount = 1
    launch.outAmount = 1
    launch.outCERP = 1
    loginPhase = "server"

  
    if key == "escape" and versionType == "dev" then love.event.quit() end
end

function checkLoginKeyPressedPhaseLogin(key)
    if key == "backspace" then
        textfields[editingField] = deleteText(textfields[editingField])
        if editingField == 2 then
            textfields[3] = deleteText(textfields[3])
        end
    elseif key == "tab" or key == "return" then
        if editingField == 1 then
            editingField = 2
        elseif editingField == 2 and key == "tab" then 
            editingField = 1
        elseif editingField == 2 and key == "return" then
            login()
        end
    end
    -- if versionType == "dev" then devLogin(key) end
    -- if key == "escape" and versionType == "dev" then love.event.quit() end
end

function checkLoginTextinputPhaseLogin(key)
    textfields[editingField] = textfields[editingField] .. key
    if editingField == 2 then
        textfields[3] = textfields[3] .. "*"
    end
end



function login()
    if textfields[1] ~= "" and textfields[2] ~= "" then
        b, c, h = http.request(api.url .. "/login", json:encode({
            UID = textfields[1],
            Password = textfields[2]
        }))
        -- print("logged in as "..textfields[1])
        
        if c == 200 then

            
            b = json:decode(tostring(b))
            UID = textfields[1]
            token = b['token']
            characters = {}
            r, h = http.request {
                url = api.url .. "/user/" .. textfields[1],
                headers = {
                    ['token'] = b['token']
                },
                sink = ltn12.sink.table(characters)
            }
    
        --  if c == 200 then -- Why was this here?
            -- if type(characters[1]) == "string" then
                    characters = json:decode(characters[1])
                -- print("Loaded characters")
            -- else
            --      print("Characters" .. json:encode(characters))
            --      characters = characters[1]
            --  end
                loginPhase = "characters"
                for i,v in ipairs(characters) do
                    if characters[i] and characters[i].Color ~= null then
                    else
                    characters[i].Color = {love.math.random(), love.math.random(), love.math.random(),  1}
                    end
                end
                if love.system.getOS() ~= "Linux" and useSteam then steam.userStats.requestCurrentStats() end -- init achievements and stat tracking
        -- end
        if versionType == "dev" then
            r, h = http.request {
                url = api.url .. "/enemies",
            
                sink = ltn12.sink.table(availableEnemies)
            }
            
            if c == 200 then
                if type(availableEnemies[1]) == "string" then
                    local c = json:decode(availableEnemies[1])
                    availableEnemies = {}
                    for i,v in ipairs(c) do
                        availableEnemies[#availableEnemies+1] = v
                        worldEdit.enemyImages[#availableEnemies] = getImgIfNotExist(v.Image)
                    end
                end
            end
        end
        elseif c == 401 then
            textfields[2] = ""
            textfields[3] = ""
            print("Login Failed")
        end
    end
end
