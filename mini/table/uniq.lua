return function(t, inplace)
	-- inplace=true by default
	if inplace == nil then inplace = true end

	local new = {}
	local last = nil
	for i,v in ipairs(t) do
		if last == nil or last~=v then
			new[#new+1]=v
			last=v
		end
	end
	if inplace then
		-- remove all i-indexes
		for i=1,#t do
			t[i]=nil
		end
		-- add all uniq i-index
		for i,v in ipairs(new) do
			t[i]=v
		end
		return t
	end
	return new
end
