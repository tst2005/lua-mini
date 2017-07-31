local inplace = require "mini.table.merge.inplace"
local function merge_all(a, b, ...)
	if type(...)=="table" then
		return merge_all(merge_all(a,b), ...)
	end
	return inplace(a,b)
end
return merge_all
