"""
    HandTypes

Defines hand types:
 - `StraightFlush`
 - `Quads`
 - `FullHouse`
 - `Flush`
 - `Straight`
 - `Trips`
 - `TwoPair`
 - `OnePair`
 - `HighCard`
"""
module HandTypes

export AbstractHandType,
    StraightFlush,
    Quads,
    FullHouse,
    Flush,
    Straight,
    Trips,
    TwoPair,
    OnePair,
    HighCard

"""
    AbstractHandType

Subtypes used for hands, such as
`Quads`, `Flush`, and `TwoPair`.
"""
abstract type AbstractHandType end
struct StraightFlush <: AbstractHandType end
struct Quads <: AbstractHandType end
struct FullHouse <: AbstractHandType end
struct Flush <: AbstractHandType end
struct Straight <: AbstractHandType end
struct Trips <: AbstractHandType end
struct TwoPair <: AbstractHandType end
struct OnePair <: AbstractHandType end
struct HighCard <: AbstractHandType end

end # module