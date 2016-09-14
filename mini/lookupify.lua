

local function lookupify(src, dst)
	dst = dst or src
        for _k, v in pairs(src) do
                dst[v] = true
        end
        return tb
end

return lookupify
