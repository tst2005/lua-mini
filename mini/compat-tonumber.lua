
-- (c) TsT 2016
-- License MIT

--[[
%5.1 return tonumber("10.2"), tonumber("10.2", 10)
10.2, 10.2

%5.2 return tonumber("10.2"), tonumber("10.2", 10)
10.2, nil

%5.3 return tonumber("10.2"), tonumber("10.2", 10)
10.2, nil
]]--

local orig_tonumber = _G.tonumber
local tonumber_lua51
local tonumber_lua52more
local tonumber_lua52more2
if orig_tonumber("1.2", 10) ~= nil then
	-- not like lua 5.2+
	-- setup compat
	function tonumber_lua52more2(e, base)
		if type(base)=="number" and tostring(e):find("[^0-9-]+") then
			return nil
		end
		return orig_tonumber(e, base)
	end
	function tonumber_lua52more(e, base)
		if type(base) == "number" then
			local v = orig_tonumber(e, base)
			if v and (v % (base or 10)) ~= 0 then
				return nil
			end
			return v
		end
		return orig_tonumber(e, base)
	end
else
	function tonumber_lua51(e, base)
		-- 3   3.0   3.1416   314.16e-2   0.31416E1   -- 0xff   0x56
		if base==10 then
			--if tostring(e):find("^[-]*[0-9]*[%.]*[0-9]*[eE][%-]*[0-9]*$") then -- FIXME: fix the detection pattern ...
				return orig_tonumber(e, nil)
			--end
		end
		return orig_tonumber(e, base)
	end
end
local M = {
	tonumber  = tonumber_lua52more  or orig_tonumber,
	tonumber2 = tonumber_lua52more2 or orig_tonumber,
	tonumber52 = tonumber_lua52more,
	tonumber51 = tonumber_lua51,
}
--setmetatable(M, {__call = function(_self, ...) return tonumber_lua52more(...) end})
return M
