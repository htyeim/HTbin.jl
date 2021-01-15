

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