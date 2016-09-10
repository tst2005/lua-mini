
-- %<magic> => \<magic>
-- %\ => \\
-- %% => %

return function(pat)
	return (
		pat
		:gsub("%%([%^%$%(%)%%%.%[%]%*%+%-%?])", [[\%1]])
		:gsub([[%%\]], [[\\]])
		:gsub("%%%%", "%%")
	) -- keep only the 1st argument
end
