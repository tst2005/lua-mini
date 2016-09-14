local error = error
local function rw2ro(orig, indexbytable, ignorewrite)
	assert(type(orig)=="table")
	return setmetatable({}, {
		__index=indexbytable and orig or function(_self, k)
			assert(_self ~= orig)
			return orig[k]
		end,
		__newindex = function(self, k, v)
			if not ignorewrite and orig[k] ~= v then
				error("readonly table", 2) -- (key="..k.." v="..v..")", 2)
			end
		end,
	})
end

local copy = require "mini.table.shallowcopy"
local type = type
local assert = assert
local pairs = pairs
local setmetatable = setmetatable
local tostring = tostring
local function rw2ro_inline(orig, indexbytable, ignorewrite)
	assert(type(orig)=="table", "invalid arg #1, table expected got "..type(orig))
	local internal = {}
	for k,v in pairs(copy(orig)) do
		internal[k]=v
		orig[k]=nil
	end
	local empty=orig
	return setmetatable(empty, {
		__index=indexbytable and internal or function(_self, k)
			assert(_self==empty)
			return internal[k]
		end,
		__newindex = function(_self, k, v)
			if not ignorewrite and internal[k] ~= v then
				error("readonly table", 2) -- ("..tostring(ignorewrite)..") (key="..tostring(k).." v="..tostring(v)..")", 2)
			end
		end,
	})
end
return rw2ro_inline
