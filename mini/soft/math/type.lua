return function(n)
	return type(n) == "number" and (
			n >= -9007199254740992 -- -2^53 -- FIXME: seems a wrong limit
		and	n <=  9007199254740992 --  2^53 -- FIXME: seems a wrong limit
		and	n % 1 == 0
		and	"integer"
		or	"float"
	) or nil
end
-- FIXME: see below
-- source: http://lua-users.org/wiki/FloatingPoint
-- Largest power of ten: a 64-bit double can represent all integers exactly, up to about 1,000,000,000,000,000 (actually - 2^52 ... 2^52 - 1). [*3]
--  n >= -2^52 and n <= 2^52-1
--  n >= -4503599627370496 and n<= 4503599627370495
-- Largest power of ten: a 32-bit int can represent all integers exactly, up to about +/-2,000,000,000 (actually - 2^31 ... 2^31 - 1). 
--  n >= -2^31 and n <= 2^31-1
--  n >= -2147483648 and n <= 2147483647
