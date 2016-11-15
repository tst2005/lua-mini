

do local modhelper = require "mini.modhelper" end

--local assertlevel = require "mini.assertlevel"
local class =  require"mini.class"
local instance = class.instance

local fs_class = class("fs", nil, nil)
function fs_class:init()
	require "mini.class.autometa"(self, fs_class)
end

function fs_class:find(path, config)
	config = config or {}
	if not self:exists(path) then
		return (config.error or error)("no such file/dir:"..path)
	end
	if config.follow then self:follow() else self:nofollow() end

	local exec = config.exec or function() end
	if not self:isdir(path) then
		exec(path)
		return
	end
	for file in self:list(path) do
		if file ~= "." and file ~= ".." then
			local f = path..'/'..file		-- FIXME: path stuff!
			exec(f)
			if self:isdir(f) then
				self:find(f, config)
			end
		end
	end
end

local function new()
	return instance(fs_class)
end
fs_class.__call = new

--return require"mini.modhelper"(new, fs_class, nil)
return fs_class
