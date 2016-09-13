
-- TODO: voir si jarrive a faire une class ou lors de la creation de l'instance, l'init renvoie l'object "env" exposable + l'instance elle meme qui sert a manager l'object
-- par exemple refaire un obj_env[key] = nil ; internal[key] = exposed

-- expose : expose some methods (by table/function)
local function expose(orig, filter, indexhook)
	assert(type(orig)=="table")

	local exposed = {} -- uniq value
	local internal = {} -- the internal table use to store value

	if type(filter)=="table" then
		for k,v in pairs(filter) do -- tcopy ?
			if type(k) == "number" and type(v) == "string" then	-- filtre={"meth1", "meth2"}
				internal[v] = exposed
			elseif v == true then					-- filter={meth1=true, meth2=true}
				internal[k] = exposed
			end
		end
	elseif type(filter)=="function" then
		for k in pairs(orig) do
			if type(k) == "string" then
				local k2 = filter(k)
				print("k2=", k2, k)
				if k2 == true then
					internal[k] = exposed
				elseif type(k2) == "string" then
					internal[k2] = exposed
				end
			end
		end
	else
		error("invalid filter", 2)
	end

	return setmetatable({}, {
		__index=function(self, k)
			assert(self ~= orig)
			local v = internal[k]
			if v == exposed then
				return indexhook and indexhook(orig, k) or orig[k]
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


--local M = {}
--M.expose = expose
--setmetatable(M, {__call = function(_self, ...) return expose(...) end})
return expose
