
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

(function() local T={}
T[1]={a = "A",}
T[2]={}
T[3]={"BC",}
T[1][("x")]=T[2]
T[1][(T[2])]="foo"
T[1][("b")]=T[3]
T[1][("rr")]=T[1]
T[1][("c")]=T[3]
return T[1] end)()

]]--
