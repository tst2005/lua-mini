
-- Goal: make a proxy for a instance object to a direct use object ...
-- sample:
--[[
i1 = instance(class1)
i1:hello()

o1 = shadowself(i1)
o1.hello()
]]--

-- Important: we build the cache between original-function to proxy-function, and not between method-name to proxy-function

-- (fr)
-- a la difference de meth-prot: 
-- * on va construire des fonctions proxy pour chaque methode(function) sans le 1er argument 'self'
-- * on veut per-object internal cache, pas de cache global a base de weak table.

-- BUG :
-- * we catch instance method only if it's function (a callable table or userdata will not be catched)

-- behavior:
-- if you make a proxy and you make change (like destroy the original method) it will destroy the proxy
-- if you restore the method function the previous proxy was not restored (already destroyed/lost)

local function shadowself(inst)
	assert(type(inst)=="table")
	local cache = setmetatable({}, {__mode="kv"}) -- fully weak table
	local function getproxy(original_method)
		-- get it from cache
		local proxy = cache[original_method]
		if proxy then
			return proxy
		end

		-- create proxy function and write to cache
		local proxy = function(...)
			return original_method(inst, ...)
		end
		-- add it to cache
		cache[original_method] = proxy
		return proxy
	end
	return setmetatable({}, {
		__index=function(_self, k)
			assert(_self ~= inst, "do not expose the instance")
			local original_method = inst[k]
			if type(original_method) == "function" then
				return getproxy(original_method)
			end
			return original_method
		end,
		__newindex = function(_self)
			error("read only table", 2)
		end
	}), cache
end

local M = {}
M.newproxy = shadowself
setmetatable(M, {__call = function(_self, ...) return shadowself(...) end})
return M
