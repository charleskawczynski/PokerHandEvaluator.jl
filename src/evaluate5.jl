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
# The product of 5 primes will be unique, and
# do not depend on the order, so we're using
# this to map card combinations to a single number
# for which a method, `evaluate_offsuit` and
# `evaluate_flush` are defined. First, we dispatch
# based on flush/non-flush:
function evaluate5(t::NTuple{N,Card})::Int where {N}
    @assert N == 5
    if suit(t[1]) == suit(t[2]) == suit(t[3]) == suit(t[4]) == suit(t[5])
        return hash_table_suited[prod(prime.(t))]
    else
        return hash_table_offsuit[prod(prime.(t))]
    end
end

const hash_table_suited = Dict{Int,Int}(hcat(
    map(enumerate(straight_ranks())) do (i,card_ranks)
        Pair(prod(prime.(card_ranks)), i)       # Rows 1:10 (Straight flush)
    end...,
    map(enumerate(flush_ranks())) do (i,card_ranks)
        Pair(prod(prime.(card_ranks)), 323+i-1) # Rows 323:1599 (flush)
    end...,
))

const hash_table_offsuit = Dict{Int,Int}(hcat(
    map(enumerate(quad_ranks())) do (i,card_ranks)
        Pair(prod(prime.(card_ranks)), 11+i-1)   # Rows 11:166 (4 of a kind)
    end...,
    map(enumerate(full_house_ranks())) do (i,card_ranks)
        Pair(prod(prime.(card_ranks)), 167+i-1)  # Rows 167:322 (full house)
    end...,
    map(enumerate(straight_ranks())) do (i,card_ranks)
        Pair(prod(prime.(card_ranks)), 1600+i-1) # Rows 1600:1609 (off-suit straight)
    end...,
    map(enumerate(trip_ranks())) do (i,card_ranks)
        Pair(prod(prime.(card_ranks)), 1610+i-1) # Rows 1610:2467 (trips)
    end...,
    map(enumerate(two_pair_ranks())) do (i,card_ranks)
        Pair(prod(prime.(card_ranks)), 2468+i-1) # Rows 2468:3325 (two pair)
    end...,
    map(enumerate(pair_ranks())) do (i,card_ranks)
        Pair(prod(prime.(card_ranks)), 3326+i-1) # Rows 3326:6185 (pair)
    end...,
    map(enumerate(high_card_ranks())) do (i,card_ranks)
        Pair(prod(prime.(card_ranks)), 6186+i-1) # Rows 6186:7462 (high card)
    end...,
))
