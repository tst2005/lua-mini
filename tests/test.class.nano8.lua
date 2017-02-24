local class = require "mini.class.nano8"
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

	OK=0

	local z = class("z")
	z.metainit = false
	local zz = class("zz", nil, z)
	function zz:metainit(mt)
		assert(type(mt)=="table")
		assert(autometa(self, y)==nil)
		OK = OK +1
	end
	local zz1 = zz("ZZ1")
	local zz2 = zz("ZZ2")
	assert(OK>0)
	assert(OK==1)
end

do
	local OK = 0
	local z = class("z")
	function z:init()
		self.foo = "ok"
		--assert(require "mini.class.autometa"(self, z)==nil)
		return (require "mini.proxy.shadowself"(self)), self
		--return self
	end
	function z:metainit(mt)
		assert(type(mt)=="table")
		local errs = {}
		for k,v in pairs(z) do
			--if k ~= "__metatable" and type(k) == "string" and string.sub(k, 1, 2) == "__" then
			if type(k) == "string" and string.sub(k, 1, 2) == "__" then
				if mt[k]==nil then
					mt[k]=v
				elseif mt[k]~=v then
					errs[#errs+1]=k
				end
			end
		end
		assert(#errs==0)
		OK = OK +1
	end
	function z:__tostring() return "z string" end

	local lock = {}
	lock.__metatable=lock
	lock.__locked=true
	z.__metatable=lock

	local z1,i1 = z("Z1") assert(i1)
	local z2,i2 = z("Z2")
	for k,v in next, (getmetatable(z1)) do
		print(k,v)
	end

	assert(OK>0)
	assert(OK==1)
end

print("OK")
