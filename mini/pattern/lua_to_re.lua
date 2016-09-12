
-- %<magic> => \<magic>
-- %\ => \\
-- %% => %

---------
-- convert a lua pattern format to a regexp pattern format
-- @module mini.pattern.lua_to_re
-- @param pat the lua pattern
-- @return the regexp pattern
-- @usage local re = require"mini.pattern.lua_to_re"('^.*%.lua$') -- got '^.*\.lua$'
-- @see mini.pattern.lua_to_re

return function(pat)
	return (
		pat
		:gsub("%%([%^%$%(%)%%%.%[%]%*%+%-%?])", [[\%1]])
		:gsub([[%%\]], [[\\]])
		:gsub("%%%%", "%%")
	) -- keep only the 1st argument
end
