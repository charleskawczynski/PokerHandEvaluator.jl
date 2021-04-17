@test first(evaluate5(A♣, K♣, Q♣, J♣, T♣)) == 1  #  Royal Flush
@test first(evaluate5(K♣, Q♣, J♣, T♣, 9♣)) == 2  #  King-High Straight Flush
@test first(evaluate5(Q♣, J♣, T♣, 9♣, 8♣)) == 3  #  Queen-High Straight Flush
@test first(evaluate5(J♣, T♣, 9♣, 8♣, 7♣)) == 4  #  Jack-High Straight Flush
@test first(evaluate5(T♣, 9♣, 8♣, 7♣, 6♣)) == 5  #  Ten-High Straight Flush
@test first(evaluate5(9♣, 8♣, 7♣, 6♣, 5♣)) == 6  #  Nine-High Straight Flush
@test first(evaluate5(8♣, 7♣, 6♣, 5♣, 4♣)) == 7  #  Eight-High Straight Flush
@test first(evaluate5(7♣, 6♣, 5♣, 4♣, 3♣)) == 8  #  Seven-High Straight Flush
@test first(evaluate5(6♣, 5♣, 4♣, 3♣, 2♣)) == 9  #  Six-High Straight Flush
@test first(evaluate5(5♣, 4♣, 3♣, 2♣, A♣)) == 10 #  Five-High Straight Flush
