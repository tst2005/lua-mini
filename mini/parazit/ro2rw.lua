
local class = require "mini.class"

local parazit = require "mini.parazit"

local parazit_ro2rw = class("parazit.ro2rw", nil, parazit)
function parazit_ro2rw:init(orig)
	parazit.init(self, orig)
	self.internal = {}
	self.lost={}
end

function parazit_ro2rw:mod(k, v)
	self.internal[k] = v
end
parazit_ro2rw.add = parazit_ro2rw.mod

function parazit_ro2rw:del(k)
	self.internal[k] = self.lost
end
parazit_ro2rw.nop = parazit_ro2rw.del

function parazit_ro2rw:rok(k)
	if self.internal[k] == self.lost then
		return nil
	end
	return self.internal[k]
end
function parazit_ro2rw:rko(k)
	return self.orig[k]
end

return parazit_ro2rw
