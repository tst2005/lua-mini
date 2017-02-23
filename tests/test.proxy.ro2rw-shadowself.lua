local ro2rwss = require "mini.proxy.ro2rw-shadowself"
local inst = {
	print = print,
	foo = function() return 123 end,
	rself = function(self, a) return self, "r", a end,
	n = 123,
	t = {"a table"},
	b = true,
}
function inst:tostring(x) return tostring(x) end

local x = ro2rwss(inst)


--print("inst", inst)
--print("x", x)

--print(print, x.print, x.print)

assert( x.notexists == nil )
assert( type(x.foo) == "function" )
assert( x.b and (x.b == x.b) )
assert( x.n and (x.n == x.n) )

x.foo = nil
assert( x.foo == nil )
--x.print("foo")
assert( x.tostring(123) == "123" )

local proxyvalueastext = tostring(x.tostring)

function inst:tostring(x)
	return "updated"..tostring(x)
end

assert( x.tostring(123) == "updated123" )

assert( x.tostring==x.tostring )
assert( proxyvalueastext == tostring(x.tostring) )

print( (x.rself("a"))== inst and "1st arg is inst" or "1st arg (inst) was removed")

--assert( table.concat( {x.rself("a")}, ";")  == "r;a")


