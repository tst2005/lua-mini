
local M = {}
local lshift, rshift, band -- forward declare


function M.rrotate(x, disp)  -- Lua5.2 inspired
	disp = disp % 32
	local low = band(x, 2^disp-1)
	return rshift(x, disp) + lshift(low, 32-disp)
end
local rrotate = M.rrotate

function M.lrotate(x, disp)  -- Lua5.2 inspired
  return rrotate(x, -disp)
end
local lrotate = M.lrotate

M.rol = M.lrotate  -- LuaOp inspired
M.ror = M.rrotate  -- LuaOp insipred

function M.arshift(x, disp) -- Lua5.2 inspired
  local z = rshift(x, disp)
  if x >= 0x80000000 then z = z + lshift(2^disp-1, 32-disp) end
  return z
end
local arshift = M.arshift

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
