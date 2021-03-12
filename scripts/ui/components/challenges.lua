
function initChallenges()
    challenges = {
        open = true,
        amount = 1,
        font = love.graphics.newFont("assets/ui/fonts/C&C Red Alert [INET].ttf", 13),
        fs = { -- fontScale
            text = 2,
        },
        {text = "I really want you to kill all these mobs please and make it quick or else"},
        {text = "I really want you to kill all these mobs please and make it quick or else"},
        {text = "I really want you to kill all these mobs please and make it quick or else"},
    }

    chal = {}
    for i = 1, 3 do
        chal[i] = {
        ["Desc"] = "Kill 50x Wolf",
        ["ImgPath"] = "assets/world/objects/Portal.png",
        ["IsComplete"] = false,
        ["Item"] = {}, -- item,
        ["XP"] = 500,
        ["Reset"] = "8 Hours, 14 Minutes",
    }
    end
end



function updateChallenges(dt)
    local c = challenges
end

local w, h = 500, 84 * 3 + 10 * 4 + 64
function drawChallenges()
    local c = challenges
    local x,y = uiX / 2 - w / 2, uiY / 2 - h / 2
    love.graphics.setFont(c.font)
    love.graphics.setColor(0,0,0,0.8)
    love.graphics.rectangle("fill", x, y, w, h, 10)
    love.graphics.setColor(1,1,1)

    y = y + 64
    for i,v in ipairs(chal) do
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("fill", x + 10, y + 10, 84, 84, 6)
        love.graphics.draw(getImgIfNotExist(v.ImgPath), x + 20, y + 20, 0, 2)
        love.graphics.printf(v.Desc, x + 114, y + 10 + 4, (w - 134) / c.fs.text, "left", 0, c.fs.text)
        love.graphics.printf(boolToString(v.IsComplete), x + 114, y + 10 + 4, (w - 134) / c.fs.text, "right", 0, c.fs.text)
        love.graphics.setColor(1,0,0)
        love.graphics.printf("Resets in " .. v.Reset, x + 114, y + 10 + 4 + (c.font:getHeight() * c.fs.text), (w - 134) / c.fs.text, "left", 0, c.fs.text)
        y = y + 94
    end
end

function checkChallengesKeyPressed(key)
    local c = challenges
end

function checkChallengesMousePressed(button)
    local c = challenges
end

-- initChallenges()
-- updateChallenges(dt)
-- drawChallenges(x,y)
-- checkChallengesKeyPressed(key)
-- checkChallengesMousePressed(button)