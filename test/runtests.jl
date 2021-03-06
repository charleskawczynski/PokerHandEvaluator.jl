using Test
using PokerHandEvaluator
using PokerHandEvaluator: evaluate5
using PlayingCards
using BenchmarkTools
const PHE = PokerHandEvaluator

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
    N_offsuit = length(PHE.hash_table_offsuit)
    N_flush = length(PHE.hash_table_suited)
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

@testset "CompactHandEval & FullHandEval (6/7-card evaluate)" begin
    table_cards = (J♡,J♣,A♣,A♢)
    player_cards = (
      (A♠,2♠,table_cards...),
      (J♠,J♣,table_cards...),
    );
    che = CompactHandEval.(player_cards)
    winner = che[argmin(hand_rank.(che))]
    @test hand_rank(winner) == 47
    @test hand_type(winner) == :quads

    table_cards = (J♡,J♣,A♣,A♢,5♣)
    player_cards = (
      (A♠,2♠,table_cards...),
      (J♠,J♣,table_cards...),
    );
    fhe = FullHandEval.(player_cards)
    winner = fhe[argmin(hand_rank.(fhe))]
    @test hand_rank(winner) == 47
    @test hand_type(winner) == :quads
    # could have equally returned (J♠,J♣,J♡,J♣,A♢):
    @test best_cards(winner) == (J♠,J♣,J♡,J♣,A♣)
    @test all_cards(winner) == (J♠,J♣,table_cards...)

    # Additional interfaces
    fhe = FullHandEval((A♠,2♠), table_cards)
    che = CompactHandEval((A♠,2♠), table_cards)
    fhe = FullHandEval((A♠,2♠)..., table_cards...)
    che = CompactHandEval((A♠,2♠)..., table_cards...)

    fhe = FullHandEval((A♠,2♠), table_cards[1:end-1])
    che = CompactHandEval((A♠,2♠), table_cards[1:end-1])
    fhe = FullHandEval((A♠,2♠)..., table_cards[1:end-1]...)
    che = CompactHandEval((A♠,2♠)..., table_cards[1:end-1]...)

    fhe = FullHandEval((A♠,2♠), table_cards[1:end-2])
    che = CompactHandEval((A♠,2♠), table_cards[1:end-2])
    fhe = FullHandEval((A♠,2♠)..., table_cards[1:end-2]...)
    che = CompactHandEval((A♠,2♠)..., table_cards[1:end-2]...)
end


function compute_hand_type_simple(rank::Int)
         if 1 ≤ rank ≤ 10;     return :straight_flush
    elseif 11 ≤ rank ≤ 166;    return :quads
    elseif 167 ≤ rank ≤ 322;   return :full_house
    elseif 323 ≤ rank ≤ 1599;  return :flush
    elseif 1600 ≤ rank ≤ 1609; return :straight
    elseif 1610 ≤ rank ≤ 2467; return :trips
    elseif 2468 ≤ rank ≤ 3325; return :two_pair
    elseif 3326 ≤ rank ≤ 6185; return :one_pair
    elseif 6186 ≤ rank ≤ 7462; return :high_card
    else; error("Bad hand rank input")
    end
end

@testset "Hand types" begin
    ranks = 1:7462
    hrts = compute_hand_type_simple.(ranks)
    hrtbs = PHE.hand_type_binary_search.(ranks)
    @test all(hrts .== hrtbs)
    @test_throws AssertionError PHE.hand_type_binary_search(0)
    @test_throws AssertionError PHE.hand_type_binary_search(7463)
end

if VERSION >= v"1.4"
    @testset "Allocations" begin
        cards_5 = (J♡,J♣,A♣,A♢,5♣);
        cards_7 = (A♠,2♠,cards_5...);
        cards_6 = (J♣,cards_5...);

        # Compile first:
        alloc_1 = @allocated CompactHandEval(cards_5)
        alloc_2 = @allocated CompactHandEval(cards_6)
        alloc_3 = @allocated CompactHandEval(cards_7)
        alloc_4 = @allocated FullHandEval(cards_5)
        alloc_5 = @allocated FullHandEval(cards_6)
        alloc_6 = @allocated FullHandEval(cards_7)

        alloc_1 = @allocated CompactHandEval(cards_5)
        alloc_2 = @allocated CompactHandEval(cards_6)
        alloc_3 = @allocated CompactHandEval(cards_7)
        alloc_4 = @allocated FullHandEval(cards_5)
        alloc_5 = @allocated FullHandEval(cards_6)
        alloc_6 = @allocated FullHandEval(cards_7)

        @test alloc_1 ≤ 32
        @test alloc_2 ≤ 688
        @test alloc_3 ≤ 944
        @test alloc_4 ≤ 144
        @test alloc_5 ≤ 1440
        @test alloc_6 ≤ 1632
    end
end
