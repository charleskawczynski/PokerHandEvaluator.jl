using Documenter, PokerHandEvaluator

format = Documenter.HTML(
    prettyurls = !isempty(get(ENV, "CI", "")),
    collapselevel = 1,
)

makedocs(
    sitename = "PokerHandEvaluator.jl",
    strict = true,
    format = format,
    checkdocs = :exports,
    clean = true,
    doctest = true,
    modules = [PokerHandEvaluator],
    pages = Any[
        "Home" => "index.md",
        "Implementation" => "implementation.md",
        "Performance" => "perf.md",
        "API" => "api.md",
    ],
)

deploydocs(
    repo = "github.com/charleskawczynski/PokerHandEvaluator.jl.git",
    target = "build",
    push_preview = true,
    devbranch = "main",
    forcepush = true,
)
