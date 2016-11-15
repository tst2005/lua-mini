
local lfs = require "lfs"
do
        local lfs = require"lfs"
        assert(lfs.symlinkattributes, "missing lfs.symlinkattributes")
end

local io = require "io"

local modhelper = require "mini.modhelper"

local M = {}
local modhelper = require "mini.modhelper"
local assertlevel = require "mini.assertlevel"
local class =  require"mini.class"
local instance = class.instance
local shadowself = require "mini.proxy.shadowself"

local fs_class = require "mini.fs.core"

local fs_lfs_class = class("fs.lfs", nil, fs_class)
function fs_lfs_class:init()
	--self.backend = "lfs"
	self._options = {
		follow = false,
	}
	require "mini.class.autometa"(self, fs_lfs_class)
	local s = self:workaround()
	return s
end

function fs_lfs_class:list(path)
	return lfs.dir( assert(path, "invalid path") )
end

function fs_lfs_class:workaround() -- or other way to intercept the instance object and returns the shadowed proxy
	self._shadowself = assert(shadowself(self))
	return assert(self._shadowself)
end

local attrs_fs_to_lfs = {
	dev = "dev",
	ino = "ino",
--	nlink
--	uid
--	gid
--	rdev
	atime = "access",
	mtime = "modification",
	ctime = "change",
--	size
--	permissions
	perm = "permissions",		mod = "permissions",
--	blocks
--	blksize
	type = "mode",
}


--local mode_to_type = {
--	file = "file",
--	directory, link, socket, named pipe, char device, block device or other
--	p = "named pipe",
--}

function fs_lfs_class:attr(p, name)
	local lfs_attr = self._options.follow and lfs.attributes or lfs.symlinkattributes
	return lfs_attr(p, attrs_fs_to_lfs[name] or name)
end
function fs_lfs_class:exists(path)
	-- force no follow
	return not not (lfs.symlinkattributes(
		assert(path, "invalid path"), "mode"
	))
end


function fs_lfs_class:isdir(p)
	return self:attr(p, "type")=="directory"
end
function fs_lfs_class:islink(p)
	return lfs.symlinkattributes(p, attrs_fs_to_lfs[name] or name)
end

function fs_lfs_class:atime() -- accesstime
end
function fs_lfs_class:ctime() -- changetime // creat[ed] time ?
end
function fs_lfs_class:mtime() -- modificationtime
end


function fs_lfs_class:opt(name)
	return self._options[name]
end

function fs_lfs_class:follow()
	self._options.follow = true
end
function fs_lfs_class:nofollow()
	self._options.follow = false
end

--[[
function fs_lfs_class:setopt(name, value)
	assert(value ~= nil, "invalid option value")
	assert(self._options[name]==nil, "invalid option")
	self._options[name]=value
end
]]--

function fs_lfs_class:type(path)
	return self:attr(path, "type")
end

function fs_lfs_class:open(path, mode, ...)
	return io.open(path, mode, ...)
end

local function new()
	return instance(fs_lfs_class)
end

fs_lfs_class.__call = new

return modhelper(new, fs_class)
--return modhelper(new, nil, nil)
--return new
