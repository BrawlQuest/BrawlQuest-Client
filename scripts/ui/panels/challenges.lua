
function initChallenges()
    challenges = {
        open = false,
        amount = 1,
        font = love.graphics.newFont("assets/ui/fonts/C&C Red Alert [INET].ttf", 13),
        mouseOver = 0,
        fs = { -- fontScale
            title = 3,
            text = 2,
        },
    }

    chal = {}
    for i = 1, 3 do
        chal[i] = {
        ["Desc"] = "Kill 50x Wolf",
        ["ImgPath"] = "assets/world/objects/Portal.png",
        ["IsComplete"] = false,
        ["Tracking"] = true,
        ["Item"] = {}, -- item,
        ["XP"] = 500,
        ["Reset"] = "8 Hours, 14 Minutes",
    }
    end
end

function updateChallenges(dt)
    local c = challenges
end

local w, h = 500, 84 * 3 + 10 * 4 + 90
function drawChallenges()
    local c = challenges
    local x,y = uiX / 2 - w / 2, uiY / 2 - h / 2
    love.graphics.setFont(c.font)
    love.graphics.setColor(0,0,0,0.8)
    love.graphics.rectangle("fill", x - 5, y, w + 10, h + 5, 10)
    love.graphics.setColor(1,1,1)

    love.graphics.printf("Village Noticeboard\n-- ADVENTURERS WANTED --", x + 10, y + 8, w / c.fs.title, "center", 0, c.fs.title)

    y = y + 90
    c.mouseOver = 0
    for i,v in ipairs(chal) do
        local text
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("fill", x + 10, y + 10, 84, 84, 6)
        love.graphics.draw(getImgIfNotExist(v.imgpath), x + 20, y + 20, 0, 2)
        love.graphics.printf(v.description, x + 114, y + 10 + 4, (w - 134) / c.fs.text, "left", 0, c.fs.text)
        if v.IsComplete then text = "Completed" elseif v.Tracking then text = "Tracking" else text = "Available" end
        love.graphics.printf(text, x + 114, y + 10 + 4, (w - 134) / c.fs.text, "right", 0, c.fs.text)
        if v.IsComplete then text = "Resets in " .. v.Reset elseif v.Tracking then text = "Press to Stop Tracking" else text = "Press to Accept Challenge" end
        love.graphics.printf("Reward: " .. v.xP .. "XP", x + 114, y + 10 + 4 + (c.font:getHeight() * c.fs.text), (w - 134) / c.fs.text, "left", 0, c.fs.text)
        love.graphics.setColor(1,0,0)
        if isMouseOver((x + 114) * scale, (y + 10 + 4 + (c.font:getHeight() * c.fs.text) * 2) * scale, (c.font:getWidth(text) * c.fs.text) * scale, (c.font:getHeight(text) * c.fs.text) * scale) then
            love.graphics.setColor(1,0,1)
            c.mouseOver = i
        end
        love.graphics.printf(text, x + 114, y + 10 + 4 + (c.font:getHeight() * c.fs.text) * 2, (w - 134) / c.fs.text, "left", 0, c.fs.text)
        y = y + 94
    end
end

function checkChallengesKeyPressed(key)
    local c = challenges
    if checkMoveOrAttack(key) or key == "f" then c.open = false end
end

function checkChallengesMousePressed(button)
    local c = challenges
    if c.mouseOver > 0 then chal[c.mouseOver].Tracking = not chal[c.mouseOver].Tracking end
end

-- initChallenges()
-- updateChallenges(dt)
-- drawChallenges(x,y)
-- checkChallengesKeyPressed(key)
-- checkChallengesMousePressed(button)