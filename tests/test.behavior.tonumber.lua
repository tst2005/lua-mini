local tonumber53 = require "behavior.tonumber.to53"
local tonumber52 = require "behavior.tonumber.to52"
local tonumber51 = require "behavior.tonumber.to51"

-- tonumber lua 5.2+ --
do	print("tonumber lua5.2 ...")

	local tonumber = tonumber52
	assert( ("%2.2f"):format( tonumber("10.2") or 0) == "10.20")

	assert( tonumber("10.2", 10) == nil)
	assert( tonumber("-10", 10) == -10)

	for _i, invalid_base in ipairs{ true, false, {}, "z" } do
		local ok, msg = pcall( function() tonumber("-10", invalid_base) end)
		assert(not ok, "should fail but got: "..tostring(msg).." for tonumber(\"-10\", "..tostring(invalid_base)..")")
		--print(ok, msg)
		assert( msg and msg:find("number expected, got "..type(invalid_base)) )
	end

	for _i, valid_base in ipairs{ 2, 10, 16, 35 } do
		local ok, msg = pcall( function() return tonumber("10", valid_base) end)
		assert( ok and msg and type(msg)=="number" and msg==valid_base )
	end

	assert( tonumber(10) == 10 )
--	assert( tonumber(10.2, 10) == nil ) -- lua 5.1-5.2, but not lua 5.3
--	assert( tonumber(10.0,10) == 10 )
end

-- tonumber lua 5.1 --
do	print("tonumber lua5.1 ...")

	local tonumber = tonumber51
	--print("lua 5.1")

	for _i, s in ipairs{ "3",   "3.0",   "3.1416",   "314.16e-2",   "0.31416E1",   "0xff",   "0x56",} do
		assert(type( tonumber51(s, 10) )=="number")
	end
end

-- tonumber lua 5.3
do	print("tonumber lua5.3 ...")

	assert( not pcall(tonumber53, 1.2, 10) )
	assert( pcall(tonumber52, 1.2, 10) )
	assert( pcall(tonumber51, 1.2, 10) )

	local r = math.random()
	assert( not pcall(tonumber53, r, 10) )
	assert( pcall(tonumber52, r, 10) )
	assert( pcall(tonumber51, r, 10) )
end

print("ok")
