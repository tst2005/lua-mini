
--[[

# nano class

## differ point

 * use <class>:newinstance(<args>) to create an new instance of <class>, do not call the class!
 * <meta>:__call meta is free for custom use
 * the new instance constructor is named "__newinstance", set up it on <class>:__newinstance(...)
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
		subtype = subtype or {}
		local meta = { __index = subtype }
		assert(not subtype.newinstance)
		subtype.newinstance = function(_self, ...)
			local instance = setmetatable({}, meta)
			return instance:__newinstance(...)
		end
		return setmetatable(subtype, {__index = self})
	end,
	__newinstance = function(self) return self end,
}
-- </thirdparty>

local function newclass(name, prototype, parent)
	local parent = parent or base:extend()
	local klass = parent:extend(prototype)
	klass.__newinstance = (prototype or {}).__newinstance or (parent or {}).__newinstance
	--klass._name = name
	return klass
end

--[[
local function newinstance(class, ...)
        return class(...)
end
]]--

M.newclass = newclass
return setmetatable(M, {
	__call = function(_, ...)
		return newclass(...)
	end,
})
