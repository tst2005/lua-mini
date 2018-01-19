return function(G)
	-- nil|false = error
	-- true = return direct value
	-- function = call it with (orig, k)
	local defaultmap = {
		["boolean"] = true,
		["number"] = true,
		["string"] = true,
		["function"] = false,
		["table"] = function() G.error("TODO: make a wrapper for table", 2) end,
		["DEFAULT"] = false,
	}
	return function(map)
		if map == nil then map = {} end
		for k,v in G.pairs(defaultmap) do
			if map[k]==nil then
				map[k]=v
			end
		end
		return map
	end
end
