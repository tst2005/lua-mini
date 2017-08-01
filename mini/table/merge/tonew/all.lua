local tonew = require "mini.table.merge.tonew"
return function(a, ...)
        local t_args = {...}
        for _i,b in ipairs(t_args) do
                a = tonew(a,b)
        end
        return a
end
