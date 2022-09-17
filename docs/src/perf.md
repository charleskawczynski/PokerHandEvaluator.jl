# Performance

```@meta
CurrentModule = PokerHandEvaluator
```

Here is a snapshot example of using [`BenchmarkTools`](https://github.com/JuliaCI/BenchmarkTools.jl) on PokerHandEvaluator.jl's base evaluation method [`evaluate5`](@ref):

## Introspection

```@example
using InteractiveUtils, PlayingCards, PokerHandEvaluator
@code_typed PokerHandEvaluator.evaluate5((A♡, A♣, A♠, 3♡, 2♢))
```

## Benchmark

There is a [`perf.jl`](https://github.com/charleskawczynski/PokerHandEvaluator.jl/blob/main/perf.jl) file at the top level of the repo which estimates PokerHandEvaluator.jl's performance, here's how it can be run:

!!! note
    This `perf.jl` file needs some additional packages (StatsBase.jl, BenchmarkTools.jl, and Combinatorics.jl) that are not shipped with PokerHandEvaluator.jl

```@example
using PokerHandEvaluator
@time include(joinpath(pkgdir(PokerHandEvaluator), "perf.jl"))
```
