return function(a, b)
	local inplace = require "mini.table.merge.inplace"
	return inplace(inplace({}, a), b)
end
