
return setmetatable({
	clean = function()
		local copy = require "mini.table.shallowcopy"
		local preload = require"package".preload
		for k,v in next, copy(preload), nil do
			preload[k]=nil
		end
	end,
}, {
	__index=function(_, k)
		return require("mini."..k)
	end,
})

