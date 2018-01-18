local ro2rwss = require "mini.proxy.ro2rw-shadowself-metaproxy"
ro2rwss.defaultmap.table = true -- disable error in case of proxy request for a table

--[[
local myclass = class(...)
local inst = instance(myclass)
]]--



-- fake a simple class instance
local inst = {
	print = print,
	foo = function() return 123 end,
	rself = function(self, a) return self, "r", a end,
	n = 123,
	t = {"a table"},
	b = true,
}
function inst:tostring(e) return tostring(e) end

-- convert an instance to an environment
local e = ro2rwss(inst)

assert( print ~= e.print)				-- e.print is a proxy for the original print function
assert( e.notexists == nil )				-- we don't got a proxy for non existant thing
assert( type(e.foo) == "function" )			-- e.foo is a function like the original one
assert( e.b and (e.b == e.b) )				-- e.b is a boolean (not a proxy)
assert( e.n and (e.n == e.n) )				-- e.n is a number (not a proxy)
e.foo = nil						-- drop a value in the e
assert( e.foo == nil )					-- the foo value is really lost (we don't get the original.foo or a new proxy)
assert( e.tostring(123) == "123" )			--
local proxyvalueastext = tostring(e.tostring)		-- remember the value as string to be compared
function inst:tostring(x)
	return "updated"..tostring(x)
end							-- change the instant method (yes it is ugly)
assert( e.tostring(123) == "updated123" )		-- the proxy is still the same function but the result use the updated method
assert( e.tostring==e.tostring )			-- the proxy function is in cache, not generated at each call
assert( proxyvalueastext == tostring(e.tostring) ) -- compare (as string) the previous and current proxy function

print( (e.rself("a"))== inst
	and "1st arg is inst (mkproxy1 used?)"
	or "1st arg (inst) was removed (mkproxy2 used?)")

print("orig print=", print)
do      
	print("list e:")
	for k,v in pairs(e) do
		print(k,v)
	end
	print("/list")
end
