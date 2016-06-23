# lua mini

Some minimal util for lua.

Mainly :
 * class system
 * forward compat for `load` function
 * some other minor functions

Some code comes from thirdparties :
 * mini.class : [knife.base][knife.base] under [MIT License][knife-lic]
 * mini.compat-env : [pl.compat][pl.compat] under [MIT License][pl-lic]

Components
==========

## assertlevel.lua

It's an `assert` function that accept the `error` function's third argument.


## assoc.lua

A way to get an uniq value (as key) from two or more object.

```lua
local a, b, c = {}, {}, {}

local t = {}
local key = assoc(a, b, c)
t[key] = "abc"
```

## class/*.lua

## class.lua

## compat-env.lua

Provide a minimalist forward compatibility layer for the `load` function

## ro2rw.lua

Generate a read/writable table proxy indexed from a readonly table.

## (memoize.lua)

FILLME

## (misc.lua)

FILLME

## pattern.lua

FILLME

## quote_magics.lua

A function to convert plaintext to lua pattern to be matched using any `string.*` matching function (`find`, `match`, `gsub`, ...)



## shadowself.lua

Use to use an instance like a usual standalone function

## tcopy.lua

FILLME

## toboolean.lua

A simple function to convert :
 * `"true"` string to `true` boolean value
 * `"false"` string to `false` boolean value
 * anything else to nil

## weaktable.lua

FILLME


# License

My code is under [MIT License][mycode-lic]


[knife.base]: https://github.com/airstruck/knife/blob/master/knife/base.lua
[knife-lic]: https://github.com/airstruck/knife/blob/master/license

[pl.compat]: https://github.com/tst2005/lua-penlight/blob/master/lua/pl/compat.lua#L51-L67
[pl-lic]: https://github.com/tst2005/lua-penlight/blob/master/LICENSE.md

[mycode-lic]: https://www.opensource.org/licenses/mit-license

