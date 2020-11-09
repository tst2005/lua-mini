
local G = {string={find=string.find, sub=string.sub}, type=type, table={insert=table.insert}}

-- the strong's split function https://github.com/tst2005/strong/blob/master/strong.lua#L189-L205
-- about (pos1 > pos2), see https://github.com/mebens/strong/pull/2
return function(self, pat, plain, max)
	--self=type(self)=="table" and self[1] or self
	assert(type(self)=="string")
	assert(type(pat)=="string")
	--plain
	assert(not max or type(max)=="number")
	local tinsert = table.insert
	local find, sub = string.find, string.sub
	local t = {}
	local pos,pos1,pos2 = 1,nil

	while (function()
		pos1, pos2 = find(self, pat, pos, plain)
		return pos1 and (not max or #t<max)
	end)() do
		tinsert(t, sub(self, pos, pos1 - 1))
		pos = pos2+1
	end
	tinsert(t, sub(self, pos))
	return t
end
