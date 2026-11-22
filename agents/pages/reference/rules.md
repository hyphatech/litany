# Rules

Every rule litany has.

<!-- Written by docs/catalog.ts from `litany rules`; never edited by hand. -->

[Selecting rules](../guide/selecting-rules.md) says what the columns
decide.

**84 rules · 30 on by default (stable correctness, suspicious, perf) · 14 restriction (cherry-picked; outside all) · 16 nursery**

| Rule | Group | Stability | Fix | Default | Finds |
|---|---|---|---|---|---|
| [`dead-code`](rules/dead-code.md) | suspicious | nursery | never | off | exported value unreachable from any root |
| [`disable-all-warnings`](rules/disable-all-warnings.md) | suspicious | stable | never | on | a warning attribute disables every warning |
| [`eta-reducible-forwarding`](rules/eta-reducible-forwarding.md) | style | nursery | never | off | binding that only forwards its arguments |
| [`ignored-result`](rules/ignored-result.md) | restriction | stable | never | off | result or option value is discarded by a wildcard binding |
| [`invalid-function-comparison`](rules/invalid-function-comparison.md) | suspicious | stable | never | on | structural comparison with a function operand |
| [`invalid-hashtable-key`](rules/invalid-hashtable-key.md) | suspicious | stable | never | on | polymorphic Hashtbl operation on a value proved functional |
| [`invalid-nan-comparison`](rules/invalid-nan-comparison.md) | correctness | stable | never | on | comparison with nan is a compile-time constant |
| [`manual-boolean-operator`](rules/manual-boolean-operator.md) | style | stable | sometimes | off | if with one boolean-literal branch spells an operator longhand |
| [`manual-case-guard`](rules/manual-case-guard.md) | pedantic | nursery | never | off | case body that is immediately an if-then-else |
| [`manual-eta-lambda`](rules/manual-eta-lambda.md) | style | nursery | sometimes | off | anonymous function that only forwards its parameters |
| [`manual-format-quoting`](rules/manual-format-quoting.md) | pedantic | nursery | sometimes | off | format literal hand-quotes %s where %S quotes and escapes |
| [`manual-list-exists`](rules/manual-list-exists.md) | style | stable | never | off | recursive function that re-implements List.exists |
| [`manual-list-filter-map`](rules/manual-list-filter-map.md) | style | stable | never | off | recursive function that re-implements List.filter or filter_map |
| [`manual-list-fold`](rules/manual-list-fold.md) | style | stable | never | off | recursive function that re-implements a List fold |
| [`manual-list-forall`](rules/manual-list-forall.md) | style | stable | never | off | recursive function that re-implements List.for_all |
| [`manual-list-map`](rules/manual-list-map.md) | style | stable | never | off | recursive function that hand-rolls a list map |
| [`manual-option-bind`](rules/manual-option-bind.md) | style | stable | never | off | two-case option match that re-implements Option.bind |
| [`manual-option-map`](rules/manual-option-map.md) | style | stable | sometimes | off | two-case match that unwraps, transforms, and rewraps an option |
| [`manual-option-value`](rules/manual-option-value.md) | style | stable | sometimes | off | two-case match extracting an option's value over a trivial default |
| [`manual-record-update`](rules/manual-record-update.md) | style | stable | never | off | record rebuilt field by field from one base |
| [`manual-result-bind`](rules/manual-result-bind.md) | style | stable | never | off | two-case result match that re-implements Result.bind |
| [`manual-result-map`](rules/manual-result-map.md) | style | stable | sometimes | off | two-case match that transforms one result arm and rebuilds the other |
| [`manual-temp-dir`](rules/manual-temp-dir.md) | suspicious | stable | sometimes | on | temp file removed and re-created as a directory |
| [`manual-tuple-matching`](rules/manual-tuple-matching.md) | style | stable | sometimes | off | single irrefutable tuple case that could be a let binding |
| [`missing-final-newline`](rules/missing-final-newline.md) | style | nursery | always | off | file does not end with a newline |
| [`missing-printer`](rules/missing-printer.md) | pedantic | nursery | never | off | comparable abstract type whose interface exposes no printer |
| [`needless-and-binding`](rules/needless-and-binding.md) | style | nursery | never | off | let rec binding riding an and-chain it does not need |
| [`needless-append-empty`](rules/needless-append-empty.md) | style | stable | sometimes | off | append or concatenation with the neutral element |
| [`needless-fun-match`](rules/needless-fun-match.md) | style | nursery | never | off | fun-then-match over an otherwise unused final parameter |
| [`needless-list-length`](rules/needless-list-length.md) | perf | stable | sometimes | on | List.length compared with 0 or 1 to test emptiness |
| [`needless-list-map-before-concat`](rules/needless-list-map-before-concat.md) | perf | stable | never | on | List.map feeding concatenation builds an intermediate list |
| [`needless-mutually-recursive-types`](rules/needless-mutually-recursive-types.md) | style | stable | never | off | and-chained type that is not mutually recursive with its group |
| [`open-of-ordinary-module`](rules/open-of-ordinary-module.md) | restriction | nursery | never | off | an open of a module that is not made to be opened |
| [`outdated-str-module`](rules/outdated-str-module.md) | style | stable | never | off | reference into the outdated Str module |
| [`quadratic-list-append`](rules/quadratic-list-append.md) | perf | stable | never | on | list append folded with the accumulator on the left |
| [`quadratic-string-concat-chain`](rules/quadratic-string-concat-chain.md) | pedantic | stable | never | off | a chain of three or more (^) segments |
| [`quadratic-string-concat-fold`](rules/quadratic-string-concat-fold.md) | perf | stable | never | on | string concatenation folded through (^) |
| [`redundant-bind-return`](rules/redundant-bind-return.md) | style | stable | never | off | bind into a bare return re-wraps the value unchanged |
| [`redundant-boolean-comparison`](rules/redundant-boolean-comparison.md) | suspicious | stable | sometimes | on | comparison with a boolean constant |
| [`redundant-boolean-operator`](rules/redundant-boolean-operator.md) | style | stable | never | off | boolean operator with a constant operand |
| [`redundant-conversion-roundtrip`](rules/redundant-conversion-roundtrip.md) | perf | stable | sometimes | on | conversion immediately undone by its inverse |
| [`redundant-guard-true`](rules/redundant-guard-true.md) | suspicious | stable | sometimes | on | when guard that is literally true or false |
| [`redundant-if-bool`](rules/redundant-if-bool.md) | style | stable | sometimes | off | if whose both branches are boolean literals restates the condition |
| [`redundant-list-roundtrip`](rules/redundant-list-roundtrip.md) | perf | stable | never | on | list converted to a sequence and immediately back |
| [`redundant-match-bool`](rules/redundant-match-bool.md) | style | stable | sometimes | off | boolean match interrupting an if/else chain |
| [`redundant-nested-if`](rules/redundant-nested-if.md) | style | stable | sometimes | off | else-less if directly nested in an else-less if |
| [`redundant-not-not`](rules/redundant-not-not.md) | style | stable | sometimes | off | double boolean negation |
| [`redundant-option-comparison`](rules/redundant-option-comparison.md) | pedantic | stable | sometimes | off | comparison with None spells an Option predicate |
| [`redundant-option-roundtrip`](rules/redundant-option-roundtrip.md) | perf | stable | never | on | option converted to a list only to take its head back |
| [`redundant-return-bind`](rules/redundant-return-bind.md) | style | stable | never | off | bind of a fresh return wraps a value only to unwrap it |
| [`restricted-dependency`](rules/restricted-dependency.md) | restriction | stable | never | off | reference to a dependency forbidden by workspace policy |
| [`restricted-export-name`](rules/restricted-export-name.md) | restriction | stable | never | off | exported name breaking the configured naming policy |
| [`restricted-global-mutable-state`](rules/restricted-global-mutable-state.md) | restriction | stable | never | off | toplevel mutable state in library code |
| [`restricted-public-exception`](rules/restricted-public-exception.md) | restriction | stable | never | off | exception declared in a public library interface |
| [`suspicious-ambiguous-constructors`](rules/suspicious-ambiguous-constructors.md) | suspicious | nursery | never | off | constructor that shadows a standard constructor |
| [`suspicious-catch-all-handler`](rules/suspicious-catch-all-handler.md) | suspicious | stable | never | on | wildcard exception handler swallows every exception |
| [`suspicious-duplicate-condition`](rules/suspicious-duplicate-condition.md) | suspicious | stable | never | on | else-if condition that duplicates the previous arm's |
| [`suspicious-exit-in-library`](rules/suspicious-exit-in-library.md) | suspicious | stable | never | on | exit referenced in library code |
| [`suspicious-failwith-in-library`](rules/suspicious-failwith-in-library.md) | restriction | stable | never | off | failwith referenced in library code |
| [`suspicious-file-exists-race`](rules/suspicious-file-exists-race.md) | restriction | stable | never | off | exists check guarding a filesystem operation on the same path |
| [`suspicious-general-float-equality`](rules/suspicious-general-float-equality.md) | pedantic | stable | never | off | bit-exact equality on floats |
| [`suspicious-if-same-branches`](rules/suspicious-if-same-branches.md) | suspicious | stable | never | on | if whose two branches are written identically |
| [`suspicious-ignored-partial-application`](rules/suspicious-ignored-partial-application.md) | suspicious | stable | never | on | ignore of a value that is still a function |
| [`suspicious-literal-condition`](rules/suspicious-literal-condition.md) | suspicious | stable | never | on | if over a literal true or false condition |
| [`suspicious-lost-backtrace`](rules/suspicious-lost-backtrace.md) | suspicious | stable | never | on | work between catching and re-raising can overwrite the backtrace |
| [`suspicious-physical-equality`](rules/suspicious-physical-equality.md) | suspicious | stable | never | on | physical comparison with a non-immediate operand |
| [`suspicious-polymorphic-compare-on-opaque`](rules/suspicious-polymorphic-compare-on-opaque.md) | suspicious | stable | never | on | polymorphic comparison of a Set, Map, or Hashtbl value |
| [`suspicious-print-debugging`](rules/suspicious-print-debugging.md) | restriction | stable | never | off | console printing entrypoint referenced in library code |
| [`suspicious-rec-without-recursion`](rules/suspicious-rec-without-recursion.md) | suspicious | stable | sometimes | on | let rec group that never recurses |
| [`suspicious-sequence-ignored-value`](rules/suspicious-sequence-ignored-value.md) | suspicious | stable | never | on | pure projection discarded where the compiler cannot warn |
| [`suspicious-str-formatter`](rules/suspicious-str-formatter.md) | suspicious | stable | never | on | reference to the process-global Format.str_formatter |
| [`suspicious-swallowed-cancellation`](rules/suspicious-swallowed-cancellation.md) | suspicious | stable | sometimes | on | total handler around eio code converts cancellation into a value |
| [`suspicious-transposable-arguments`](rules/suspicious-transposable-arguments.md) | pedantic | stable | never | off | three adjacent same-typed unlabeled parameters |
| [`suspicious-unused-module-binding`](rules/suspicious-unused-module-binding.md) | suspicious | stable | never | on | module binding the unit never uses and never exports |
| [`suspicious-variant-arity-tuple`](rules/suspicious-variant-arity-tuple.md) | suspicious | stable | never | on | constructor whose one argument is a parenthesized tuple |
| [`suspicious-wall-clock-elapsed`](rules/suspicious-wall-clock-elapsed.md) | suspicious | stable | never | on | duration computed from wall-clock reads |
| [`trailing-whitespace`](rules/trailing-whitespace.md) | style | stable | always | off | trailing spaces or tabs at end of line |
| [`unsafe-obj-magic`](rules/unsafe-obj-magic.md) | restriction | stable | never | off | use of Obj.magic |
| [`untyped-ignore`](rules/untyped-ignore.md) | restriction | nursery | never | off | ignore discards a value without naming its type |
| [`untyped-wildcard-binding`](rules/untyped-wildcard-binding.md) | restriction | nursery | never | off | let _ discards a value without naming its type |
| [`wildcard-over-owned-variant`](rules/wildcard-over-owned-variant.md) | restriction | nursery | never | off | a wildcard arm in a match over a variant the code owns |
| [`unsafe-partial-stdlib`](rules/unsafe-partial-stdlib.md) | restriction | stable | never | off | reference to a partial stdlib eliminator |
| [`unused-export`](rules/unused-export.md) | suspicious | nursery | never | off | exported value never used by another unit |
| [`used-underscore-binding`](rules/used-underscore-binding.md) | suspicious | nursery | never | off | underscore-prefixed binding is used |
