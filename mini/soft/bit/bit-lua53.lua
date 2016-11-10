local common = require"mini.soft.bit.common"
local M = {
	band	= function(a, b)	return a & b	end,
	bor	= function(a, b)	return a | b	end,
	bxor	= function(a, b)	return a ~ b	end,
	bnot	= function(a)		return ~a	end,
	rshift	= function(a, n)	return a >> n	end,
	lshift	= function(a, n)	return a << n	end,
	lrotate = function(a, n)	error("sorry lua5.3 builtin sucks, lrotate not support", 2) end,
	rrotate = function(a, n)	error("sorry lua5.3 builtin sucks, rrotate not support", 2) end,
	arshift = function(a, n)	error("sorry lua5.3 builtin sucks, arshift not support", 2) end,
}
common.lshift = M.lshift
common.rshift = M.rshift
common.band = M.band
M.lrotate = common.lrotate
M.rrotate = common.rrotate
M.arshift = common.arshift
return M
