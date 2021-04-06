--[[

function initVar()
    Var = {
        open = true,
        amount = 1,
    }
end

function updateVar(dt)
    local e = Var
end

function drawVar()
    local e = Var
    local x,y = uiX / 2 * scale, uiY / 2 * scale
end

function checkVarKeyPressed(key)
    local e = Var
end

function checkVarMousePressed(button)
    local e = Var
end

--[[
initVar()
updateVar(dt)
drawVar()
if Var.open then updateVar(dt) end
if Var.open then drawVar() end
elseif Var.open then checkVarKeyPressed(key)
if Var.open then checkVarMousePressed(button) end
]]

--[[
function updateVar(dt)
    for i,v in ipairs(particles.sparkles) do
        
    end
end

function drawVar()
    for i,v in ipairs(particles.sparkles) do
        
    end
end

function addVar()
    
end

--[[
updateVar(dt)
drawVar()
addVar()
]]

function orCalc(val, tab) -- compares a value to a table of items
    local output = false
    for i,v in ipairs(tab) do if v == val then output = true break end end
    return output
end

function andCalc(val, tab) -- compares a value to a table of items
    local count = 0
    for i,v in ipairs(tab) do if v == val then count = count + 1 end end
    if count == #tab then return true else return false end
end

function getImgIfNotExist(v)
    if not worldImg[v] then
        if v and v ~= "" and love.filesystem.getInfo(v) then
            worldImg[v] = love.graphics.newImage(v)
        else
            worldImg[v] = love.graphics.newImage("assets/error.png")
            print("Can't find "..v)
        end
    end
    return worldImg[v]
end

function getTextHeight(text, width, thisFont, thisScale)
    thisScale = thisScale or 1
	local width, lines = thisFont:getWrap(text, width / thisScale)
 	return ((#lines)*(thisFont:getHeight())) * thisScale
end

function deleteText(text, amount) -- text = deleteText(text, amount)
    amount = amount or 1
    local byteOffset = utf8.offset(text, -1)
    if byteOffset and string.len(text) > 0 then return string.sub(text, 1, byteOffset - 1) else return text end
end

function copy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
    return res
end

function arrayContains(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function explode (inputstr, sep)
    sep = sep or ","
    if inputstr then
        local t = {}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do table.insert(t, str) end
        return t
    else return {""} end
end

function distanceToPoint(x,y,x2,y2)
    return math.sqrt(math.abs(x-x2)*math.abs(x-x2) + math.abs(y-y2)*math.abs(y-y2))
end

function difference(a,b)
    return math.abs(a-b)
end

function isMouseOver(x,y,width,height)
    if mx > x and mx < x+width and my > y and my < y+height then
        return true
    end
    return false
end

function recursiveEnumerate(folder, r)
	local lfs = love.filesystem
	local filesTable = lfs.getDirectoryItems(folder)
	for i,v in ipairs(filesTable) do
        local file = folder.."/"..v
        local infoTable = {}
        lfs.getInfo(file, infoTable)
    
		if (infoTable.type == 'file') then
            r[#r+1] = file
		elseif (infoTable.type == 'directory') then
			r = recursiveEnumerate(file, r)
		end
	end
	return r
end

function tableDifference(a, b)
    if a and b then
        local aa = {}
        for k,v in pairs(a) do aa[v]=true end
        for k,v in pairs(b) do aa[v]=nil end
        local ret = {}
        local n = 0
        for k,v in pairs(a) do
            if aa[v] then n=n+1 ret[n]=v end
        end
        return ret
    else
        return {}
    end
end

function isMouseDown()
    if love.mouse.isDown(1) or love.mouse.isDown(2) then return true
    else return false end
end

function math.averageAngles(...)
	local x,y = 0,0
	for i=1,select('#',...) do local a= select(i,...) x, y = x+math.cos(a), y+math.sin(a) end
	return math.atan2(y, x)
end

function math.damp(dt, var, speed, dest)
    speed, dest = speed or 4, dest or 0
    local output = var
    if var < dest then var = var + speed * dt if var >= dest then output = dest else output = var end
    elseif var > dest then var = var - speed * dt if var <= dest then output = dest else output = var end end
    return output
end

function table.removekey(table, key)
    local element = table[key]
    table[key] = nil
    return element
end

-- Returns the distance between two points.
function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end
-- Distance between two 3D points:
function math.dist(x1,y1,z1, x2,y2,z2) return ((x2-x1)^2+(y2-y1)^2+(z2-z1)^2)^0.5 end
 
 
-- Returns the angle between two points.
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end
 
 
-- Returns the closest multiple of 'size' (defaulting to 10).
function math.multiple(n, size) size = size or 10 return math.round(n/size)*size end
 
 
-- Clamps a number to within a certain range.
function math.clamp(low, n, high) return math.min(math.max(low, n), high) end
 
 
-- Linear interpolation between two numbers.
function lerp(a,b,t) return (1-t)*a + t*b end
function lerp2(a,b,t) return a+(b-a)*t end
 
-- Cosine interpolation between two numbers.
function cerp(a,b,t) local f=(1-math.cos(t*math.pi))*.5 return a*(1-f)+b*f end
 
 
-- Normalize two numbers.
function math.normalize(x,y) local l=(x*x+y*y)^.5 if l==0 then return 0,0,0 else return x/l,y/l,l end end
 
 
-- Returns 'n' rounded to the nearest 'deci'th (defaulting whole numbers).
function math.round(n, deci) deci = 10^(deci or 0) return math.floor(n*deci+.5)/deci end
 
 
-- Randomly returns either -1 or 1.
function math.rsign() return love.math.random(2) == 2 and 1 or -1 end
 
 
-- Returns 1 if number is positive, -1 if it's negative, or 0 if it's 0.
function math.sign(n) return n>0 and 1 or n<0 and -1 or 0 end
 
 
-- Gives a precise random decimal number given a minimum and maximum
function math.prandom(min, max) return love.math.random() * (max - min) + min end
 
 
-- Checks if two line segments intersect. Line segments are given in form of ({x,y},{x,y}, {x,y},{x,y}).
function checkIntersect(l1p1, l1p2, l2p1, l2p2)
	local function checkDir(pt1, pt2, pt3) return math.sign(((pt2.x-pt1.x)*(pt3.y-pt1.y)) - ((pt3.x-pt1.x)*(pt2.y-pt1.y))) end
	return (checkDir(l1p1,l1p2,l2p1) ~= checkDir(l1p1,l1p2,l2p2)) and (checkDir(l2p1,l2p2,l1p1) ~= checkDir(l2p1,l2p2,l1p2))
end
 
-- Checks if two lines intersect (or line segments if seg is true)
-- Lines are given as four numbers (two coordinates)
function findIntersect(l1p1x,l1p1y, l1p2x,l1p2y, l2p1x,l2p1y, l2p2x,l2p2y, seg1, seg2)
	local a1,b1,a2,b2 = l1p2y-l1p1y, l1p1x-l1p2x, l2p2y-l2p1y, l2p1x-l2p2x
	local c1,c2 = a1*l1p1x+b1*l1p1y, a2*l2p1x+b2*l2p1y
	local det,x,y = a1*b2 - a2*b1
	if det==0 then return false, "The lines are parallel." end
	x,y = (b2*c1-b1*c2)/det, (a1*c2-a2*c1)/det
	if seg1 or seg2 then
		local min,max = math.min, math.max
		if seg1 and not (min(l1p1x,l1p2x) <= x and x <= max(l1p1x,l1p2x) and min(l1p1y,l1p2y) <= y and y <= max(l1p1y,l1p2y)) or
		   seg2 and not (min(l2p1x,l2p2x) <= x and x <= max(l2p1x,l2p2x) and min(l2p1y,l2p2y) <= y and y <= max(l2p1y,l2p2y)) then
			return false, "The lines don't intersect."
		end
	end
	return x,y
end

function panelMovement(dt, table, dir, ID, speed)
    speed = speed or 4
    ID = ID or "amount"
    if dir > 0 then
        if table[ID] < 1 then
            table[ID] = table[ID] + speed * dt
            if table[ID] > 1 then table[ID] = 1 end
        end
    else
        if table[ID] > 0 then
            table[ID] = table[ID] - speed * dt
            if table[ID] < 0 then table[ID] = 0 end
        end
    end
end

soundStore = {}

function playSoundIfExists(path, notRelative)
    if not soundStore[path] then
        if love.filesystem.getInfo(path) then
            soundStore[path] = love.audio.newSource(path, "static")
            if notRelative then soundStore[path]:setRelative(true) else soundStore[path]:setPosition(player.dx/32,player.dy/32) end
            setEnvironmentEffects(soundStore[path])
            soundStore[path]:setVolume(sfxVolume)
            soundStore[path]:play()
        end
    else
        if soundStore[path]:isPlaying() then soundStore[path]:stop() end
        if notRelative then soundStore[path]:setRelative(true) else soundStore[path]:setPosition(player.dx/32,player.dy/32) end
        setEnvironmentEffects(soundStore[path])
        soundStore[path]:setVolume(sfxVolume)
        soundStore[path]:play()
    end
end