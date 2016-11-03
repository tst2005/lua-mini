local ro2rw = require "mini.parazit.ro2rw"

local para = ro2rw() -- instance() ?

local foo = {}

local bar = para:attach(foo)

print(bar[1])
bar[1]="bar"
print(bar[1])
