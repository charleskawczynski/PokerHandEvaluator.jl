# Based on the enumeration of all 7,462 Five-Card Poker Hand Equivalence Classes

using LinearAlgebra: dot

# The product of 5 primes will be unique, and
# do not depend on the order, so we're using
# this to map card combinations to a single number
# for which a method, `hand_rank_offsuit` and
# `hand_rank_flush` are defined. First, we dispatch
# based on flush/non-flush:
"""
    hand_rank(::Tuple{Card,Card,Card,Card,Card})

The hand rank (from 1:7462)

    (A♡,K♡,Q♡,J♡,10♡) -> 1
    ...
    (7♡,5♢,4♣,3♠,2♡) -> 7462

to compare poker hands (lower is better).
"""
function hand_rank(t::Tuple{
    Card{S1},
    Card{S2},
    Card{S3},
    Card{S4},
    Card{S5}}
) where {S1,S2,S3,S4,S5}
    hand_rank_offsuit(Val(prod(prime.(t))))
end

function hand_rank(t::Tuple{
    Card{S},
    Card{S},
    Card{S},
    Card{S},
    Card{S}}
) where {S}
    hand_rank_flush(Val(prod(prime.(t))))
end

hand_rank(v::Vector) = hand_rank(Tuple(v))

function sort_combinations(comb, sort_by_first_val = false)
    if length(comb[1])==1 || sort_by_first_val
        return sort(comb; by=x->high_value(x[1]), rev=true)
    else
        coeffs = (10 .^ (length(comb[1]):-1:2)..., 1)
        return sort(comb; by=x->dot(high_value.(x), coeffs), rev=true)
    end
end

#####
##### Rows 1:10 (Straight flush)
#####

straight_ranks() =
    (vcat(10:13, 1:1),9:(9+4),8:(8+4),7:(7+4),6:(6+4),5:(5+4),4:(4+4),3:(3+4),2:(2+4),1:(1+4))

for (i,cards) in enumerate(straight_ranks())
    p = prod(prime.(cards))
    @eval hand_rank_flush(::Val{$p}) = $i
end

#####
##### Rows 11:166 (4 of a kind)
#####

function ranks_old()
    r = ranks()
    return [r[2:end]..., r[1]]
end

function ranks_high_to_low()
    r = ranks()
    return [r[1], r[end:-1:2]...]
end

function quad_ranks()
    quads_combos = collect(combinations(full_deck(), 4))
    sorted_quads_combos = sort.(quads_combos; by = x->high_value(x), rev=true)
    sorted_quads_combos = filter(sorted_quads_combos) do x
        high_value(x[1])==high_value(x[2])==high_value(x[3])==high_value(x[4])
    end
    sorted_quads_combos = sort_combinations(sorted_quads_combos)
    card_ranks = [begin
        (rank.(quads)..., kicker)
    end for quads in sorted_quads_combos for kicker in ranks_old()[end:-1:1] if rank(quads[1]) ≠ kicker]
    return card_ranks
end

