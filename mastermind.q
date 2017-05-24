perm:{{raze x{x,/:y except x}\:y}[;y]/[x-1;y]}
score:{[g;c]                    / (g)uess, (c)ode
 w:where not e:c=g;             / (e)xact
 i:{x _ x ? y}/[c w;g w];       / (i)ncorrect
 ("j"$sum e;count[w]-count i)}
filt:{[S;G;g;s](S _:S?g;G where (s~score[g]@) each G)} / (S)et (G)uesses, (s)core, (g)uess
pick:{[f;S;G] / (f)unction, (S)et of unused records, logical (G)uesses
 if[1=count G;:first G];              / only 1 left
 S@:where f (group G score\:) each S; / filter all unpicked codes for best split
 first $[count G:G inter S;G;S]} / guess a viable solution if possible
algo:{[f;SGgs] SG,enlist pick[f] . SG:filt . SGgs}
turn:{[a;c;SGgs] SGg,enlist score[;c]last SGg:a SGgs}
game:{[a;S;g;c](not count[g]=first last@) turn[a;c]\  (S;S;g;score[g;c])}
summary:{[SGgs]`n`guess`score!(count SGgs 1),-2#SGgs}
dist:count each group asc@
/ algorithms
simple:{enlist 1b}                             / simple case
mparts:{x=max x:count each x}                  / most parts
msize:{x=min x:(max count each) each x}        / min max size (knuth)
esize:{x=min x:({x wavg x} count each) each x} / min expected size
entropy:{x=min x:({sum x*2 xlog x%:sum x} count each) each x} / max entropy

guess:{[SG] -1"guess? HINT: ",-3!SG 1;read0 0}
stdin:{[SGgs]show enlist summary SGgs;SG,enlist guess SG:filt . SGgs}

\
/ An Optimal Mastermind (4,7) Strategy and More Results in the Expected Case
/ Geoffroy Ville
/ https://arxiv.org/pdf/1305.1010

S:cross/[4#enlist raze string til 6] / 4x6 Set (w/ repeat)
a:(count game[algo[`simple];S;"0000"]@) peach 50?S
b:(count game[algo[`msize];S;"0011"]@) peach 50?S
dist c:(count game[algo[`esize];S;"0012"]@) peach 50?S
dist d:(count game[algo[`entropy];S;"0123"]@) peach 50?S
dist e:(count game[algo[`mparts];S;"0012"]@) peach 50?S
summary each game[algo[`simple];S;"0011"] c:S 10
summary each game[algo[`msize];S;"0011"] c:S 10
summary each game[algo[`esize];S;"0011"] c:S 10
summary each game[algo[`entropy];S;"0011"] c:S 10
summary each game[algo[`msize];S;"0011"] c:rand S
summary each game[algo[`msize];S;"0011"] c:"0231"
summary each game[`stdin;S;"0011"] c:"0231"

c:"ROYGPABW"             / Red Orange Yellow Green Pink grAy Blue White
P:flip (where;raze til each)@\: 5 4 3 1 1 / peg combinations
SG:(S;S:perm[4] c)                        / 4x8 Set (no repeat)
pick[`mparts] . SG:(filt . SG)["BRAY";1 2]
pick[`mparts] . SG:(filt . SG)["ROAB";1 3]
pick[`mparts] . SG:(filt . SG)["ORYB";2 1]
pick[`mparts] . SG:(filt . SG)["AROB";4 0]

