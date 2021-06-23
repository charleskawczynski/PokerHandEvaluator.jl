#####
##### Best n-card hand rank, from combinations.
#####

function min_hand_rank_full(eval1, cards)
    hand_rank_2 = evaluate5(cards)
    if first(eval1) <= hand_rank_2
        return eval1
    else
        hand_type_2 = hand_type_binary_search(hand_rank_2)
        return (hand_rank_2, hand_type_2, cards)
    end
end

function min_hand_rank_compact(hand_rank_1, cards)
    hand_rank_2 = evaluate5(cards)
    if hand_rank_1 < hand_rank_2
        return hand_rank_1
    else
        return hand_rank_2
    end
end

function best_hand_rank_from_7_cards_full(c)
    cards=(c[1],c[2],c[3],c[4],c[5]) # first combination

    hand_rank = evaluate5(cards)
    hand_type = hand_type_binary_search(hand_rank)
    hr = (hand_rank, hand_type, cards)

    cards=(c[1],c[2],c[3],c[4],c[6]); hr = min_hand_rank_full(hr, cards)
    cards=(c[1],c[2],c[3],c[4],c[7]); hr = min_hand_rank_full(hr, cards)
    cards=(c[1],c[2],c[3],c[5],c[6]); hr = min_hand_rank_full(hr, cards)
    cards=(c[1],c[2],c[3],c[5],c[7]); hr = min_hand_rank_full(hr, cards)
    cards=(c[1],c[2],c[3],c[6],c[7]); hr = min_hand_rank_full(hr, cards)
    cards=(c[1],c[2],c[4],c[5],c[6]); hr = min_hand_rank_full(hr, cards)
    cards=(c[1],c[2],c[4],c[5],c[7]); hr = min_hand_rank_full(hr, cards)
    cards=(c[1],c[2],c[4],c[6],c[7]); hr = min_hand_rank_full(hr, cards)
    cards=(c[1],c[2],c[5],c[6],c[7]); hr = min_hand_rank_full(hr, cards)
    cards=(c[1],c[3],c[4],c[5],c[6]); hr = min_hand_rank_full(hr, cards)
    cards=(c[1],c[3],c[4],c[5],c[7]); hr = min_hand_rank_full(hr, cards)
    cards=(c[1],c[3],c[4],c[6],c[7]); hr = min_hand_rank_full(hr, cards)
    cards=(c[1],c[3],c[5],c[6],c[7]); hr = min_hand_rank_full(hr, cards)
    cards=(c[1],c[4],c[5],c[6],c[7]); hr = min_hand_rank_full(hr, cards)
    cards=(c[2],c[3],c[4],c[5],c[6]); hr = min_hand_rank_full(hr, cards)
    cards=(c[2],c[3],c[4],c[5],c[7]); hr = min_hand_rank_full(hr, cards)
    cards=(c[2],c[3],c[4],c[6],c[7]); hr = min_hand_rank_full(hr, cards)
    cards=(c[2],c[3],c[5],c[6],c[7]); hr = min_hand_rank_full(hr, cards)
    cards=(c[2],c[4],c[5],c[6],c[7]); hr = min_hand_rank_full(hr, cards)
    cards=(c[3],c[4],c[5],c[6],c[7]); hr = min_hand_rank_full(hr, cards)
    return hr
end

function best_hand_rank_from_6_cards_full(c)
    cards=(c[1],c[2],c[3],c[4],c[5]); # first combination

    hand_rank = evaluate5(cards);
    hand_type = hand_type_binary_search(hand_rank);
    hr = (hand_rank, hand_type, cards)

    cards=(c[1],c[2],c[3],c[4],c[6]); hr = min_hand_rank_full(hr, cards)
    cards=(c[1],c[2],c[3],c[5],c[6]); hr = min_hand_rank_full(hr, cards)
    cards=(c[1],c[2],c[4],c[5],c[6]); hr = min_hand_rank_full(hr, cards)
    cards=(c[1],c[3],c[4],c[5],c[6]); hr = min_hand_rank_full(hr, cards)
    cards=(c[2],c[3],c[4],c[5],c[6]); hr = min_hand_rank_full(hr, cards)
    return hr
end

function best_hand_rank_from_7_cards_compact(c)
    cards=(c[1],c[2],c[3],c[4],c[5]); hr = evaluate5(cards)
    cards=(c[1],c[2],c[3],c[4],c[6]); hr = min_hand_rank_compact(hr, cards)
    cards=(c[1],c[2],c[3],c[4],c[7]); hr = min_hand_rank_compact(hr, cards)
    cards=(c[1],c[2],c[3],c[5],c[6]); hr = min_hand_rank_compact(hr, cards)
    cards=(c[1],c[2],c[3],c[5],c[7]); hr = min_hand_rank_compact(hr, cards)
    cards=(c[1],c[2],c[3],c[6],c[7]); hr = min_hand_rank_compact(hr, cards)
    cards=(c[1],c[2],c[4],c[5],c[6]); hr = min_hand_rank_compact(hr, cards)
    cards=(c[1],c[2],c[4],c[5],c[7]); hr = min_hand_rank_compact(hr, cards)
    cards=(c[1],c[2],c[4],c[6],c[7]); hr = min_hand_rank_compact(hr, cards)
    cards=(c[1],c[2],c[5],c[6],c[7]); hr = min_hand_rank_compact(hr, cards)
    cards=(c[1],c[3],c[4],c[5],c[6]); hr = min_hand_rank_compact(hr, cards)
    cards=(c[1],c[3],c[4],c[5],c[7]); hr = min_hand_rank_compact(hr, cards)
    cards=(c[1],c[3],c[4],c[6],c[7]); hr = min_hand_rank_compact(hr, cards)
    cards=(c[1],c[3],c[5],c[6],c[7]); hr = min_hand_rank_compact(hr, cards)
    cards=(c[1],c[4],c[5],c[6],c[7]); hr = min_hand_rank_compact(hr, cards)
    cards=(c[2],c[3],c[4],c[5],c[6]); hr = min_hand_rank_compact(hr, cards)
    cards=(c[2],c[3],c[4],c[5],c[7]); hr = min_hand_rank_compact(hr, cards)
    cards=(c[2],c[3],c[4],c[6],c[7]); hr = min_hand_rank_compact(hr, cards)
    cards=(c[2],c[3],c[5],c[6],c[7]); hr = min_hand_rank_compact(hr, cards)
    cards=(c[2],c[4],c[5],c[6],c[7]); hr = min_hand_rank_compact(hr, cards)
    cards=(c[3],c[4],c[5],c[6],c[7]); hr = min_hand_rank_compact(hr, cards)
    return hr
end

function best_hand_rank_from_6_cards_compact(c)
    cards = (c[1],c[2],c[3],c[4],c[5]); hr = evaluate5(cards)
    cards = (c[1],c[2],c[3],c[4],c[6]); hr = min_hand_rank_compact(hr, cards)
    cards = (c[1],c[2],c[3],c[5],c[6]); hr = min_hand_rank_compact(hr, cards)
    cards = (c[1],c[2],c[4],c[5],c[6]); hr = min_hand_rank_compact(hr, cards)
    cards = (c[1],c[3],c[4],c[5],c[6]); hr = min_hand_rank_compact(hr, cards)
    cards = (c[2],c[3],c[4],c[5],c[6]); hr = min_hand_rank_compact(hr, cards)
    return hr
end