return function(t_src, t_dst)
	for k,v in pairs(t_src) do
		if t_dst[k] ~= v then
			t_dst[k] = v
		end
	end
	return t_dst
end
