function initNews()
    news = {
        open = false,
        amount = 1,
    }
end

function updateNews(dt)
    local e = news

end

function drawNews()
    local e = news
    local w,h = 600, 400
    local x,y = uiX / 2 - w/2, uiY / 2 - h/2
    love.graphics.setColor(0,0,0,0.8)
    love.graphics.rectangle("fill", x, y, w, h, 10)

    love.graphics.setColor(1,1,1)
    love.graphics.print("Welcome Back " .. me.Name .. "!", x, y)
end

function checkNewsKeyPressed(key)
    local e = news
end

function checkNewsMousePressed(button)
    local e = news
end

--[[
initNews()
updateNews(dt)
drawNews()
if news.open then updateNews(dt) end
if news.open then drawNews() end
elseif news.open then checkNewsKeyPressed(key)
elseif news.open then checkNewsMousePressed(button)

]]