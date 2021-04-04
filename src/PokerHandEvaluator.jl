module PokerHandEvaluator

using PlayingCards
using Combinatorics

export hand_rank

#####
##### Hand eval methods
#####

prime(::Type{NumberCard{2}}) = 2
prime(::Type{NumberCard{3}}) = 3
prime(::Type{NumberCard{4}}) = 5
prime(::Type{NumberCard{5}}) = 7
prime(::Type{NumberCard{6}}) = 11
prime(::Type{NumberCard{7}}) = 13
prime(::Type{NumberCard{8}}) = 17
prime(::Type{NumberCard{9}}) = 19
prime(::Type{NumberCard{10}}) = 23
prime(::Type{Jack}) = 29
prime(::Type{Queen}) = 31
prime(::Type{King}) = 37
prime(::Type{Ace}) = 41
prime(r::Rank) = prime(typeof(r))
prime(card::Card) = prime(rank(card))

dn_type(::Type{Ace}) = King
dn_type(::Type{King}) = Queen
dn_type(::Type{Queen}) = Jack
dn_type(::Type{Jack}) = NumberCard{10}
dn_type(::Type{NumberCard{N}}) where {N} = NumberCard{N-1}
dn_type(::Type{NumberCard{2}}) = Ace

# Nth type down from T
type_dn(::Type{T}, n::Int) where {T} = type_dn(T, Val(n))
type_dn(::Type{T}, ::Val{0}) where {T} = T
type_dn(::Type{T}, ::Val{N}) where {T, N} = type_dn(dn_type(T), Val(N-1))

include("hand_eval.jl")

function _precompile_()
    # avoid running precompile statements when the package isn't precompiling:
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing

    for hand in straight_flush_ranks();   Base.precompile(hand_rank_flush  , (Val{prod(prime.(hand))},)); end
    for hand in quad_ranks();             Base.precompile(hand_rank_flush  , (Val{prod(prime.(hand))},)); end
    for hand in full_house_ranks();       Base.precompile(hand_rank_flush  , (Val{prod(prime.(hand))},)); end
    for hand in flush_ranks();            Base.precompile(hand_rank_flush  , (Val{prod(prime.(hand))},)); end
    for hand in offsuit_straight_ranks(); Base.precompile(hand_rank_flush  , (Val{prod(prime.(hand))},)); end
    for hand in trip_ranks();             Base.precompile(hand_rank_flush  , (Val{prod(prime.(hand))},)); end
    for hand in two_pair_ranks();         Base.precompile(hand_rank_flush  , (Val{prod(prime.(hand))},)); end
    for hand in pair_ranks();             Base.precompile(hand_rank_flush  , (Val{prod(prime.(hand))},)); end
    for hand in high_card_ranks();        Base.precompile(hand_rank_flush  , (Val{prod(prime.(hand))},)); end

    for hand in straight_flush_ranks();   Base.precompile(hand_rank_offsuit, (Val{prod(prime.(hand))},)); end
    for hand in quad_ranks();             Base.precompile(hand_rank_offsuit, (Val{prod(prime.(hand))},)); end
    for hand in full_house_ranks();       Base.precompile(hand_rank_offsuit, (Val{prod(prime.(hand))},)); end
    for hand in flush_ranks();            Base.precompile(hand_rank_offsuit, (Val{prod(prime.(hand))},)); end
    for hand in offsuit_straight_ranks(); Base.precompile(hand_rank_offsuit, (Val{prod(prime.(hand))},)); end
    for hand in trip_ranks();             Base.precompile(hand_rank_offsuit, (Val{prod(prime.(hand))},)); end
    for hand in two_pair_ranks();         Base.precompile(hand_rank_offsuit, (Val{prod(prime.(hand))},)); end
    for hand in pair_ranks();             Base.precompile(hand_rank_offsuit, (Val{prod(prime.(hand))},)); end
    for hand in high_card_ranks();        Base.precompile(hand_rank_offsuit, (Val{prod(prime.(hand))},)); end

end
_precompile_()

end # module
