
local re_to_lua = require "mini.pattern".re_to_lua

assert( ("%"):gsub("%%", "%%%%") == "%%")
assert( ([[\\]]):gsub([[\\]], [[%%\]]) == [[%\]])

local lua_to_re = require "mini.pattern".lua_to_re

assert( ([[%\]]):gsub([[%%\]], [[\\]]) == [[\\]])
assert( not ([[%]]):find("%%%%") )
assert( ([[%%]]):gsub("%%%%", "%%") == "%")

local luapat = "\\([%^%$%(%)%%%.%[%]%*%+%-%?])"
assert( re_to_lua(lua_to_re(luapat)), luapat)

