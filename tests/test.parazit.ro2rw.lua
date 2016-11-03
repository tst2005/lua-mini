local ro2rw = require "mini.parazit.ro2rw"

local para = ro2rw() -- instance() ?

local foo = {"foo1", "foo2"}

local bar = para:attach(foo)
assert(foo==bar)
assert(bar[1]=="foo1")
assert(rawget(bar,1)==nil)
bar[1]="bar1"
assert(bar[1]=="bar1")
assert(rawget(bar,1)==nil)

assert( para:detach() == foo)
assert(getmetatable(foo)==nil)
assert(foo[1]=="foo1")
assert(rawget(foo, 1)=="foo1")

print("OK")
