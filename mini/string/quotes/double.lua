-- local G = {tostring=tostring, string={byte=string.byte, gsub=string.gsub}, }
local function doublequote_dump_string(s, nonprintable_pat, nonprintable_names)
	nonprintable_pat = nonprintable_pat or "[%z\1-\31\127-\255]"
	nonprintable_names = nonprintable_names or {["\0"]="0", ["\a"]="a", ["\b"]="b", ["\t"]="t", ["\n"]="n", ["\v"]="v", ["\f"]="f", ["\r"]="r",}
	local byte = string.byte
	return '"'..(s
		:gsub("[\"\\]", function(cap)
			return "\\"..cap
		end)
		:gsub(nonprintable_pat, function(cap)
			return "\\"..(nonprintable_names[cap] or tostring(byte(cap)))
		end)
	)..'"'
end
return doublequote_dump_string
