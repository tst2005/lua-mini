
backports,newer:	get a newer behavior on an older VM

	to51_?from50?
	to52_from{51}
	to53_from{51,52}

compat,older:		get back an older behavior on a recent VM

	to51_from{52,53}
	to52_from{53}
	to53_?from54?

## string -> number (base 10)

```
%5.1 return tonumber("10.2"), tonumber("10.2", 10)
10.2, 10.2

%5.2 return tonumber("10.2"), tonumber("10.2", 10)
10.2, nil

%5.3 return tonumber("10.2"), tonumber("10.2", 10)
10.2, nil
```

## number -> number (base 10)

```
%5.1 return tonumber(10.2, 10)
10.2

%5.2 return tonumber(10.2, 10)
nil

%5.3 return tonumber(10.2, 10)
bad argument #1 to 'tonumber' (string expected, got number)
```

## number -> number (no base)

```
$ lua5.1 -e 'print(tonumber(10.0))'
10
$ lua5.2 -e 'print(tonumber(10.0))'
10
$ lua5.3 -e 'print(tonumber(10.0))'
10.0
```

## lua 5.3 float VS int

```
$ lua5.3 -e 'print(tonumber(10.0))'
10.0
$ lua5.3 -e 'print(tonumber(10))'
10
``` 

#

```
$ lua5.3 -e 'print(tonumber(10.000))'                                                                                                                                         
10.0
$ lua5.2 -e 'print(tonumber(10.000))'                                                                                                                                         
10
$ lua5.1 -e 'print(tonumber(10.000))'                                                                                                                                         
10
```

```
$ lua5.1 -e 'print(tonumber(10.000,10))'                                                                                                                                      
10
$ lua5.2 -e 'print(tonumber(10.000,10))'
10
$ lua5.3 -e 'print(tonumber(10.000,10))'
lua5.3: (command line):1: bad argument #1 to 'tonumber' (string expected, got number)
```

```
$ lua5.1 -e 'print(tonumber("10.000",10))'                                                                                                                                    
10
$ lua5.2 -e 'print(tonumber("10.000",10))'                                                                                                                                    
nil
$ lua5.3 -e 'print(tonumber("10.000",10))'                                                                                                                                 
nil

```
