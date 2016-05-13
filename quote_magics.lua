local function quote_magics(str)
        local first = str:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0")
	return first
end

do -- self test
	for _i, k in ipairs{ "^", "$", "(", ")", "%", ".", "[", "]", "*", "+", "-", "?" } do
		assert( quote_magics(k) == "%"..k)
	end
end

return quote_magics
