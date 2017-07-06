local M = { indent = "\t", eol="\n", assign=" = ", }
-- for inline use indent="" eol=" " assign="="
local function tprint(t, lvl)
	lvl = lvl or 0
	if type(t) == "table" then
		local r={}
		r[#r+1]="{"
		lvl=lvl+1
		for k,v in pairs(t) do
			r[#r+1]= (M.indent or ""):rep(lvl).."["..tprint(k,lvl).."]"..(M.assign or "=")..tprint(v,lvl)..","
		end
		lvl=lvl-1
		r[#r+1]=(M.indent or ""):rep(lvl).."}"
		return table.concat(r, (M.eol or ""))
	end
	if type(t) == "string" then
		--return ("%q"):format(t)
		return '"'..t:gsub("[\"\\]", function(cap) return "\\"..cap end)..'"'
	end
	return tostring(t)
end
return setmetatable(M, {__call=function(_, t) return tprint(t) end})
