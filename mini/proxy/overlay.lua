
-- make a proxy object to
--  * enforce some content values
--  * deny write of this enforced values

--[[

read:
intercept layer d1:					["cc"]=dA,			<- bypass
base layer      d1:	["."]=d1,	[".."]=d0,	["cc"]=d2,			<- orig
write:
intercept       d1:					["cc"]=readonly,		<- bypass
base            d1:					["cc"]=d2,			<- orig


usual read : over[k] or orig[k]
usual write: if over[k]==nil then orig[k]=v else error("readonly")

mount action:
bypass write: assert(over[k]==nil); over[k]=v

umount action:
bypass write: assert(over[k]~=nil); over[k]=nil

]]--

-- solution 1 : use function for __index and __newindex
local function proxy_overlay(orig)
	local over = {}
	return setmetatable({}, {
		__index = function(_self, k)
			if over[k]==nil then
				return orig[k]
			else
				return over[k]
			end
		end,
		__newindex = function(_self, k,v)
			if over[k]~=nil then
				error("readonly", 2)
			else
				orig[k]=v
			end
		end,
	}), over
end

return proxy_overlay
