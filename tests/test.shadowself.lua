
DEBUG_WEAK=({...})[1]

local shadowself = require "mini.shadowself"
local ro2rw      = require "mini.ro2rw"
local function kcount(t)
	local count=0
	for _k in pairs(t) do
		count=count+1
	end
	return count
end
--[[
do
local i = {}
function i:hello()
	return("hello self="..tostring(self))
end
i.t = {"t"}

local r = i:hello()

local o0, cache = shadowself(i)
assert( kcount(cache) == 0 ) -- nothing asked, no method proxy in cache
local o = ro2rw(o0)

assert( o.hello == o.hello, "instable method function value")
assert( o.hello() == r) -- hello method proxy was in cache

assert( kcount(cache) == 1 )

assert( i.t == o.t )
assert( o.t == o.t )

assert( kcount(cache) == 1 ) -- t is not a function/method, then no change in cache

o.t = nil
assert( i.t )
assert( o.t == nil )

o.hello = 1
assert(o.hello == 1)
o.hello = nil
assert(o.hello == nil)

end

print("-- part 2 --")

]]--

do
	local fakeinst = {}
	function fakeinst:hello(a) return a, tostring(self) end

	local str_fakeinst = tostring(fakeinst)
	local o,cache = shadowself(fakeinst)
	assert( kcount(cache) == 0 )

	assert( o.hello )
	assert( kcount(cache) == 1 )		-- hello proxy added

	assert( o.hello	== o.hello )
	assert( kcount(cache) == 1 )		-- no change

	local a, b = o.hello("aa")
	assert( a == "aa" )
	assert( tostring(b) == str_fakeinst)

	local str_hello = tostring(o.hello)
	fakeinst.hello2 = fakeinst.hello	-- backup the hello value into hello2
	assert( kcount(cache) == 1 ) 		-- no change

	assert( o.hello2 )			-- hello == hello2 : only one entry in cache
	assert( kcount(cache) == 1 )

	local hh = fakeinst.hello
	assert( fakeinst.hello2 == fakeinst.hello )

	local h1 = o.hello			-- store the value else the garbage collector will drop it soon
	fakeinst.hello = nil
	assert(fakeinst.hello2 ~= nil)
	assert( kcount(cache) == 1 ) 		-- no change

	collectgarbage();collectgarbage();
	assert( kcount(cache) == 1 )		-- still 1, until h1 exists

	print(o.hello2, str_hello)

	assert( o.hello == nil )
	fakeinst.hello = fakeinst.hello2
	assert( tostring(o.hello), str_hello )

	fakeinst.hello2 = nil
	hh = nil
	collectgarbage();collectgarbage();
	assert( kcount(cache) == 1)
	h1 = nil
	collectgarbage();collectgarbage();
	assert( kcount(cache) == 0)
	
	assert( o.hello )
	assert( kcount(cache) == 1 ) -- hello added again ?

	local h = fakeinst.hello
	fakeinst.hello = nil

	collectgarbage();collectgarbage();
	assert( kcount(cache) == 0)

	assert( o.hello == nil)
	assert( kcount(cache) == 0)

	fakeinst.hello = h
	assert( o.hello )
	assert( kcount(cache) == 1)
	
	print( tostring(o.hello), str_hello )

	--assert( not ( tostring(o.hello) == str_hello) )

	assert( kcount(cache) == 1)
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
