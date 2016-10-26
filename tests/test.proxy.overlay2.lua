local overlay = require "mini.proxy.overlay"

local d = {}
d["."]=d
d[".."]={}
d["cc"]="ORIG"

do ------------------------------------------------------
local _d,mount,unproxy,copy = overlay(d, true)
local newd = d
local d = copy

assert(newd["."]==d["."])
assert(newd[".."]==d[".."])
assert(newd["nonexistant"]==nil)

-- mount
mount["cc"]="MOUNTED"
assert(newd["cc"]=="MOUNTED")

newd["dd"]="DD"
assert(d["dd"]=="DD")
assert(mount["dd"]==nil)
assert(copy["dd"]=="DD") -- ?

local ok, err = pcall(function() newd["cc"]="foo" end)
assert(not ok and err:find(": readonly$"))
assert(d["cc"]~="foo")

-- umount
mount["cc"]=nil
assert(newd["cc"]=="ORIG")

assert(d["dd"]=="DD")

-- unproxify
unproxy()

assert(copy["dd"]==nil)
assert(newd["dd"]=="DD")

end ----------------------------------------------------

assert(d["dd"]=="DD")
assert(d["cc"]=="ORIG")
assert(d["."]==d)
assert(d[".."])
