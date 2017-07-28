
-- (c) TsT 2016
-- License MIT

--[[
%5.1 return tonumber("10.2"), tonumber("10.2", 10), 
10.2, 10.2

%5.2 return tonumber("10.2"), tonumber("10.2", 10)
10.2, nil

%5.3 return tonumber("10.2"), tonumber("10.2", 10)
10.2, nil


%5.1 return tonumber(10.2, 10)
10.2

%5.2 return tonumber(10.2, 10)
nil

%5.3 return tonumber(10.2, 10)
bad argument #1 to 'tonumber' (string expected, got number)
]]--

local orig_tonumber = tonumber
local modname = (... or ""):gsub("%.init$","") -- the module name (should be *.tonumber.to51 or *.tonumber.to52 or *.tonumber.to53)
local wanted=modname:gsub("^.*%.to(.*)$","%1")
assert(wanted=="51" or wanted=="52" or wanted=="53")

local vm=(orig_tonumber("1.2", 10) == nil) and "52" or "51"
assert(vm=="51" or vm=="52")
if vm=="52" and not pcall(orig_tonumber, 1.2, 10) then -- error == 5.3
	vm="53"
end
if vm==wanted then
	return orig_tonumber
end
return require(modname.."_from"..vm)(_G)
