local path = require "mini.path"

---- extname ----
assert( path("/a/b/c.x"):extname()		== ".x")
assert( path("/a/b/.file.ext"):extname()	== ".ext")
assert( path("index.html"):extname()		== ".html")
assert( path('index.coffee.md'):extname()	== ".md")
assert( path('index.'):extname()		== "." )
assert( path('index'):extname()			== "" )
assert( path('.index'):extname()		== "" )


local p = path("/a/b/c.x")
assert( tostring(p) == "/a/b/c.x" )
assert( p:dirname() == "/a/b" )
assert( p:basename() == "c.x" )
assert( p:isabs() == true )

p.sep =';'
assert( p:tostring() == ";a;b;c.x" )
assert( tostring(p)  == ";a;b;c.x" )

p = path(package.path, ';'):insert("END"):insert("BEGIN",1)
assert( p:tostring() == "BEGIN;"..package.path..";END" )

--print(p:concat('\n'))

p = path("a;b;c;d;e", ';')
assert(
	p	:insert("",3)
		:ifinsert("empty -->", p:search("", 0) or false)
		:ifinsert("<-- empty", p:search("", 1) or false)
		:tostring()
	== "a;b;empty -->;;<-- empty;c;d;e"
)

p = path("a;b;c;d;e", ';')
assert(
	p	:ifinsert("empty -->", p:search("", 0) or false)
		:ifinsert("<-- empty", p:search("", 1) or false)
		:tostring()
	== "a;b;c;d;e"
)

-- test clone
assert( type(p)=="table" and p:clone() ~= p)

local P=function(p) return path(p, '/') end
local a, r = "/a/b/s", "r/e/l"
local pa = P(a)
local pr = P(r)
--[[
assert( tostring( pa:join(pr)) == a.."/"..r)
assert( tostring( pr:join(pr)) == r.."/"..r)
assert( tostring( pa:join(pa)) == a)
assert( tostring( pr:join(pa)) == a)
]]--

assert( tostring( P(r):toabs(P("/1/2/3")) ) == "/1/2/3".."/"..r)
assert( tostring( P(a):toabs(P("/1/2/3")) ) == a)
assert( tostring( P('/'):toabs(P("/1/2/3")) ) == '/')
assert( tostring( P('b/c'):toabs(P("/"))) == "/b/c" )
assert( tostring( P('b/c'):toabs(P("/a"))) == "/a/b/c" )
assert( tostring( P('b/c'):toabs(P("/a/"))) == "/a/b/c" )

assert( tostring( P(r):toabs(P("/"))) == "/"..r)

print("OK")
