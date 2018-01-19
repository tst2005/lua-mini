--local G = {type=type, setmetatable=setmetatable, assert=assert, error=error, next=next}
--	local mkproxies = require "mini.proxy.mkproxies"({type=type})
--	local mkproxy2 = mkproxies.mkproxy2

--[[
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
]]--
-- local mkmetaproxy = require "mini.proxy.ro2rw.mkmetaproxy"(G)

return function(G)
	local function ro2rw(orig, map, mkmetaproxy)
		G.assert(G.type(orig)=="table")
		G.assert(G.type(map)=="table", "missing map argument")

		local lost = {} -- uniq value
		local internal = {} -- the internal table use to store value (initial proxy) -- could be used for internal registry access
		local update = {} -- used to remind deleted keys (updated value: lost for nil, else custom value)
	
		local mt = {
			__index=function(_self, k)
				G.assert(_self ~= orig)			-- never expose the original instance object
				local v = update[k]			-- get the last updated value of the field
				if v ~= nil then			-- the field was already updated, the original proxy is not accessible by this env
					if v == lost then		-- the previous action drop the field value
						return nil		-- then return an nil value
					end
					return v			-- there is any other value, return it
				end
				-- at this step:  v == nil, now we lookup into internal
				local proxy = internal[k]
				if proxy == nil and orig[k] ~= nil then		-- there is no proxy for now, and the instance has a method to proxy
					local f = map[G.type(orig[k])] or map["DEFAULT"]
					if not f then
						G.error("unable to wrap data type "..G.type(orig[k]), 2) -- FIXME: silence error ?
					end
					if f == true then
						return orig[k]
					end
					proxy = f(orig, k)			-- create a new proxy and write it to internal registry
					internal[k] = proxy			-- add it to internal registry
				end
				return proxy
			end,
			__newindex = function(_self, k, v)
				if v == nil then -- this action erase the field
					if orig[k]~=nil then			-- only remind this drop if there is something existant to hide
						if internal[k]~=nil then
							update[k] = lost	-- set the lost mark
						end
					elseif internal[k]~=nil then		-- this case should not happen (we don't remove the class method after a proxy is create?)
						internal[k]=nil			-- cleanup, to reset anything
						update[k]=nil
					end
				else
					update[k] = v				-- always apply change into update[], never in internal[]
				end
			end,
		}
		if mkmetaproxy then
			mt = mkmetaproxy(orig, mt)
		end
		return G.setmetatable({}, mt), internal
	end
	return ro2rw
end
