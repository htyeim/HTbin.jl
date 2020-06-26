using HTbin
using Dates
using Test


@time @testset "HTbin.jl Package Tests" begin

    testdir = joinpath(dirname(@__DIR__), "test")
    @time @testset "so_files" begin
        include(joinpath(testdir, "so_files.jl"))
    end

end
