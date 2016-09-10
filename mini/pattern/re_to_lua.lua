
-- % => %%
-- \\ => %\
-- \<magic> => %<magic>  \. => %.

return function(pat)
	return (
		pat
		:gsub("%%", "%%%%")
		:gsub([[\\]], [[%%\]])
		:gsub("\\([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
	) -- keep only the 1st argument
end

