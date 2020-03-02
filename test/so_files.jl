
let
    spa = SpaInput(year = 2003, month = 10, day = 17, 
            hour = 12, minute = 0, second = 30,
            timezone = 0.0, delta_ut1 = 0, delta_t = 67,
            longitude = 0.0, latitude = 0.0, elevation = 1860.14,
            pressure = 66.6, temperature = 166.6, slope = 0.0,
            azm_rotation = 0.0, atmos_refract = 0.5667, 
            function_int = 0,)

    zenithout = Ref{Cdouble}(0.0)
    azimuthout = Ref{Cdouble}(0.0)
    get_za(spa, zenithout, azimuthout)
    # println("  ", zenithout[], "\t", azimuthout[])
    # 9.936110030111635     202.08736805795803
    @test isapprox(zenithout[], 9.936110030111635)
    @test isapprox(azimuthout[],  202.08736805795803)
end


let
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

    @test isapprox(qlatout[], 16.185024)
    @test isapprox(qlonout[], 85.22224)
    @test isapprox(glatout[], 25.0)
    @test isapprox(glonout[], 11.000001)
    # isapprox(qlatout[],)
    # isapprox(qlatout[],)
    # isapprox(qlatout[],)
end

let
    ch1 = atm8_chapman(1000.0, 30.0)
    @test isapprox(ch1, 1.154317169142657)

end

let
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

    this_pwd = pwd()
    need_cd_hwm = this_pwd != hwm_dir
    if need_cd_hwm cd(hwm_dir)   end

    hwm14(iyd, sec, alt, glat, glon,
                  hrl_32, fbar, f10p7, aaps_hwm,
                  W, )

    if need_cd_hwm cd(this_pwd) end

    v = 100.0 * W[1] * tvn0
    u = 100.0 * W[2] * tvn0
    # print(u, "\t", v)
    @test isapprox(u,  -2843.706703186035)
    @test isapprox(v, -34.654366970062256)
    

end
let
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
                  hrl_32, fbar, f10p7,  aaps_msise,
                mmass, Tinf_scl, d, temp,
            )
    # println("# ", join(d, ", "))
    # println("# ", join(temp, ", "))
    @test isapprox(d[1], 2.0281334e12)
    @test isapprox(d[2], 0.0)
    @test isapprox(d[3], 3.0222293e17)
    @test isapprox(d[4], 8.107734e16)
    @test isapprox(d[5], 3.6150396e15)
    @test isapprox(d[6], 1.8594203e-5)
    @test isapprox(d[7], 0.0)
    @test isapprox(d[8], 0.0)
    @test isapprox(d[9], 0.0)
    @test isapprox(temp[1], 1027.3185)
    @test isapprox(temp[2], 230.39586)
end