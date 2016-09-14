local quote_magics = require "mini.quote_magics"

for _i, k in ipairs{ "^", "$", "(", ")", "%", ".", "[", "]", "*", "+", "-", "?" } do
	assert( quote_magics(k) == "%"..k)
end

