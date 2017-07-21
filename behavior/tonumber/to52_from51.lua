
local orig_tonumber = tonumber -- 5.1
--[[
return function(e, base)
	if type(base)=="number" and tostring(e):find("[^0-9-]+") then
		return nil
	end
	return orig_tonumber(e, base)
end
]]--
return function(e, base)
	if type(base) == "number" then
		local v = orig_tonumber(e, base)
		if v and (v % (base or 10)) ~= 0 then
			return nil
		end
		return v
	end
	return orig_tonumber(e, base)
end
