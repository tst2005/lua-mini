
-- TOSEE: https://bitbucket.org/doub/path

local string_split = require "mini.string.split"
local shallowcopy = require "mini.table.shallowcopy"
local asserttype = require "mini.asserttype"
local class = require "mini.class"
local instance = assert(class.instance)

local class_path;class_path = class("path", {
	init = function(self, p, sep)
		self.sep = asserttype(sep or '/', "string", "separator must be a string", 2)
		if not p then
			self.path = {"."}
		elseif type(p) == "table" then -- FIXME: find a better way to check if p is a path
			self.path = shallowcopy(p.path or p) -- import the splitted path ; or, import the table content
		elseif type(p) == "string" then
			self.path = string_split(p or ".", self.sep)
		end
		assert(self.path, "invalid path argument")
		require "mini.class.autometa"(self, class_path)
	end
})

-- isAbsolute https://nodejs.org/docs/latest/api/path.html#path_path_isabsolute_path
function class_path:isabs()
	return self.path[1]==""
end

function class_path:isrel()
	return not self:isabs()
end

function class_path:chsep(newsep)
	self.sep = assert(newsep) -- FIXME: check if items contains newsep ?
	return self
end
function class_path:append(what)
	table.insert(self.path, what)
	return self
end
function class_path:insert(what, where)
	if where == false then return self end
	assert(type(what)=="string")
	if not where then
		where = (#self.path+1)
	elseif where <= -1 then
		where = #self.path +where +2
	elseif where < 1 then
		where = 1
	end
	table.insert(self.path, where, what)
	return self
end
function class_path:search(item, offset)
	for i,v in ipairs(self.path) do
		if v == item then
			return i+(offset or 0)
		end
	end
	return nil
end
function class_path:ifinsert(what, where, found_offset)
	if where == false then return self end
	local i = self:search(what, found_offset)
	if i then
		return self
	end
	where = where or found_offset and i
	return self:insert(what or what_search, where)
end

function class_path:dirname()
	return table.concat(self.path, self.sep, 1, #self.path-1)
end
function class_path:basename(ext)
	assert(not ext, "basename: ext is not implemented yet")
--[[	local v = ""
	for i=#self.path,1,-1 do
		if v~= then break end
		v=self.path[i]
	end
]]--
--[[	for _i,v in ipairs(ripairs(self.path)) do
		if v~="" then
			return v
		end
	end
]]--
	return self.path[#self.path]
end

-- https://nodejs.org/docs/latest/api/path.html#path_path_extname_path
function class_path:extname()
	local filename = self.path[#self.path]
	return filename:find("[^.]%.") and filename:match(".*(%.[^.]*)$") or ""
end

-- $ dirname  /a///////b////// => /a
-- $ basename /a///////b////// => b
-- $ dirname //a///b////c      => //a///b
-- dirname: 1) remove //*[^/]+/*$ 2) re


function class_path:clone()
	local new = instance(class_path, nil, self.sep)
	--update(self,new) -- copy missing fields ?
	new.path = shallowcopy(self.path)
	assert(new.sep == self.sep)
	return new
end

-- *    + abs2 = abs2
-- rel1 + rel2 = rel1/rel2
-- abs1 + rel2 = abs1/rel2
function class_path:cd(suffixpath, inplace)
	if type(suffixpath)=="string" then
		suffixpath = instance(class_path, suffixpath, self.sep)
	end
	assert(type(suffixpath)=="table" and suffixpath.isabs, "suffixpath must be a path object")
	if suffixpath:isabs() then
		return suffixpath:clone()
	end
	assert(self.sep == suffixpath.sep) -- same separator ?
	local new = inplace and self	-- no clone
		or self:clone()		-- clone
	for i, v in ipairs(suffixpath.path) do
	--	if i > 1 or v~= "" then
			new:append(v)
	--	end
	end
	return new
end

-- /   + b/c => /a/b
-- /a  + b/c => /a/b/c
-- /a/ + b/c => /a/b/c
-- convert a path to an absolute path
function class_path:toabs(prefixpath, inplace)
	if self:isabs() then
		return inplace and self or self:clone()
	end
	assert(self.sep == prefixpath.sep) -- same separator ?
	local abs = inplace and prefixpath or prefixpath:clone()
	if abs.path[#abs.path]=="" then
		-- drop the last empty item to avoid dual separator
		abs.path[#abs.path]=nil
	end
	for i, v in ipairs(self.path) do
		abs:append(v)
	end
	assert(abs:isabs())
	return abs
end

function class_path:__tostring()
	return table.concat(self.path, self.sep)
end
class_path.tostring = assert(class_path.__tostring)

function class_path:concat(sep, i, j)
	sep = sep or self.sep
	return table.concat(self.path, sep, i, j)
end


-- https://nodejs.org/docs/latest/api/path.html#path_path_normalize_path
-- a////b => a/b
-- a/./b  => a/b
-- a/x/../b => a/b (disabled)
-- x/../a/b => a/b (disabled)
--[[
function class_path:normpath(path)
	local sep = self.sep
	assert(sep == "/", "separator is not supported")
	return (
		path
		:gsub("^$", ".")		-- if empty returns "."
		:gsub("/+", "/")		-- remove multiple '/' occurrence
		:gsub("/$", "")			-- remove ending '/' if exists
		:gsub("$", "/")			-- add ending '/'
		:gsub("/%./", "/")
--			:gsub("^", "/")			-- prefix by '/'
--			:gsub("/[^/]+/%.%./", "/")	-- reduce "/something/.." to "/"
--			:gsub("^/", "")			-- remove the '/' prefix
		:gsub("^(.+)/$", "%1")		-- remove the last ending '/' if exists
		:gsub("^%./(.+)$", "%1")	-- if "./something" keep "something"
	)
end
]]--

-- parse(p) https://nodejs.org/docs/latest/api/path.html#path_path_parse_path
function class_path:parse(p)
	return instance(class_path, p)
end

local function new(p)
	return instance(class_path, p)
end

return setmetatable({parse=new}, {__call = function(_, ...) return instance(class_path, ...) end})
