module PokerHandEvaluator

using LinearAlgebra: dot
using PlayingCards
using Combinatorics

export CompactHandEval, FullHandEval
export hand_rank, hand_type, best_cards, all_cards

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

A Symbol corresponding to the type of hand.
Concretely, `hand_type` returns one of:
 - `:straight_flush`
 - `:quads`
 - `:full_house`
 - `:flush`
 - `:straight`
 - `:trips`
 - `:two_pair`
 - `:one_pair`
 - `:high_card`
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
winning_hand = hand_type(fhe[winner_id]) # = :trips
winning_rank = hand_rank(fhe[winner_id]) # = 1842
winning_cards = best_cards(fhe[winner_id]) # = (J♠, T♣, J♡, J♣, 5♣)
allcards = all_cards(fhe[winner_id]) # = (J♠, T♣, J♡, J♣, 2♣, 3♢, 5♣)
```
"""
struct FullHandEval{
        AC <: Union{Tuple, AbstractArray},
        TC <: Union{Tuple, AbstractArray}
    } <: AbstractHandEvaluation
    hand_type::Symbol
    rank::Int
    all_cards::AC
    best_cards::TC
    FullHandEval(player_cards::Tuple, table_cards::Tuple) =
        FullHandEval((player_cards..., table_cards...))
    FullHandEval(all_cards...) = FullHandEval(all_cards)
    function FullHandEval(all_cards::Union{Tuple,AbstractArray})
        @assert 5 ≤ length(all_cards) ≤ 7
        rank, hand_type, best_cards = evaluate_full(all_cards)

        return new{
            typeof(all_cards),
            typeof(best_cards)}(hand_type, rank, all_cards, best_cards)
    end
end

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
table_cards = (J♡,J♣,A♣,A♢);
player_cards = (
  (A♠,2♠,table_cards...),
  (J♠,J♣,table_cards...),
);
che = CompactHandEval.(player_cards);
winner_id = argmin(hand_rank.(che)) # = 2
winning_hand = hand_type(che[winner_id]) # = :quads
```
"""
struct CompactHandEval <: AbstractHandEvaluation
    rank::Int
    CompactHandEval(player_cards::Tuple, table_cards::Tuple) =
        CompactHandEval((player_cards..., table_cards...))
    # CompactHandEval(all_cards...) = CompactHandEval(all_cards)
    function CompactHandEval(all_cards::Union{Tuple,AbstractArray})
        @assert 5 ≤ length(all_cards) ≤ 7
        return new(evaluate_compact(all_cards))
    end
end

hand_type(th::CompactHandEval) =
    hand_type_binary_search(hand_rank(th))
hand_rank(th::CompactHandEval) = th.rank

"""
    evaluate(cards::Card...)
    evaluate(::Card,::Card,::Card,::Card,::Card[,::Card,::Card])
    evaluate(::Tuple{Card,Card,Card,Card,Card[,Card,Card]})

Evaluates 5, 6, and 7-card hands using
[`evaluate5`](@ref). This is done by using
`Combinatorics.combinations` to evaluate
all possible 5, 6, and 7-card hand combinations.
"""
function evaluate end

function hand_type_binary_search(rank::Int)
    @assert 1 ≤ rank ≤ 7462
    if rank ≤ 1609
        if rank ≤ 166
            rank ≤ 10 && return :straight_flush
            return :quads
        else
            rank ≤ 322 && return :full_house
            rank ≤ 1599 && return :flush
            return :straight
        end
    else
        if rank ≤ 3325
            rank ≤ 2467 && return :trips
            return :two_pair
        else
            rank ≤ 6185 && return :one_pair
            return :high_card
        end
    end
end

#####
##### evaluate_full
#####

# Wrapper for 5 card hands:
function evaluate_full(t::Tuple{<:Card,<:Card,<:Card,<:Card,<:Card})
    hand_rank = evaluate5(t)
    return (hand_rank, hand_type_binary_search(hand_rank), t)
end

# Wrapper for 6 card hands:
function evaluate_full(t::Tuple{<:Card,<:Card,<:Card,<:Card,<:Card,<:Card})
    return best_hand_rank_from_6_cards_full(t)
end
# Wrapper for 7 card hands:
function evaluate_full(t::Tuple{<:Card,<:Card,<:Card,<:Card,<:Card,<:Card,<:Card})
    return best_hand_rank_from_7_cards_full(t)
end

# Wrapper for view interface:
function evaluate_full(all_cards::AbstractArray)
    n_cards = length(all_cards)
    if n_cards == 5
        hand_rank = evaluate5(all_cards)
        hand_type = hand_type_binary_search(hand_rank)
        return (hand_rank, hand_type, all_cards)
    elseif n_cards == 6
        return best_hand_rank_from_6_cards_full(all_cards)
    elseif n_cards == 7
        return best_hand_rank_from_7_cards_full(all_cards)
    end
end

#####
##### evaluate_compact
#####

# Wrapper for 5 card hands:
evaluate_compact(t::Tuple{<:Card,<:Card,<:Card,<:Card,<:Card}) = evaluate5(t)

# Wrapper for 6 card hands:
function evaluate_compact(t::Tuple{<:Card,<:Card,<:Card,<:Card,<:Card,<:Card})
    return best_hand_rank_from_6_cards_compact(t)
end
# Wrapper for 7 card hands:
function evaluate_compact(t::Tuple{<:Card,<:Card,<:Card,<:Card,<:Card,<:Card,<:Card})
    return best_hand_rank_from_7_cards_compact(t)
end
# Wrapper for view interface:
function evaluate_compact(all_cards::AbstractArray)
    n_cards = length(all_cards)
    if n_cards == 5
        return evaluate5(all_cards)
    elseif n_cards == 6
        return best_hand_rank_from_6_cards_compact(all_cards)
    elseif n_cards == 7
        return best_hand_rank_from_7_cards_compact(all_cards)
    end
end

include("best_hand_rank_from_n_cards.jl")
include("HandCombinations.jl")
include("evaluate5.jl")

end # module
