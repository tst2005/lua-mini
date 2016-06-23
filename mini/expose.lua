
-- TODO: voir si jarrive a faire une class ou lors de la creation de l'instance, l'init renvoie l'object "env" exposable + l'instance elle meme qui sert a manager l'object
-- par exemple refaire un obj_env[key] = nil ; internal[key] = exposed

-- expose only selected
local function expose(orig, exposed_keys)
	assert(type(orig)=="table")
	local exposed = {} -- uniq value
	local internal = {} -- the internal table use to store value
	for k,v in pairs(exposed_keys or {}) do -- tcopy ?
		if v == true then
			internal[k] = exposed
		end
	end
	return setmetatable({}, {
		__index=function(self, k)
			assert(self ~= orig)
			local v = internal[k]
			if v == exposed then
				return orig[k]
			end
			return v
		end,
		__newindex = function(self, k, v)
			assert(self ~= orig)
--			if v == nil then
				internal[k] = v
--			else
--				internal[k]=nil
--				rawset(self, k, v)
--			end
		end,
	})
end

-- almost like expose_all_by_default
local function ro2rw(readonly)
	assert(type(orig)=="table")
	local lost = {} -- uniq value
	local internal = {} -- the internal table use to store value
	return setmetatable({}, {
		__index=function(_self, k)
			assert(_self ~= readonly)
			if internal[k] == lost then
				return nil
			end
			if internal[k] ~= nil then
				return internal[k]
			end
			return readonly[k]
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
M.ro2rw = ro2rw
M.expose = expose
setmetatable(M, {__call = function(_self, ...) return expose(...) end})
return M
