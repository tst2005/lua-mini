return function(t)
	local table_remove = table.remove
	local last = nil
	for i=#t,1,-1 do
		local v = t[i]
		if last ~= nil and last==v then
			table_remove(t,i)
		else
			last=v
		end
	end
	return t
end
