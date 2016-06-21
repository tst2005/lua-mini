
-- Important: we build the cache between original-function to proxy-function, and not between method-name to proxy-function

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

-- behavior:
-- if you make a proxy and you make change (like destroy the original method) it will destroy the proxy
-- if you restore the method function the previous proxy was not restored (already destroyed/lost)

local function dualenv(orig)
	assert(type(orig)=="table")
	local lost = {} -- uniq value
	local internal = {} -- the internal table use to store value
	return setmetatable({}, {
		__index=function(_self, k)
			assert(_self ~= orig)
			if internal[k] == lost then
				return nil
			end
			if internal[k] ~= nil then
				return internal[k]
			end
			local original_method = orig[k]
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
M.dualenv = dualenv
setmetatable(M, {__call = function(_self, ...) return dualenv(...) end})
return M
