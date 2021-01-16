# module IRI2016
# using Dates
# using RemoteFiles
# # import PlotlyJS
# isapple = Sys.isapple()
# islinux = Sys.islinux()

const path_iri_offline = string(@__DIR__, "offline_2021_01_16")
const _iri2016_so_filename = 
            string(
                    @__DIR__, "/iri2016",
                    isapple ? "_macos" : islinux ? "_linux" : "_win",
                    ".so",
                )

const _iri_tar = @RemoteFile(
        "http://irimodel.org/IRI-2016/00_iri.tar",
        file = "00_iri.tar",
        dir = @__DIR__,
        updates = :never
    )

const _ig_rz_dat = @RemoteFile(
        "https://chain-new.chain-project.net/echaim_downloads/ig_rz.dat",
        file = "ig_rz.dat",
        dir = @__DIR__,
        updates = :daily
        )
    
const _apf107_dat = @RemoteFile(
        "https://chain-new.chain-project.net/echaim_downloads/apf107.dat",
        file = "apf107.dat",
        dir = @__DIR__,
        updates = :daily
        )
    
const _ccir_ursi_tar = @RemoteFile(
            "http://irimodel.org/COMMON_FILES/00_ccir-ursi.tar",
            file = "00_ccir-ursi.tar",
            dir = @__DIR__,
            updates = :never
        )


function _check_iri2016()
    iri_tar = download_or_cp_file(_iri_tar, path_iri_offline, RemoteFiles.Http())
    run(`tar -xvf $iri_tar --directory $(dirname(iri_tar))`)
    _check_so(_iri2016_so_filename)

end
_check_iri2016()
# IRI_SUB


# hwm14(IYD::Int32, SEC::Float32,
#     ALT::Float32, GLAT::Float32, GLONG::Float32,
#     STL::Float32, F107A::Float32, F107::Float32,
#     AP::Array{Float32,1},
#     W::Array{Float32,1},
# ) = ccall((:hwm14_, _hwm14_so_filename),
#     Nothing,
#     (Ref{Int32},   # IYD
#         Ref{Float32}, # SEC
#         Ref{Float32}, # ALT
#         Ref{Float32}, # GLAT
#         Ref{Float32}, # GLONG
#         Ref{Float32}, # STL
#         Ref{Float32}, # F107A
#         Ref{Float32}, # F107
#         Ptr{Float32}, #  AP
#         Ptr{Float32},),
#     IYD, SEC,
#     ALT, GLAT, GLONG,
#     STL, F107A, F107,
#     AP,
#     W,
# )


function _init_iri()
    download_or_cp_file(_ig_rz_dat, path_iri_offline, )
    download_or_cp_file(_apf107_dat, path_iri_offline, )

    ccir_ursi_tar = path(_ccir_ursi_tar)
    if !isfile(ccir_ursi_tar)
        download_or_cp_file(_ccir_ursi_tar, path_iri_offline, RemoteFiles.Http())
        run(`tar -xvf $ccir_ursi_tar --directory $(dirname(ccir_ursi_tar))`)
    end

    this_pwd = pwd()
    if this_pwd != @__DIR__
        cd(@__DIR__)
        @warn "work directory (iri2016) have changed\n from: $this_pwd\n   to: $(@__DIR__)"
        # c = true
    end

    ccall((:read_ig_rz_, _iri2016_so_filename), Nothing, ())
    ccall((:readapf107_, _iri2016_so_filename), Nothing, ())
    this_pwd
    # if c cd(thispwd) end
end

_iri_sub(JF::Array{Int32,1},JMAG::Int32,
            ALATI::Float32,ALONG::Float32,
            IYYYY::Int32,MMDD::Int32,DHOUR::Float32,
            HEIBEG::Float32,HEIEND::Float32,HEISTP::Float32,
            OUTF::Array{Float32,2},OARR::Array{Float32,1}) =
            ccall((:iri_sub_, _iri2016_so_filename),
                Nothing,
                (Ptr{Int32}, Ref{Int32}, Ref{Float32}, Ref{Float32}, # jf,JMAG, lat lon
                Ref{Int32}, Ref{Int32}, Ref{Float32}, # IYYYY MMDD DHOUR
                Ref{Float32}, Ref{Float32}, Ref{Float32}, # altbeg altend altstp
                Ptr{Float32}, Ptr{Float32},),
                JF,JMAG,ALATI,ALONG,IYYYY,MMDD,DHOUR,HEIBEG,HEIEND,HEISTP,OUTF,OARR
            )

function test_iri()
    # (JF, JMAG, ALATI, ALONG, IYYYY, MMDD, DHOUR, HEIBEG, HEIEND, HEISTP, )

    _init_iri()
    dn = DateTime(2014, 3, 23, 14, 30)

    # jf[3] = 0  # 4 B0,B1 other model-31
    # jf[4] = 0  # 5  foF2 - URSI
    # jf[5] = 0  # 6  Ni - RBV-10 & TTS-03
    # jf[20] = 0  # 21 ion drift not computed
    # jf[22] = 0  # 23 Te_topside (TBT-2011)
    # jf[27] = 0  # 28 spreadF prob not computed
    # jf[28] = 0  # 29 (29,30) => NeQuick
    # jf[29] = 0  # 30
    # # (Brian found a case that stalled IRI when on):
    # jf[32] = 0  # 33 Auroral boundary model off
    # jf[34] = 0  # 35 no foE storm update
    # # Not standard, but outputs same as values as standard so not an issue
    # jf[21] = 0  # 22 ion densities in m^-3 (not %)
    # jf[33] = 0  # 34 turn messages off
    # [3,4,5,20,22,27,28,29,32,34, 21,33] .+ 1

    JF = ones(Int32, 50)
    for ind in [4, 5, 6, 21, 23, 28, 29, 30, 33, 35, 22, 34]
        JF[ind] = 0
    end

    # (datetime.datetime(2014, 3, 23, 14, 30), 40.0, -80.0, 250.0)

    JMAG = Int32(0)
    ALATI = Float32(40.0)
    ALONG = Float32(-80.0)
    IYYYY = Int32(year(dn))
    MMDD = -Int32(dayofyear(dn))
    DHOUR = Float32(hour(dn) * 3600.0 + minute(dn) * 60) / 3600 + 25

    HEIBEG  = Float32(100.0)
    HEIEND = Float32(1000.0) 
    HEISTP = Float32(1.0)
    
    
    OUTF = Array{Float32,2}(undef, (20, 1000))
    OARR = Array{Float32,1}(undef, 100)
    _iri_sub(JF, JMAG, ALATI, ALONG, IYYYY, MMDD, DHOUR, HEIBEG, HEIEND, HEISTP, OUTF, OARR)
    # @show OUTF[1:10,1]
    # tr = PlotlyJS.scatter(;y=OUTF[1,:])
    # PlotlyJS.savehtml(PlotlyJS.plot(tr, ), "test.html")
    # println(OUTF[1]) 1.0536364e11
    OUTF, OARR
end
# iri()

# end moulde IRI2016
# end
