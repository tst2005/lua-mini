local tonumber = require "tonumber".tonumber2

assert( ("%2.2f"):format( tonumber("10.2") or 0) == "10.20")

assert( tonumber("10.2", 10) == nil)
assert( tonumber("-10", 10) == -10)

for _i, invalid_base in ipairs{ true, false, {}, "z" } do
	local ok, msg = pcall( function() tonumber("-10", invalid_base) end)
	assert( not ok and msg and msg:find("number expected, got "..type(invalid_base)) )
end

for _i, valid_base in ipairs{ 2, 10, 16, 35 } do
	local ok, msg = pcall( function() return tonumber("10", valid_base) end)
	assert( ok and msg and type(msg)=="number" and msg==valid_base )
end

assert( tonumber(10) == 10 )
assert( tonumber(10.2, 10) == nil )
