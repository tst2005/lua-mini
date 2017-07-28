local args = {...}
return function(G)
	local modname = (args[1] or ""):gsub("%.init$","") -- the module name (should be *.tonumber.to51 or *.tonumber.to52 or *.tonumber.to53)
	local tonumber52 = require( modname:gsub("%.to5.*$","")..".to52" ) -- tonumber.to52
	return function(e, base)
		if base ~= nil then
			if type(base) ~= "number" then
				error("bad argument #2 to 'tonumber' (number expected, got "..type(base)..")",2)
			end
			if type(e) ~= "string" then
				error("bad argument #1 to 'tonumber' (string expected, got "..type(e)..")",2)
			end
		end
		return tonumber52(e, base)
	end
end
