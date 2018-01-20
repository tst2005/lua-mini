return function(G)
	--local G = {type=type} -- setmetatable=setmetatable, assert=assert, error=error

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
--[[
		mkproxy1prefix = mkproxy1prefix,
		mkproxy2prefix = mkproxy2prefix,
]]--
	}
	return M
end
