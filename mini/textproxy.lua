
local textproxy = function(v)
	local subproxy = function(field)
		return function(self, ...)
			return string[field](tostring(self), ...)
		end
	end
	local p = {v=v}
	for _i, field in ipairs{"byte", "find", "format", "gmatch", "gsub", "len", "lower", "match", "pack", "packsize", "rep", "reverse", "sub", "unpack", "upper"} do
		p[field] = subproxy(field)
	end
	p.dump = string.dump
	p.char = string.char
	return setmetatable(p, {
		__tostring=function(self) return self.v end,
	})
--[[
	return setmetatable({
			v = v,
			byte = function(self, ...) return string.byte(self.v, ...) end,
			find = function(self, ...) return string.find(self.v, ...) end,
			format = function(self, ...) return string.format(self.v, ...) end,
			gmatch = function(self, ...) return string.gmatch(self.v, ...) end,
			gsub = function(self, ...) return string.gsub(self.v, ...) end,
			len = function(self, ...) return string.len(self.v, ...) end,
			--string.lower (s)
			--string.match (s, pattern [, init])
			--string.pack (fmt, v1, v2, ···)
			--string.packsize (fmt)
			--string.rep (s, n [, sep])
			--string.reverse (s)
			--
			char = string.char,
			dump = string.dump,
		}, {
		__tostring=function(self) return self.v end,
--		__index=function(self) end,
	})
]]--
end

return textproxy
