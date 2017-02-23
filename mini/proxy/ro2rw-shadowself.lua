
local function mkproxy1(orig, k)
	return function(...)
		return orig[k](orig, ...)
	end
end
local function mkproxy2a(orig, k)
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
local function mkproxy2b(orig, k)
	return function(...)
		local function filter(...)
			if (...) == orig then
				return select(2, ...)
			else
				return ...
			end
		end
		return filter( orig[k](orig, ...) )
	end
end


local function ro2rwss(orig, mkproxy)
	assert(type(orig)=="table")

	mkproxy = mkproxy~=nil and mkproxy or mkproxy2

	local lost = {} -- uniq value
	local internal = {} -- the internal table use to store value

	return setmetatable({}, {
		__index=function(_self, k)
			assert(_self ~= orig)
			local proxy = internal[k]
			if proxy == lost then
				return nil
			end
			--if type(k)~="string" then return nil end
			if proxy == nil and orig[k] ~= nil then
				local t = type(orig[k])
				if t=="boolean" or t=="string" or t=="number" then
					return orig[k]
				end
				if t=="function" then
					-- create a new proxy function and write it to internal registry
					--[[
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
					]]--
					proxy = mkproxy(orig, k)
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
				if orig[k]~=nil then
					internal[k] = lost
				end
			else
				internal[k] = v
			end
		end,
	})
end

return ro2rwss
