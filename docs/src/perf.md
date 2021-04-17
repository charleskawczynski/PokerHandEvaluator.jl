# Performance

```@meta
CurrentModule = PokerHandEvaluator
```

There is a [`perf.jl`](https://github.com/charleskawczynski/PokerHandEvaluator.jl/blob/main/perf.jl) file at the top level of the repo which roughly estimates PokerHandEvaluator.jl's performance. Here is a snapshot example of using [`BenchmarkTools`](https://github.com/JuliaCI/BenchmarkTools.jl) on PokerHandEvaluator.jl's base evaluation method [`evaluate5`](@ref):

```@example perf
using BenchmarkTools, InteractiveUtils
using PlayingCards, PokerHandEvaluator
@code_typed PokerHandEvaluator.evaluate5((A♡, A♣, A♠, 3♡, 2♢))
```

```@example perf
@btime PokerHandEvaluator.evaluate5($(A♡, A♣, A♠, 3♡, 2♢))
nothing
```

`eval`ing methods for all unique hands is a bit expensive for the compiler as there are many method definitions. This timing may not be representative of what users should expect, however. Running PokerHandEvaluator.jl's `perf.jl` file shows that performance is around 2 μs:

```@example
using PokerHandEvaluator
phe_dir = dirname(dirname(pathof(PokerHandEvaluator)))
include(joinpath(phe_dir, "perf.jl")) # compile first
include(joinpath(phe_dir, "perf.jl"))
```

`perf.jl` is configured to evaluate roughly 4% of all possible hands, but this can easily be adjusted.
