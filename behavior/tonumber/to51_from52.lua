local args = {...}
return function(g)
	local orig_tonumber = g.tonumber -- 53 or more
	return function(e, base)
		print("behavior/tonumber/to51_from52.lua")
		if base ~= nil then
			if type(base) == "number" then
				if base==10 then
					return orig_tonumber(e) -- tonumber51("10.2", 10) <=> tonumber("10.2", nil) => 10.2
				end
				if base >= 2 then -- valid base
					local ok, v = pcall(orig_tonumber, e, base)
					if not ok then
						return nil -- lua <= 5.2 behavior (no 5.3 error!)
					end
					--return v -- converted value
				end
				-- here: should be an invalid base
			end
		end
		print("= behavior/tonumber/to51_from52.lua: orig_tonumber()")
		return orig_tonumber(e, base)
	end
end
