-- un module lua_pattern



local re_to_lua = require "mini.pattern.re_to_lua"
assert( ("%"):gsub("%%", "%%%%") == "%%")
assert( ([[\\]]):gsub([[\\]], [[%%\]]) == [[%\]])

local lua_to_re = require "mini.pattern.lua_to_re"
do
	assert( ([[%\]]):gsub([[%%\]], [[\\]]) == [[\\]])
	assert( not ([[%]]):find("%%%%") )
	assert( ([[%%]]):gsub("%%%%", "%%") == "%")
	assert( ... )
	
	local luapat = "\\([%^%$%(%)%%%.%[%]%*%+%-%?])"
	print( re_to_lua_pattern(lua_to_re_pattern(luapat)), luapat)

end
