using PlayingCards
using Test
using Combinatorics
using PokerHandEvaluator

function benchmark()
    k = 0
    for cards in combinations(full_deck(), 5)
        hr = hand_rank(cards)
        k+=1
        k>=100 && break
    end
end

function main()
  @time benchmark()
end

main()
