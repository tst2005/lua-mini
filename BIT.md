|bitop	|bit32	|function name	|jit2.0	|5.1	|5.2/5.3compat	|5.3	|[minimal]	|
|-------|-------|---------------|-------|-------|---------------|-------|---------------|
|	|bit32	|band		|-	|-	|y		|	|minimal	|
|bit	|	|band		|y	|y	|y		|	|minimal	|
|	|	|`&`		|	|	|		|`&`	|minimal	|
|											|
|	|bit32	|bnot		|-	|-	|y		|	|minimal	|
|bit	|	|bnot		|y	|y	|y		|	|minimal	|
|	|	|`~`		|	|	|		|`~`	|minimal	|
|											|
|	|bit32	|bor		|-	|-	|y		|	|minimal	|
|bit	|	|bor		|y	|y	|y		|	|minimal	|
|	|	|`|`		|	|	|		|`|`	|minimal	|
|											|
|	|bit32	|bxor		|-	|-	|y		|	|minimal	|
|bit	|	|bxor		|y	|y	|y		|	|minimal	|
|	|	|`~`		|	|	|		|`~`	|minimal	|
|											|
|	|bit32	|lshift		|-	|-	|y		|	|minimal	|
|bit	|	|lshift		|y	|y	|y		|	|minimal	|
|	|	|`<<`		|	|	|		|`<<`	|minimal	|
|											|
|	|bit32	|rshift		|-	|-	|y		|	|minimal	|
|bit	|	|rshift		|y	|y	|y		|	|minimal	|
|	|	|`>>`		|	|	|		|`>>`	|minimal	|
|											|
|	|bit32	|arshift	|-	|-	|y		|-	|common		|
|bit	|	|arshift	|y	|y	|y		|-	|common		|
|											|
|	|bit32	|lrotate	|-	|-	|y		|-	|common		|
|bit	|	|rol		|y	|y	|y		|-	|common		|
|											|
|	|bit32	|rrotate	|-	|-	|y		|-	|common		|
|bit	|	|ror		|y	|y	|y		|-	|common		|
|											|
|bit	|	|bswap		|y	|y	|y		|-	|bitop		|
|bit	|	|tobit		|y	|y	|y		|-	|bitop		|
|bit	|	|tohex		|y	|y	|y		|-	|bitop		|
|											|
|	|bit32	|btest		|-	|-	|Y		|-	|bit32		|
|	|bit32	|extract	|-	|-	|Y		|-	|bit32		|
|	|bit32	|replace	|-	|-	|Y		|-	|bit32		|
