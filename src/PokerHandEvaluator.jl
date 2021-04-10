module PokerHandEvaluator

using PlayingCards
using Combinatorics

export hand_rank

#####
##### Hand eval methods
#####

const primes = (41,2,3,5,7,11,13,17,19,23,29,31,37)
prime(i::UInt8) = primes[i]
prime(i::Int) = prime(UInt8(i))
prime(card::Card) = primes[rank(card)]

include("hand_eval.jl")

end # module
