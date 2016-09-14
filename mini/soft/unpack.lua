--return require"table".unpack or require "_G".unpack

local function unpack(t, i, j)
	if type(t) ~= "table" then
		error("bad argument #1 to 'unpack' (table expected, got "..type(t)..")", 2)
	end
	if type(i) == "number" and type(j)=="number" and j-i > 2048 then
		error("too many results to unpack", 2)
	end
	local function ext(t, n, ...)
		if t == nil or n < (i or 1) then
			return ...
		end
		return ext(t, n-1, t[n], ...)
	end
	return ext(t, j or #t)
end

return unpack
