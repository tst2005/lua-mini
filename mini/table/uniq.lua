return function(t)
	local new = {}
	local past = nil
	for i,v in ipairs(t) do
		if not last or last~=v then
			new[#new+1]=v
			last=v
		end
	end
	for i=1,#t do
		t[i]=nil
	end
	for i,v in ipairs(new) do
		t[i]=v
	end
	return t
end
