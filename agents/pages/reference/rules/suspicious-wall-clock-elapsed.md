# suspicious-wall-clock-elapsed

duration computed from wall-clock reads

<!-- Written by docs/catalog.ts from `litany explain suspicious-wall-clock-elapsed`; never edited by hand. -->

**suspicious · warning · stable · since 1.0 · fix: never · on by default**

`Unix.gettimeofday` and `Unix.time` read the wall clock: NTP steps,
manual clock changes, and suspend/resume make it jump both ways.
Arithmetic that turns wall-clock reads into a duration — `now +.
timeout` deadlines, `now -. started` elapsed — silently produces
negative or wildly inflated durations under a clock step: watchdogs
kill healthy children, retry loops spin or hang. A monotonic counter
(`Mtime_clock`, the project's own clock module) is the remedy, and
choosing one is a dependency decision — no fix.

```ocaml
(* bad *)  let deadline = Unix.gettimeofday () +. timeout in …
(* good *) let deadline = Mtime.add_span (Mtime_clock.now ()) span in …
```

Fires on float `+.`/`-.` (and `Float.add`/`Float.sub`) applications
where either argument is directly a `Unix.gettimeofday ()` or
`Unix.time ()` call, anchored at the arithmetic expression. Storing the
function as a clock seam, passing a timestamp as data, scaling with
`*.`, monotonic counter subtraction, and `Sys.time` (process CPU time,
monotone) deliberately do not fire. A wall-clock read that flows
through a `let` binding before the arithmetic is a recorded false
negative.
