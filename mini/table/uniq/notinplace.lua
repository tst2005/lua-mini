return function(t)
	local new = {}
	local last = nil
	for i,v in ipairs(t) do
		if last == nil or last~=v then
			new[#new+1]=v
			last=v
		end
	end
	return new
end
