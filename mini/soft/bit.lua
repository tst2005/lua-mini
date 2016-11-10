
local bit
if _VERSION == "Lua 5.3" then
	bit = require "mini.soft.bit.bit-lua53"
	-- require"mini.table.shallowcopy"(bit, require"mini.soft.bit.base-lua53only")
else
	bit = {}
end
bit = require "mini.soft.bit.numberlua"

bit.bitop = require "mini.soft.bit.numberlua.bitop"
bit.bit   = bit.bitop
bit.bit32 = require "mini.soft.bit.numberlua.bit32"

return bit
