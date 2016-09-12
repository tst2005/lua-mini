
---------
-- convert patterns format between a lua and regexp
-- @module mini.pattern
-- @param pat the lua pattern
-- @return the regexp pattern
-- @usage local lua_to_re = require"mini.pattern".lua_to_re
-- @usage local re_to_lua = require"mini.pattern".re_to_lua
-- @see mini.pattern.lua_to_re
-- @see mini.pattern.re_to_lua

local allowed = {re_to_lua=true, lua_to_re=true}
return setmetatable({}, {
	__index=function(_, k)
		if allowed[k] then
			return require("mini.pattern."..k)
		end
	end,
})
