|bitop	|bit32	|bit.numberlua	|function name	|jit2.0	|5.1	|5.2/5.3compat	|5.3	|[minimal]	|
|-------|-------|---------------|---------------|-------|-------|---------------|-------|---------------|
|	|	|bit.numberlua	|band		|y	|y	|y		|y	|minimal	|
|	|bit32	|		|band		|-	|-	|y		|	|minimal	|
|bit	|	|		|band		|y	|-	|y		|	|minimal	|
|	|	|		|`&`		|	|	|		|`&`	|minimal	|
|													|
|	|	|bit.numberlua	|bnot		|y	|y	|y		|y	|minimal	|
|	|bit32	|		|bnot		|-	|-	|y		|	|minimal	|
|bit	|	|		|bnot		|y	|-	|y		|	|minimal	|
|	|	|		|`~`		|	|	|		|`~`	|minimal	|
|													|
|	|	|bit.numberlua	|bor		|y	|y	|y		|y	|minimal	|
|	|bit32	|		|bor		|-	|-	|y		|	|minimal	|
|bit	|	|		|bor		|y	|-	|y		|	|minimal	|
|	|	|		|`|`		|	|	|		|`|`	|minimal	|
|													|
|	|	|bit.numberlua	|bxor		|y	|y	|y		|y	|minimal	|
|	|bit32	|		|bxor		|-	|-	|y		|	|minimal	|
|bit	|	|		|bxor		|y	|-	|y		|	|minimal	|
|	|	|		|`~`		|	|	|		|`~`	|minimal	|
|													|
|	|	|bit.numberlua	|lshift		|y	|y	|y		|y	|minimal	|
|	|bit32	|		|lshift		|-	|-	|y		|	|minimal	|
|bit	|	|		|lshift		|y	|?	|y		|	|minimal	|
|	|	|		|`<<`		|	|	|		|`<<`	|minimal	|
|													|
|	|	|bit.numberlua	|rshift		|y	|y	|y		|y	|minimal	|
|	|bit32	|		|rshift		|-	|-	|y		|	|minimal	|
|bit	|	|		|rshift		|y	|?	|y		|	|minimal	|
|	|	|		|`>>`		|	|	|		|`>>`	|minimal	|
|													|
|	|	|bit.numberlua	|arshift	|y	|y	|y		|y	|minimal	|
|	|bit32	|		|arshift	|-	|-	|y		|-	|common		|
|bit	|	|		|arshift	|y	|?	|y		|-	|common		|
|													|
|	|	|bit.numberlua	|lrotate	|y	|y	|y		|y	|minimal	|
|	|bit32	|		|lrotate	|-	|-	|y		|-	|common		|
|bit	|	|		|rol		|y	|?	|y		|-	|common		|
|													|
|	|	|bit.numberlua	|rrotate	|y	|y	|y		|y	|minimal	|
|	|bit32	|		|rrotate	|-	|-	|y		|-	|common		|
|bit	|	|		|ror		|y	|?	|y		|-	|common		|
|													|
|bit	|	|		|bswap		|Y	|-	|-		|-	|bitop		|
|	|	|bit.numberlua	|bswap		|y	|y	|y		|y	|bit.numberlua	|
|													|
|bit	|	|		|tohex		|Y	|-	|-		|-	|bitop		|
|	|	|bit.numberlua	|tohex		|y	|y	|y		|y	|bit.numberlua	|
|													|
|bit	|	|		|tobit		|Y	|-	|-		|-	|bitop		|
|													|
|	|bit32	|		|btest		|-	|-	|Y		|-	|bit32		|
|	|	|bit.numberlua	|btest		|y	|y	|y		|y	|bit.numberlua	|
|													|
|	|bit32	|		|extract	|-	|-	|Y		|-	|bit32		|
|	|	|bit.numberlua	|extract	|y	|y	|y		|y	|bit.numberlua	|
|													|
|	|bit32	|		|replace	|-	|-	|Y		|-	|bit32		|
|	|	|bit.numberlua	|replace	|y	|y	|y		|y	|bit.numberlua	|
