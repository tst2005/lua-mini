
-- http://lua-users.org/wiki/OrderedTable

-- create an empty table that is able to remind the write order.
-- Warning: the order is the first creation. Remove or change will change anything.

local function low_newtable(t, mt)
	local nextkey, firstkey = {}, {}
	nextkey[nextkey] = firstkey
 
	local function onext(self, key)
		while key ~= nil do
			key = nextkey[key]
			local val = self[key]
			if val ~= nil then return key, val end
		end
	end
 
--	local mt = {}
 
	function mt:__newindex(key, val)
print("DEBUG: writeorder.newtable: rawset", key, val)
		rawset(self, key, val)
		if nextkey[key] == nil then
			nextkey[nextkey[nextkey]] = key		-- lastkey = nextkey[nextkey] ; nextkey[lastkey] = key
								-- At the first write, lastkey is firstkey, then nextkey[firstkey] = key
			nextkey[nextkey] = key			-- lastkey = key
		end
	end
 
	function mt:__pairs() return onext, self, firstkey end
 
	return setmetatable(t, mt)
end
local function newtable()
	return low_newtable({}, {})
end
local function updatetable(t)
	local mt = getmetatable(t) or {}
	assert(mt.__newindex==nil, "meta __newindex already set")
	assert( mt.__pairs==nil, "meta __pairs already set")
	return low_newtable(t, mt)
end


local function pairs52(t, ...)
	return ( (getmetatable(t) or {}).__pairs or pairs)(t, ...)
end
return setmetatable({
	newtable=newtable,
	updatetable = updatetable,
	pairs=pairs52
}, {
	__call=function(_, t)
		if not t then
			return newtable()
		end
		return updatetable(t)
	end,
})
