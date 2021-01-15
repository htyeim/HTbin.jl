

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

