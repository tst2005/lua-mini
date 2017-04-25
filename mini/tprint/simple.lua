local M = {
	indent = "\t",
	assign = " = ",
	identifier = "^[a-zA-Z_][a-zA-Z0-9_]*$", -- does not support UTF8 identifier
	reserved = nil
	--[[ ishort=true, kshort=true,]]
}
local function tprint(t, lvl, cfg)
	cfg = cfg or {}
	local indent = cfg.indent or M.indent
	local assign = cfg.assign or M.assign
	local identifier = cfg.identifier or M.identifier
	local reserved = cfg.reserved or M.reserved
	lvl = lvl or 0
	if type(t) == "table" then
		local r={}
		r[#r+1]="{"
		lvl=lvl+1 -- ident
		local i=1 -- implicit numeric index
		for k,v in pairs(t) do
			local line = (indent):rep(lvl)
			if type(k) == "number" then -- it seems a numerical index 
				-- check if it is reallly the current index : it could also be a number <= 0 or a float, ...
				if i == k and (cfg.ishort ~= false) then -- only if not deny by config
					i=i+1 -- increment the implicit index
				else
					line = line .. "["..tprint(k,lvl,cfg).."]"..assign
				end
			else
				if type(k) == "string" then -- it's a key/hash index
					-- check if k is a valid identifier and not a reserved word
					if cfg.kshort~=false
					   and (type(identifier)~="string" or k:find(identifier))
					   and (not reserved or not reserved(k)) then
						line = line .. k .. assign
					end
				else
					line = line .. "["..tprint(k,lvl,cfg).."]"..assign
				end
			end
			r[#r+1]= line..tprint(v,lvl,cfg)..","
		end
		lvl=lvl-1 -- dedent
		r[#r+1]=(indent):rep(lvl).."}"
		return table.concat(r, "\n")
	end
	if type(t) == "string" then
		--return ("%q"):format(t)
		return '"'..t:gsub("[\"\\]", function(cap) return "\\"..cap end)..'"'
	end
	return tostring(t)
end
local function tprint2(t, cfg)
	return tprint(t, nil, cfg)
end
return setmetatable(M, {__call=function(_, ...) return tprint2(...) end})
