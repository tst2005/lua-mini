
-- the strong's split function https://github.com/tst2005/strong/blob/master/strong.lua#L189-L205
return function(self, pat, plain)
	--self = type(self)=="table" and self[1] or self
	assert(type(self)=="string")
	assert(type(pat)=="string")
        local tinsert = table.insert or function(t,v) t[#t+1]=v end
        local find, sub = string.find, string.sub
	local t = {}
	while true do
		local pos1, pos2 = find(self, pat, 1, plain or false)
		if not pos1 or pos1 > pos2 then
			tinsert(t, self)
			return t
		end
		tinsert(t, sub(self, 1, pos1 - 1))
		self = self:sub(pos2 + 1)
	end
end

-- https://github.com/amireh/lua_cliargs/blob/master/src/cliargs/utils/split.lua

