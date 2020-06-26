

bin_dir = joinpath(@__DIR__, "bin/")
# export bin_dir
isapple  = Sys.isapple()
sys_suffix = isapple ? "_macos" : "_linux";

