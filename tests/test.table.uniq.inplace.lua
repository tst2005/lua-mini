local uniq = require "mini.table.uniq.inplace"

local t = {"a", "b", "c", "c", "c", "d", "d", "e"}
uniq(t)
assert(t[1]=="a" and t[2]=="b" and t[3]=="c" and t[4]=="d" and t[5]=="e")
print("OK")
