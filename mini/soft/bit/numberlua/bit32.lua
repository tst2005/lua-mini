
local floor = math.floor

local MOD = 2^32
local MODM = MOD-1

local base = require "mini.soft.bit.numberlua"
local tohex = base.tohex
local bor, band, bnot = base.bor, base.band, base.bnot
local bxor = base.bxor
local lshift, rshift = base.lshift, base.rshift
local arshift, rrotate, lrotate, bswap = base.arshift, base.rrotate, base.lrotate, base.bswap

--
-- Start Lua 5.2 "bit32" compat section.
--

local bit32 = {} -- Lua 5.2 'bit32' compatibility

function bit32.bnot(x)
  return (-1 - x) % MOD
end

local function bit32_bxor(a, b, c, ...)
  local z
  if b then
    a = a % MOD
    b = b % MOD
    z = bxor(a, b)
    if c then
      z = bit32_bxor(z, c, ...)
    end
    return z
  elseif a then
    return a % MOD
  else
    return 0
  end
end
bit32.bxor = bit32_bxor

local function bit32_band(a, b, c, ...)
  local z
  if b then
    a = a % MOD
    b = b % MOD
    z = ((a+b) - bxor(a,b)) / 2
    if c then
      z = bit32_band(z, c, ...)
    end
    return z
  elseif a then
    return a % MOD
  else
    return MODM
  end
end
bit32.band = bit32_band

local function bit32_bor(a, b, c, ...)
  local z
  if b then
    a = a % MOD
    b = b % MOD
    z = MODM - band(MODM - a, MODM - b)
    if c then
      z = bit32_bor(z, c, ...)
    end
    return z
  elseif a then
    return a % MOD
  else
    return 0
  end
end
bit32.bor = bit32_bor

function bit32.btest(...)
  return bit32_band(...) ~= 0
end

function bit32.lrotate(x, disp)
  return lrotate(x % MOD, disp)
end

function bit32.rrotate(x, disp)
  return rrotate(x % MOD, disp)
end

function bit32.lshift(x,disp)
  if disp > 31 or disp < -31 then return 0 end
  return lshift(x % MOD, disp)
end

function bit32.rshift(x,disp)
  if disp > 31 or disp < -31 then return 0 end
  return rshift(x % MOD, disp)
end

function bit32.arshift(x,disp)
  x = x % MOD
  if disp >= 0 then
    if disp > 31 then
      return (x >= 0x80000000) and MODM or 0
    else
      local z = rshift(x, disp)
      if x >= 0x80000000 then z = z + lshift(2^disp-1, 32-disp) end
      return z
    end
  else
    return lshift(x, -disp)
  end
end

function bit32.extract(x, field, ...)
  local width = ... or 1
  if field < 0 or field > 31 or width < 0 or field+width > 32 then error 'out of range' end
  x = x % MOD
  return extract(x, field, ...)
end

function bit32.replace(x, v, field, ...)
  local width = ... or 1
  if field < 0 or field > 31 or width < 0 or field+width > 32 then error 'out of range' end
  x = x % MOD
  v = v % MOD
  return replace(x, v, field, ...)
end

return bit32
