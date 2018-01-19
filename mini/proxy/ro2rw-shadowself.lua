
local G = {type=type, setmetatable=setmetatable, assert=assert, error=error}

local mkproxies = require "mini.proxy.ro2rw.mkproxies"({type=type})
local mkproxy1, mkproxy1prefix = mkproxies.mkproxy1, mkproxies.mkproxy1prefix
local mkproxy2, mkproxy2prefix = mkproxies.mkproxy2, mkproxies.mkproxy2prefix

-- nil|false = error
-- true = return direct value
-- function = call it with (orig, k)
local defaultmap = {
	["boolean"] = true,
	["number"] = true,
	["string"] = true,
	["function"] = mkproxy2,
	["table"] = function() error("TODO: make a wrapper for table", 2) end,
	["DEFAULT"] = false,
}

local function ro2rwss(orig, map)
	G.assert(G.type(orig)=="table")

	map = map and G.setmetatable(map, {__index=defaultmap}) or defaultmap

	local lost = {} -- uniq value
	local internal = {} -- the internal table use to store value

	return G.setmetatable({}, {
		__index=function(_self, k)
			G.assert(_self ~= orig)
			local proxy = internal[k]
			if proxy == lost then
				return nil
			end
			if proxy == nil and orig[k] ~= nil then
				local f = map[G.type(orig[k])] or map["DEFAULT"]
				if not f then
					G.error("unable to wrap data type "..G.type(orig[k]), 2)
				end
				if f == true then
					return orig[k]
				end
				proxy = f(orig, k)		-- create a new proxy and write it to internal registry
				internal[k] = proxy		-- add it to internal registry
			end
			return proxy
		end,
		__newindex = function(self, k, v)
			if v == nil then
				if orig[k]~=nil then
					internal[k] = lost
				end
			else
				internal[k] = v
			end
		end,
	})
end
local M = setmetatable({
	ro2rwss=ro2rwss,
	mkproxy1 = mkproxy1,
	mkproxy2 = mkproxy2,
	mkproxy1prefix = mkproxy1prefix,
	mkproxy2prefix = mkproxy2prefix,
	defaultmap = defaultmap,
}, {__call = function(_self, ...)
	return ro2rwss(...)
end})
return M
