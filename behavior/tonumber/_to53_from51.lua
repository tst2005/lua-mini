local args = {...}
return function(_G)
	local modname = (args[1] or ""):gsub("%.init$","") -- the module name (should be *.tonumber.to51 or *.tonumber.to52 or *.tonumber.to53)
	local parentname = modname:gsub("%.to5.*$","")
	local tonumber52 = require( parentname..".to52" ) -- tonumber.to52
	return require( parentname..".to53_from52" )( {tonumber = tonumber52} )
end
