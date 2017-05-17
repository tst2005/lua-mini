
local function instance(c)
	return setmetatable({}, {__index=c})
end

local function class(prototype, parent)
	local mt = {__index=parent, __call=instance}
	return setmetatable(prototype or {}, mt), mt
end

return class