for (k,card_ranks) in enumerate(quad_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_offsuit(::Val{$p}) = 11+$k-1
end

#####
##### Rows 167:322 (full house)
#####

function full_house_ranks()
    three_quarter_deck = filter(x->suit(x) isa Club || suit(x) isa Heart || suit(x) isa Spade, full_deck())
    half_deck = filter(x->suit(x) isa Club || suit(x) isa Heart, full_deck())
    trip_combos = collect(combinations(three_quarter_deck, 3))
    pair_combos = collect(combinations(half_deck, 2))
    trip_combos = sort.(trip_combos; by = x->high_value(x), rev=true)
    pair_combos = sort.(pair_combos; by = x->high_value(x), rev=true)

    sorted_pair_combos = filter(pair_combos) do x
        high_value(x[1])==high_value(x[2])
    end
    sorted_trip_combos = filter(trip_combos) do x
        high_value(x[1])==high_value(x[2])==high_value(x[3])
    end
    sorted_trip_combos = sort_combinations(sorted_trip_combos, true)
    sorted_pair_combos = sort_combinations(sorted_pair_combos, true)
    card_ranks = [begin
        (rank.(tc)..., rank.(pc)...)
    end for tc in sorted_trip_combos for pc in sorted_pair_combos if rank(tc[1]) ≠ rank(pc[1])]
    return card_ranks
end

for (k,card_ranks) in enumerate(full_house_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_offsuit(::Val{$p}) = 167+$k-1
end

#####
##### Rows 323:1599 (flush)
#####

consecutive(tup) = all(ntuple(i->tup[i]+1==tup[i+1], 4))
function is_straight(cards)
    ranks = sort(collect(high_value.(cards)))
    ranks_low = sort(collect(low_value.(cards)))
    high_straight = consecutive(ranks)
    low_straight = consecutive(ranks_low)
    return low_straight || high_straight
end

function flush_ranks()
    club_combos = combinations(filter(x->suit(x) isa Club, full_deck()), 5)
    sorted_club_combos = sort.(club_combos; by = x->high_value(x), rev=true)
    sorted_club_combos = sort_combinations(sorted_club_combos)
    card_ranks = [begin
        rank.(cards)
    end for cards in sorted_club_combos if !is_straight(cards)]
end

for (k,card_ranks) in enumerate(flush_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_flush(::Val{$p}) = 323+$k-1
end

#####
##### Rows 1600:1609 (offsuit straight)
#####

for (k,card_ranks) in enumerate(straight_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_offsuit(::Val{$p}) = 1600+$k-1
end

#####
##### Rows 1610:2467 (trips)
#####

function trip_ranks()
    club_deck = filter(x->suit(x) isa Club, full_deck())
    club_kicker_combos = collect(combinations(club_deck, 2))
    sorted_club_kicker_combos = sort.(club_kicker_combos; by = x->high_value(x), rev=true)
    sorted_club_kicker_combos = sort_combinations(sorted_club_kicker_combos)
    card_ranks = [begin
        (rank_trips,rank_trips,rank_trips,rank.(kickers)...)
    end for rank_trips in ranks_high_to_low() for kickers in sorted_club_kicker_combos
        if rank_trips ≠ rank(kickers[1]) && rank_trips ≠ rank(kickers[2])]
    return card_ranks
end

for (k,card_ranks) in enumerate(trip_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_offsuit(::Val{$p}) = 1610+$k-1
end

#####
##### Rows 2468:3325 (two pair)
#####

function two_pair_ranks()
    half_deck = filter(x->suit(x) isa Club || suit(x) isa Heart, full_deck())
    combos = collect(combinations(half_deck, 4))
    combos = sort.(combos; by = x->high_value(x), rev=true)
    two_pair_combos = filter(x->high_value(x[1])==high_value(x[2]) && high_value(x[3])==high_value(x[4]), combos)
    sorted_two_pair_combos = sort_combinations(two_pair_combos)
    card_ranks = [begin
        (rank.(two_pair)...,kicker)
    end for two_pair in sorted_two_pair_combos for kicker in ranks_high_to_low()
        if rank(two_pair[1]) ≠ kicker && rank(two_pair[3]) ≠ kicker]
    return card_ranks
end

for (k,card_ranks) in enumerate(two_pair_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_offsuit(::Val{$p}) = 2468+$k-1
end

#####
##### Rows 3326:6185 (pair)
#####

function pair_ranks()
    three_quarters_deck = filter(x->suit(x) isa Club, full_deck())
    combos = collect(combinations(three_quarters_deck, 3))
    combos = sort.(combos; by = x->high_value(x), rev=true)
    combos = sort_combinations(combos)
    card_ranks = [begin
        (ranks_pair, ranks_pair, rank.(kickers)...)
    end for ranks_pair in ranks_high_to_low() for kickers in combos
        if ranks_pair ≠ rank(kickers[1]) && ranks_pair ≠ rank(kickers[2]) && ranks_pair ≠ rank(kickers[3])]
    return card_ranks
end

for (k,card_ranks) in enumerate(pair_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_offsuit(::Val{$p}) = 3326+$k-1
end

#####
##### Rows 6186:7462 (high card)
#####

function high_card_ranks()
    club_deck = filter(x->suit(x) isa Club, full_deck())
    combos = collect(combinations(club_deck, 5))
    combos = sort.(combos; by = x->high_value(x), rev=true)
    combos = sort_combinations(combos)
    card_ranks = [kickers for kickers in combos if !is_straight(kickers)]
    return card_ranks
end

for (k,card_ranks) in enumerate(high_card_ranks())
    p = prod(prime.(card_ranks))
    @eval hand_rank_offsuit(::Val{$p}) = 6186+$k-1
end
