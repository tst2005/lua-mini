local function quote_magics(str)
        local first = str:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0")
	return first
end

return quote_magics
