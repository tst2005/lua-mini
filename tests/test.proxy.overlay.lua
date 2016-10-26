local overlay = require "mini.proxy.overlay"

local d = {}
d["."]=d
d[".."]={}
d["cc"]="ORIG"

local newd,mount = overlay(d)
assert(newd["."]==d)
assert(newd[".."]==d[".."])
assert(newd["nonexistant"]==nil)

-- mount
mount["cc"]="MOUNTED"
assert(newd["cc"]=="MOUNTED")

newd["dd"]="DD"
assert(d["dd"]=="DD")
assert(mount["dd"]==nil)

local ok, err = pcall(function() newd["cc"]="foo" end)
assert(not ok and err:find(": readonly$"))
assert(d["cc"]~="foo")

-- umount
mount["cc"]=nil
assert(newd["cc"]=="ORIG")

assert(d["dd"]=="DD")
