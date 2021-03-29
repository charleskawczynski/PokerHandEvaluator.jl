@test hand_rank((A♣, K♣, Q♣, J♣, T♣)) == 1  #  Royal Flush
@test hand_rank((K♣, Q♣, J♣, T♣, 9♣)) == 2  #  King-High Straight Flush
@test hand_rank((Q♣, J♣, T♣, 9♣, 8♣)) == 3  #  Queen-High Straight Flush
@test hand_rank((J♣, T♣, 9♣, 8♣, 7♣)) == 4  #  Jack-High Straight Flush
@test hand_rank((T♣, 9♣, 8♣, 7♣, 6♣)) == 5  #  Ten-High Straight Flush
@test hand_rank((9♣, 8♣, 7♣, 6♣, 5♣)) == 6  #  Nine-High Straight Flush
@test hand_rank((8♣, 7♣, 6♣, 5♣, 4♣)) == 7  #  Eight-High Straight Flush
@test hand_rank((7♣, 6♣, 5♣, 4♣, 3♣)) == 8  #  Seven-High Straight Flush
@test hand_rank((6♣, 5♣, 4♣, 3♣, 2♣)) == 9  #  Six-High Straight Flush
@test hand_rank((5♣, 4♣, 3♣, 2♣, A♣)) == 10 #  Five-High Straight Flush
