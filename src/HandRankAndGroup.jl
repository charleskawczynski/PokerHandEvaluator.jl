"""
    HandRankAndGroup

`hand_rank_and_group` returns a hand rank
as well as a type (e.g. `Quads`, `Straight` etc.).
This extra information may not be needed for purely
simulating games, so this module is separate from the
`PokerHandEvaluator.hand_rank`.
"""
module HandRankAndGroup

using ..HandCombinations
using PlayingCards
using Combinatorics

export hand_rank_and_group

"""
    hand_rank_and_group

Exactly the same as `hand_rank`, except
`hand_rank_and_group` returns a tuple of the rank
and sub-type of [`AbstractHand`](@ref)
"""
function hand_rank_and_group end

export StraightFlush,
    Quads,
    FullHouse,
    Flush,
    Straight,
    Trips,
    TwoPair,
    OnePair,
    HighCard

"""
    AbstractHand

Subtypes used for hands, such as
`Quads`, `Flush`, and `TwoPair`.
"""
abstract type AbstractHand end
struct StraightFlush <: AbstractHand end
struct Quads <: AbstractHand end
struct FullHouse <: AbstractHand end
struct Flush <: AbstractHand end
struct Straight <: AbstractHand end
struct Trips <: AbstractHand end
struct TwoPair <: AbstractHand end
struct OnePair <: AbstractHand end
struct HighCard <: AbstractHand end


# Based on the enumeration of all 7,462 Five-Card Poker Hand Equivalence Classes

# The product of 5 primes will be unique, and
# do not depend on the order, so we're using
# this to map card combinations to a single number
# for which a method, `hand_rank_and_group_offsuit` and
# `hand_rank_and_group_flush` are defined. First, we dispatch
# based on flush/non-flush:
hand_rank_and_group(t::Tuple{Card{S1},Card{S2},Card{S3},Card{S4},Card{S5}}) where {S1,S2,S3,S4,S5} =
    hand_rank_and_group_offsuit(Val(prod(prime.(t))))

hand_rank_and_group(t::Tuple{Card{S},Card{S},Card{S},Card{S},Card{S}}) where {S} =
    hand_rank_and_group_flush(Val(prod(prime.(t))))

hand_rank_and_group(v::Vector) = hand_rank_and_group(Tuple(v))

for (i,card_ranks) in enumerate(straight_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_and_group_flush(::Val{$p}) = ($i, StraightFlush())          # Rows 1:10 (Straight flush)
end

for (k,card_ranks) in enumerate(quad_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_and_group_offsuit(::Val{$p}) = (11+$k-1, Quads())   # Rows 11:166 (4 of a kind)
end

for (k,card_ranks) in enumerate(full_house_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_and_group_offsuit(::Val{$p}) = (167+$k-1, FullHouse())  # Rows 167:322 (full house)
end

for (k,card_ranks) in enumerate(flush_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_and_group_flush(::Val{$p}) = (323+$k-1, Flush())    # Rows 323:1599 (flush)
end

for (k,card_ranks) in enumerate(straight_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_and_group_offsuit(::Val{$p}) = (1600+$k-1, Straight()) # Rows 1600:1609 (off-suit straight)
end

for (k,card_ranks) in enumerate(trip_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_and_group_offsuit(::Val{$p}) = (1610+$k-1, Trips()) # Rows 1610:2467 (trips)
end

for (k,card_ranks) in enumerate(two_pair_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_and_group_offsuit(::Val{$p}) = (2468+$k-1, TwoPair()) # Rows 2468:3325 (two pair)
end

for (k,card_ranks) in enumerate(pair_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_and_group_offsuit(::Val{$p}) = (3326+$k-1, OnePair()) # Rows 3326:6185 (pair)
end

for (k,card_ranks) in enumerate(high_card_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_and_group_offsuit(::Val{$p}) = (6186+$k-1, HighCard()) # Rows 6186:7462 (high card)
end

end # module