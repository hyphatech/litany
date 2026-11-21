# quadratic-string-concat-chain

a chain of three or more (^) segments

<!-- Written by docs/catalog.ts from `litany explain quadratic-string-concat-chain`; never edited by hand. -->

**pedantic · warning · stable · since 1.0 · fix: never · off by default**

`(^)` associates to the right, so `a ^ b ^ c` builds `b ^ c` and then
copies it whole into `a ^ (b ^ c)`: every added segment recopies the ones
after it.

```ocaml
(* bad *)  dir ^ "/" ^ file
(* good *) String.concat "" [ dir; "/"; file ]
```

Fires when `Stdlib.(^)`'s right operand is itself a `Stdlib.(^)`
application — three or more segments in one chain. A two-segment
concatenation, a rebound `(^)`, and a left-parenthesized `(a ^ b) ^ c`
(the right operand is simple) deliberately do not fire. A chain of n
segments holds n − 2 matching nodes; the rule reports one finding per
maximal chain — at the innermost matching node, whose rightmost operand
is simple — so a nine-segment chain is one finding, not seven. Two
copies of three short segments rarely
matter, hence pedantic and off; no fix, because choosing the separator
layout is editorial.

Option `(max-segments <n>)` (n ≥ 2, default 2) raises the tolerated
chain length: only chains of more than n segments fire, anchored at the
node where the chain first exceeds n. This makes the recorded
narrowing — a higher segment threshold — configurable:

```lisp
(rule quadratic-string-concat-chain
 (max-segments 4))
```

Pedantic: a chain of three or four segments in a message or a path costs nothing
anyone would measure, so reporting one is a house's choice.
