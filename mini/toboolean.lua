
--local function toboolean(v) return ({["true"]=true,["false"]=false})[v] end
local function toboolean(v)
	if v=="true" then
		return true
	elseif v=="false" then
		return false
	else
		return nil
	end
end
return toboolean
