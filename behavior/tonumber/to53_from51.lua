local args = {...}
return function(_G)
	local modname = (args[1] or ""):gsub("%.init$","") -- the module name (should be *.tonumber.to51 or *.tonumber.to52 or *.tonumber.to53)
	local tonumber52 = require( modname:gsub("%.to5.*$","")..".to52" ) -- tonumber.to52
	return function(e, base)
		if base ~= nil then
			if type(base) ~= "boolean" then
				error("arg2 must be boolean",2)
			end
			if type(e) ~= "string" then
				error("arg1 must be a string",2)
			end
		end
		return tonumber52(e, base)
	end
end
