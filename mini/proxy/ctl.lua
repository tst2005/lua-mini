local class = require "mini.class"
local instance = assert(class.instance)

local proxyctl = class("proxyctl")
function proxyctl:init(orig, handler_to_start, handler_to_stop)
	self._enabled	= false
	self._orig	= assert(orig)
	self._start	= assert(handler_to_start)
	self._stop	= assert(handler_to_stop)
end

function proxyctl:start(...)
	if self._start then
		self._enabled = true
		return self._start(self, ...)
	end
end

function proxyctl:stop(...)
	if self._stop then
		self._enabled = false
		return self._stop(self, ...)
	end
end

function proxyctl:status()
	return self._enabled
end

return proxyctl
