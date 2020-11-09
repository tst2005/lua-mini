
local G = {string={find=string.find, sub=string.sub}, type=type, table={insert=table.insert}}

-- the strong's split function https://github.com/tst2005/strong/blob/master/strong.lua#L189-L205
-- about (pos1 > pos2), see https://github.com/mebens/strong/pull/2
return function(self, pat, plain, max, filter)
	--self=type(self)=="table" and self[1] or self
	assert(type(self)=="string")
	assert(type(pat)=="string")
	--plain
	assert(not max or type(max)=="number", "invalid max number")
	filter = filter or function(v) return v end
	assert(type(filter)=="function")
	local tinsert = table.insert or function(t,v) t[#t+1]=v end
	local find, sub = string.find, string.sub
	local t = {}
	while true do
		local pos1, pos2 = find(self, pat, 1, plain or false)
		if not pos1 or pos1>pos2 or (max and #t>=max) then
			if max and #t>=max then
				return t, filter(self, t, true)
			else
				tinsert(t, filter(self, t, nil))
				return t
			end
		end
		tinsert(t, filter(sub(self, 1, pos1 - 1), t))
		self = sub(self, pos2 + 1)
	end
end

-- https://github.com/amireh/lua_cliargs/blob/master/src/cliargs/utils/split.lua

