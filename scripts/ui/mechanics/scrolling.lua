local t
function initScrolling()
    scrolling = {
        open = true,
        amount = 1,
    }
    t = scrolling
    scrollers = {
        key = {
            p = 0, -- position
            v = 0, -- velocity
        }
    }
end

function updateScrolling(dt)
    for scrollKey, scroll in next, scrollers do
        
    end
end


--[[
initScrolling()
updateScrolling(dt)
drawScrolling()
if scrolling.open then updateScrolling(dt) end
]]