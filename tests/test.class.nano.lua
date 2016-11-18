local class = require "mini.class.nano".newclass

local foo = class("foo", nil, nil)
function foo:hello() return "hello" end

local bar = class("bar", nil, foo)
function bar:world() return "world" end
function bar:hello() return "hayllo "..self:world() end

assert(foo.hello and foo:hello()=="hello")
assert(foo.world==nil)
assert(bar.hello and bar:hello()=="hayllo world")


assert(foo.newinstance)
local foo1 = assert( foo:newinstance() )
assert(foo1:hello()=="hello")

local bar1 = assert( bar:newinstance() )
assert(bar1:hello()=="hayllo world")

--assert(foo._name == "foo" and bar._name == "bar")
--print(foo1._name == nil)
--print(bar1._name == nil)

------------------------------------------------------------------

local echo_class = class("echo", nil, nil)
function echo_class:__newinstance(what)
	self.what = assert(what)
	return self
end
function echo_class:hello()
	return self.what
end

local echo1 = assert( echo_class:newinstance("la la la la") )
local echo2 = assert( echo_class:newinstance("pom pom pom") )
assert(echo1:hello()=="la la la la")
assert(echo2:hello()=="pom pom pom")

print("OK")
