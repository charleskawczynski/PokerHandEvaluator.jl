using PlayingCards
using BenchmarkTools
using Test
using Combinatorics
using PokerHandEvaluator
using PokerHandEvaluator.HandRankAndGroup

time_per_eval = true
# N_evals = 1
# N_evals = 1
N_evals = 10^5      # ~4%  of all combinations
# N_evals = 10^6    # ~38% of all combinations
# N_evals = 2598960 # all combinations

### Only collect hands if N_evals has changed:
(@isdefined N_old) || (N_old = N_evals)
# length(combinations(full_deck(), 5)) = 2598960
N_old == N_evals || (hands = collect(combinations(full_deck(), 5))[1:N_evals])
(@isdefined hands) || (hands = collect(combinations(full_deck(), 5))[1:N_evals])
N_old = N_evals
###

function benchmark(hands)
    hr = hand_rank.(hands)
    # hr = hand_rank_and_group.(hands)
    return nothing
end

function main(hands, N_evals, time_per_eval)
  if N_evals == 1
      @btime benchmark(hands)
  elseif time_per_eval
    Δt_all_combos = @elapsed benchmark(hands)
    Δt_per_hand_eval = Δt_all_combos/N_evals
    @show Δt_per_hand_eval
    return nothing
  else
    @time benchmark(hands)
  end
end

main(hands, N_evals, time_per_eval)
