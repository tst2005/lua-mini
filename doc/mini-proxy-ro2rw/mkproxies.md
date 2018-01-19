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

Si vous avez du mal a lire ce code, voici une version qui pourra peut-être vous aidez.

# A quoi sert un proxy ?

Un proxy est une fonction différente qui fait la meme chose.
C'est un élément qui fait "relai" ou qui fait semblant d'être l'originale en ne l'étant pas.

## un exemple simple

```lua
local function hello()
	return "hello world"
end
local function proxy()
	return hello()
end
print(hello()) -- hello world
print(proxy()) -- hello world
print("hello", hello)
print("proxy", proxy)
print(hello == proxy) -- false, proxy est différent de hello
```

## un générateur de proxy

```lua
local function hello()
	return "hello world"
end
local function mkproxy(f)
	local p = function()
		return f()
	end
	return p
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

Je l'utilise pour `ro2rw` ...
