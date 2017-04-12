local M = { indent = "\t" }
local function tprint(t, lvl)
	lvl = lvl or 0
	if type(t) == "table" then
		local r={}
		r[#r+1]="{"
		lvl=lvl+1
		for k,v in pairs(t) do
			r[#r+1]= (M.indent):rep(lvl).."["..tprint(k,lvl).."] = "..tprint(v,lvl)..","
		end
		lvl=lvl-1
		r[#r+1]=(M.indent):rep(lvl).."}"
		return table.concat(r, "\n")
	end
	if type(t) == "string" then
		return ("%q"):format(t)
	end
	return tostring(t)
end
return setmetatable(M, {__call=function(_, ...) return tprint(...) end})
