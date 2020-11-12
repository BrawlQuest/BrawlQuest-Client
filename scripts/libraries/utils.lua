
function copy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
    return res
  end

  function arrayContains (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function explode (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function distanceToPoint(x,y,x2,y2)
    return math.sqrt(math.abs(x-x2)*math.abs(x-x2) + math.abs(y-y2)*math.abs(y-y2))
end

function difference(a,b)
    return math.abs(a-b)
end

function isMouseOver(x,y,width,height)
    cx,cy = love.mouse.getPosition()

    if cx > x and cx < x+width and cy > y and cy < y+height then
        return true
    end
    
    return false
end

function tableLength(T)
	return #T
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
