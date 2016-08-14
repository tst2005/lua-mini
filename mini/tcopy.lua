local function tcopy(t_src, t_dst)
	t_dst = t_dst or {}
        for k,v in pairs(t_src) do
                t_dst[k] = v
        end
        return t_dst
end
return tcopy
