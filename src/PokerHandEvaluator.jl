module PokerHandEvaluator

using LinearAlgebra: dot
using PlayingCards
using Combinatorics

export hand_rank

"""
    hand_rank(::Tuple{Card,Card,Card,Card,Card})

The hand rank (from 1:7462)

    (A♡,K♡,Q♡,J♡,10♡) -> 1
    ...
    (7♡,5♢,4♣,3♠,2♡) -> 7462

to compare poker hands (lower is better).
"""
function hand_rank end

include("HandCombinations.jl")
include("hand_rank.jl")
include("HandRankAndGroup.jl")

end # module
