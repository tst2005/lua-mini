local args = {...}
return function(_G)
	local orig_tonumber = _G.tonumber -- 53 or more
	return function(e, base)
		if base ~= nil and type(base) ~= "number" then
			return nil -- lua <= 5.2 behavior
		end
		return orig_tonumber(e, base)
	end
end
