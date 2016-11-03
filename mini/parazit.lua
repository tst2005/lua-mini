
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
function parazit:init()
	return 
end

-- returns:
-- #1: the original object
-- #2: (specific) the internal proxy.overlay registry
local function mutant_on(self)
	local mt = getmetatable(orig)
	assert(mt==nil or (mt.__index==nil and mt.__newindex==nil))

	local orig = self._orig

	local copy = movecontent(orig, {})
	self._copy = copy

	local proxy, over = proxy_overlay(copy)
	if not mt then
		mt={}
		setmetatable(orig, mt)
	end
	mt = mt or {}
	mt.__index    = proxy
	mt.__newindex = proxy

	return over
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

	local oldmt = getmetatable(victim)	-- backup original metatable
	local newmt = {}			-- the new empty metatable
	local ok,v = pcall(setmetatable, victim, newmt)
	if not ok then
		return false
	end
	assert(getmetatable(v)==newmt, "internal error, attach failure")
	-- at this step the victim metatable is a empty table => easy to dump (without interception)

	local new = victim
	self.orig = movecontent(victim, {})
	self.victim = victim
	self.new = new
	self.origmt = oldmt
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
	return new
end

function parazit:detach()
	if self.victim then
		if not pcall(setmetatable, victim, self.metavictim) then
			return false
		end
		self.metavictim = nil
		self.victim = nil
	end
	return true
end
--[[
local function mutant_off(self)
	local orig = self.orig
	local mt = assert(getmetatable(orig))
	mt.__index = nil
	mt.__newindex = nil
	movecontent(copy, orig)
	if next(mt) == nil then -- mt is an empty table
		mt=nil
		setmetatable(orig, nil)
	end
	--return nil
end
]]--

-- read op: (offset=1)
--	nko 1 = offset + 0
--	nok 2 = offset + 1
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
	local dispatch = {"nko", "nok", "nop","add","del","mod"}
	--		   1      2      3     4     5     6
	local even = dispatch[mask]
	print(even, k, v)
	if self[even] then
		print("handler exists")
	end
end

return parazit
