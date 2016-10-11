
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
-- Start LuaBitOp "bit" compat section.
--

local bit = {} -- LuaBitOp "bit" compatibility


local bit_tobit = base.tobit
function bit.tobit(x)
  x = x % MOD
  if x >= 0x80000000 then x = x - MOD end
  return x
end

--function bit.tohex(x, ...)
--  return tohex(x % MOD, ...)
--end
bit.tohex=tohex

function bit.bnot(x)
  return base.tobit(bnot(x % MOD))
end

local function bit_bor(a, b, c, ...)
  if c then
    return bit_bor(bit_bor(a, b), c, ...)
  elseif b then
    return bit_tobit(bor(a % MOD, b % MOD))
  else
    return bit_tobit(a)
  end
end
bit.bor = bit_bor

local function bit_band(a, b, c, ...)
  if c then
    return bit_band(bit_band(a, b), c, ...)
  elseif b then
    return bit_tobit(band(a % MOD, b % MOD))
  else
    return bit_tobit(a)
  end
end
bit.band = bit_band

local function bit_bxor(a, b, c, ...)
  if c then
    return bit_bxor(bit_bxor(a, b), c, ...)
  elseif b then
    return bit_tobit(bxor(a % MOD, b % MOD))
  else
    return bit_tobit(a)
  end
end
bit.bxor = bit_bxor

function bit.lshift(x, n)
  return bit_tobit(lshift(x % MOD, n % 32))
end

function bit.rshift(x, n)
  return bit_tobit(rshift(x % MOD, n % 32))
end

function bit.arshift(x, n)
  return bit_tobit(arshift(x % MOD, n % 32))
end

function bit.rol(x, n)
  return bit_tobit(lrotate(x % MOD, n % 32))
end

function bit.ror(x, n)
  return bit_tobit(rrotate(x % MOD, n % 32))
end

function bit.bswap(x)
  return bit_tobit(bswap(x % MOD))
end

return bit
