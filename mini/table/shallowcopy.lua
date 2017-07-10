local pairs = pairs
-- https://github.com/premake/premake-core/blob/master/src/base/table.lua#L39
return function(object)
	local copy = {}
	for k, v in pairs(object) do
		copy[k] = v
	end
	return copy
end

-- see also:
-- https://github.com/amireh/lua_cliargs/blob/master/src/cliargs/utils/shallow_copy.lua
-- courtesy of http://lua-users.org/wiki/CopyTable
--[[
local function shallow_copy(orig)
	assert(type(orig)=="table")
	if type(orig) == 'table' then
		local copy = {}

		for orig_key, orig_value in pairs(orig) do
			copy[orig_key] = orig_value
		end

		return copy
	else -- number, string, boolean, etc
		return orig
	end
end
]]--
