--[[

# nano class

## similar

 * the new instance constructor is named "init", set up it on <class>:init(...)
 * the default built-in constructor return the new created instance

## different

 * a custom constructor controls the returned instance, it will usually end by a `return self` (do not forget it)
 * the class name is put in the <class>._name
 * TODO(?): the '_*' class field will be not available from instance (?)

]]--

-- Copyright (c) 2016 TsT <tst2005@gmail.com>

local M = {}
--M._VERSION  = "mini.class.nano v0.1.0"
--M._URL      = 'http://github.com/tst2005/lua-mini'
--M._LICENSE  = 'MIT'


-- <thirdparty>
-- knife.base : https://github.com/airstruck/knife/blob/master/knife/base.lua
-- Copyright (c) 2015 airstruck
-- MIT License : https://github.com/airstruck/knife/blob/master/license
local base = {
	extend = function(self, subtype)
		subtype = subtype or {}				-- class table
		local meta = { __index = subtype }		-- instance metatable
		local metainittodo = true
		local class_mt = { __index = self }
		class_mt.__call = function(self, ...)
			local instance = setmetatable({}, meta)
			if metainittodo and instance.metainit then
				metainittodo = nil
				instance:metainit(meta)
			end
			return assert(instance:init(...), "instance is nil ? check the class:init() function return")
		end
		return setmetatable(subtype, class_mt)		-- class table and class metatable
	end,
	init = function(self) return self end,
	metainit = function() end,
}
-- </thirdparty>

local function common_class(name, prototype, parent)
	local parent = parent or base:extend()
	local klass = parent:extend(prototype)
	klass.init = (prototype or {}).init or (parent or {}).init
	assert(klass.init)
	assert(klass.metainit)
	klass._name = name
	return klass
end

local function common_instance(c, ...)
        return c(...)
end

M.class		= common_class
M.instance	= common_instance
return setmetatable(M, {
	__call = function(_, ...)
		return common_class(...)
	end,
})
