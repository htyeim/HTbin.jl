

bin_dir = joinpath(@__DIR__, "bin/")
export bin_dir

function call_make(path::String, len::Int64 = 5)
    if length(Glob.glob(glob"*.so", bin_dir)) < len
        println("compile so files")
        run(`make -C $path/code all`)
    end
end
call_make(bin_dir,5)

sys_suffix = Sys.isapple() ? 
                "_macos.so" : 
                "_linux.so";

const _spa_so_filename = string(bin_dir, "spa", sys_suffix)

export _get_za
_get_za(year::Int32,month::Int32,day::Int32,
                    hour::Int32,minute::Int32,second::Float64,
                    timezone::Float64, delta_ut1::Float64,delta_t::Float64,
                    longitude::Float64,latitude::Float64,elevation::Float64,
                    pressure::Float64, temperature::Float64,slope::Float64,
                    azm_rotation::Float64,atmos_refract::Float64,
                    function_int::Int32,
                    zenithout::Ref{Float64},azimuthout::Ref{Float64}) = 
                    ccall((:get_za, _spa_so_filename), 
                        Nothing,
                        (Int32, Int32, Int32, Int32, Int32, Float64,
                        Float64, Float64, Float64,
                        Float64, Float64, Float64,
                        Float64, Float64, Float64,
                        Float64, Float64, Int32,
                        Ref{Cdouble}, Ref{Cdouble},),
                        year, month,  day,  hour,  minute,  second,
                         timezone,  delta_ut1,  delta_t,
                         longitude,  latitude,  elevation,
                         pressure,  temperature,  slope,
                         azm_rotation,  atmos_refract,
                         function_int,
                        zenithout, azimuthout, )
                
export SpaInput
@with_kw struct SpaInput
    year::Int32
    month::Int32
    day::Int32
    hour::Int32
    minute::Int32
    second::Float64
    delta_ut1::Float64 = 0.0
    delta_t::Float64 = 66.6
    timezone::Float64 = 0.0
    longitude::Float64 = 0.0
    latitude::Float64 = 0.0
    elevation::Float64 = 350000.0
    pressure::Float64 = 66.6
    temperature::Float64 = 166.6
    slope::Float64 = 0.0
    azm_rotation::Float64 = 0.0
    atmos_refract::Float64 = 0.5667
    function_int::Int32 = 0
                
end
function SpaInput(dt::DateTime, pos::LLA)
    SpaInput(year = Dates.year(dt),
                        month = Dates.month(dt),
                        day = Dates.day(dt),
                        hour = Dates.hour(dt),
                        minute = Dates.minute(dt),
                        second = Dates.second(dt) + Dates.millisecond(dt) / 1000000.0,
                        latitude = pos.lat, longitude = pos.lon, elevation = pos.alt,
                        )
end
export get_za
function get_za(spa::SpaInput, 
                            zenithout::Ref{Float64} ,
                            azimuthout::Ref{Float64},)::Nothing
    _get_za(
                        spa.year, spa.month, spa.day, spa.hour, spa.minute, spa.second,
                        spa.timezone, spa.delta_ut1, spa.delta_t,
                        spa.longitude, spa.latitude, spa.elevation,
                        spa.pressure, spa.temperature, spa.slope,
                        spa.azm_rotation, spa.atmos_refract,
                        spa.function_int,
                        zenithout, azimuthout, )
    return
end





const _apex_data_file   = string(bin_dir, "apexsh.dat")
const _apex_so_filename = string(bin_dir, "apex", sys_suffix)


export _loadapexsh
_loadapexsh(year_32::Float32) = ccall((:loadapxsh_, _apex_so_filename), 
        Nothing,
        (Ptr{UInt8}, Ref{Float32},),
        _apex_data_file, year_32)

export _apxg2q
_apxg2q(glat::Float32, glon::Float32, height::Float32, vecflagin::Int32, 
        qlatout::Ref{Float32}, qlonout::Ref{Float32}, 
        f1::Ref{Float32}, f2::Ref{Float32}, f::Ref{Float32}) = 
    ccall((:apxg2q_, _apex_so_filename), 
                    Nothing,
                    (Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Int32},
                    Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32},),
                    glat, glon, height, vecflagin, 
                    qlatout, qlonout, f1, f2, f)

export _apxq2g
_apxq2g(qlat::Float32, qlon::Float32, height::Float32, precision::Float32, 
        glatout::Ref{Float32}, glonout::Ref{Float32}, error::Ref{Float32}) = 
    ccall((:apxq2g_, _apex_so_filename), 
        Nothing,
        (Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32},
        Ref{Float32}, Ref{Float32}, Ref{Float32},),
        qlat, qlon, height, precision, 
        glatout, glonout, error)








const _chapman_so_filename = string(bin_dir, "chapman", sys_suffix)

export atm8_chapman
atm8_chapman(xscale::Float64, chi::Float64)::Float64 = 
    ccall((:atm8_chapman_, _chapman_so_filename),
            Float64,
            (Ref{Float64}, Ref{Float64}),
            xscale,
            chi,)




export hwm_dir
hwm_dir  = bin_dir
const _hwm14_so_filename = string(bin_dir, "hwm14", sys_suffix)

export hwm14
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



const _msise_so_filename = string(bin_dir, "msise00", sys_suffix)

export gtd7
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