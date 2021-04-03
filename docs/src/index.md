# PokerHandEvaluator.jl

A package for evaluating poker hands. PokerHandEvaluator.jl broadly uses the [Cactus Kev](http://suffe.cool/poker/evaluator.html) approach (described in the next section) to evaluate hand ranks.

## Cactus Kev approach

There are `combinations(52,5)`, or 2,598,960, unique 5-card hands. However, many of these hands have the exact same rank (e.g., (A♡,A♢,K♣,K♠,3♢) and (A♣,A♠,K♡,K♢,3♡)). There are 7462 unique _hand ranks_ defined as

 - A K Q J 10 royal straight flush: `hand_rank = 1`
 - K Q J 10 9 straight flush: `hand_rank = 2`
 - ...
 - 7 5 4 3 2: `hand_rank = 7462`

That's the gist of it. There's one more aspect to be addressed, and that is how to make the input arguments order-agnostic (to avoid sorting input arguments). To make the `hand_rank` order-agnostic, the card rank of each input can be mapped to prime numbers, and the product of these prime numbers are (1) unique (the product of unique primes is unique) and (2) order-agnostic (due to the multiplication commutative property). This mapped relationship can be implemented in various ways, for example via lookup tables, binary search etc.

## PokerHandEvaluator.jl's implementation

PokerHandEvaluator.jl uses [PlayingCards.jl](https://github.com/charleskawczynski/PlayingCards.jl) and defines `hand_rank` for a `Tuple` of 5 [`Card`](https://github.com/charleskawczynski/PlayingCards.jl#cards)s. The `hand_rank` wrapper first uses (specialized) dispatch on flush vs off-suited hands which calls `hand_rank_flush` and `hand_rank_offsuit`. There are 1287 `hand_rank_flush` methods and 7462 - 1287 = 6175 `hand_rank_offsuit` methods. `hand_rank_flush` and `hand_rank_offsuit` methods are defined via `Val` for the mapped product of primes for the given card combination:

 - `hand_rank_offsuit(::Val{prod(prime.(cards))}) = N`
 - `hand_rank_flush(::Val{prod(prime.(cards))}) = N`

PokerHandEvaluator.jl simply loops over the combinations of hands (using [Combinatorics.jl](https://github.com/JuliaMath/Combinatorics.jl)) and `eval`-ing the methods into the module to return the value directly:

```@example perf
using BenchmarkTools, InteractiveUtils
using PlayingCards, PokerHandEvaluator
@code_typed hand_rank((A♡, A♣, A♠, 3♡, 2♢))
```

```@example perf
@btime hand_rank($(A♡, A♣, A♠, 3♡, 2♢))
nothing
```

Doing this is very expensive for the compiler as there are many method definitions-- hence why we precompile all of these methods so that the expense is paid up-front.
