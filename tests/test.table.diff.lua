local diff = require "mini.table.diff"

local a = {"a", "b", "buz", orig="y"}
local b = {"a", "bar", "c", extra="x"}

local function chg(a,b,k,va,vb)
	print("-"..k.."="..tostring(va))
	print("+"..k.."="..tostring(vb))
end
local function less(a,b,k,va,vb)
	print("-"..k.."="..tostring(va))
end
local function more(a,b,k,va,vb)
	print("+"..k.."="..tostring(vb))
end
local function com(a,b,k,va,vb)
	assert(va==vb)
	print(" "..k.."="..tostring(va))
end

diff(a,b, chg, less, more, com)



--print(require"mini.tprint"(c))
--[[
assert(c~=a)
assert(c==b)
assert(c[1]==a[1] and c[2]==a[2] and c[3]==a[3])
assert(c.orig==true)
assert(c.extra==nil)
]]--
