module PokerHandEvaluator

using LinearAlgebra: dot
using PlayingCards
using Combinatorics

export CompactHandEval, FullHandEval
export hand_rank, hand_type, best_cards, all_cards

include("HandTypes.jl")
using .HandTypes

abstract type AbstractHandEvaluation end

"""
    hand_rank(::AbstractHandEvaluation)

The hand rank, between 1 (straight royal flush)
and 7462 (7 high with lowest kickers):

    (A♡,K♡,Q♡,J♡,10♡) -> 1
    ...
    (7♡,5♢,4♣,3♠,2♡) -> 7462
"""
function hand_rank end

"""
    hand_type(::AbstractHandEvaluation)

The hand type, a sub-type of
[`AbstractHandType`](@ref).
"""
function hand_type end

"""
    best_cards(::FullHandEval)

The set of cards with the lowest (best) rank.
"""
function best_cards end

"""
    all_cards(::FullHandEval)

All of the input cards to `FullHandEval`.
"""
function all_cards end

"""
    FullHandEval(cards::Card...)
    FullHandEval(::Card,::Card,::Card,::Card,::Card[,::Card,::Card])
    FullHandEval(::Tuple{Card,Card,Card,Card,Card[,::Card,::Card]})

A compact hand evaluation, with supporting methods:
[`hand_rank`](@ref), [`hand_type`](@ref), [`best_cards`](@ref), [`all_cards`](@ref).

# Examples

```julia
using PlayingCards, PokerHandEvaluator
table_cards = (J♡,J♣,2♣,3♢,5♣)
player_cards = (
  (A♠,2♠,table_cards...),
  (J♠,T♣,table_cards...),
);
fhe = FullHandEval.(player_cards);
winner_id = argmin(hand_rank.(fhe)) # = 2
winning_hand = hand_type(fhe[winner_id]) # = Trips()
winning_rank = hand_rank(fhe[winner_id]) # = 1842
winning_cards = best_cards(fhe[winner_id]) # = (J♠, T♣, J♡, J♣, 5♣)
allcards = all_cards(fhe[winner_id]) # = (J♠, T♣, J♡, J♣, 2♣, 3♢, 5♣)
```
"""
struct FullHandEval{HT <: AbstractHandType, AC <: Tuple, TC <: Tuple} <: AbstractHandEvaluation
    hand_type::HT
    rank::Int
    all_cards::AC
    best_cards::TC
    FullHandEval(player_cards::Tuple, table_cards::Tuple) =
        FullHandEval((player_cards..., table_cards...))
    FullHandEval(all_cards...) = FullHandEval(all_cards)
    FullHandEval(all_cards::Vector) = FullHandEval(Tuple(all_cards))
    function FullHandEval(all_cards::Tuple)
        @assert 5 ≤ length(all_cards) ≤ 7
        rank, hand_type, best_cards = evaluate_full(all_cards)

        return new{
            typeof(hand_type),
            typeof(all_cards),
            typeof(best_cards)}(hand_type, rank, all_cards, best_cards)
    end
end

to_tuple(th::FullHandEval) = (th.rank, th.hand_type, th.best_cards, th.all_cards)
hand_rank(th::FullHandEval) = th.rank
hand_type(th::FullHandEval) = th.hand_type
best_cards(th::FullHandEval) = th.best_cards
all_cards(th::FullHandEval) = th.all_cards

"""
    CompactHandEval(cards::Card...)
    CompactHandEval(::Card,::Card,::Card,::Card,::Card[,::Card,::Card])
    CompactHandEval(::Tuple{Card,Card,Card,Card,Card[,::Card,::Card]})

A compact hand evaluation, with supporting methods:
[`hand_rank`](@ref), [`hand_type`](@ref).

# Examples

```julia
using PlayingCards
using PokerHandEvaluator
using PokerHandEvaluator.HandTypes
table_cards = (J♡,J♣,A♣,A♢);
player_cards = (
  (A♠,2♠,table_cards...),
  (J♠,J♣,table_cards...),
);
che = CompactHandEval.(player_cards);
winner_id = argmin(hand_rank.(che)) # = 2
winning_hand = hand_type(che[winner_id]) # = Quads()
```
"""
struct CompactHandEval{HT <: AbstractHandType} <: AbstractHandEvaluation
    hand_type::HT
    rank::Int
    CompactHandEval(player_cards::Tuple, table_cards::Tuple) =
        CompactHandEval((player_cards..., table_cards...))
    CompactHandEval(all_cards...) = CompactHandEval(all_cards)
    CompactHandEval(all_cards::Vector) = CompactHandEval(Tuple(all_cards))
    function CompactHandEval(all_cards::Tuple)
        @assert 5 ≤ length(all_cards) ≤ 7
        rank, hand_type = evaluate_compact(all_cards)
        return new{typeof(hand_type)}(hand_type, rank)
    end
end

to_tuple(th::CompactHandEval) = (th.rank, th.hand_type)
hand_rank(th::CompactHandEval) = th.rank
hand_type(th::CompactHandEval) = th.hand_type


"""
    evaluate(cards::Card...)
    evaluate(::Card,::Card,::Card,::Card,::Card[,::Card,::Card])
    evaluate(::Tuple{Card,Card,Card,Card,Card[,Card,Card]})
    evaluate(::Vector{Card})

Evaluates 5, 6, and 7-card hands using
[`evaluate5`](@ref). This is done by using
`Combinatorics.combinations` to evaluate
all possible 5, 6, and 7-card hand combinations.
"""
function evaluate end


#####
##### evaluate_full
#####

# Wrapper for 5 card hands:
evaluate_full(t::Tuple{<:Card,<:Card,<:Card,<:Card,<:Card}) = (evaluate5(t)..., t)

# Wrapper for 6 card hands:
function evaluate_full(t::Tuple{<:Card,<:Card,<:Card,<:Card,<:Card,<:Card})
    hand_ranks = map(cards -> (evaluate5(cards)..., Tuple(cards)), combinations(t, 5))
    i_max = argmin(map(x->x[1][1], hand_ranks))
    return hand_ranks[i_max]
end
# Wrapper for 7 card hands:
function evaluate_full(t::Tuple{<:Card,<:Card,<:Card,<:Card,<:Card,<:Card,<:Card})
    hand_ranks = map(cards -> (evaluate5(cards)..., Tuple(cards)), combinations(t, 5))
    i_max = argmin(map(x->x[1][1], hand_ranks))
    return hand_ranks[i_max]
end

#####
##### evaluate_compact
#####

# Wrapper for 5 card hands:
evaluate_compact(t::Tuple{<:Card,<:Card,<:Card,<:Card,<:Card}) = evaluate5(t)

# Wrapper for 6 card hands:
function evaluate_compact(t::Tuple{<:Card,<:Card,<:Card,<:Card,<:Card,<:Card})
    hand_ranks = map(cards -> evaluate5(cards), combinations(t, 5))
    i_max = argmin(map(x->x[1], hand_ranks))
    return hand_ranks[i_max]
end
# Wrapper for 7 card hands:
function evaluate_compact(t::Tuple{<:Card,<:Card,<:Card,<:Card,<:Card,<:Card,<:Card})
    hand_ranks = map(cards -> evaluate5(cards), combinations(t, 5))
    i_max = argmin(map(x->x[1], hand_ranks))
    return hand_ranks[i_max]
end

include("HandCombinations.jl")
include("evaluate5.jl")

end # module
