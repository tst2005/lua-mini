return function(t1, t2)
	local r = {} -- result
	local function isearchin(whatitem, intothistable)
		for i, v in ipairs(intothistable) do
			if v == whatitem then
				return true
			end
		end
		return nil
	end
	for i, v in ipairs(t1) do
		if isearchin(v, t2) then
			table.insert(r, v)
		end
	end
	return r
end
