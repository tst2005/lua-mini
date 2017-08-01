local inplace = require "mini.table.merge.inplace"
--[[
local function merge_all(a, b, ...)
	if type(...)=="table" then
		return merge_all(merge_all(a,b), ...)
	end
	return inplace(a,b)
end
]]--
--[[
local function internal(a, b, t_args)
	local r = inplace(a,b)
	if t_args then
		for _i,c in ipairs(t_args) do
			r = inplace(r,c)
		end
	end
	return r
end
local function merge_all(a, b, t_args)
	return internal(a, b, {...})
end
]]--
--[[
local function internal(a, t_args)
	if t_args then
		for _i,b in ipairs(t_args) do
			inplace(a,b) -- equal to a = inplace(a,b)
		end
	end
	return a
end
local function merge_all(a, ...)
	return internal(a, {...})
end
]]--
local function merge_all(a, ...)
	local t_args = {...}
	for _i,b in ipairs(t_args) do
		inplace(a,b)
	end
	return a
end
return merge_all
