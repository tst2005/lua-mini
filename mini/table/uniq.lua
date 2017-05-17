return function(t, inline)
	inline = inline==nil and true or false -- inline=true by default

	local new = {}
	local last = nil
	for i,v in ipairs(t) do
		if last == nil or last~=v then
			new[#new+1]=v
			last=v
		end
	end
	if inline then
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
	retur new
end
