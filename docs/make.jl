using Documenter, HTbin

makedocs(;
    modules=[HTbin],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/htyeim/HTbin.jl/blob/{commit}{path}#L{line}",
    sitename="HTbin.jl",
    authors="htyeim <htyeim@gmail.com>",
    assets=String[],
)

deploydocs(;
    repo="github.com/htyeim/HTbin.jl",
)
