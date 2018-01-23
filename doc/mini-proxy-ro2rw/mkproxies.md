Le fichier étudié dans ce document est [mini/proxy/ro2rw/mkproxies.lua](https://github.com/tst2005/lua-mini/blob/dev/mini/proxy/ro2rw/mkproxies.lua#L4-L8)

C'est un module qui contient une fonction `mkproxy` en plusieurs variantes.
* `mkproxy1`
* `mkproxy2`
* `mkproxy1prefix`
* `mkproxy2prefix`

J'aurais pu faire plusieurs fichiers séparés mais au vu de la faible longueur et de la grande similitude entre les variantes,
j'ai préféré les avoir au même endroit.

# Quelle est cette fonction ?

Il s'agit de la fonction que j'ai nommé `mkproxy` (pour "make proxy")
Commencons par la version la plus simple `mkproxy1`.

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
En apparence on voit qu'elles sont différentes mais à l'utilisation elles semblent bien identiques.

## un générateur de proxy

```lua
local function hello() -- notre fonction originale
	return "hello world"
end
local function mkproxy(f) -- f pourra être la fonction hello ou une autre fonction!
	local proxy = function() -- On créé toujours un nouveau `proxy`
		return f()
	end
	return proxy
end
-- NB: Si on utilise 2 fois la fonction `mkproxy` elle renverra 2 fonctions distinctes.
local proxy = mkproxy(hello)
print(hello()) -- hello world
print(proxy()) -- hello world
print("hello", hello)
print("proxy", proxy)
print(hello == proxy) -- false, proxy est différent de hello
```

# un générateur de proxy avec argument

Jusqu'à présent les exemples ont été fait avec une fonction originale `hello` qui ne prennait pas d'argument.
Il suffit de modifier légèrement le code pour passer les arguments reçus par le proxy à la fonction orignale.

Voici un fonction hello avec argument
```lua
local function hello(who)
	return "hello "..tostring((who or "world"))
end
```

Et voiçi le générateur de proxy avec argument
```lua
local function mkproxyarg(f)
	local proxy = function(...)
		return f(...)
	end
	return proxy
end
```

```lua
local proxy = mkproxyarg(hello)
print(hello("people"), "hello people") -- hello people
print(proxy("people"), "hello people") -- hello people
```

# générateur de proxy pour un élément de table

Contrairement aux exemples simples à qui on donne une fonction à utiliser (la fonction `hello` précédement),
ma fonction `mkproxy1` est prévue pour utiliser une table contenant des fonctions.

```lua
local function mkproxytable(orig, k) -- orig est une table, k est le nom d'un élement
	local f = orig[k] -- f est une fonction
	local p = function(...) -- p est le proxy créé qui executera
		return f(...)
	end
	return p
end
```
Si la fonction `hello` définie plus haut était dans une table.
On peut créer une 2ème table `t2` (différente de la 1ère table `t`) dans laquelle on met un proxy à l'élément "hello".
On obtiendra donc `t.hello` et `t2.hello`, l'une est la fonction originale, l'autre le proxy de la 1ère.

```lua
local t = {["hello"] = hello}
local t2 = {["hello"] = mkproxytable(t,"hello")}
print(t.hello("w")) -- hello world
print(t2.hello("w")) -- hello world
print(t.hello == t2.hello) -- false, les fonctions sont différentes
print(t.hello("w") == t2.hello("w")) -- true, les résultats sont identiques
```

# générateur de proxy pour avec original dynamique

le problème avec `mkproxytable` est qu'il mémorise la fonction à utiliser (`local f = orig[k]`).
Cela pour effet de garder la fonction originale prise au moment de la création du proxy.

```lua
t.hello=function() return "good bye" end
print(t.hello()) -- good bye
print(t2.hello()) -- hello world
print(t.hello()==t2.hello()) -- false, les résultats ne sont plus identiques!
```

Si comme moi vous voulez qu'à chaque appel du `proxy` il consulte la fonction qu'il y aura dans la table originale,
afin de refléter les changements éventuels de l'original.

Voici donc la variante de mkproxytable pour toujours prendre la fonction originale au moment où on l'utilise.

```lua
local function mkproxytable2(orig, k) -- orig est une table, k est le nom d'un élement
	local p = function(...) -- p est le proxy créé qui executera
		local f = orig[k] -- f est une fonction, récupérée lors de l'utilisation du proxy p
		return f(...)
	end
	return p
end
```

On peut le simplifier en
```lua
local function mkproxytable2b(orig, k) -- orig est une table, k est le nom d'un élement
	local p = function(...) -- p est le proxy créé qui executera
		return orig[k](...)	-- orig[k] est une fonction, récupérée lors de l'utilisation du proxy p
	end
	return p
end
```

Ou bien

```lua
local function mkproxytable2c(orig, k) -- orig est une table, k est le nom d'un élement
	return function(...) -- cette fonction est le proxy
		return orig[k](...)	-- orig[k] est une fonction, récupérée lors de l'utilisation du proxy p
	end
end
```

```lua
local t = {["hello"] = hello}
local t2 = {["hello"] = mkproxytable2c(t,"hello")}
print(t.hello()) -- hello world
print(t2.hello()) -- hello world
print(t.hello == t2.hello) -- false
t.hello=function() return "good bye" end
print(t.hello()) -- good bye
print(t2.hello()) -- good bye
print(t.hello() == t2.hello()) -- les résultats sont a nouveau identiques
```

# Qu'est-ce qu'un proxy d'object ?

Au final si on compare `mkproxytable2c` et `mkproxy1` il reste une différence notable.
Dans tous les exemples cités j'ai cherché à produire un proxy qui appelerait une fonction originale de façon identique à l'utilisation qu'on fait de cette fonction originale.

En lua les systèmes de classes et instances sont construites à partir de table.
En lua une instance sera une table.

Le but de mes `mkproxy` est de mémoriser cette instance originale (qui sera une table)
mais lors de l'utilisation cette table sera ajouté en 1er argument.

# Dans quel cas ai-je besoin de ces fonctions `mkproxy` ?

C'est utile lorsqu'on souhaite laisser utiliser une fonction (ou un ensemble de fonction) sans y laisser accès directement.

Je l'utilise pour `ro2rw`, `mkproxy` et ses variantes sont un petit rouage d'une plus grosse machine.
Elle me sert à transformer une instance en table pour environnement.
Une instance est une table qu'on doit utiliser comme ceci :
 * `t:hello("people")`
 * `t.hello(instance, "people")`
en table pouvant servir d'environnement pouvant être utilisé comme ceci :
 * `t2.hello("people")`

```lua
local t = {}
function t:hello(who)
	return "hello "..tostring((who or "world"))
end
local t2 = {["hello"] = mkproxy1(t,"hello")}
print(t:hello("the end")) -- hello the end
print(t2.hello("the end")) -- hello the end
print(t.hello == t2.hello) -- false, les 2 fonctions sont distinctes

t.hello=function(self) return "good bye" end -- on simule le changement de la fonction originale
print(t:hello()) -- good bye
print(t2.hello()) -- good bye
print(t:hello() == t2.hello()) -- true, les résultats sont identiques
```

