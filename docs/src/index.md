# PokerHandEvaluator.jl

```@meta
CurrentModule = PokerHandEvaluator
```

A package for evaluating poker hands.

## Functionality

PokerHandEvaluator.jl can be used to determine which player wins in a game of poker. PokerHandEvaluator.jl exports two types:

  - [`CompactHandEval`](@ref): a compact hand evaluation with limited properties and getter-methods defined:
    - [`hand_rank`](@ref)
    - [`hand_type`](@ref)
  - [`FullHandEval`](@ref): a comprehensive hand evaluation with more properties and additional methods defined:
    - [`hand_rank`](@ref)
    - [`hand_type`](@ref)
    - [`best_cards`](@ref)
    - [`all_cards`](@ref)

## Example

```@example
using PlayingCards, PokerHandEvaluator
table_cards = (J♡,J♣,2♣,3♢,5♣)
player_cards = (
  (A♠,2♠,table_cards...),
  (J♠,T♣,table_cards...),
);
fhe = FullHandEval.(player_cards);

# the hand with the lowest rank is the winner (and equal ranks tie)
@show winner_id = argmin(hand_rank.(fhe))

@show winning_hand = hand_type(fhe[winner_id])
@show winning_rank = hand_rank(fhe[winner_id])
@show winning_cards = best_cards(fhe[winner_id])
@show allcards = all_cards(fhe[winner_id])
nothing
```
