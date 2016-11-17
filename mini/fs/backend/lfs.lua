
local lfs = require"lfs"
assert(lfs.symlinkattributes, "missing lfs.symlinkattributes")
local posix = require "posix"
assert(posix.chmod)

local io = require "io"

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
	local proxy = assert(shadowself(self, nil, "_"))
	self._shadowself = proxy
	return proxy
end
function fs_lfs_class:_workaround() -- or other way to intercept the instance object and returns the shadowed proxy
	return assert(self._shadowself)
end

function fs_lfs_class:_castpath(path)
	if type(path) == "string" then
		return path
	end
	return tostring(path)
end

-- ls
function fs_lfs_class:listall(path)
	return lfs.dir( assert( self:_castpath(path), "invalid path") )
end

function fs_lfs_class:list(path)
	local f2, v2 = lfs.dir( assert( self:_castpath(path), "invalid path") )
	local f = function() return f2(v2) end
	return function()
		while true do -- FIXME: without loop!
			local v = f()
			if v ~= "." and v ~= ".." then
				return v
			end
		end
	end
end

local attrs_fs_to_lfs = {
	ino = "ino",
--	nlink
	uid = "uid",
	gid = "gid",
	dev = "dev",
--	rdev
	atime = "access",
	mtime = "modification",
	ctime = "change",
	size  = "size",
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

function fs_lfs_class:attr(path, name)
	local lfs_attr = self._options.follow and lfs.attributes or lfs.symlinkattributes
	return lfs_attr( self:_castpath(path), attrs_fs_to_lfs[name] or name)
end

-- shell: test -e
function fs_lfs_class:exists(path)
	-- force no follow
	return not not (lfs.symlinkattributes(
		assert( self:_castpath(path), "invalid path"), "mode"
	))
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


-- shell: test -d
function fs_lfs_class:isdir(path)
	return self:attr( self:_castpath(path), "type")=="directory"
end
-- shell: test -h
function fs_lfs_class:islink(path)
	return lfs.symlinkattributes( self:_castpath(path), attrs_fs_to_lfs[name] or name)
end

-- accesstime
function fs_lfs_class:atime(path)	return self:attr(path, "atime") end
-- changetime (or created time ?)
function fs_lfs_class:ctime(path)	return self:attr(path, "ctime") end
-- modificationtime
function fs_lfs_class:mtime(path)	return self:attr(path, "mtime") end

function fs_lfs_class:size(path, as_apparentsize)
	assert(as_apparentsize, "not implemented yet")
	return self:attr( self:_castpath(path), "size")
end

-- fs.permissions (file) 	Get the permission string of a file

function fs_lfs_class:uid() return self:attr(p, "uid") end
function fs_lfs_class:gid() return self:attr(p, "gid") end
function fs_lfs_class:dev() return self:attr(p, "dev") end

-- shell: touch
function fs_lfs_class:create(path) -- FIXME: or touch ?
	return lfs.touch(path)
end

-- fs.update (file, accesstime, modificationtime) 	Update the access/modification time of a file.
function fs_lfs_class:update(path, atime, mtime)
	return lfs.touch(path, atime, mtime)
end
function fs_lfs_class:currentdir()
	return lfs.currentdir()
end

function fs_lfs_class:rename(oldname, newname) -- 
end

function fs_lfs_class:mkdir(path) -- 
	return lfs.mkdir(path)
end
function fs_lfs_class:rmdir(dir, recursive) -- 
	assert(recursive, "not implemented yet")
	return lfs.rmdir(path)
end
-- fs.remove (file) 	Remove a file.

-- Get the type of the file.
function fs_lfs_class:type(path)
	return self:attr(path, "type")
end


-- fs.unlink

-- Create a link
-- Create a hardlink to a file
-- Create a symlink to a file or directory.
function fs_lfs_class:link(file, link, as_symlink)

end

function fs_lfs_class:chmod(file, mode)
	return posix.chmod(file, mode)
end
--[[
function fs_lfs_class:chown(file, uid, gid)
	return posix.chmod(file, uid, gid
end
]]--
-- fs.chgrp

function fs_lfs_class:umask(umask)
	assert(umask==nil or type(umask)=="string", "invalid umask")
	return posix.umask(umask)
end

------------------ PATH -------------------------

-- Get the directory separator that the system uses.
function fs_lfs_class:separator()
	return '/' -- FIXME
end

function fs_lfs_class:open(path, mode, ...)
	return io.open( self:_castpath(path), mode, ...)
end



local function new()
	return instance(fs_lfs_class)
end

fs_lfs_class.__call = new

return modhelper(new, fs_class)
--return modhelper(new, nil, nil)
--return new
