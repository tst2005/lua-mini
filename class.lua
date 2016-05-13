
local common = {}
common._VERSION  = "mini.class v0.1.0"
common._URL      = 'http://github.com/tst2005/lua-mini'
common._LICENSE  = 'MIT LICENSE <http://www.opensource.org/licenses/mit-license.php>'


-- <thirdparty>
-- knife.base : https://github.com/airstruck/knife/blob/master/knife/base.lua
-- Copyright (c) 2015 airstruck
-- MIT License : https://github.com/airstruck/knife/blob/master/license
local base = {
	extend = function(self, subtype)
		subtype = subtype or {}
		local meta = { __index = subtype }
		return setmetatable(subtype, {
			__index = self,
			__call = function(self, ...)
				local instance = setmetatable({}, meta)
				return instance, instance:init(...)
			end,
			__class = assert(common.class),
			__instance = assert(common.instance),
		})
	end,
	init = function() end,
}
-- </thirdparty>

common.class = function(name, prototype, parent)
	local parent = parent or base:extend()
	local klass = parent:extend(prototype)
	klass.init = (prototype or {}).init or (parent or {}).init
	klass.name = name
	return klass
end

common.instance = function(class, ...)
        return class(...)
end

common.autometa = function(...)
	return require "mini.class.autometa"(...)
end

local M = setmetatable({}, {
	__call = function(_, ...)
		return common.class(...)
	end,
	__index = common,
	__newindex = function() error("read-only", 2) end,
	__metatable = false,
})

return M
