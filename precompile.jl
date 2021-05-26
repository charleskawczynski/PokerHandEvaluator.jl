using PlayingCards, Combinatorics, PokerHandEvaluator
N_evals = 2598960 # all combinations
all_possible_hands = Tuple.(collect(combinations(full_deck(), 5))[1:N_evals]);

function precompile_hand(hands)
    ev = PokerHandEvaluator.evaluate5.(hands)
    return nothing
end

function main_precompile(hands, N_evals)
  Δt_all_combos = @elapsed precompile_hand(hands)
  Δt_per_hand_eval = Δt_all_combos/N_evals
  @show Δt_per_hand_eval
  return nothing
end

main_precompile(all_possible_hands, N_evals)
