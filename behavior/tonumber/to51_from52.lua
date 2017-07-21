
local orig_tonumber = tonumber -- 5.2 or more
return function(e, base)
	-- 3   3.0   3.1416   314.16e-2   0.31416E1   -- 0xff   0x56
	if base==10 then
		--if tostring(e):find("^[-]*[0-9]*[%.]*[0-9]*[eE][%-]*[0-9]*$") then -- FIXME: fix the detection pattern ...
			return orig_tonumber(e, nil)
		--end
	end
	return orig_tonumber(e, base)
end
