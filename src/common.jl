

const bin_dir = joinpath(@__DIR__, "bin/")
const so_dir = joinpath(@__DIR__, "so/")
const wrapperjlfile = "_wrapper.jl"
# export bin_dir

isapple  = Sys.isapple()
islinux = Sys.islinux()

function _check_so(so::String)
    if isfile(so) return end
    run(`make -C $(dirname(so)) all`)
end

# sys_suffix = isapple ? "_macos" : "_linux";

