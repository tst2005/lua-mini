local tonumber = require "mini.compat-tonumber".tonumber2

-- tonumber lua 5.2+ --

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

-- tonumber lua 5.1 --
print("lua 5.1")

local tonumber51 = require "mini.compat-tonumber".tonumber51
for _i, s in ipairs{ "3",   "3.0",   "3.1416",   "314.16e-2",   "0.31416E1",   "0xff",   "0x56",} do
	print(s, tonumber51(s, 10))
end
