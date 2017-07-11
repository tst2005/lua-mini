local sync = require "mini.table.sync"

local a = {"foo", "bar", "buz", orig=true, "z"}
local b = {"a", "b", "c", extra="x", [6]="t"}
local c = sync(a,b)

--print(require"mini.tprint"(c))

assert(c~=a)
assert(c==b)
assert(c[1]==a[1] and c[2]==a[2] and c[3]==a[3])
assert(c.orig==true)
assert(c.extra==nil)

