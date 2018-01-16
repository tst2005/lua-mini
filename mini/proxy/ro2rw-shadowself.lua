
local G = {type=type, setmetatable=setmetatable, assert=assert, error=error}

local function mkproxy1(orig, k)
	return function(...)
		return orig[k](orig, ...)
	end
end
local function mkproxy2(orig, k)
	return function(...)
		local function filter(a, ...)
			if a == orig then
				return ...
			else
				return a, ...
			end
		end
		return filter( orig[k](orig, ...) )
	end
end
local function mkproxy1prefix(orig, k)
	if G.type(k)=="string" then
		local prefix = orig._pubprefix or ""
		return function(...)
			return orig[prefix..k](orig, ...)
		end
	end
end
local function mkproxy2prefix(orig, k)
	if G.type(k)=="string" then
		local prefix = orig._pubprefix or ""
		return function(...)
			local function filter(a, ...)
				if a == orig then
					return ...
				else
					return a, ...
				end
			end
			return filter( orig[k](orig, ...) )
		end
	end
end

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
				-- create a new proxy and write it to internal registry
				proxy = f(orig, k)
				-- add it to internal registry
				internal[k] = proxy
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
		__ipairs = function(self, ...)
			local mt = getmetatable(orig)
			if mt and type(mt.__ipairs)=="function" then
				return mt.__ipairs(orig, ...)
			end
			--return ipairs(orig, ...)
			return nil
		end,
		__pairs = function(_self, ...)
			G.assert(_self ~= orig) -- or return nil ?
			-- here return a special iterator
			--	lookup key into the orig table
			-- for k in pairs(orig) do
			--	ignore deleted key, if value exist return the __index(_self, k) value ?

			local mt = getmetatable(orig)
			if mt and type(mt.__pairs)=="function" then
				return mt.__pairs(orig, ...)
			end
			return nil
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
