
local M = {_TYPE='module', _NAME='bit.numberlua', _VERSION='0.3.1.20120131'}

local floor = math.floor

local MOD = 2^32
local MODM = MOD-1

local function memoize(f)
  local mt = {}
  local t = setmetatable({}, mt)
  function mt:__index(k)
    local v = f(k); t[k] = v
    return v
  end
  return t
end

local function make_bitop_uncached(t, m)
  local function bitop(a, b)
    local res,p = 0,1
    while a ~= 0 and b ~= 0 do
      local am, bm = a%m, b%m
      res = res + t[am][bm]*p
      a = (a - am) / m
      b = (b - bm) / m
      p = p*m
    end
    res = res + (a+b)*p
    return res
  end
  return bitop
end

local function make_bitop(t)
  local op1 = make_bitop_uncached(t,2^1)
  local op2 = memoize(function(a)
    return memoize(function(b)
      return op1(a, b)
    end)
  end)
  return make_bitop_uncached(op2, 2^(t.n or 1))
end

-- ok?  probably not if running on a 32-bit int Lua number type platform
function M.tobit(x)
  return x % 2^32
end

M.bxor = make_bitop {[0]={[0]=0,[1]=1},[1]={[0]=1,[1]=0}, n=4}
local bxor = M.bxor

function M.bnot(a)   return MODM - a end
local bnot = M.bnot

function M.band(a,b) return ((a+b) - bxor(a,b))/2 end
local band = M.band

function M.bor(a,b)  return MODM - band(MODM - a, MODM - b) end
local bor = M.bor

local lshift, rshift -- forward declare

function M.rshift(a,disp) -- Lua5.2 insipred
  if disp < 0 then return lshift(a,-disp) end
  return floor(a % 2^32 / 2^disp)
end
rshift = M.rshift

function M.lshift(a,disp) -- Lua5.2 inspired
  if disp < 0 then return rshift(a,-disp) end 
  return (a * 2^disp) % 2^32
end
lshift = M.lshift

function M.tohex(x, n) -- BitOp style
  n = n or 8
  local up
  if n <= 0 then
    if n == 0 then return '' end
    up = true
    n = - n
  end
  x = band(x, 16^n-1)
  return ('%0'..n..(up and 'X' or 'x')):format(x)
end
local tohex = M.tohex

function M.extract(n, field, width) -- Lua5.2 inspired
  width = width or 1
  return band(rshift(n, field), 2^width-1)
end
local extract = M.extract

function M.replace(n, v, field, width) -- Lua5.2 inspired
  width = width or 1
  local mask1 = 2^width-1
  v = band(v, mask1) -- required by spec?
  local mask = bnot(lshift(mask1, field))
  return band(n, mask) + lshift(v, field)
end
local replace = M.replace

function M.bswap(x)  -- BitOp style
  local a = band(x, 0xff); x = rshift(x, 8)
  local b = band(x, 0xff); x = rshift(x, 8)
  local c = band(x, 0xff); x = rshift(x, 8)
  local d = band(x, 0xff)
  return lshift(lshift(lshift(a, 8) + b, 8) + c, 8) + d
end
local bswap = M.bswap

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

function M.btest(x, y) -- Lua5.2 inspired
  return band(x, y) ~= 0
end

return M
