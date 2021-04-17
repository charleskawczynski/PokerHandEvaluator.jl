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
winning_hand = hand_type(fhe[winner_id]) # = Trips()
winning_rank = hand_rank(fhe[winner_id]) # = 1842
winning_cards = best_cards(fhe[winner_id]) # = (J♠, T♣, J♡, J♣, 5♣)
allcards = all_cards(fhe[winner_id]) # = (J♠, T♣, J♡, J♣, 2♣, 3♢, 5♣)
```

## Performance

```julia
julia> using PokerHandEvaluator

julia> phe_dir = dirname(dirname(pathof(PokerHandEvaluator)));

julia> include(joinpath(phe_dir, "perf.jl")) # compile first
Δt_per_hand_eval = 1.4598465e-5

julia> include(joinpath(phe_dir, "perf.jl"))
Δt_per_hand_eval = 1.082814e-6
```
