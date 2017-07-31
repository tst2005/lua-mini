local inplace = require "mini.table.merge.tonew"
local function merge_all(a, b, ...)
	if type(...)=="table" then
		return merge_all(merge_all(a,b), ...)
	end
	return tonew(a,b)
end
