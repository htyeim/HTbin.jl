

const _msise_so_filename = 
            string(
                    @__DIR__, "/nrlmsise00",
                    isapple ? "_macos" : islinux ? "_linux" : "_win",
                    ".so",
                )

_check_nrlmsise00() = _check_so(_msise_so_filename)
_check_nrlmsise00()


# export gtd7
gtd7(IYD::Int32, SEC::Float32,
    ALT::Float32, GLAT::Float32, GLONG::Float32,
    STL::Float32, F107A::Float32, F107::Float32,
    AP::Array{Float32,1}, MASS::Int32, Tinf_scl::Float32,
    D::Array{Float32,1}, T::Array{Float32,1},
) = ccall((:gtd7_, _msise_so_filename),
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
        Ref{Int32},   #  MASS,
        Ref{Float32}, #  Tinf_scl
        Ptr{Float32}, #  D
        Ptr{Float32},),
    IYD, SEC,
    ALT, GLAT, GLONG,
    STL, F107A, F107,
    AP, MASS, Tinf_scl,
    D, T,
)



function test_gtd7()
    aaps_msise  = Array{Float32,1}(undef, 7)
    aaps_msise .= 1.0

    iyd = Int32(19199)
    sec = Float32(12 * 3600.0)
    alt  = Float32(30.0)
    glat = Float32(15.0)
    glon = Float32(36.0)
    hrl_32 = Float32(0.0)
    fbar = Float32(180.0)
    f10p7 = Float32(180.0)
    mmass = Int32(48)
    Tinf_scl = Float32(1.0)
    d    = Array{Float32,1}(undef, 9)
    temp = Array{Float32,1}(undef, 2)

    gtd7(iyd, sec, alt, glat, glon,
                hrl_32, fbar, f10p7, aaps_msise,
                mmass, Tinf_scl, d, temp,
            )
    # println("# ", join(d, ", "))
    # println("# ", join(temp, ", "))
    d, temp

end

