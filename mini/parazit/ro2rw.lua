
local class = require "mini.class"

local parazit = require "mini.parazit"

local parazit_ro2rw = class("parazit.ro2rw", nil, parazit)

function parazit_ro2rw:init(orig)
	parazit.init(self, orig)
	self.internal = {}
	self.lost={}
end

-- MOD --
function parazit_ro2rw:mod(k, v)
	self.internal[k] = v
end
-- ADD --
parazit_ro2rw.add = parazit_ro2rw.mod

-- DEL --
function parazit_ro2rw:del(k)
	self.internal[k] = self.lost
end

-- NOP --
parazit_ro2rw.nop = parazit_ro2rw.del

-- ROK --
function parazit_ro2rw:rok(k)
	local v = self.internal[k]
	if v == nil then
		return self.orig[k]
	end
	if v == self.lost then
		return nil
	end
	return v
end
-- RKO --
parazit_ro2rw.rko = parazit_ro2rw.rok

return parazit_ro2rw
