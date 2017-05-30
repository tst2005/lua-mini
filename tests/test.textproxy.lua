local textproxy = require "mini.textproxy"

local foo = textproxy("foo")
assert(type(foo)=="table")
assert(tostring(foo)=="foo")

assert(foo:sub(1,1)=="f" and foo:sub(2,-1)== "oo")

assert(foo:find("o")==2)
assert(foo:upper()=="FOO")

