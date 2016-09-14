--return require"table".unpack or require "_G".unpack

local unpack = require "mini.unpack"

local ok, err = pcall(function() unpack({}, 0, 2^31 - 1) end)
assert(not ok and err:find("too many results to unpack"))

t={"a", "b", "c", "d", nil, "f"}
print( unpack(t) )
print( _G.unpack(t) )

print( unpack(t, 2) )
print( _G.unpack(t, 2) )

print( unpack(t, 2, 5) )
print( _G.unpack(t, 2, 5) )

local errs = {}
for _i, u in ipairs{ _G.unpack, unpack } do
	local ok, err = pcall( function() u(nil) end )
	assert(not ok)
	errs[u] = err
end
assert( type(errs[_G.unpack]) == type(errs[unpack]) )
assert( errs[_G.unpack] == errs[unpack] )

assert( (errs[unpack]):find("bad argument #1 to 'u' (table expected, got nil)", nil, true) )
assert( (errs[_G.unpack]):find("bad argument #1 to 'u' (table expected, got nil)", nil, true) )

--[[
table1 = {true, nil, true, false, nil, true, nil}
table2 = {true, false, nil, false, nil, true, nil}

a1,b1,c1,d1,e1,f1,g1 = unpack( table1)
print ("table1:",a1,b1,c1,d1,e1,f1,g1)

a2,b2,c2,d2,e2,f2,g2 = unpack( table2)
print ("table2:",a2,b2,c2,d2,e2,f2,g2)
]]--
