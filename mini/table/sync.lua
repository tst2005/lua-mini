--sync
return function(src, dst)
	for k,v in pairs(src) do
		if dst[k]~=v then -- if not synced
			dst[k]=v -- update or create to sync the field value
		end
	end
	local del = {}
	for k,v in pairs(dst) do
		if src[k]==nil then -- if not exists
			del[k]=true -- mark the field to be deleted
		end
	end
	for k in pairs(del) do
		dst[k]=nil -- remove the marked field outside of the dst loop
	end
	return dst
end
