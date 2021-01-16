

const bin_dir = joinpath(@__DIR__, "bin/")
const so_dir = joinpath(@__DIR__, "so/")
const wrapperjlfile = "_wrapper.jl"
# export bin_dir

isapple  = Sys.isapple()
islinux = Sys.islinux()

function download_or_cp_file(rf::RemoteFile, pof::String="",
    rb::RemoteFiles.AbstractBackend=RemoteFiles.CURL())
    try
        download(rb, rf; quiet=true)
    catch
        fof = string(pof, "/", rf.file)
        if isfile(fof)
            cp(fof, path(rf), force=true)
        else
            throw(error("can't get file:\n      $(path(rf)) \n from $(rf.uri)"))
        end
    end
    return path(rf)
end

function _check_so(so::String)
    if isfile(so) return end
    @show so
    run(`make -C $(dirname(so)) all`)
end

# sys_suffix = isapple ? "_macos" : "_linux";

