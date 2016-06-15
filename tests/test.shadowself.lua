local shadowself = require "mini.class.shadowself"

local i = {}
function i:hello()
	return("hello self="..tostring(self))
end
i.t = {"t"}

local r = i:hello()

local o = shadowself(i)

assert( o.hello == o.hello, "instable method function value")
assert( o.hello() == r)

assert( i.t == o.t )
assert( o.t == o.t )
o.t = nil
assert( i.t )
assert( o.t == nil )

o.hello = 1
assert(o.hello == 1)
o.hello = nil
assert(o.hello == nil)

--[[

local class = require "mini.class"
local instance = class.instance

local foo = class("foo", {})
function foo:hello(who)
	return "hello "..(who or "you!")
end
function foo:hello2(who)
	return "HELLO2 "..(who or "you!")
end

local i1 = instance(foo)
print( i1:hello("bar") )
print("i1.hello", i1.hello)
print("i1.hello", i1.hello)

print( i1.hello(i1, "xxx") )

local o1 = shadowself.newproxy(i1)

print("o1.hello", o1.hello)
print("o1.hello", o1.hello)
print("-----------")
print( o1.hello("bar") )

--i1.hello = i1.hello2
o1.hello = o1.hello2 -- only changed in o1, i1.hello/hello2 still unchanged
print( o1.hello("bar2") )
print( i1:hello("bar2") )

o1.hello = nil -- dual env issue FIXED, nil are now reminded.
local ok, msg = pcall( o1.hello, "bar3")
assert(not ok)

]]--
