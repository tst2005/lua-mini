-- un module lua_pattern

-- % => %%
-- \\ => %\
-- \<magic> => %<magic>  \. => %.

local function re_to_lua_pattern(pat)
	local first = pat
		:gsub("%%", "%%%%")
		:gsub([[\\]], [[%%\]])
		:gsub("\\([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
	return first
end
assert( ("%"):gsub("%%", "%%%%") == "%%")
assert( ([[\\]]):gsub([[\\]], [[%%\]]) == [[%\]])

-- %<magic> => \<magic>
-- %\ => \\
-- %% => %

local function lua_to_re_pattern(pat)
	local first = pat
		:gsub("%%([%^%$%(%)%%%.%[%]%*%+%-%?])", [[\%1]])
		:gsub([[%%\]], [[\\]])
		:gsub("%%%%", "%%")
	return first
end

do
	assert( ([[%\]]):gsub([[%%\]], [[\\]]) == [[\\]])
	assert( not ([[%]]):find("%%%%") )
	assert( ([[%%]]):gsub("%%%%", "%%") == "%")
	assert( ... )
	
	local luapat = "\\([%^%$%(%)%%%.%[%]%*%+%-%?])"
	print( re_to_lua_pattern(lua_to_re_pattern(luapat)), luapat)

end
return {
	re_to_lua = re_to_lua_pattern,
	lua_to_re = lua_to_re_pattern,
}
