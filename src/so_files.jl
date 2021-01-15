#= 
const so_suffix = string(sys_suffix, ".so")

function call_make_one(c::String,
                    path_bin::String, path_code::String, 
                    so_suffix::String=so_suffix,
            )
    so = string(c, so_suffix)
    so_to = string(path_bin, "/", so)
    if isfile(so_to) return end
    @show so_to
    path_source = string(path_code, "/", c)
    run(`make -C $path_source all`)
    @show string(path_source, "/", so)
    cp(string(path_source, "/", so), so_to, )
    ncf = readlines(string(path_source, "/cpfiles"))
    for i in ncf
        isempty(i) && continue
        cp(string(path_source, "/", i), string(path_bin, "/", i), force=true)
    end

end

function call_make(path_bin::String, path_code::String)
    sod = ["apex", "chapman", "hwm14", "nrlmsise00", "spa"]
    for i in sod
        call_make_one(i, path_bin, path_code)
    end

end

# call_make(bin_dir, string(bin_dir, "/code"),) =#

include(string(so_dir, "/apex/", wrapperjlfile))
include(string(so_dir, "/chapman/", wrapperjlfile))
include(string(so_dir, "/hwm14/", wrapperjlfile))
include(string(so_dir, "/iri2016/", wrapperjlfile))
include(string(so_dir, "/nrlmsise00/", wrapperjlfile))
include(string(so_dir, "/spa/", wrapperjlfile))


