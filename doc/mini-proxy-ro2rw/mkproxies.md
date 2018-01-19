Le fichier étudier dans ce document est [mini/proxy/ro2rw/mkproxies.lua](https://github.com/tst2005/lua-mini/blob/dev/mini/proxy/ro2rw/mkproxies.lua#L4-L8)

C'est un module qui contient une fonction `mkproxy` en plusieurs variantes.
* `mkproxy1`
* `mkproxy2`
* `mkproxy1prefix`
* `mkproxy2prefix`

J'aurais pu faire plusieurs fichiers séparés mais au vu de la faible longueur et de la grande similitude entre les variantes,
j'ai préféré les avoir au meme endroit.

# Quelle est cette fonction ?

Il s'agit de la fonction que j'ai nommé `mkproxy` (pour "make proxy")
Commencons pas la version plus simple `mkproxy1`.

## mkproxy1, la version simple

```lua
local function mkproxy1(orig, k)
	return function(...)
		return orig[k](orig, ...)
	end
end
```

Vous avez peut-être du mal à lire ou comprendre ce code...
Reprenons depuis le début!

# A quoi sert un proxy ?

Un proxy est une fonction différente (distincte) qui fait la meme chose que l'original.

## un exemple simple

```lua
-- la fonction hello ci dessous sera notre fonction originale
local function hello()
	return "hello world"
end
-- nous pouvons crééer une autre fonction nommée proxy qui utilisera l'original et renverra son résultat
local function proxy()
	return hello()
end
print(hello()) -- hello world
print(proxy()) -- hello world
print("hello", hello)
print("proxy", proxy)
print(hello == proxy) -- false, proxy est différent de hello
```
En apparence on voit qu'elles sont différentes mais a l'utilisation elle semble bien identique.

## un générateur de proxy



```lua
local function hello() -- notre fonction originale
	return "hello world"
end
local function mkproxy(f) -- f pourra être la fonction hello ou une autre fonction!
	local proxy = function() -- On créé toujours un nouveau `proxy`. Si on utilise 2 fois la fonction mkproxy elle renverra 2 fonctions distinctes.
		return f()
	end
	return proxy
end
local proxy = mkproxy(hello)
print(hello()) -- hello world
print(proxy()) -- hello world
print("hello", hello)
print("proxy", proxy)
print(hello == proxy) -- false, proxy est différent de hello
```

# générateur de proxy pour un élément de table

Contrairement aux exemples simple a qui on donne une fonction a utiliser (la fonction `hello` précédement),
ma fonction `mkproxy1` est prévue pour 

```lua
local function mkproxytable(orig, k) -- orig est une table, k est le nom d'un élement
	local f = orig[k] -- f est une fonction
	local p = function(...) -- p est le proxy créé qui executera
		return f(orig, ...)
	end
	return p
end
```
Si la fonction `hello` définie plus haut était dans une table.
On peut créé une 2eme table `t2` (différente de la 1ère table `t`) dans laquelle on met un proxy à l'élément "hello".
On obtiendra donc `t.hello` et `t2.hello`, l'une la fonction originale, l'autre le proxy de la 1ère.

```lua
local t = {["hello"] = hello}
local t2 = {["hello"] = mkproxytable(t,"hello")}
print(t.hello()) -- hello world
print(t2.hello()) -- hello world
print(t.hello == t2.hello) -- false, les fonctions sont différentes
print(t.hello() == t2.hello()) -- true, les résultats sont identiques
```



# générateur de proxy pour avec original dynamique

```lua
t.hello=function() return "good bye" end
print(t.hello()) -- good bye
print(t2.hello()) -- hello world
print(t.hello()==t2.hello()) -- false, les résultats ne sont plus identiques!
```

```lua
local t = {["hello"] = hello}
local t2 = {["hello"] = mkproxy1(t,"hello")}
print(t.hello()) -- hello world
print(t2.hello()) -- hello world
print(t.hello == t2.hello) -- false
t.hello=function() return "good bye" end
print(t.hello()) -- good bye
print(t2.hello()) -- good bye
print(t.hello() == t2.hello()) -- les résultats sont a nouveau identiques
```

# Dans quel cas ai-je besoin de ces fonctions `mkproxy` ?

C'est utile lorsqu'on souhaite laisser utiliser une fonction (ou un ensemble de fonction) sans y laisser accès directement.

Je l'utilise pour `ro2rw`, `mkproxy` et ses variantes sont un petit rouage d'une plus grosse machine!
