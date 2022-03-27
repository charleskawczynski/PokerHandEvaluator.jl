# PokerHandEvaluator.jl

|||
|---------------------:|:----------------------------------------------|
| **Docs Build**       | [![docs build][docs-bld-img]][docs-bld-url]   |
| **Documentation**    | [![dev][docs-dev-img]][docs-dev-url]          |
| **GHA CI**           | [![gha ci][gha-ci-img]][gha-ci-url]           |
| **Code Coverage**    | [![codecov][codecov-img]][codecov-url]        |
| **Bors enabled**     | [![bors][bors-img]][bors-url]                 |

[docs-bld-img]: https://github.com/charleskawczynski/PokerHandEvaluator.jl/workflows/Documentation/badge.svg
[docs-bld-url]: https://github.com/charleskawczynski/PokerHandEvaluator.jl/actions?query=workflow%3ADocumentation

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://charleskawczynski.github.io/PokerHandEvaluator.jl/dev/

[gha-ci-img]: https://github.com/charleskawczynski/PokerHandEvaluator.jl/workflows/ci/badge.svg
[gha-ci-url]: https://github.com/charleskawczynski/PokerHandEvaluator.jl/actions?query=workflow%3Aci

[codecov-img]: https://codecov.io/gh/charleskawczynski/PokerHandEvaluator.jl/branch/main/graph/badge.svg
[codecov-url]: https://codecov.io/gh/charleskawczynski/PokerHandEvaluator.jl

[bors-img]: https://bors.tech/images/badge_small.svg
[bors-url]: https://app.bors.tech/repositories/32815

A package for evaluating poker hands.

## Installation

```@repl
julia>]
(v1.x) pkg> add PokerHandEvaluator
```

## Functionality

PokerHandEvaluator.jl can be used to determine which player wins in a game of poker. PokerHandEvaluator.jl exports two types:

  - `CompactHandEval`: a compact hand evaluation with limited properties and getter-methods defined:
    - `hand_rank`
    - `hand_type`
  - `FullHandEval`: a comprehensive hand evaluation with more properties and additional methods defined:
    - `hand_rank`
    - `hand_type`
    - `best_cards`
    - `all_cards`

## Example

```julia
using PlayingCards, PokerHandEvaluator
table_cards = (J♡,J♣,2♣,3♢,5♣)
player_cards = (
  (A♠,2♠,table_cards...),
  (J♠,T♣,table_cards...),
);
fhe = FullHandEval.(player_cards);
winner_id = argmin(hand_rank.(fhe)) # = 2
winning_hand = hand_type(fhe[winner_id]) # = :trips
winning_rank = hand_rank(fhe[winner_id]) # = 1842
winning_cards = best_cards(fhe[winner_id]) # = (J♠, T♣, J♡, J♣, 5♣)
allcards = all_cards(fhe[winner_id]) # = (J♠, T♣, J♡, J♣, 2♣, 3♢, 5♣)
```

## Performance

If you clone PokerHandEvaluator.jl, you can run the performance script, `perf.jl`, at the top-level of the project.
Here's a code snippet to see performance


> **Note** Running `perf.jl` needs some additional packages (StatsBase.jl, BenchmarkTools.jl, and Combinatorics.jl) that are not shipped with PokerHandEvaluator.jl


```julia
using PokerHandEvaluator
phe_dir = dirname(dirname(pathof(PokerHandEvaluator)));
include(joinpath(phe_dir, "perf.jl"))
```

Running this gives:

```julia
julia> using PokerHandEvaluator

julia> phe_dir = dirname(dirname(pathof(PokerHandEvaluator)));

julia> include(joinpath(phe_dir, "perf.jl"))
Δt_per_evaluate5 = 2.0215967156093207e-8
*******5-card hand evaluation benchmark*******
BechmarkTools.Trial: 10000 samples with 195 evaluations.
 Range (min … max):  487.949 ns …   6.095 μs  ┊ GC (min … max): 0.00% … 82.90%
 Time  (median):     509.082 ns               ┊ GC (median):    0.00%
 Time  (mean ± σ):   549.924 ns ± 194.761 ns  ┊ GC (mean ± σ):  1.47% ±  4.24%

  ▂▆█▄▂▃▂  ▁▁                                                   ▁
  ██████████████▇▇▇▇███████▆▇▆▇▇▆▆▅▆▆▆▇▇▆▆▆▆▆▅▆▆▆▅▅▅▅▄▅▄▅▃▅▃▅▃▃ █
  488 ns        Histogram: log(frequency) by time        110 μs <

 Memory estimate: 608 bytes, allocs estimate: 8.
*******7-card hand evaluation benchmark*******
BechmarkTools.Trial: 10000 samples with 15 evaluations.
 Range (min … max):  932.067 ns …  57.009 μs  ┊ GC (min … max): 0.00% … 97.53%
 Time  (median):       1.042 μs               ┊ GC (median):    0.00%
 Time  (mean ± σ):     1.111 μs ± 633.655 ns  ┊ GC (mean ± σ):  0.50% ±  0.98%

   ▅▇█▇▆▅▄▃▁                         ▁                          ▂
  ▇█████████▇▆▆▅▅▆▅▃▃▄▁▅▅▃▄▄▁▁▃▁▃▆████▇▇█▇▆▆▅▆▄▅▅▃▄▃▅▅▅▅▅▆▆▅▅▅▅ █
  932 ns        Histogram: log(frequency) by time       2.69 μs <

 Memory estimate: 640 bytes, allocs estimate: 10.
```

## Related packages

| Package                                                                             |  Development status      |         Purpose                                       |
|------------------------------------------------------------------------------------:|:------------------------:|:------------------------------------------------------|
| [PlayingCards.jl](https://github.com/charleskawczynski/PlayingCards.jl)             | Perhaps stable           | Representing cards                                    |
| [PokerHandEvaluator.jl](https://github.com/charleskawczynski/PokerHandEvaluator.jl) | Perhaps stable           | Comparing any two 5-7 card hands                      |
| [TexasHoldem.jl](https://github.com/charleskawczynski/TexasHoldem.jl)               | Likely changes needed    | Simulating multi-player games of TexasHoldem          |
| [PokerBots.jl](https://github.com/charleskawczynski/PokerBots.jl)                   | _very_ early development | Battling bots with prescribed (or learned) strategies |
| [PokerGUI.jl](https://github.com/charleskawczynski/PokerGUI.jl)                     | _very_ early development | Visualizing TexasHoldem games via a GUI               |
