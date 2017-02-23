
local function ro2rwss(orig)
	assert(type(orig)=="table")
	local lost = {} -- uniq value
	local internal = {} -- the internal table use to store value

	return setmetatable({}, {
		__index=function(_self, k)
			assert(_self ~= orig)

			local proxy = internal[k]
			if proxy == lost then
				return nil
			end
			if proxy == nil then
				local t = type(orig[k])
				if t=="nil" or t=="boolean" or t=="string" or t=="number" then
					return orig[k]
				end
				if t == "function" then
					-- create a new proxy function and write it to internal registry
					proxy = function(...)
						local function filter(a, ...)
							if a == orig then
								return ...
							else
								return a, ...
							end
						end
						return filter( orig[k](orig, ...) )
					end
				elseif t=="table" then
					error("TODO: make a wrapper for table", 2) 
				else
					error("unable to wrap data type "..t, 2)
				end
                		-- add it to internal registry
				internal[k] = proxy
			end
			return proxy
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

return ro2rwss
