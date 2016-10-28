local proxyctl = require "mini.proxy.ctl"

local t = {}
local ctl = proxyctl(t,
	function(self) end,
	function(self) end
)
assert(ctl:status()==false)
ctl:start()
assert(ctl:status()==true)
ctl:stop()
assert(ctl:status()==false)
