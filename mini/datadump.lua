
-- data dumper (tprint en version du code pour reconstruire les donnees exacte)

local tprint = require "mini.tprint"

local cfg = {}
local Th = {n=0}
local seen = {}
cfg.seen=setmetatable({},{
	__index=function(_,t)
		local n = Th[t]
		if not n then
			n = Th.n+1
			Th.n = n
			Th[n]=t
			Th[t]=n
		end
		return seen[t]
	end,
	__newindex = function(_,t,v)
		seen[t]=v
	end,
})

local assigns = {}
cfg.skipassign = function(t,k,v) -- called for all keys of t
	if type(k)=="table" or type(v)=="table" then
		if type(k)=="table" then tprint(k, cfg) end
		if type(v)=="table" then tprint(v, cfg) end
		table.insert(assigns, {t,k,v})
		return true
	end
	return false
end

local function table2code(x)
	if type(x)=="table" then
		local n = assert(Th[x])
		return "T["..n.."]"
	end
	return tprint(x, cfg)
end

local function mkassigns(out)
	local t,k,v
	for _,t_k_v in ipairs(assigns) do
		t,k,v=unpack(t_k_v)
		table.insert(out,""..table2code(t).."[("..table2code(k)..")]="..table2code(v).."")
	end
end


local function mksubtables(out, cfg)
	local cfg2={
		skipassign = function(t,k,v)
	        	return type(k)=="table" or type(v)=="table" or false
		end
	}
	if cfg.inline~=nil then
		cfg2.inline=cfg.inline
	end
	local ret = {}
	local seen = cfg.seen
	for n,t in ipairs(Th) do
		--if n==1 or seen[t] and seen[t] > 1 then
			table.insert(out, "T["..n.."]="..tprint(t,cfg2))
		--end
	end
end

local function datadump(R, cfg_)

	local out = {
		"(function() local T={}"
	}
	if cfg_.inline ~= nil then
		cfg.inline = cfg_.inline
		out.inline = cfg_.inline
	end
	tprint(R, cfg)

	mksubtables(out, cfg)
	mkassigns(out)
	table.insert(out, "return T[1] end)()")

	return table.concat(out, "\n")
end
return datadump
