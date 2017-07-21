
backports,newer:	get a newer behavior on an older VM

	to51_?from50?
	to52_from{51}
	to53_from{51,52}

compat,older:		get back an older behavior on a recent VM

	to51_from{52,53}
	to52_from{53}
	to53_?from54?
