# Based on the enumeration of all 7,462 Five-Card Poker Hand Equivalence Classes

using .HandCombinations

"""
    evaluate5(cards::Card...)
    evaluate5(::Card,::Card,::Card,::Card,::Card)
    evaluate5(::Tuple{Card,Card,Card,Card,Card})

This is PokerHandEvaluator.jl's _core_ method.

Returns the `rank` (an `Int`) from `1:7462`:

    (A♡,K♡,Q♡,J♡,10♡) -> 1
    ...
    (7♡,5♢,4♣,3♠,2♡) -> 7462

for 5-card hands _only_.
"""
function evaluate5 end

evaluate5(cards::Card...)::Int = evaluate5(cards)
evaluate5(cards::SubArray)::Int = evaluate5(Tuple(cards))

# The product of 5 primes will be unique, and
# do not depend on the order, so we're using
# this to map card combinations to a single number
# for which a method, `evaluate_offsuit` and
# `evaluate_flush` are defined. First, we dispatch
# based on flush/non-flush:
function evaluate5(t::NTuple{N,Card})::Int where {N}
    @assert N == 5
    if suit(t[1]) == suit(t[2]) == suit(t[3]) == suit(t[4]) == suit(t[5])
        evaluate5_flush(Val(prod(prime.(t))))
    else
        evaluate5_offsuit(Val(prod(prime.(t))))
    end
end

for (i,card_ranks) in enumerate(straight_ranks())
    p = prod(prime.(card_ranks))
    @eval evaluate5_flush(::Val{$p})::Int = $i          # Rows 1:10 (Straight flush)
end

for (k,card_ranks) in enumerate(quad_ranks())
    p = prod(prime.(card_ranks))
    @eval evaluate5_offsuit(::Val{$p})::Int = 11+$k-1   # Rows 11:166 (4 of a kind)
end

for (k,card_ranks) in enumerate(full_house_ranks())
    p = prod(prime.(card_ranks))
    @eval evaluate5_offsuit(::Val{$p})::Int = 167+$k-1  # Rows 167:322 (full house)
end

for (k,card_ranks) in enumerate(flush_ranks())
    p = prod(prime.(card_ranks))
    @eval evaluate5_flush(::Val{$p})::Int = 323+$k-1    # Rows 323:1599 (flush)
end

for (k,card_ranks) in enumerate(straight_ranks())
    p = prod(prime.(card_ranks))
    @eval evaluate5_offsuit(::Val{$p})::Int = 1600+$k-1 # Rows 1600:1609 (off-suit straight)
end

for (k,card_ranks) in enumerate(trip_ranks())
    p = prod(prime.(card_ranks))
    @eval evaluate5_offsuit(::Val{$p})::Int = 1610+$k-1 # Rows 1610:2467 (trips)
end

for (k,card_ranks) in enumerate(two_pair_ranks())
    p = prod(prime.(card_ranks))
    @eval evaluate5_offsuit(::Val{$p})::Int = 2468+$k-1 # Rows 2468:3325 (two pair)
end

for (k,card_ranks) in enumerate(pair_ranks())
    p = prod(prime.(card_ranks))
    @eval evaluate5_offsuit(::Val{$p})::Int = 3326+$k-1 # Rows 3326:6185 (pair)
end

for (k,card_ranks) in enumerate(high_card_ranks())
    p = prod(prime.(card_ranks))
    @eval evaluate5_offsuit(::Val{$p})::Int = 6186+$k-1 # Rows 6186:7462 (high card)
end
