
local M = {}

local function autometa(inst, methods)
	assert( type(methods)=="table", "methods must be a table")
	local mt = getmetatable(inst)
	assert(type(mt)=="table")
	local errs = {}
	for k,v in pairs(methods) do
		if k ~= "__metatable" and type(k) == "string" and string.sub(k, 1, 2) == "__" then
			if mt[k]==nil then
				mt[k]=v
			elseif mt[k]~=v then
				errs[#errs+1]=k
			end
		end
	end
	if #errs > 0 then
		error( #errs.."error(s):"..table.concat(errs, ";"), 2)
	end
	return nil
end

M.autometa = autometa

setmetatable(M, {__call=function(_self, ...) return M.autometa(...) end})

return M
