----------------

-- <thirdparty>
-- pl.compat : https://github.com/stevedonovan/Penlight/blob/master/lua/pl/compat.lua
-- Copyright (c) 2009 Steve Donovan, David Manura
-- License : https://github.com/stevedonovan/Penlight/blob/master/LICENSE.md

--- Lua 5.1/5.2 compatibility
-- The exported function `load` is Lua 5.2 compatible.
-- `compat.setfenv` and `compat.getfenv` are available for Lua 5.2, although
-- they are not always guaranteed to work.
-- @module pl.compat

local compat = {}

--compat.lua51 = _VERSION == 'Lua 5.1'

----------------
-- Load Lua code as a text or binary chunk.
-- @param ld code string or loader
-- @param[opt] source name of chunk for errors
-- @param[opt] mode 'b', 't' or 'bt'
-- @param[opt] env environment to load the chunk in
-- @function compat.load

---------------
-- Get environment of a function.
-- With Lua 5.2, may return nil for a function with no global references!
-- Based on code by [Sergey Rozhenko](http://lua-users.org/lists/lua-l/2010-06/msg00313.html)
-- @param f a function or a call stack reference
-- @function compat.setfenv

---------------
-- Set environment of a function
-- @param f a function or a call stack reference
-- @param env a table that becomes the new environment of `f`
-- @function compat.setfenv

if pcall(load, '') then -- check if it's lua 5.2+ or LuaJIT's with a compatible load
	compat.load = _G.load
else
	local native_load = load
	function compat.load(str,src,mode,env)
		local chunk,err
		if type(str) == 'string' then
			if str:byte(1) == 27 and not (mode or 'bt'):find 'b' then
				return nil,"attempt to load a binary chunk"
			end
			chunk,err = loadstring(str,src)
		else
			chunk,err = native_load(str,src)
		end
		if chunk and env then setfenv(chunk,env) end
		return chunk,err
	end
end
-- </thirdparty>

return compat
