local assoc = require "assoc"
local get,set = assoc.get, assoc.set
local get2,set2 = assoc.get2, assoc.set2

local c = {} -- cache

local a, b = {"a"}, {"b"}
local ab = function() return "ab" end

set2(c, ab, a, b)
assert( get2(c, a, b) == ab )

set(c, "ok", 1, 2, 3, 4)
--for k,v in pairs(c) do print(k,v) end

print(get(c, 1, 2, 3, 4))
