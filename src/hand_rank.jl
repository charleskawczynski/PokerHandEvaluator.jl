# Based on the enumeration of all 7,462 Five-Card Poker Hand Equivalence Classes

using .HandCombinations
# The product of 5 primes will be unique, and
# do not depend on the order, so we're using
# this to map card combinations to a single number
# for which a method, `hand_rank_offsuit` and
# `hand_rank_flush` are defined. First, we dispatch
# based on flush/non-flush:
hand_rank(t::Tuple{Card{S1},Card{S2},Card{S3},Card{S4},Card{S5}}) where {S1,S2,S3,S4,S5} =
    hand_rank_offsuit(Val(prod(prime.(t))))

hand_rank(t::Tuple{Card{S},Card{S},Card{S},Card{S},Card{S}}) where {S} =
    hand_rank_flush(Val(prod(prime.(t))))

hand_rank(v::Vector) = hand_rank(Tuple(v))

for (i,card_ranks) in enumerate(straight_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_flush(::Val{$p}) = $i          # Rows 1:10 (Straight flush)
end

for (k,card_ranks) in enumerate(quad_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_offsuit(::Val{$p}) = 11+$k-1   # Rows 11:166 (4 of a kind)
end

for (k,card_ranks) in enumerate(full_house_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_offsuit(::Val{$p}) = 167+$k-1  # Rows 167:322 (full house)
end

for (k,card_ranks) in enumerate(flush_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_flush(::Val{$p}) = 323+$k-1    # Rows 323:1599 (flush)
end

for (k,card_ranks) in enumerate(straight_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_offsuit(::Val{$p}) = 1600+$k-1 # Rows 1600:1609 (off-suit straight)
end

for (k,card_ranks) in enumerate(trip_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_offsuit(::Val{$p}) = 1610+$k-1 # Rows 1610:2467 (trips)
end

for (k,card_ranks) in enumerate(two_pair_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_offsuit(::Val{$p}) = 2468+$k-1 # Rows 2468:3325 (two pair)
end

for (k,card_ranks) in enumerate(pair_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_offsuit(::Val{$p}) = 3326+$k-1 # Rows 3326:6185 (pair)
end

for (k,card_ranks) in enumerate(high_card_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_offsuit(::Val{$p}) = 6186+$k-1 # Rows 6186:7462 (high card)
end
