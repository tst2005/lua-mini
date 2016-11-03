
local function movecontent(src, dst)
	assert(type(dst)=="table")
	for k,v in next, src, nil do -- copy all from src to dst
		dst[k]=v
	end
	for k,v in next, dst, nil do -- remove all from dst
		src[k]=nil
	end
	return dst
end

local class = require "mini.class"
local instance = assert(class.instance)

local parazit = class("parazit")

function parazit:init(victim)
	-- TODO: self:attach(victim)
	return 
end

-- victim
-- orig				| (==internal)
-- origmt			|
-- new		(=={})		| (==victim)
-- newmt

function parazit:attach(victim)
	assert(type(victim)=="table")
	if self.victim then
		error("victim already exists", 2)
	end

	local origmt = getmetatable(victim)	-- backup original metatable
	local newmt = {}			-- the new empty metatable
	local ok,v = pcall(setmetatable, victim, newmt)
	if not ok then
		return false
	end
	assert(getmetatable(v)==newmt, "internal error, attach failure")
	-- at this step the victim metatable is a empty table => easy to dump (without interception)

	self.orig = movecontent(victim, {})

	local new = victim

	self.victim = victim
	self.new = new
	self.origmt = origmt
	self.newmt = newmt

	-- set the handlers
	function newmt.__index(_t, k)
		return self:reader(k)
	end
	function newmt.__newindex(_t, k, v)
		self:writer(k, v)
	end
	-- TODO: newmt.__metatable = true ?
	-- TODO: __pairs
	-- TODO: __ipairs
	assert(self.victim)
	return new
end

function parazit:detach()
	assert(self.victim)

	local victim = self.victim
	local newmt = self.newmt
	newmt.__metatable	= nil

	assert(getmetatable(victim)==newmt)

	newmt.__index		= nil
	newmt.__newindex	= nil
	newmt.__pairs		= nil
	newmt.__ipairs		= nil

	if next(newmt) == nil then -- newmt is an empty table
		newmt=nil
		setmetatable(victim, nil)
	end
	assert(getmetatable(victim)==nil)

	movecontent(self.orig, victim)

	if not pcall(setmetatable, victim, self.origmt) then
		error("fail to restore backuped metatable", 2)
		return false, "fail to restore backuped metatable"
	end
	self.new	= nil
	self.victim	= nil
	self.orig	= nil
	self.origmt	= nil
	self.newmt	= nil

	return victim
end

-- read op: (offset=1)
--	rko 1 = offset + 0
--	rok 2 = offset + 1
-- write op: (offset=3)
--	nop 3 = offset + 0 + 0
--	add 4 = offset + 0 + 1
--	del 5 = offset + 2 + 0
--	mod 6 = offset + 2 + 1

function parazit:reader(k) -- like __index
	local mask = 1 + (self.orig[k] == nil and 1 or 0)
	return self:hook(mask, k)
end

function parazit:writer(k, v) -- like __newindex
	local mask = 3 + (self.orig[k]~=nil and 2 or 0) + (v~=nil and 1 or 0)
	return self:hook(mask, k, v)
end

function parazit:hook(mask, k, v)
	local dispatch = {"rko", "rok", "nop","add","del","mod"}
	--		   1      2      3     4     5     6
	local event = dispatch[mask]

--print("#### hook ", event, self[event], mask, k, v)
	if not self[event] then
		print("NO SUCK self["..event.."]","self", self)
		return
	end
	return assert(self[event])(self, k, v)
end

return parazit
