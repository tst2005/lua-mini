local M = {
	indent = "\t",
	assign = " = ",
	identifier = "^[a-zA-Z_][a-zA-Z0-9_]*$", -- does not support UTF8 identifier
	reserved = nil, -- reserved keywords
	inline=true,
	list_sep=",",
--	list_sep_last=",",
	ishort=true,
	kshort=true,
	updater = nil, --[[function(t, lvl, cfg) return cfg end]]
	nonprintable = "[%z\1-\31\127-\255]"
	nonprintable_names = {["\0"]="0", ["\a"]="a", ["\b"]="b", ["\t"]="t", ["\n"]="n", ["\v"]="v", ["\f"]="f", ["\r"]="r",},
	recursivefound = function(t, lvl, count)
		return "{--[["..tostring(t).." is a trap! ("..tostring(count)..")!]]} "
	end
}
local function tprint(t, lvl, cfg)
	lvl = lvl or 0
	cfg = cfg or {}

	if cfg.updater then
		cfg = cfg.updater(t, lvl, cfg)
	end
	local indent	= cfg.indent
	local assign	= cfg.assign
	local identifier = cfg.identifier
	local reserved	= cfg.reserved
	local inline	= cfg.inline	
	local separator	= cfg.list_sep

	if type(t) == "table" then
		if cfg.seen[t] then
			return cfg.recursivefound(t, lvl, cfg.seen[t])
		end
		cfg.seen[t]=(cfg.seen[t] or 0) +1
		local r={}
		r[#r+1]="{"
		lvl=lvl+1 -- ident
		local i=1 -- implicit numeric index
		for k,v in pairs(t) do
			local line = ""
			if type(k) == "number" then -- it seems a numerical index
				-- check if it is reallly the current index : it could also be a number <= 0 or a float, ...
				if i == k and (cfg.ishort ~= false) then -- only if not deny by config
					i=i+1 -- increment the implicit index
				else
					line = "["..tprint(k,lvl,cfg).."]"..assign
				end
			else
				-- it's a key/hash index and k is a valid identifier and not a reserved word
				if type(k) == "string" and
				   cfg.kshort~=false and
				   (type(identifier)~="string" or k:find(identifier)) and
				   (not reserved or not reserved(k)) then
					line = k .. assign
				else
					line = "["..tprint(k,lvl,cfg).."]"..assign
				end
			end
			-- the content value
			r[#r+1]= (inline and "" or (indent):rep(lvl)) .. line .. tprint(v,lvl,cfg)..(separator)

		end
		lvl=lvl-1 -- dedent
		r[#r+1]=(inline and "" or (indent):rep(lvl)).."}"
		return table.concat(r, (inline and "" or "\n"))
	end
	if type(t) == "string" then
		local names = cfg.nonprintable_names
		--return ("%q"):format(t)
		return '"'..t:gsub("[\"\\]", function(cap) return "\\"..cap end)
			:gsub(cfg.nonprintable, function(cap)
				return "\\"..(names and names[cap] or string.byte(cap))
			end)..'"'
	end
	return tostring(t)
end
local function tprint2(t, cfg)
	cfg = setmetatable(cfg or {}, {__index=M})
	cfg.seen = cfg.seen or {}
	return tprint(t, nil, cfg)
end
return setmetatable(M, {__call=function(_, ...) return tprint2(...) end})
