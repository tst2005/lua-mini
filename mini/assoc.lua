
-- 1&2 => result

local function cache_set2(t_cache, result, obj1, obj2)
	assert(type(t_cache)=="table")
	if type(t_cache[obj1])=="table" then
		if t_cache[obj1][obj2] ~= nil then
			return result
		end
	else
		t_cache[obj1] = {} -- weak key/value table 
	end
	t_cache[obj1][obj2] = result
	return result
end

-- 1&2 => result

local function cache_get2(t_cache, obj1, obj2)
	assert(type(t_cache)=="table")
	if type(t_cache[obj1])=="table" and t_cache[obj1][obj2] ~= nil then
		return t_cache[obj1][obj2]
	end
	return nil
end


-- 1 2 3 4 5
-- (((1&2)&3)&4)&5

local function cache_setN(t_cache, result, obj1, obj2, ...)
	if #{...} > 0 then
		cache_setN(t_cache, result, cache_set2(t_cache, {}, obj1, obj2), ...)
	else
		cache_set2(t_cache, result, obj1, obj2)
	end
	return
end

local function cache_getN(t_cache, obj1, obj2, ...)
	if #{...} > 0 then
		return cache_getN(t_cache, cache_get2(t_cache, obj1, obj2), ...)
	end
	return cache_get2(t_cache, obj1, obj2)
end
local M = {}
M.set2 = cache_set2
M.get2 = cache_get2
M.set  = cache_setN
M.get  = cache_getN
return M
