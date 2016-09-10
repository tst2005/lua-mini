
-- the strong's split function https://github.com/tst2005/strong/blob/master/strong.lua#L189-L205
return function(self, pat, plain)
	local t = {}
	while true do
		local pos1, pos2 = string.find(type(self)=="table" and self[1] or self, pat, 1, plain or false)
		if not pos1 or pos1 > pos2 then
			t[#t + 1] = self
			return t
		end
		t[#t + 1] = self:sub(1, pos1 - 1)
		self = self:sub(pos2 + 1)
	end
end

-- https://github.com/amireh/lua_cliargs/blob/master/src/cliargs/utils/split.lua

