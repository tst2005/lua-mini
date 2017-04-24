local class = require "mini.class.pico"
local foo = class()
function foo:hello() return "hello" end
local bar = class(nil, foo)
function bar:world() return "world" end
function bar:hello() return "hayllo "..self:world() end


assert(foo.hello and foo:hello()=="hello")
assert(foo.world==nil)
assert(bar.hello and bar:hello()=="hayllo world")
print("OK")
