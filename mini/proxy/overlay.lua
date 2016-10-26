--[[

read:
intercept layer d1:					["cc"]=dA,			<- bypass
base layer      d1:	["."]=d1,	[".."]=d0,	["cc"]=d2,			<- orig
write:
intercept       d1:					["cc"]=readonly,		<- bypass
base            d1:					["cc"]=d2,			<- orig


usual read : over[k] or orig[k]
usual write: if over[k]==nil then orig[k]=v else error("readonly")

mount action:
bypass write: assert(over[k]==nil); over[k]=v

umount action:
bypass write: assert(over[k]~=nil); over[k]=nil

]]--

-- solution 1 : use function for __index and __newindex
local function proxyoverlay(orig)
	local over = {}
	return setmetatable({}, {
		__index = function(_self, k)
			if over[k]==nil then
				return orig[k]
			else
				return over[k]
			end
		end,
		__newindex = function(_self, k,v)
			if over[k]~=nil then
				error("readonly", 2)
			else
				orig[k]=v
			end
		end,
	}), over
end

local function movecontent(src, dst)
	assert(type(dst)=="table")
	for k,v in next, src, nil do -- copy all from src to dst
		dst[k]=v
	end
	for k,v in next, dst, nil do -- remove all from dst
		src[k]=nil
	end
	return dst
end

-- solution 2 : use special table for __index and __newindex
local function mutantoverlay(orig) -- make a mutation of the original object
	local mt = getmetatable(orig)
	assert(mt==nil or (mt.__index==nil and mt.__newindex==nil))

	local copy = movecontent(orig, {})

	local proxy, over = mountoverlay(copy)
	if not mt then
		mt={}
		setmetatable(orig, mt)
	end
	mt = mt or {}
	mt.__index = proxy
	mt.__newindex = proxy

	local function unproxy()
		local mt = assert(getmetatable(orig))
		mt.__index = nil
		mt.__newindex = nil
		movecontent(copy, orig)
		if next(mt) == nil then -- mt is an empty table
			mt=nil
			setmetatable(orig, nil)
		end
	end

	return orig, over, unproxy, copy
end

local function overlay(orig, inplace)
	if inplace then
		return mutantoverlay(orig)
	else
		return proxyoverlay(orig)
	end
end

return overlay
