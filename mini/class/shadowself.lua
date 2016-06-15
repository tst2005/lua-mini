
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

-- to see: think about to expose the internal table, or the lost marker value.
-- DUAL ENV: 
-- if we need to share multiple dual env ... it should be interesting to have
-- a separated table to manager marks,
-- like status[key] = <value>
-- * true => return original
-- * false => dropped(return nil)
-- * nil

local function shadowself(inst)
	assert(type(inst)=="table")
	local cache = {}
	local function getproxy(original_method)
		local proxy = cache[original_method]
		-- get from cache
		if proxy then
			return proxy
		end
		-- create proxy function and write to cache
		local proxy = function(...)
			return original_method(inst, ...)
		end
		cache[original_method] = proxy
		return proxy
	end
	local lost = {} -- uniq value
	local internal = {} -- the internal table use to store value
	return setmetatable({}, {
		__index=function(_self, k)
			assert(_self ~= inst)
			if internal[k] == lost then
				return nil
			end
			if internal[k] ~= nil then
				return internal[k]
			end
			local original_method = inst[k]
			if type(original_method) == "function" then
				return getproxy(original_method)
			end
			return original_method
		end,
		__newindex = function(self, k, v)
			if v == nil then
				internal[k] = lost
			else
				internal[k] = v
			end
		end,
	})
end

local M = {}
M.newproxy = shadowself
setmetatable(M, {__call = function(_self, ...) return shadowself(...) end})
return M
