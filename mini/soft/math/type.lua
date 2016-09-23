return function(n)
	return type(n) == "number" and (
			n >= -9007199254740992
		and	n <= 9007199254740992
		and	n % 1 == 0
		and	"integer"
		or	"float"
	) or nil
end
