
DEBUG_WEAK=({...})[1]

local shadowself = require "mini.class.shadowself"
local dualenv    = require "mini.class.dualenv"


local i = {}
function i:hello()
	return("hello self="..tostring(self))
end
i.t = {"t"}

local r = i:hello()

local o = dualenv(shadowself(i))

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

print("-- part 2 --")
do
	local fakeinst = {}
	function fakeinst:hello(a) return a, tostring(self) end

	local str_fakeinst = tostring(fakeinst)
	local o = shadowself(fakeinst)
	assert( o.hello	== o.hello )
	local a, b = o.hello("aa")
	assert( a == "aa" )
	assert( tostring(b) == str_fakeinst)

	local str_hello = tostring(o.hello)

print("backup the hello value into hello2")
	fakeinst.hello2 = fakeinst.hello
	fakeinst.hello = nil

	collectgarbage();collectgarbage();
print("CG;CG;")
	print(o.hello2, str_hello)
	assert( o.hello == nil )
	fakeinst.hello = fakeinst.hello2
	assert( tostring(o.hello), str_hello )

	fakeinst.hello2 = nil
	local h = fakeinst.hello
	fakeinst.hello = nil

	collectgarbage();collectgarbage();

	assert( o.hello == nil)
	fakeinst.hello = h
	print( o.hello, str_hello)
end

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
