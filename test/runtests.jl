using Test
using PokerHandEvaluator
using PokerHandEvaluator.HandRankAndGroup
using PlayingCards
using BenchmarkTools
const PHE = PokerHandEvaluator
const HRAC = HandRankAndGroup

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

@testset "Vector interface" begin
    @test hand_rank((A♠,K♠,Q♠,J♠,T♠)) == hand_rank([A♠,K♠,Q♠,J♠,T♠])
    @test hand_rank_and_group((A♠,K♠,Q♠,J♠,T♠)) == hand_rank_and_group([A♠,K♠,Q♠,J♠,T♠])
end
@testset "N-methods" begin
    N_offsuit = length(methods(PHE.hand_rank_offsuit))
    N_flush = length(methods(PHE.hand_rank_flush))
    @test N_offsuit+N_flush == 7462
end

@testset "N-hands" begin
    L_1 = length(PHE.straight_ranks()) # flush
    L_2 = length(PHE.quad_ranks())
    L_3 = length(PHE.full_house_ranks())
    L_4 = length(PHE.flush_ranks())
    L_5 = length(PHE.straight_ranks()) # off-suit
    L_6 = length(PHE.trip_ranks())
    L_7 = length(PHE.two_pair_ranks())
    L_8 = length(PHE.pair_ranks())
    L_9 = length(PHE.high_card_ranks())

    @test L_1+L_2+L_3+L_4+L_5+L_6+L_7+L_8+L_9 == 7462
end

@testset "HandRankAndGroup" begin
    @test hand_rank_and_group((A♠,K♠,Q♠,J♠,T♠)) == (1, StraightFlush())
    @test hand_rank_and_group((A♠,A♣,A♡,A♢,K♣)) == (11, Quads())
    @test hand_rank_and_group((A♠,A♣,A♡,K♢,K♣)) == (167, FullHouse())
    @test hand_rank_and_group((A♠,K♠,Q♠,J♠,9♠)) == (323, Flush())
    @test hand_rank_and_group((A♠,K♠,Q♠,J♠,T♣)) == (1600, Straight())
    @test hand_rank_and_group((A♠,A♣,A♡,K♢,Q♣)) == (1610, Trips())
    @test hand_rank_and_group((A♠,A♣,K♡,K♢,Q♣)) == (2468, TwoPair())
    @test hand_rank_and_group((A♠,A♣,K♡,Q♢,J♣)) == (3326, OnePair())
    @test hand_rank_and_group((A♠,K♣,Q♡,J♢,9♣)) == (6186, HighCard())
end
