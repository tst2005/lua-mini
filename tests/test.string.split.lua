local split = require "mini.string.split"

assert( table.concat(split("aa bb cc  d dd e", " ", true), ";") == "aa;bb;cc;;d;dd;e")
assert( table.concat(split("aa bb cc  d dd e", "%s+"), ";") == "aa;bb;cc;d;dd;e")
