# Implementation

```@meta
CurrentModule = PokerHandEvaluator
```

PokerHandEvaluator.jl's approach follows [Cactus Kev](http://suffe.cool/poker/evaluator.html), however, our implementation, described below, is different.

There are `combinations(52,5)`, or 2,598,960, unique 5-card hands. However, many of these hands have the exact same `rank` (e.g., (A♡,A♢,K♣,K♠,3♢) and (A♡,A♢,K♣,K♠,3♡)). There are only 7462 unique _hand ranks_:

 - A K Q J 10 royal straight flush: `rank = 1`
 - K Q J 10 9 straight flush: `rank = 2`
 - ...
 - 7 5 4 3 2: `rank = 7462`

PokerHandEvaluator.jl's core method, [`evaluate5`](@ref), returns this rank so that any two hands can be compared to determine the winner. There's one more wrinkle to flatten. Exposing an interface that is order-agnostic (so that users don't need to sort the cards before evaluation) is important for performance. To make the `evaluate5` order-agnostic, the card rank of each input is mapped to prime numbers:

```julia
const primes = (41,2,3,5,7,11,13,17,19,23,29,31,37)
prime(card::Card) = primes[rank(card)]
```

The product of prime numbers are (1) unique and (2) order-agnostic (due to the multiplication commutative property). This mapped relationship can be implemented in various ways, for example via lookup tables, binary search etc.. PokerHandEvaluator.jl simply loops over the combinations of hands (using [Combinatorics.jl](https://github.com/JuliaMath/Combinatorics.jl)) and `eval`s the methods (by dispatching on types `::Val{prod(primes.(cards))}`) to return the rank directly.

Finally, PokerHandEvaluator.jl checks to see the card's `suit` to disambiguate flush vs off-suited hands:

```julia
function evaluate5(t::NTuple{N,Card}) where {N}
    if suit(t[1]) == suit(t[2]) == suit(t[3]) == suit(t[4]) == suit(t[5])
        evaluate5_flush(Val(prod(prime.(t))))
    else
        evaluate5_offsuit(Val(prod(prime.(t))))
    end
end
```

This approach has performance / compile-time implications. See the [performance](./perf.md) documentation for more information.
