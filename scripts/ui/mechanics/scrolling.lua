local t
function initScrolling()
    scrolling = {
        open = true,
        amount = 1,
    }
    t = scrolling
    scrollers = {}
end

function updateScrolling(dt)
    for scrollKey, scroll in next, scrollers do
        scroll.velocity = scroll.velocity - scroll.velocity * math.min( dt * 15, 1 )
        scroll.position = scroll.position + scroll.velocity * dt

        local max
        if scroll.max > scroll.boxMax then max = scroll.max - scroll.boxMax
        else max = scroll.max scroll.position = 0 end
        if scroll.position < scroll.min then
            scroll.position = scroll.min
        elseif scroll.position > max then
            scroll.position = max
        end
        -- -- print(scrollKey .. ", " .. scroll.position)
    end
end

function checkScrollingWheelMoved(dx, dy)
    for scrollKey, scroll in next, scrollers do
        if scroll.allowed() and scroll.max > scroll.boxMax then scroll.velocity = scroll.velocity - dy * 512 end
    end
end

function addScroller(key, min, max, boxMax, allowed)
    if not scrollers[key] then
        scrollers[key] = {
            position = 0,
            velocity = 0,
            min = min or 0,
            max = max or 200,
            boxMax = boxMax or 400,
            allowed = allowed or function () return true end,
        }
    else
        scrollers[key].min = min or 0
        scrollers[key].max = max or 200
        scrollers[key].boxMax = boxMax or 400
    end
end

--[[
initScrolling()a
updateScrolling(dt)
drawScrolling()
if scrolling.open then updateScrolling(dt) end
]]