local function merge(dest, source)
        for k,v in pairs(source) do
                dest[k] = dest[k] or v
        end
        return dest
end
local function keysfrom(source, keys)
        assert(type(source)=="table")
        assert(type(keys)=="table")
        local t = {}
        for i,k in ipairs(keys) do
                t[k] = source[k]
        end
        return t
end

