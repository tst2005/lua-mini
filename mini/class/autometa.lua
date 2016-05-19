
local M = {}

local function autometa(inst, methodes)
	local mt = getmetatable(inst)
	assert(type(mt)=="table")
	local errs = {}
	for k,v in pairs(methodes) do
		if k ~= "__metatable" and type(k) == "string" and string.sub(k, 1, 2) == "__" then
			if mt[k]==nil then
				mt[k]=v
			else
				errs[#errs+1]=k
			end
		end
	end
	if #errs > 0 then
		return errs
	end
	return nil
end

M.autometa = autometa

setmetatable(M, {__call=function(_self, ...) return M.autometa(...) end})

return M
