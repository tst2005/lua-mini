
local function ro2rw(orig)
	assert(type(orig)=="table")
	local lost = {} -- uniq value
	local internal = {} -- the internal table use to store value
	return setmetatable({}, {
		__index=function(_self, k)
			assert(_self ~= orig)
			if internal[k] == nil then
				return orig[k]
			end
			if internal[k] == lost then
				return nil
			end
			return internal[k]
		end,
		__newindex = function(self, k, v)
			if v == nil then
				internal[k] = lost
			else
				internal[k] = v
			end
		end,
	})
end

return ro2rw
