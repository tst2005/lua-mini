
--[[

# nano class

## differ point

 * use <class>:newinstance(<args>) to create an new instance of <class>, do not call the class!
 * <meta>:__call meta is free for custom use
 * the new instance constructor is named "init", set up it on <class>:init(...)
 * the default built-in constructor return the new created instance
 * a custom constructor controls the returned instance, it will be usually end by a `return self` 
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
		assert(not subtype.newinstance)
		subtype.newinstance = function(_self, ...)
			local instance = setmetatable({}, meta)
			return instance:init(...)
		end
		return setmetatable(subtype, {__index = self})
	end,
	init = function(self) return self end,
}
-- </thirdparty>

local function common_class(name, prototype, parent)
	local parent = parent or base:extend()
	local klass = parent:extend(prototype)
	klass.init = (prototype or {}).init or (parent or {}).init
	--klass._name = name
	return klass
end

M.newclass	= common_class
M.class		= common_class
--M.instance	= function(c, ...) return c:newinstance(...) end
return setmetatable(M, {
	__call = function(_, ...)
		return common_class(...)
	end,
})
