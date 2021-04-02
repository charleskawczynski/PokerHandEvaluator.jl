using Test
using HoldemHandEvaluator
using PlayingCards
using BenchmarkTools
const HHE = HoldemHandEvaluator

@testset "Recurse type" begin
    @test HHE.type_dn(Ace, 1) == King

    @test HHE.dn_type(Ace) == King
    @test HHE.dn_type(King) == Queen
    @test HHE.dn_type(Queen) == Jack
    @test HHE.dn_type(Jack) == NumberCard{10}
    @test HHE.dn_type(NumberCard{3}) == NumberCard{2}
    @test HHE.dn_type(NumberCard{2}) == Ace
end

@testset "Straight flush (Ranks 1:10)" begin
    include("test_straight_flush.jl")
end
@testset "Test quads (Ranks 11:166)" begin
    include("test_quads.jl")
end
@testset "Test Full house (Ranks 167:322)" begin
    include("test_full_house.jl")
end
@testset "Test flush (Ranks 323:1599)" begin
    include("test_flush.jl")
end
@testset "Test off-suit straight (Ranks 1600:1609)" begin
    include("test_offsuit_straight.jl")
end
@testset "Test trips (Ranks 1610:2467)" begin
    include("test_trips.jl")
end
@testset "Test two-pair (Ranks 2468:3325)" begin
    include("test_two_pair.jl")
end
@testset "Test pair (Ranks 3326:6185)" begin
    include("test_pair.jl")
end
@testset "Test high card (Ranks 6186:7462)" begin
    include("test_high_card.jl")
end

@testset "N-methods" begin
    N_offsuit = length(methods(HoldemHandEvaluator.hand_rank_offsuit))
    N_flush = length(methods(HoldemHandEvaluator.hand_rank_flush))
    @test N_offsuit+N_flush == 7462
end
