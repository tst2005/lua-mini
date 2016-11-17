

do local modhelper = require "mini.modhelper" end

--local assertlevel = require "mini.assertlevel"
local class =  require"mini.class"
local instance = class.instance

local fs_class = class("fs", nil, nil)
function fs_class:init()
	require "mini.class.autometa"(self, fs_class)
end

-- sort by name: nosort, sorted
-- type ordered: dirfirst VS filefirst
-- shell: -depth subdir hook after, else subdir hook before

function fs_class:find(path, config)
	config = config or {}
	if not self:exists(path) then
		return (config.error or error)("no such file/dir:"..path)
	end
	if config.follow then self:follow() else self:nofollow() end
	
	local level = 0
	local mindepth, maxdepth = config.mindepth, config.maxdepth
	--local cdin, cdout = config.cdin, config.cdout

	local exec = config.exec or function() end

	local function _find(subpath, config)
		local abspath = path:cd(subpath)

		if not self:isdir(abspath) then -- file
			print("exec", path, subpath)
			exec(tostring(subpath))
			return
		end
		for item in self:listall(abspath) do
			assert(type(item)=="string")
			if item ~= "." and item ~= ".." then
				local subpath2
				if type(subpath) == "table" then
					subpath2 = subpath:cd(item)
				else
					subpath2 = subpath..'/'..item -- FIXME
				end
				print("exec", path, subpath2)
				exec(tostring(subpath2))
				if self:isdir( abspath:cd(item) ) then
					_find(subpath2, config) -- FIXME: with level ...
				end
			end
		end
	end
	_find(".", config)
end

local function new()
	return instance(fs_class)
end
fs_class.__call = new

--return require"mini.modhelper"(new, fs_class, nil)
return fs_class
