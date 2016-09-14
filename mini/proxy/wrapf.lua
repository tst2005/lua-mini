
local function wrapf(orig, f)
	assert(type(orig)=="table")
	assert(type(f)=="function")
	local wrappers = {} -- the internal table use to store generated wrappers
	return setmetatable({}, {
		__index=function(_self, k)
			assert(_self ~= orig)
			if not wrappers[k] then
				local w = function(...)
					return f(...)
				end
				wrappers[k] = w
			end
			return wrappers[k]
		end,
	})
end

local M = {}
M.wrapf = wrapf
setmetatable(M, {__call = function(_self, ...) return wrapf(...) end})
return M
