local class = require "mini.class.nano6"
local instance = assert(class.instance)

do
	local OK = 0

	local x = class("x", {
		init = function(self, what)
			self.what = what
			return self
		end,
		metainit = function(self, mt)
			OK = OK + 1
		end,
	})

	local x1 = x("X1")
	local x2 = x("X2")
	assert(OK > 0)
	assert(OK==1)
end

-- but, class -> init/metainit -> instance does not use metainit

do
	local OK = 0

	local x = class("x", nil, nil)
	function x:init(what)
		self.what = what
		return self
	end
	function x:metainit(mt)
		OK = OK + 1
	end

	local x1 = x("X1")
	local x2 = x("X2")

	assert(OK>0)
	assert(OK==1)
	--print(OK == 0 and "yes" or "no", ": bad case is known")
end

-- workaround:  class -> init/metainit -> subclass -> instance

do
	local OK = 0

	local x = class("x", nil, nil)
	function x:init(what)
		self.what = what
		return self
	end
	function x:metainit(mt)
		OK = OK +1
	end

	local x = class("x2", x)

	local x1 = x("X1")
	local x2 = x("X2")

	assert(OK>0)
	assert(OK==1)
end

do
	local OK = 0

	local autometa = require "mini.class.autometa"
	local y = class("y")
	function y:init(what)
		return self
	end
	function y:metainit(mt)
		assert(type(mt)=="table")
		assert(autometa(self, y)==nil)
		OK = OK +1
	end
	y.__foo = 123

	local y1 = y("Y1")
	local y2 = y("Y2")
	assert(getmetatable(y1).__foo == 123)
	assert(getmetatable(y2).__foo == 123)

	assert(OK>0)
	assert(OK==1)
end

print("OK")
