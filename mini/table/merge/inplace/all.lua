local inplace = require "mini.table.merge.inplace"
return function(a, ...)
	local t_args = {...}
	for _i,b in ipairs(t_args) do
		inplace(a,b)
	end
	return a
end
