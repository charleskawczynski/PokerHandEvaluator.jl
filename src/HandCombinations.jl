module HandCombinations

using LinearAlgebra: dot
using PlayingCards
using Combinatorics

export prime,
    straight_ranks,
    quad_ranks,
    full_house_ranks,
    is_straight,
    flush_ranks,
    trip_ranks,
    two_pair_ranks,
    pair_ranks,
    high_card_ranks

##### Helpers

const primes = (41,2,3,5,7,11,13,17,19,23,29,31,37)
prime(i::Int8) = primes[i]
prime(i::Int) = prime(Int8(i))
prime(card::Card) = primes[rank(card)]

function sort_combinations(comb, sort_by_first_val = false)
    if length(comb[1])==1 || sort_by_first_val
        return sort(comb; by=x->high_value(x[1]), rev=true)
    else
        coeffs = (10 .^ (length(comb[1]):-1:2)..., 1)
        return sort(comb; by=x->dot(high_value.(x), coeffs), rev=true)
    end
end

##### Rows 1:10 (Straight flush) | Rows 1600:1609 (Off-suit straight)

function straight_ranks()
    (vcat(10:13, 1:1),9:(9+4),8:(8+4),7:(7+4),6:(6+4),5:(5+4),4:(4+4),3:(3+4),2:(2+4),1:(1+4))
end

##### Rows 11:166 (4 of a kind)

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

##### Rows 167:322 (full house)

function full_house_ranks()
    three_quarter_deck = filter(x->suit(x) == ♣ || suit(x) == ♡ || suit(x) == ♠, full_deck())
    half_deck = filter(x->suit(x) == ♣ || suit(x) == ♡, full_deck())
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

##### Rows 323:1599 (flush)

consecutive(tup) = all(ntuple(i->tup[i]+1==tup[i+1], 4))
function is_straight(cards)
    ranks = sort(collect(high_value.(cards)))
    ranks_low = sort(collect(low_value.(cards)))
    high_straight = consecutive(ranks)
    low_straight = consecutive(ranks_low)
    return low_straight || high_straight
end

function flush_ranks()
    club_combos = combinations(filter(x->suit(x) == ♣, full_deck()), 5)
    sorted_club_combos = sort.(club_combos; by = x->high_value(x), rev=true)
    sorted_club_combos = sort_combinations(sorted_club_combos)
    card_ranks = [begin
        rank.(cards)
    end for cards in sorted_club_combos if !is_straight(cards)]
end

##### Rows 1610:2467 (trips)

function trip_ranks()
    club_deck = filter(x->suit(x) == ♣, full_deck())
    club_kicker_combos = collect(combinations(club_deck, 2))
    sorted_club_kicker_combos = sort.(club_kicker_combos; by = x->high_value(x), rev=true)
    sorted_club_kicker_combos = sort_combinations(sorted_club_kicker_combos)
    card_ranks = [begin
        (rank_trips,rank_trips,rank_trips,rank.(kickers)...)
    end for rank_trips in ranks_high_to_low() for kickers in sorted_club_kicker_combos
        if rank_trips ≠ rank(kickers[1]) && rank_trips ≠ rank(kickers[2])]
    return card_ranks
end

##### Rows 2468:3325 (two pair)

function two_pair_ranks()
    half_deck = filter(x->suit(x) == ♣ || suit(x) == ♡, full_deck())
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

##### Rows 3326:6185 (pair)

function pair_ranks()
    three_quarters_deck = filter(x->suit(x) == ♣, full_deck())
    combos = collect(combinations(three_quarters_deck, 3))
    combos = sort.(combos; by = x->high_value(x), rev=true)
    combos = sort_combinations(combos)
    card_ranks = [begin
        (ranks_pair, ranks_pair, rank.(kickers)...)
    end for ranks_pair in ranks_high_to_low() for kickers in combos
        if ranks_pair ≠ rank(kickers[1]) && ranks_pair ≠ rank(kickers[2]) && ranks_pair ≠ rank(kickers[3])]
    return card_ranks
end

##### Rows 6186:7462 (high card)

function high_card_ranks()
    club_deck = filter(x->suit(x) == ♣, full_deck())
    combos = collect(combinations(club_deck, 5))
    combos = sort.(combos; by = x->high_value(x), rev=true)
    combos = sort_combinations(combos)
    card_ranks = [kickers for kickers in combos if !is_straight(kickers)]
    return card_ranks
end

end # module