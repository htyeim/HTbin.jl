

const _apex_data_file   = string(@__DIR__, "/apexsh.dat")
const _apex_so_filename = 
            string(
                    @__DIR__, "/apex",
                    isapple ? "_macos" : islinux ? "_linux" : "_win",
                    ".so",
                )

_check_apex() = _check_so(_apex_so_filename)
_check_apex()

# export _loadapexsh
_loadapexsh(year_32::Float32) =
        ccall((:loadapxsh_, _apex_so_filename),
                Nothing,
                (Ptr{UInt8}, Ref{Float32},),
                _apex_data_file, year_32)

# export _apxg2q
_apxg2q(glat::Float32, glon::Float32,
        height::Float32, vecflagin::Int32,
        qlatout::Ref{Float32}, qlonout::Ref{Float32},
        f1::Ref{Float32}, f2::Ref{Float32}, f::Ref{Float32}) =
            ccall((:apxg2q_, _apex_so_filename),
                Nothing,
                (Ref{Float32}, Ref{Float32},
                Ref{Float32}, Ref{Int32},
                Ref{Float32}, Ref{Float32},
                Ref{Float32}, Ref{Float32}, Ref{Float32},),
                    glat, glon,
                    height, vecflagin,
                    qlatout, qlonout,
                    f1, f2, f,)

# export _apxq2g
_apxq2g(qlat::Float32, qlon::Float32,
        height::Float32, precision::Float32,
        glatout::Ref{Float32}, glonout::Ref{Float32},
        error::Ref{Float32}) =
            ccall((:apxq2g_, _apex_so_filename),
                    Nothing,
                    (Ref{Float32}, Ref{Float32},
                    Ref{Float32}, Ref{Float32},
                    Ref{Float32}, Ref{Float32}, Ref{Float32},),
                        qlat, qlon,
                        height, precision,
                        glatout, glonout, error,)






function test_apex()
    dt = Dates.DateTime(2010, 6, 6, 1, 2, 3)
    year = 2010
    yearf = Dates.year(dt) + Dates.dayofyear(dt) / Dates.daysinyear(dt)
    year32f = Float32(yearf)
    glat = Float32(25.0)
    glon = Float32(11.0)
    height = Float32(350.0)
    vecflagin = Int32(0)
    qlatout = Ref{Float32}(0.0)
    qlonout = Ref{Float32}(0.0)
    f1 = Ref{Float32}(0.0)
    f2 = Ref{Float32}(0.0)
    f = Ref{Float32}(0.0)

    _loadapexsh(year32f)
    _apxg2q(glat, glon, height, vecflagin,
            qlatout, qlonout, f1, f2, f)


    qlat = qlatout[]
    qlon = qlonout[]
    precision = 1.0f-10
    glatout = Ref{Float32}(0.0)
    glonout = Ref{Float32}(0.0)
    gerror  = Ref{Float32}(0.0)
    _apxq2g(qlat, qlon, height, precision,
            glatout, glonout,  gerror)


    # println("# ", qlatout[], ", ", qlonout[], ", ", f1[], ", ", f2[], ", ", f[])
    # println("# ", glatout[], ",\t", glonout[], ",\t", gerror[])
    # println("# ", glat, ",\t", glon, )
    # 16.185024, 85.22224, -9999.0, -9999.0, -9999.0
    # 25.0, 11.000001, 0.0

    # @test isapprox(qlatout[], 16.185024)
    # @test isapprox(qlonout[], 85.22224)
    # @test isapprox(glatout[], 25.0)
    # @test isapprox(glonout[], 11.000001)
    qlatout[], qlonout[], glatout[], glonout[]

    
end
