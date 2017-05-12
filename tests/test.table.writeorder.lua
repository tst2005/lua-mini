local wo = require "mini.table.writeorder"
local pairs = wo.pairs

local t = wo()
t["a"]="A"
t["b"]="B"
t["r"]="R"
t["aa"]="AA"
t["z"]="Z"

for k,v in pairs(t) do print(k,v) end
print("order should be a,b,r,aa,z")

t["b"]=nil
t["b"]="BBB"
for i=1,10000 do
	t["b"]=nil
	t["b"]="B"
end
print("---")
for k,v in pairs(t) do print(k,v) end
