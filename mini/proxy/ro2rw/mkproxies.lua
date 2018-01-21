return function(G)
	--local G = {type=type} -- setmetatable=setmetatable, assert=assert, error=error

	local function mkproxy1(orig, k) -- mkproxy_inst2env
		return function(...)
			return orig[k](orig, ...)
		end
	end
	local mkproxy_inst2env = mkproxy1

	local function mkproxy_env2inst(orig, k) -- mkproxy_env2inst
		return function(_, ...)
			return orig[k](...)
		end
	end

	local function mkproxy2(orig, k) -- mkproxy_inst2env_noreturnself
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
	local mkproxy_inst2env_noreturnself = mkproxy2
--[[
	local function mkproxy1prefix(orig, k)
		if G.type(k)=="string" then
			local prefix = orig._pubprefix or ""
			if orig[prefix..k] then
				return function(...)
					return orig[prefix..k](orig, ...)
				end
			end
		end
	end
	local function mkproxy2prefix(orig, k)
		if G.type(k)=="string" then
			local prefix = orig._pubprefix or ""
			if not orig[prefix..k] then return nil end
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
]]--	
	local M = {
		mkproxy1 = mkproxy1,
		mkproxy2 = mkproxy2,
		mkproxy_inst2env = mkproxy_inst2env,
		mkproxy_env2inst = mkproxy_env2inst,
		mkproxy_inst2env_noreturnself = mkproxy_inst2env_noreturnself,
--[[
		mkproxy1prefix = mkproxy1prefix,
		mkproxy2prefix = mkproxy2prefix,
]]--
	}
	return M
end
