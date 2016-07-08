local expose = require "mini.proxy.expose"

local o = {
	"a",
	"b",
	x = "x",
	y = "y",
	z = "z",
}

local choice = {
	[1]=false,
	[2]=true,
	[3]=true,
	x=true,
	y=false,
	z=true,
}

local p = expose(o, choice)

--for k,v in pairs(p) do
--	print(k,v)
--end

assert(p[1]==nil)
assert(p[2]=="b")
assert(p[3]==nil)
assert(p[4]==nil)

assert(p.x=="x")
assert(p.y==nil)
assert(p.z=="z")

p.z=1
assert(p.z==1)
p.z=true
assert(p.z==true)
p.z=nil
assert(p.z==nil)

