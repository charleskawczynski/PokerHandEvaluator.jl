push!(LOAD_PATH, ".")
using Documenter, HoldemHandEvaluator

format = Documenter.HTML(
    prettyurls = !isempty(get(ENV, "CI", "")),
    collapselevel = 1,
)

makedocs(
    sitename = "HoldemHandEvaluator.jl",
    strict = true,
    format = format,
    checkdocs = :exports,
    clean = true,
    doctest = true,
    modules = [HoldemHandEvaluator],
    pages = Any[
        "Home" => "index.md",
        "API" => "api.md",
    ],
)

deploydocs(
    repo = "github.com/charleskawczynski/HoldemHandEvaluator.jl.git",
    target = "build",
    push_preview = true,
    devbranch = "main",
    forcepush = true,
)
