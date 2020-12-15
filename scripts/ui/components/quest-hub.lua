function initQuestHub()
end

function updateQuestHub()
end

function drawQuestHub(thisX, thisY) 
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", thisX, thisY, -313, -121)
    love.graphics.setColor(1,1,1,1)
    if me.Name ~= null then drawProfilePic(thisX - 73, thisY - 100, 1, "left", me.Name) end
end