-- source: http://lua-users.org/wiki/SimpleRound

return function (num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end
