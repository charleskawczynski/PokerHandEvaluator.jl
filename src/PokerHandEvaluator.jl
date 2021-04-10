module PokerHandEvaluator

using PlayingCards
using Combinatorics

export hand_rank

#####
##### Hand eval methods
#####

prime(::Val{UInt8(1)}) = 41
prime(::Val{UInt8(2)}) = 2
prime(::Val{UInt8(3)}) = 3
prime(::Val{UInt8(4)}) = 5
prime(::Val{UInt8(5)}) = 7
prime(::Val{UInt8(6)}) = 11
prime(::Val{UInt8(7)}) = 13
prime(::Val{UInt8(8)}) = 17
prime(::Val{UInt8(9)}) = 19
prime(::Val{UInt8(10)}) = 23
prime(::Val{UInt8(11)}) = 29
prime(::Val{UInt8(12)}) = 31
prime(::Val{UInt8(13)}) = 37
prime(i::UInt8) = prime(Val(i))
prime(i::Int) = prime(UInt8(i))
prime(card::Card) = prime(Val(rank(card)))

include("hand_eval.jl")

# function _precompile_()
#     # avoid running precompile statements when the package isn't precompiling:
#     ccall(:jl_generating_output, Cint, ()) == 1 || return nothing

#     for hand in straight_flush_ranks();   Base.precompile(hand_rank_flush  , (Val{prod(prime.(hand))},)); end
#     for hand in quad_ranks();             Base.precompile(hand_rank_flush  , (Val{prod(prime.(hand))},)); end
#     for hand in full_house_ranks();       Base.precompile(hand_rank_flush  , (Val{prod(prime.(hand))},)); end
#     for hand in flush_ranks();            Base.precompile(hand_rank_flush  , (Val{prod(prime.(hand))},)); end
#     for hand in offsuit_straight_ranks(); Base.precompile(hand_rank_flush  , (Val{prod(prime.(hand))},)); end
#     for hand in trip_ranks();             Base.precompile(hand_rank_flush  , (Val{prod(prime.(hand))},)); end
#     for hand in two_pair_ranks();         Base.precompile(hand_rank_flush  , (Val{prod(prime.(hand))},)); end
#     for hand in pair_ranks();             Base.precompile(hand_rank_flush  , (Val{prod(prime.(hand))},)); end
#     for hand in high_card_ranks();        Base.precompile(hand_rank_flush  , (Val{prod(prime.(hand))},)); end

#     for hand in straight_flush_ranks();   Base.precompile(hand_rank_offsuit, (Val{prod(prime.(hand))},)); end
#     for hand in quad_ranks();             Base.precompile(hand_rank_offsuit, (Val{prod(prime.(hand))},)); end
#     for hand in full_house_ranks();       Base.precompile(hand_rank_offsuit, (Val{prod(prime.(hand))},)); end
#     for hand in flush_ranks();            Base.precompile(hand_rank_offsuit, (Val{prod(prime.(hand))},)); end
#     for hand in offsuit_straight_ranks(); Base.precompile(hand_rank_offsuit, (Val{prod(prime.(hand))},)); end
#     for hand in trip_ranks();             Base.precompile(hand_rank_offsuit, (Val{prod(prime.(hand))},)); end
#     for hand in two_pair_ranks();         Base.precompile(hand_rank_offsuit, (Val{prod(prime.(hand))},)); end
#     for hand in pair_ranks();             Base.precompile(hand_rank_offsuit, (Val{prod(prime.(hand))},)); end
#     for hand in high_card_ranks();        Base.precompile(hand_rank_offsuit, (Val{prod(prime.(hand))},)); end

# end
# _precompile_()

end # module
