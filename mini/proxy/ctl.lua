local class = require "mini.class"
local instance = assert(class.instance)

local proxyctl = class("proxyctl")
function proxyctl:init(orig, handler_on, handler_off)
	self._active	= false
	self._orig	= assert(orig)
	self._on	= assert(handler_on)
	self._off	= assert(handler_off)
end

function proxyctl:start(...)
	if self._on then
		self._active = true
		return self._on(self, ...)
	end
end

function proxyctl:stop(...)
	if self._off then
		self._active = false
		return self._off(self, ...)
	end
end

function proxyctl:status()
	return self._active
end

return proxyctl
