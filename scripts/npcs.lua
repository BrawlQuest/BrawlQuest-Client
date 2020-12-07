npcs = {}
npcsDrawable = {}
npcImg = {}

function drawNPCs() 
    for i,v in ipairs(npcsDrawable) do
        if not worldImg[v.ImgPath] then
            if love.filesystem.getInfo(v.ImgPath) then
                worldImg[v.ImgPath] = love.graphics.newImage(v.ImgPath)
            else
                worldImg[v.ImgPath] = love.graphics.newImage("assets/error.png")
            end
        end
        love.graphics.draw(worldImg[v.ImgPath], v.X, v.Y)
        drawNamePlate(v.X, v.Y, v.Name)
    end
end

function updateNPCs(dt)
    for i,v in ipairs(npcs) do
        if npcsDrawable[i] == null then
            npcsDrawable[i] = v
            npcsDrawable[i].X = v.X*32
            npcsDrawable[i].Y = v.Y*32
        end
        
        local n = npcsDrawable[i]
        if n.ID ~= v.ID then
           n = v
           n.X = v.X*32
            n.Y = v.Y*32
        end
        if distanceToPoint(n.X, n.Y, v.X * 32, v.Y * 32) > 3 then 
            if n.X-3 > v.X*32 then
                n.X = n.X - 32*dt
            elseif n.X+3 < v.X*32 then
                n.X = n.X + 32*dt
            end
            if n.Y-3 > v.Y*32 then
                n.Y = n.Y - 32*dt
            elseif n.Y+3 < v.Y*32 then
                n.Y = n.Y + 32 *dt
            end
        end
    end
end