

using HTbin:SpaInput, get_za!, 
            _loadapexsh, _apxg2q, _apxq2g,
            atm8_chapman,
            hwm_dir, hwm14,
            gtd7



function test_all()
    qlatout, qlonout, glatout, glonout = HTbin.test_apex()
    @test isapprox(qlatout, 16.185024)
    @test isapprox(qlonout, 85.22224)
    @test isapprox(glatout, 25.0)
    @test isapprox(glonout, 11.000001)

    ch1 = HTbin.test_chapman()
    @test isapprox(ch1, 1.154317169142657)


    OUTF, OARR = HTbin.test_iri()
    @test isapprox(OUTF[1], 1.0536364e11)

    u, v = HTbin.test_hwm()
    @test isapprox(u,  -2843.706703186035)
    @test isapprox(v, -34.654366970062256)


    d, temp = HTbin.test_gtd7()
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

    zenithout, azimuthout = HTbin.test_spa()
    @test isapprox(zenithout, 9.936110030111635)
    @test isapprox(azimuthout,  202.08736805795803)
end

test_all()
