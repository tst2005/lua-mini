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
return function(G)
	local function ro2rw_mp(orig, map)
		G.assert(G.type(orig)=="table")
		G.assert(G.type(map)=="table", "missing map argument")

		local lost = {} -- uniq value
		local internal = {} -- the internal table use to store value (initial proxy) -- could be used for internal registry access
		local update = {} -- used to remind deleted keys (updated value: lost for nil, else custom value)
	
		local mt = G.setmetatable({
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
	--[[
			__ipairs = function(_self, ...)
				local mt = getmetatable(orig)
				if mt and type(mt.__ipairs)=="function" then
					return mt.__ipairs(orig, ...)
				end
				--return ipairs(orig, ...)
				return nil
			end,
	]]--
			__pairs = function(_t)
				G.assert(_t ~= orig) -- or return nil ?
	--			if orig.next==nil then
	--				--return nil
	--				error("missing orig:next() implementation")
	--			end
	--			local _next = _t["next"] -- TODO: use the private table to access _G.next
	--			return _next, _t, nil
	--			-- here return a special iterator
	--			--	lookup key into the orig table
	--			-- for k in pairs(orig) do
	--			--	ignore deleted key, if value exist return the __index(_self, k) value ?
				local _next = function(t0, k0)
					local pubenv = _t -- orig._pubenv ? -- FIXME: we supposed _t is the proxy table (but it is probably unsafe ?)
					if t0==pubenv then
						local k1,v1 = k0,nil
 						while v1 == nil do
							k1 = G.next(orig, k1)
							if k1 == nil then return nil,nil end
							v1 = _t[k1]		-- will use __index and return the proxy ?
						end
	 					return k1,v1
					else
						return G.next(t0, k0)
					end
				end
				return _next, _t, nil
			end,
			-- __metatable ?
		}, {
			__index=function(_t, k) -- #### any other meta field will be supported ####
				if type(k)=="string" then
					local mt = getmetatable(orig)
					if mt and type(mt["__"..k])=="function" then -- FIXME: only function ? if table return the mt[__*][k] ?
						return mt["__"..k](orig, k)
					end
				end
				return nil
			end,
		})
		return G.setmetatable({}, mt), internal
	end
	return ro2rw_mp
end
