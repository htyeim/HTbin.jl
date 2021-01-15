# module HWM14
# isapple = Sys.isapple()
# islinux = Sys.islinux()

# export hwm_dir
hwm_dir  = @__DIR__
const _hwm14_so_filename = 
            string(
                    @__DIR__, "/hwm14",
                    isapple ? "_macos" : islinux ? "_linux" : "_win",
                    ".so",
                )

_check_hwm14() = _check_so(_hwm14_so_filename)
_check_hwm14()

# export hwm14
# need cd to the directory including data files
# this_pwd = pwd()
# need_cd_hwm = this_pwd != hwm_dir
# if need_cd_hwm cd(hwm_dir)   end
# hwm14(iyd, sec, alt, glat, glon,
#         hrl_32, fbar, f10p7, aaps_hwm,
#         W, )
# if need_cd_hwm cd(this_pwd) end
function _init_hwm()
    this_pwd = pwd()
    if this_pwd != @__DIR__
        # @warn "work directory should change to $(@__DIR__) before call hwm"
        cd(@__DIR__)
        @warn "work directory (hwm14) have changed\n from: $this_pwd\n   to: $(@__DIR__)"
        # c = true
    end
    this_pwd
end

hwm14(IYD::Int32, SEC::Float32,
    ALT::Float32, GLAT::Float32, GLONG::Float32,
    STL::Float32, F107A::Float32, F107::Float32,
    AP::Array{Float32,1},
    W::Array{Float32,1},
) = ccall((:hwm14_, _hwm14_so_filename),
    Nothing,
    (Ref{Int32},   # IYD
        Ref{Float32}, # SEC
        Ref{Float32}, # ALT
        Ref{Float32}, # GLAT
        Ref{Float32}, # GLONG
        Ref{Float32}, # STL
        Ref{Float32}, # F107A
        Ref{Float32}, # F107
        Ptr{Float32}, #  AP
        Ptr{Float32},),
    IYD, SEC,
    ALT, GLAT, GLONG,
    STL, F107A, F107,
    AP,
    W,
)


function test_hwm()
    aaps_hwm  = Array{Float32,1}(undef, 2)
    aaps_hwm .= 1.0

    W = Array{Float32,1}(undef, 2)
    iyd = Int32(19199)
    sec = Float32(12 * 3600.0)
    alt  = Float32(30.0)
    glat = Float32(15.0)
    glon = Float32(36.0)
    hrl_32 = Float32(0.0)
    fbar = Float32(180.0)
    f10p7 = Float32(180.0)

    tvn0 = 1.0

    this_pwd = _init_hwm()
    hwm14(iyd, sec, alt, glat, glon,
            hrl_32, fbar, f10p7, aaps_hwm,
            W, )

    cd(this_pwd)

    v = 100.0 * W[1] * tvn0
    u = 100.0 * W[2] * tvn0
    # print(u, "\t", v)
    u, v
    # @test isapprox(u,  -2843.706703186035)
    # @test isapprox(v, -34.654366970062256)
end


# end module HWM14
# end