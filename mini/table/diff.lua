--diff
return function(src, dst, differ, less, more, common)
	for k,v in pairs(src) do
		local v2 = dst[k]
		if v2~=v then -- if not synced
			if v2==nil then
				less(src, dst, k, v, "")
			else
				differ(src, dst, k, v, v2)
			end
		else
			common(src, dst, k, v, v2)
		end
	end
	for k,v in pairs(dst) do
		if src[k]==nil then -- if not exists
			more(src, dst, k, "", v)
		end
	end
	return dst
end
