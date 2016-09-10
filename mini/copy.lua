
local function pass(value)
	return value
end
local function raise(o)
	error("no handler to copy data type ("..type(o)..")", 2)
end

local defaultway = {
	["string"]		= pass,
	["number"]		= pass,
	["boolean"]		= pass,
	["nil"]		= pass,
	["table"]		= function(t) return require "mini.table.shallowcopy"(t) end,
	["function"]	= function(f) return function(...) return f(...) end end,
	thread		= fail,
	userdata	= fail,
--	file		= fail,
}

local function copy(orig, way)
	local f = way and way[type(orig)]
	if f == nil then
		f = defaultway[type(orig)]
	end
	if type(f) ~= "function" then
		error("the copy handler must be a function, got "..type(f)..")", 2)
	end
	return f(orig)
end

return copy


