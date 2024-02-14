
function initForging()
    forging = {
        open = false,
        amount = 1,
        w = 600,
        h = 400,
        r = 0,
        ra = 1,
        a = 0,
        alpha = 1,
        forging = false,
        forgeImg = love.graphics.newImage("assets/world/objects/Furnace.png"),
        font = crafting.font,
        mouseOver = {
            furnace = false,
        },
        ores = {
        
        },
        enteredItems = {},
        resultItems = {},
        showResults = false,
    }

    c, h = http.request {
        url = api.url .. "/forge",
        method = "GET",
        source = ltn12.source.string(body),
        headers = {
            ["token"] = token
        },
        sink = ltn12.sink.table(forging.ores)
    }

    forging.ores = json:decode(table.concat(forging.ores))
end

function updateForging(dt)
    local f = forging
    if f.forging then
        f.ra = f.ra + 10 * dt
        if f.ra > 2 then f.ra = 0 end
        local offset = 1
        f.r = cerp(-offset, offset, f.ra)

        f.a = f.a + 0.35 * dt
        if f.a >= 1 then -- end forging
            forgingPush:stop()
            setEnvironmentEffects(forgingPop)
            forgingPop:play()
            for i,v in ipairs(f.enteredItems) do
                c, h = http.request {
                    url = api.url .. "/forge/" .. me.name .. "/" .. v.item.id,
                    method = "GET",
                    source = ltn12.source.string(body),
                    headers = {
                        ["token"] = token
                    },
                }
            end
            f.forging = false
            f.a = 0
            -- f.showResults = true
            f.open = false -- TODO: make the endpoint return the items smelted
            -- f.resultItems = copy(f.enteredItems)
            f.enteredItems = {}
        end
    elseif f.showResults then
        f.alpha = 0.3
        f.r = 0
        f.a = f.a + 0.5 * dt
        if f.a >= 1 then
            f.showResults = false
            f.a = 0
            f.alpha = 1
            f.showResults = false
            f.resultItems = {}
        end
    else
        f.r = 0
    end
end

function drawForging()
    local f = forging
    local x,y = (uiX / 2), (uiY / 2)
    love.graphics.setFont(f.font)
    love.graphics.setColor(0,0,0,0.86)
    love.graphics.rectangle("fill", x - f.w / 2, y - f.h / 2, f.w, f.h, 10)
    love.graphics.setColor(1,1,1,f.alpha)

    love.graphics.push()
        love.graphics.translate(x + 100, y)
        love.graphics.rotate(math.rad(f.r))
        local offset = 0
        f.mouseOver.furnace = true
        if isMouseOver((x + 100 - 160) * scale, (y - 160) * scale, 320 * scale, 320 * scale) and not f.forging then
            offset = 3
            love.graphics.setColor(1, 0.5, 0.5, f.alpha)
            f.mouseOver.furnace = true
        else f.mouseOver.furnace = false end
        love.graphics.draw(f.forgeImg, -16 * 10 + f.r, -16 * 10 - offset, 0, 10)
    love.graphics.pop()

    love.graphics.setColor(1,1,1,f.alpha)
    x,y = x - f.w / 2 + 10, y - f.h / 2 + 10
    love.graphics.print("FORGING", x + 10, y, 0, 4)

    y = y + f.font:getHeight() * 4
    love.graphics.print("Entered Ores", x + 10, y, 0, 3)

    if #f.enteredItems == 0 then
        local w, h = 200, getTextHeight("You don't have any ores to smelt", 200, f.font, 2)
        x, y = x + 10, (uiY / 2) + 30 - h / 2
        love.graphics.printf("You don't have any ores to smelt", x, y, 200 / 2, "center", 0, 2)
    elseif #f.enteredItems > 0 then
        x,y = x + 10, y + f.font:getHeight() * 3 + 6
        for i,v in ipairs(f.enteredItems) do
            drawInventoryItem(x,y,v.item,v.amount)
            love.graphics.print(v.item.name, x + 44, y + 8, 0, 2)
            y = y + 46
        end

        x,y = uiX / 2 + f.w / 2, uiY / 2 - f.h / 2
        love.graphics.setColor(1,1,0,f.alpha)
        love.graphics.push()
            love.graphics.translate(x - 20, y + 20)
            love.graphics.rotate(math.rad(25))
            love.graphics.scale(3)
            love.graphics.print("Press the furnace to forge!", -f.font:getWidth("Press the furnace to forge!") / 2)
        love.graphics.pop()
    end

    if #f.resultItems > 0 then
        love.graphics.setColor(1,1,1)
        x,y = (uiX / 2), (uiY / 2)
        local w,h = #f.resultItems * 34 + 10 * (#f.resultItems - 1), 34
        love.graphics.push()
            love.graphics.translate(x,y)
            love.graphics.scale(2)
            local dx = 0
            for i,v in ipairs(f.resultItems) do
                drawInventoryItem(dx - w / 2, 0, v.item, v.amount)
                dx = dx + 44
            end
            love.graphics.printf("You Received:", 0 - uiX / 2, -20, uiX / 2, "center", 0, 2)
        love.graphics.pop()
    end
end

function checkForgingKeyPressed(key)
    local f = forging
    if key == "return" and #f.enteredItems > 0 then smeltOres() end
    if (key == "f" or checkMoveOrAttack(key)) and not f.forging and not f.showResults then f.open = false end
end

function checkForgingMousePressed(button)
    local f = forging
    if f.mouseOver.furnace then
        smeltOres()
    end
end

function enterOres()
    local f = forging
    for i, item in ipairs(f.ores) do
        local amount = getItemAmount(item.enteritem)
        if amount > 0 then f.enteredItems[#f.enteredItems+1] = {item = item.enteritem, amount = amount} end
    end
end



function smeltOres()
    local f = forging
    f.forging = true
    setEnvironmentEffects(forgingPush)
    forgingPush:play()
end

function openForging()
    local f = forging
    f.enteredItems = {}
    enterOres()
    f.open = true
end
