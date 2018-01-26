
-- data dumper (tprint en version du code pour reconstruire les donnees exacte)

local R = {
	a = "A",
	b = {"BC"},
}
R.c = R.b
R.rr=R
R.x={}
R[R.x]="foo"

local tprint = require "mini.tprint"
local datadump = require "mini.datadump"
local ret = datadump(R, {inline=nil})
print(ret)

--[[ Result:

(function() local T={};local function tset(a,b,c) a[b]=c end
T[1]={a = "A",}
T[2]={"BC",}
T[3]={}
tset(T[1],"c",T[2])
tset(T[1],"b",T[2])
tset(T[1],"x",T[3])
tset(T[1],"rr",T[1])
tset(T[1],T[3],"foo")
return T[1] end)()

]]--
