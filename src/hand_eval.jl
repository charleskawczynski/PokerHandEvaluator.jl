# Based on the enumeration of all 7,462 Five-Card Poker Hand Equivalence Classes

using LinearAlgebra: dot

# The product of 5 primes will be unique, and
# do not depend on the order, so we're using
# this to map card combinations to a single number
# for which a method, `hand_rank_offsuit` and
# `hand_rank_flush` are defined. First, we dispatch
# based on flush/non-flush:
function hand_rank(t::Tuple{
    Card{R1,S1},
    Card{R2,S2},
    Card{R3,S3},
    Card{R4,S4},
    Card{R5,S5}}
) where {R1,R2,R3,R4,R5,S1,S2,S3,S4,S5}
    hand_rank_offsuit(Val(prod(prime.(t))))
end

function hand_rank(t::Tuple{
    Card{R1,S},
    Card{R2,S},
    Card{R3,S},
    Card{R4,S},
    Card{R5,S}}
) where {R1,R2,R3,R4,R5,S}
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

for (i,R) in enumerate(typeof.(ranks()[end:-1:1])[1:end-3])
    rs = (R, type_dn(R,1), type_dn(R,2), type_dn(R,3), type_dn(R,4))
    p = prod(prime.(rs))
    @eval hand_rank_flush(::Val{$p}) = $i
end

#####
##### Rows 11:166 (4 of a kind)
#####

let k = 1
    quads_combos = collect(combinations(full_deck(), 4))
    sorted_quads_combos = sort.(quads_combos; by = x->high_value(x), rev=true)
    sorted_quads_combos = filter(sorted_quads_combos) do x
        high_value(x[1])==high_value(x[2])==high_value(x[3])==high_value(x[4])
    end
    sorted_quads_combos = sort_combinations(sorted_quads_combos)
    for quads in sorted_quads_combos
        for kicker in ranks()[end:-1:1]
            card_ranks = (rank.(quads)..., kicker)
            card_ranks[1] == card_ranks[5] && continue
            p = prod(prime.(card_ranks))
            @eval hand_rank_offsuit(::Val{$p}) = 11+$k-1
            k+=1
        end
    end
end


#####
##### Rows 167:322 (full house)
#####

let k = 1
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
    for tc in sorted_trip_combos
        for pc in sorted_pair_combos
            rank(tc[1]) == rank(pc[1]) && continue
            hand = (tc..., pc...)
            p = prod(prime.(hand))
            @eval hand_rank_offsuit(::Val{$p}) = 167+$k-1
            k+=1
        end
    end
end

#####
##### Rows 323:1599 (flush)
#####

consecutive(tup) = all(ntuple(i->tup[i]+1==tup[i+1], 4))
function is_straight(cards)
    ranks = sort(collect(high_value.(rank_type.(cards))))
    ranks_low = sort(collect(low_value.(rank_type.(cards))))
    high_straight = consecutive(ranks)
    low_straight = consecutive(ranks_low)
    return low_straight || high_straight
end

let k = 1
    club_combos = combinations(filter(x->suit(x) isa Club, full_deck()), 5)
    sorted_club_combos = sort.(club_combos; by = x->high_value(x), rev=true)
    sorted_club_combos = sort_combinations(sorted_club_combos)
    for cards in sorted_club_combos
        is_straight(cards) && continue
        p = prod(prime.(cards))
        @eval hand_rank_flush(::Val{$p}) = 323+$k-1
        k+=1
    end
end


#####
##### Rows 1600:1609 (offsuit straight)
#####

for (i,R) in enumerate(typeof.(ranks()[end:-1:1])[1:end-3])
    rs = (R, type_dn(R,1), type_dn(R,2), type_dn(R,3), type_dn(R,4))
    p = prod(prime.(rs))
    @eval hand_rank_offsuit(::Val{$p}) = 1600+$i-1
end

#####
##### Rows 1610:2467 (trips)
#####

let k = 1
    club_deck = filter(x->suit(x) isa Club, full_deck())
    club_kicker_combos = collect(combinations(club_deck, 2))
    sorted_club_kicker_combos = sort.(club_kicker_combos; by = x->high_value(x), rev=true)
    sorted_club_kicker_combos = sort_combinations(sorted_club_kicker_combos)
    for rank_trips in sort(collect(ranks()); by=x->high_value(x), rev=true)
        for kickers in sorted_club_kicker_combos
            R3 = typeof(rank_trips)
            Rks = rank.(kickers)
            Rk1 = typeof(Rks[1])
            Rk2 = typeof(Rks[2])
            Rk1 == R3 && continue
            Rk2 == R3 && continue
            rs = (R3,R3,R3,Rk1,Rk2)
            p = prod(prime.(rs))
            @eval hand_rank_offsuit(::Val{$p}) = 1610+$k-1
            k+=1
        end
    end
end

#####
##### Rows 2468:3325 (two pair)
#####

let k = 1
    half_deck = filter(x->suit(x) isa Club || suit(x) isa Heart, full_deck())
    combos = collect(combinations(half_deck, 4))
    combos = sort.(combos; by = x->high_value(x), rev=true)
    two_pair_combos = filter(x->high_value(x[1])==high_value(x[2]) && high_value(x[3])==high_value(x[4]), combos)
    sorted_two_pair_combos = sort_combinations(two_pair_combos)
    for rank_2_pair in sorted_two_pair_combos
        for kickers in sort(collect(ranks()); by=x->high_value(x), rev=true)
            R1 = typeof(rank(rank_2_pair[1]))
            R2 = typeof(rank(rank_2_pair[3]))
            Rk = typeof(kickers)
            R1 == Rk && continue
            R2 == Rk && continue
            rs = (R1,R1,R2,R2,Rk)
            p = prod(prime.(rs))
            @eval hand_rank_offsuit(::Val{$p}) = 2468+$k-1
            k+=1
        end
    end
end

#####
##### Rows 3326:6185 (pair)
#####

let k = 1
    three_quarters_deck = filter(x->suit(x) isa Club, full_deck())
    combos = collect(combinations(three_quarters_deck, 3))
    combos = sort.(combos; by = x->high_value(x), rev=true)
    combos = sort_combinations(combos)
    for RP in typeof.(ranks()[end:-1:1])
        for kickers in combos
            R1 = typeof(rank(kickers[1]))
            R2 = typeof(rank(kickers[2]))
            R3 = typeof(rank(kickers[3]))
            RP==R1 && continue
            RP==R2 && continue
            RP==R3 && continue
            rs = (RP,RP,R1,R2,R3)
            p = prod(prime.(rs))
            @eval hand_rank_offsuit(::Val{$p}) = 3326+$k-1
            k+=1
        end
    end
end

#####
##### Rows 6186:7462 (high card)
#####

let k = 1
    club_deck = filter(x->suit(x) isa Club, full_deck())
    combos = collect(combinations(club_deck, 5))
    combos = sort.(combos; by = x->high_value(x), rev=true)
    combos = sort_combinations(combos)
    for kickers in combos
        is_straight(kickers) && continue
        p = prod(prime.(rank.(kickers)))
        @eval hand_rank_offsuit(::Val{$p}) = 6186+$k-1
        k+=1
    end
end
