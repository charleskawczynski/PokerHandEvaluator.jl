using PlayingCards
using BenchmarkTools
using Combinatorics
using PokerHandEvaluator

time_per_eval = true
# N_evals = 1
# N_evals = 2
# N_evals = 10^5      # ~4%  of all combinations
# N_evals = 10^6    # ~38% of all combinations
N_evals = 2598960 # all combinations

### Only collect hands if N_evals has changed:
(@isdefined N_old) || (N_old = N_evals)
# length(combinations(full_deck(), 5)) = 2598960
N_old == N_evals || (hands = Tuple.(collect(combinations(full_deck(), 5))[1:N_evals]))
(@isdefined hands) || (hands = Tuple.(collect(combinations(full_deck(), 5))[1:N_evals]))
N_old = N_evals
###

function benchmark(hands)
    ev = PokerHandEvaluator.evaluate5.(hands)
    return nothing
end

function main(hands, N_evals, time_per_eval)
  if N_evals == 1
      @btime benchmark(hands)
  elseif time_per_eval
    Δt_all_combos = @elapsed benchmark(hands)
    Δt_per_evaluate5 = Δt_all_combos/N_evals
    @show Δt_per_evaluate5
    return nothing
  else
    @time benchmark(hands)
  end
end

main(hands, N_evals, time_per_eval)

# Practical use-case:
using StatsBase, BenchmarkTools, PlayingCards, PokerHandEvaluator
const cards_buffer5 = Vector{Card}(undef, 5);
println("*******5-card hand evaluation benchmark*******")
bm5 = @benchmark CompactHandEval(Tuple(sample!($(full_deck()), $cards_buffer5; replace=false)))
io = IOBuffer()
show(io, "text/plain", bm5)
println(String(take!(io)))

const cards_buffer7 = Vector{Card}(undef, 7);
println("*******7-card hand evaluation benchmark*******")
bm7 = @benchmark CompactHandEval(Tuple(sample!($(full_deck()), $cards_buffer7; replace=false)))
io = IOBuffer()
show(io, "text/plain", bm7)
println(String(take!(io)))

nothing
