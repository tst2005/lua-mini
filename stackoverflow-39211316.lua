local tprint = require "mini.tprint.better"

local function recursivefound(t, lvl, cfg)
	local v = cfg.seen[t]
	if not v then
		cfg.c = (cfg.c or 0)+1
		v="t"..cfg.c
		cfg.seen[t]=v
	end
	return v
end
local function table_eq(a,b)
	return (tprint(a, {seen={}, recursivefound=recursivefound})) == (tprint(b, {seen={}, recursivefound=recursivefound}))
end

local t1 = {}

t1[t1]=t1
t1.x = {[t1] = {1, 2, 3}}

local t2 = {}
local t3 = {}

t2[t3]=t2
t3[t2]=t3
t2.x = {[t3] = {1, 2, 3}}
t3.x = {[t2] = {1, 2, 3}}

assert(table_eq(t1, t2) == false)
assert(table_eq(t2, t3) == true)

local t4 = {}
t4[{}] = 1
t4["1"] = {}

local t5 = {}
local t6 = {}
t5[t6] = 1
t5["1"] = t6

assert(table_eq(t4, t5) == false)
