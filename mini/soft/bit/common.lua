
local M = {}

-- <thirdparty bit.numberlua>
local lshift, rshift, band -- forward declare

local function CHECK(x)
	if not( x >= 0x0 and x<= 4294967295 ) then
		return band(x, 0xffffffff)
	end
	return x
end

local
function rrotate(x, disp)  -- Lua5.2 inspired
	disp = disp % 32
	local low = band(x, 2^disp-1)
	return CHECK( rshift(x, disp) + lshift(low, 32-disp) )
end
M.rrotate = rrotate

local
function lrotate(x, disp)  -- Lua5.2 inspired
	return CHECK( rrotate(x, -disp) )
end
M.lrotate = lrotate

M.rol = M.lrotate  -- LuaOp inspired
M.ror = M.rrotate  -- LuaOp insipred

local
function arshift(x, disp) -- Lua5.2 inspired
	local z = rshift(x, disp)
	if x >= 0x80000000 then z = z + lshift(2^disp-1, 32-disp) end
	return CHECK(z)
end
M.arshift = arshift

-- </thirdparty>

local proxyM = setmetatable({}, {
	__index = M,
	__newindex = function(self, k, v)
		if k == "lshift" then
			lshift = v
		elseif k == "rshift" then
			rshift = v
		elseif k == "band" then
			band = v
		else
			M[k]=v
		end
	end,
})
return proxyM
