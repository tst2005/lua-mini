return function(a, b)
	local ins = assert(table.insert)
	for i,v in ipairs(b) do
		ins(a, v)
	end
	return a
end
