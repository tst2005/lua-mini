local icommon = require "mini.table.icommon"
local tprint = require "mini.tprint"

print(tprint( icommon({"a", "b", "c", "d"}, {"d", "b", "z"})) == '{"b","d",}')
print(tprint( icommon({"nope", "a", "b", "a", "b", "z"}, {"foo", "b", "a", "b", "bar"})) )
