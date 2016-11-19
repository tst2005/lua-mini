
--[[

# nano class

## what is different ?

 * to create an new instance of <class>, do NOT CALL the class!
 * to create an new instance of <class>, use :
  * require"mini.class.nano2".instance(<class>, ...)
  * or  <class>:newinstance(...)
  * or  <class>.newinstance(<class>, ...)
  * or  getmetatable(<class>):__newinstance(...)
  * or  getmetatable(<class>).__newinstance(<ignored>, ...)
 * <meta>:__call meta is free for custom use
 * the constructor is named "init", set up it on <class>:init(...)
 * the default built-in constructor return the new created instance
 * a custom constructor controls the returned instance, it will be usually end by a `return self` 

## Optionnal / maybe
 * the class name is put in the <class>._name
 * TODO(?): the '_*' class field will be not available from instance (?)

]]--

-- Copyright (c) 2016 TsT <tst2005@gmail.com>

local M = {}
--M._VERSION  = "mini.class.nano v0.1.0"
--M._URL      = 'http://github.com/tst2005/lua-mini'
--M._LICENSE  = 'MIT'

-- get the class_mt.__newinstance to create an instance
local function newinstance(c, ...)
	return assert(
		assert(
			getmetatable(c), "no metatable for this class ?!"
		).__newinstance, "no mt.__newinstance for this class ?!"
	)(c, ...)
end

-- <thirdparty>
-- knife.base : https://github.com/airstruck/knife/blob/master/knife/base.lua
-- Copyright (c) 2015 airstruck
-- MIT License : https://github.com/airstruck/knife/blob/master/license
local base = {
	extend = function(self, subtype)
		subtype = subtype or {}					-- class table
		assert(subtype.newinstance == nil, "this class already has a newinstance method!")
--		subtype.newinstance = newinstance
		local meta = { __index = subtype }			-- instance metatable
		local function __newinstance(_self, ...)
			local instance = setmetatable({}, meta)		-- instance table (with instance metatable)
			return instance:init(...)
		end
		return setmetatable(subtype,
			{__index = self, __newinstance = __newinstance}	-- class metatable
		)
	end,
	init = function(self) return self end,
}
-- </thirdparty>

local function common_class(name, prototype, parent)
	local parent = parent or base:extend()
	local klass = parent:extend(prototype)
	klass.init = (prototype or {}).init or (parent or {}).init -- NOTE: prototype.init is the ClassCommons specs. BUT klass.<init> and parent.<init> should be renamed to follow the nano specs!
	--klass._name = name
	return klass
end

M.class		= common_class
M.instance	= newinstance

M.common	= {class = common_class, instance = newinstance}

return setmetatable(M, {
	__call = function(_, ...)
		return common_class(...)
	end,
})
