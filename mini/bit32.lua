-- http://lua-users.org/lists/lua-l/2015-05/msg00120.html
-- https://github.com/daurnimator/lua-http/blob/master/http/bit.lua
-- for old lua => posix.bit32 (removed from https://github.com/luaposix/luaposix/pull/206/commits/a7bdfab414b9d633b18bf6368c8e66dcb684b70c )
-- http://bitop.luajit.org/api.html

local function softrequire(name)
	local ok, mod = pcall(require, name)
	return ok and type(mod)=="table" and mod or nil
end
return softrequire "bitop" or softrequire "bit" or softrequire "bit32" or softrequire "mini.soft.bit32-forlua53" or nil
