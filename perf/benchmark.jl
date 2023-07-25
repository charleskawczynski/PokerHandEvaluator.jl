using PlayingCards
using PlayingCards: AbstractDeck
import Random
Random.seed!(1234)
import PokerHandEvaluator as PHE

struct DummyDeck <: AbstractDeck
    cards::Vector{Card}
end
Base.pop!(deck::DummyDeck, n::Int) = ntuple(i->deck.cards[i], n)
Random.shuffle!(deck::DummyDeck) = Random.shuffle!(Random.default_rng(), deck)

function Random.shuffle!(rng::Random.AbstractRNG, deck::DummyDeck)
    Random.shuffle!(rng, deck.cards)
    return deck
end

function do_work!(deck)
    fhe = PHE.FullHandEval(pop!(deck, 7))
    shuffle!(deck)
end

deck = DummyDeck(full_deck())
using BenchmarkTools
@benchmark do_work!($deck)
