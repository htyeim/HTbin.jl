

bin_dir = joinpath(@__DIR__, "bin/")
export bin_dir
sys_suffix = Sys.isapple() ?
                "_macos" :
                "_linux";
