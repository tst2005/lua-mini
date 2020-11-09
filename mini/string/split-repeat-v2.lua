
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
	repeat
		if pos1 then
			tinsert(t, sub(self, pos, pos1 - 1))
			pos = pos2+1
		end
		pos1, pos2 = find(self, pat, pos, plain)
	until not pos1 or pos1>pos2 or (max and #t>=max);

	tinsert(t, sub(self, pos))
	return t
end
