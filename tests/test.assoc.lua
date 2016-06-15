local assoc = require "mini.assoc"

--[[
local get,set = assoc.getN, assoc.setN
local get2,set2 = assoc.get2, assoc.set2

local c = {} -- cache

local a, b = {"a"}, {"b"}
local ab = function() return "ab" end

set2(c, ab, a, b)
assert( get2(c, a, b) == ab )

set(c, "ok", 1, 2, 3, 4)

print(get(c, 1, 2, 3, 4))

]]--

local A = assoc()
A:set("f1", 1, 2, 3)
-- A:set("f2", 1 2)  -- FIXME
A:set("f2", 4, 5, 6)

assert( A:get(1, 2, 3) == "f1")
assert( A:get(4, 5, 6) == "f2")
print("ok")
