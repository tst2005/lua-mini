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
			del[#del+1]=k -- mark the field to be deleted
		end
	end
	for _i,k in ipairs(del) do
--		if type(k)=="number" and k <= #dst then
--			table.remove(dst,k)
--		else
			dst[k]=nil
--		end
	end
	return dst
end
