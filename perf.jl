using PlayingCards
using Test
using Combinatorics
using PokerHandEvaluator

function benchmark(N)
    k = 0
    # length(combinations(full_deck(), 5)) = 2598960
    for cards in combinations(full_deck(), 5)
        hr = hand_rank(cards)
        k+=1
        k>=N && break
    end
    return
end

function main()
  N_evals = 10^5      # ~4%  of all combinations
  # N_evals = 10^6    # ~38% of all combinations
  # N_evals = 2598960 # all combinations

  Δt_all_combos = @elapsed benchmark(N_evals)
  Δt_per_hand_eval = Δt_all_combos/N_evals
  @show Δt_per_hand_eval
  return nothing
end

main()
