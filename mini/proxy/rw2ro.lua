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

return rw2ro
