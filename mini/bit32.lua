-- http://lua-users.org/lists/lua-l/2015-05/msg00120.html
-- https://github.com/daurnimator/lua-http/blob/master/http/bit.lua
-- for old lua => posix.bit32 (removed from https://github.com/luaposix/luaposix/pull/206/commits/a7bdfab414b9d633b18bf6368c8e66dcb684b70c )
-- http://bitop.luajit.org/api.html
-- compat: https://github.com/SquidDev/urn/blob/master/lib/lua/bit32.lua

local function requireany(names)
	for _i, name in ipairs(names) do
		local ok, mod = pcall(require, name)
		if ok and type(mod)=="table" then
			return mod
		end
	end
	return nil
end
return requireany {"bitop", "bit", "bit32", "mini.soft.bit.bit-lua53"}
