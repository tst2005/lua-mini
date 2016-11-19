local class = require "mini.class.nano5"
local instance = assert(class.instance)

do
	local OK = false

	local x = class("x", {
		init = function(self, what)
			self.what = what
			return self
		end,
		metainit = function(self, mt)
			OK = true
		end,
	})

	local x1 = x("X1")
	local x2 = x("X2")
	assert(OK)
end

-- but, class -> init/metainit -> instance does not use metainit

do
	local OK = false

	local x = class("x", nil, nil)
	function x:init(what)
		self.what = what
		return self
	end
	function x:metainit(mt)
		OK = true
	end

	local x1 = x("X1")
	local x2 = x("X2")

	print(not OK and "yes" or "no", ": bad case is known")
end

-- workaround:  class -> init/metainit -> subclass -> instance

do
	local OK = false

	local x = class("x", nil, nil)
	function x:init(what)
		self.what = what
		return self
	end
	function x:metainit(mt)
		OK = true
	end

	local x = class("x2", x)

	local x1 = x("X1")
	local x2 = x("X2")

	assert(OK)
end

print("OK")
