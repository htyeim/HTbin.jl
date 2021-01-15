

const _spa_so_filename =
                string(
                    @__DIR__, "/spa",
                    isapple ? "_macos" : islinux ? "_linux" : "_win",
                    ".so",
                )

_check_spa() = _check_so(_spa_so_filename)
_check_spa()

# export _get_za
# that azimuth is measured westward from south. 
_get_za(zenithout::Ref{Float64},azimuthout::Ref{Float64},
        year::Int32,month::Int32,day::Int32,
        hour::Int32,minute::Int32,second::Float64,
        timezone::Float64, delta_ut1::Float64,delta_t::Float64,
        longitude::Float64,latitude::Float64,elevation::Float64,
        pressure::Float64, temperature::Float64,slope::Float64,
        azm_rotation::Float64,atmos_refract::Float64,
        function_int::Int32,) =
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

# export SpaInput

@with_kw mutable struct SpaInput
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
    SpaInput(year=Dates.year(dt),
            month=Dates.month(dt),
            day=Dates.day(dt),
            hour=Dates.hour(dt),
            minute=Dates.minute(dt),
            second=Dates.second(dt) + Dates.millisecond(dt) / 1000000.0,
            latitude=pos.lat, longitude=pos.lon, elevation=pos.alt,
            )
end
# export get_za!
function get_za!(zenithout::Ref{Float64} ,
                azimuthout::Ref{Float64},
                spa::SpaInput, )::Nothing
    _get_za(zenithout, azimuthout,
            spa.year, spa.month, spa.day, spa.hour, spa.minute, spa.second,
            spa.timezone, spa.delta_ut1, spa.delta_t,
            spa.longitude, spa.latitude, spa.elevation,
            spa.pressure, spa.temperature, spa.slope,
            spa.azm_rotation, spa.atmos_refract,
            spa.function_int,)
    return
end



function test_spa()
    
    spa = SpaInput(year=2003, month=10, day=17,
            hour=12, minute=0, second=30,
            timezone=0.0, delta_ut1=0, delta_t=67,
            longitude=0.0, latitude=0.0, elevation=1860.14,
            pressure=66.6, temperature=166.6, slope=0.0,
            azm_rotation=0.0, atmos_refract=0.5667,
            function_int=0,)

    zenithout = Ref{Cdouble}(0.0)
    azimuthout = Ref{Cdouble}(0.0)
    get_za!(zenithout, azimuthout, spa, )
    # println("  ", zenithout[], "\t", azimuthout[])
    # 9.936110030111635     202.08736805795803
    zenithout[], azimuthout[]
    # @test isapprox(zenithout[], 9.936110030111635)
    # @test isapprox(azimuthout[],  202.08736805795803)
end
