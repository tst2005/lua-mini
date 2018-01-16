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

print("---")
do
	local t = wo()
	t["a"]="1"
	t["b"]="2"
	t["r"]="3"
	t["aa"]="4"
	t["z"]="5"

	t["b"]="6"
	for k,v in pairs(t) do print(k,v) end

	t["b"]=nil
	t["b"]=nil
	t["b"]="6"
	t["bb"]="7"

	for k,v in pairs(t) do print(k,v) end
end
