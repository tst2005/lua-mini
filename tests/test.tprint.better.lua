local tprint = require "mini.tprint.better"
local inline=true
assert(tprint({}, {inline=inline})=="{}")
assert(tprint({"a"}, {inline=inline})== '{"a",}')
assert(tprint({aa="AA"}, {inline=inline,kshort=true})=='{aa = "AA",}')
assert(tprint({aa="AA"}, {inline=inline,kshort=false})=='{["aa"] = "AA",}')
assert(tprint({"aa"}, {inline=inline,ishort=false})=='{[1] = "aa",}')

inline=false
assert(tprint({}, {inline=inline})=="{\n}")
assert(tprint({"a"}, {inline=inline})=='{\n\t"a",\n}')
assert(tprint({aa="AA"}, {inline=inline,kshort=true})=='{\n\taa = "AA",\n}')
assert(tprint({aa="AA"}, {inline=inline,kshort=false})=='{\n\t["aa"] = "AA",\n}')
assert(tprint({"aa"}, {inline=inline,ishort=false})=='{\n\t[1] = "aa",\n}')

--[[
local t = {}
t.a = {t2 = t}
t.b = "b"
t.n = 3.14
t[1]=true

print("t="..tprint(t))
]]--
