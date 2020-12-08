npcs = {}
npcsDrawable = {}
npcImg = {}

function drawNPCs() 
    for i,v in pairs(npcsDrawable) do
        if not worldImg[v.ImgPath] then
            if love.filesystem.getInfo(v.ImgPath) then
                worldImg[v.ImgPath] = love.graphics.newImage(v.ImgPath)
            else
                worldImg[v.ImgPath] = love.graphics.newImage("assets/error.png")
                print("AN ERROR OCURRED. "..v.ImgPath.." can't be found.")
            end
        end
       
        love.graphics.draw(worldImg[v.ImgPath], v.X, v.Y)
        drawNamePlate(v.X+16, v.Y, v.Name)
    end
end

function updateNPCs(dt)
    for i,v in ipairs(npcs) do
        if npcsDrawable[v.ID] == null then
            npcsDrawable[v.ID] = copy(v)
            npcsDrawable[v.ID].X = v.X*32
            npcsDrawable[v.ID].Y = v.Y*32
        end
      
        local n = npcsDrawable[v.ID]

        if distanceToPoint(n.X, n.Y, v.X * 32, v.Y * 32) > 64 then
            n.X = v.X*32
            n.Y = v.Y*32
        end
        if distanceToPoint(n.X, n.Y, v.X * 32, v.Y * 32) > 1 then 
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

function startConversation()
    for i,v in ipairs(npcs) do
        if distanceToPoint(player.x,player.y,v.X,v.Y) <= 1 and not showNPCChatBackground  and v.Conversation ~= "" then
            local b = {}
            c, h = http.request{url = api.url.."/conversation/"..v.Conversation, method="GET", source=ltn12.source.string(body), headers={["token"]=token}, sink=ltn12.sink.table(b)}
            npcChat = json:decode(b[1])
            npcChat.Options = json:decode(string.gsub(npcChat.Options, "'", '"'))
            createNPCChatBackground(player.x,player.y)
            showNPCChatBackground = not showNPCChatBackground
        end
    end
end