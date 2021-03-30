using Test
using HoldemHandEvaluator
using PlayingCards
using BenchmarkTools
const HHE = HoldemHandEvaluator

@testset "Recurse type" begin
    @test HHE.recurse_up(2♣) == 12

    @test HHE.type_up(2♣, 1) == NumberCard{3}
    @test HHE.type_dn(A♣, 1) == King
end

@testset "Card eval helpers" begin

    # From the table:
    @test HHE.quads_base(Ace) == 11
    @test HHE.quads_base(King) == 23
    @test HHE.quads_base(Queen) == 35
    @test HHE.quads_base(Jack) == 47
    @test HHE.quads_base(NumberCard{10}) == 59
    @test HHE.quads_base(NumberCard{9}) == 71
    @test HHE.quads_base(NumberCard{8}) == 83
    @test HHE.quads_base(NumberCard{7}) == 95
    @test HHE.quads_base(NumberCard{6}) == 107
    @test HHE.quads_base(NumberCard{5}) == 119
    @test HHE.quads_base(NumberCard{4}) == 131
    @test HHE.quads_base(NumberCard{3}) == 143
    @test HHE.quads_base(NumberCard{2}) == 155
    @test_throws ErrorException HHE.single_kicker_iter(Ace, Ace)

    # For debugging:
    debug = false
    if debug
        for r in rank_list()[end:-1:1]
            @show string(r), HHE.quads_base(typeof(r))
        end
        s_readability = "(string(r), string(rk), HHE.single_kicker_iter(typeof(r), typeof(rk))) = "
        for r in rank_list()[end:-1:1]
            for rk in rank_list()[end:-1:1]
                rk == r && (println(s_readability); continue)
                @show string(r), string(rk), HHE.single_kicker_iter(typeof(r), typeof(rk))
            end
            println()
        end
    end
end

@testset "trips_base" begin
    @test HHE.trips_base(Ace) == 1610
    @test HHE.trips_base(King) == 1610+66
    @test HHE.trips_base(Queen) == 1610+66*2
    @test HHE.trips_base(Jack) == 1610+66*3
    k = 4
    for i in 10:-1:2
        @test HHE.trips_base(NumberCard{i}) == 1610+66*k
        k+=1
    end
end
