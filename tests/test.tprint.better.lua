local tprint = require "mini.tprint.better"

local t = {}
t.a = {t2 = t}
t.b = "b"
t.n = 3.14
t[1]=true

print("t="..tprint(t))
