
package = 'mini'
version = '0.1.0-alpha'
source = {
  url = 'https://github.com/tst2005/lua-mini/archive/FILLME.tar.gz',
  dir = 'FILLME'
}
description = {
  summary = 'lua-mini ...',
  detailed = [[
...
  ]],
  homepage = 'https://github.com/tst2005/lua-mini/',
  license = 'MIT <http://opensource.org/licenses/MIT>'
}
dependencies = {
  'lua >= 5.1, <5.4',
}
build = {
  type = 'builtin',
  modules = {
	["mini"]			=	"mini.lua",
	["mini.assertlevel"]		= 	"mini/assertlevel.lua",
--	["mini.assoc"]			= 	"mini/assoc.lua",
	["mini.cache"]			= 	"mini/cache.lua",
	["mini.class"]			= 	"mini/class/autometa.lua",
	["mini.class.autometa"]		= 	"mini/class.lua",
	["mini.class.meth-prot"]	= 	"mini/class/meth-prot.lua",
	["mini.soft.unpack"]		=	"mini/soft/unpack.lua",
	["mini.unpack"]			=	"mini/unpack.lua",
	["mini.load"]			= 	"mini/load.lua",
	["mini.compat-env"]		=	"mini/compat-env.lua",
	["mini.table.maxn"]		= 	"mini/table/maxn.lua",
--	["mini.tonumber"]		= 	"mini/tonumber.lua",
	["mini.soft.tonumber"]		= 	"mini/soft/tonumber.lua",
	["mini.copy"]			= 	"mini/copy.lua",
--	["mini.iterator.range"]		= 	"mini/iterator/range.lua",
--	["mini.kpairs"]			= 	"mini/kpairs.lua",

--	["mini.lookup"]			= 	"mini/lookup.lua",
	["mini.lookupify"]		= 	"mini/lookupify.lua",

	["mini.math.round"]		= 	"mini/math/round.lua",
	["mini.soft.math.type"]		=	"mini/soft/math/type.lua",
	["mini.math.type"]		=	"mini/math/type.lua",

	["mini.memoize"]		= 	"mini/memoize.lua",

	["mini.microclass"]		= 	"mini/microclass.lua",
	["mini.miniclass"]		= 	"mini/miniclass.lua",

	["mini.pattern"]		= 	"mini/pattern.lua",
	["mini.pattern.lua_to_re"]	= 	"mini/pattern/lua_to_re.lua",
	["mini.pattern.re_to_lua"]	= 	"mini/pattern/re_to_lua.lua",

	["mini.proxy.expose"]		= 	"mini/proxy/expose.lua",
	["mini.proxy.ro2rw"]		= 	"mini/proxy/ro2rw.lua",
	["mini.proxy.shadowself"]	= 	"mini/proxy/shadowself.lua",
	["mini.proxy.wrapf"]		= 	"mini/proxy/wrapf.lua",
	["mini.quote_magics"]		= 	"mini/quote_magics.lua",

	["mini.string.split"]		= 	"mini/string/split.lua",

	["mini.table.arraycopy"]	= 	"mini/table/arraycopy.lua",
	["mini.table.deepcopy"]		= 	"mini/table/deepcopy.lua",
	["mini.table.foreachi"]		= 	"mini/table/foreachi.lua",
	["mini.table.foreach"]		= 	"mini/table/foreach.lua",

	["mini.table.isempty"]		= 	"mini/table/isempty.lua",
	["mini.table.shallowcopy"]	= 	"mini/table/shallowcopy.lua",
	["mini.table.update"]		= 	"mini/table/update.lua",
--	["mini.tcopy"]			= 	"mini/tcopy.lua",
	["mini.tcopyonwrite"]		= 	"mini/tcopyonwrite.lua",

	["mini.toboolean"]		= 	"mini/toboolean.lua",
	["mini.unpack"]			= 	"mini/unpack.lua",
	["mini.weaktable"]		= 	"mini/weaktable.lua",

	["mini.strict.mro"]		=	"mini/strict/mro.lua",

--	["mini.luafun.fun"]	= 	"mini/luafun/fun.lua",
--	["mini.luafun.tests.basic"]	= 	"mini/luafun/tests/basic.lua",
--	["mini.luafun.tests.compositions"]	= 	"mini/luafun/tests/compositions.lua",
--	["mini.luafun.tests.filtering"]	= 	"mini/luafun/tests/filtering.lua",
--	["mini.luafun.tests.generators"]	= 	"mini/luafun/tests/generators.lua",
--	["mini.luafun.tests.indexing"]	= 	"mini/luafun/tests/indexing.lua",
--	["mini.luafun.tests.operators"]	= 	"mini/luafun/tests/operators.lua",
--	["mini.luafun.tests.reducing"]	= 	"mini/luafun/tests/reducing.lua",
--	["mini.luafun.tests.slicing"]	= 	"mini/luafun/tests/slicing.lua",
--	["mini.luafun.tests.transformations"]	= 	"mini/luafun/tests/transformations.lua",

  },
--[[
  install = {
    bin = {
      ldoc = "aio/ldoc-only.lua"
    }
  }
]]--
}
