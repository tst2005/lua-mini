
assert(setmetatable)

local function weak_table(mode)
	mode = mode or "k"
	assert(mode==nil or mode=="k" or mode=="v" or mode=="kv", "invalid mode")
	return setmetatable({}, {__mode=mode})
end

return weak_table
